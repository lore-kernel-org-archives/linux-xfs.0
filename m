Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p292lCeA013715 for <xfs@oss.sgi.com>; Tue, 8 Mar 2011 20:47:13 -0600
Received: from act-ironport-ext.csiro.au (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F05E4331CCB
	for <xfs@oss.sgi.com>; Tue,  8 Mar 2011 18:49:57 -0800 (PST)
Received: from act-ironport-ext.csiro.au (act-mx-ext.csiro.au [150.229.7.36])
	by cuda.sgi.com with ESMTP id tJ23nEzhlXmEIVRC for
	<xfs@oss.sgi.com>; Tue, 08 Mar 2011 18:49:57 -0800 (PST)
Date: Wed, 9 Mar 2011 13:49:51 +1100
From: Vincent McIntyre <vincent.mcintyre@csiro.au>
Subject: Re: correct procedure for mismatched UUIDs (error 117)
Message-ID: <20110309024951.GG3702@mayhem.atnf.CSIRO.AU>
References: <20110308022451.GC32056@mayhem.atnf.CSIRO.AU>
	<20110309005013.GG1956@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110309005013.GG1956@dastard>
Content-Language: en-US
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Mar 09, 2011 at 11:50:13AM +1100, Dave Chinner wrote:

> Did you change the mapping while the filesystems were mounted?

I am pretty sure we did not but unfortunately I don't think we kept
a typescript of that operation so I can't be absolutely certain.
My recollection is that we dismounted, flushed multipath bindings,
then tweaked the bindings file and restarted multipathd.

...

> > Things seemed ok until we tried to 'ls' one of the filesystems;
> > then we got a stack trace:
> >  Filesystem "dm-20": XFS internal error xfs_da_do_buf(2) at line 2085 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa027c48b
> 
> That indicates a block was read from disk that had an incorrect
> magic number in it. i.e. it wasn't a directory block that the
> directory extent map pointed to.
> 

I see.

> > Once we saw the ls failure we stopped and changed the mount paths for
> > the affected filesystems in fstab, then rebooted.
> > During boot, we got:
> >  XFS mounting filesystem dm-13
> >  XFS: log has mismatched uuid - can't recover
> >  XFS: failed to find log head
> >  XFS: log mount/recovery failed: error 117
> >  XFS: log mount failed
> > 
> > for both of the filesystems.
> 
> Which implies that the superblock was written to disk with the wrong
> UUID in it. And the only way that can happen is if the superblock
> for the wrong filesystem is written to the block device. Hence my
> question of whether you swapped the paths while the filesystems were
> mounted - the superblock is only read during mount time, and the
> UUID is never modified, so the only way an incorrect UUID can be
> written to the filesystem is if the block device changes underneath
> the mounted filesystem.
> 

I'll do some more checking to see if we can ascertain if we swapped
the block device underneath.

I was trying to figure out which was wrong - the log or the SB -
but could not decide.

> > We tried to revert the binding change but that didn't get us out of jail.
> > First we commented out the affected filesystems in /etc/fstab, rebooted.
> > When we tried to mount manually after checking the /dev/mapper paths
> > were what we thought they should be, we still got complaints about
> > mismatching UUIDs.
> 
> Nope, once you've written a bad superblock, you're pretty much screwed
> 

So xfs_admin -U would not help? We contemplated that but because we were
not sure if the log or the SB was wrong we decided against trying it.


> > We ran xfs_admin -u on each filesystem, which told us what we already knew:
> >  # xfs_admin -u /dev/mapper/mpath0-part1
> >  warning: UUID in AG 1 differs to the primary SB
> >  UUID = bd57b07f-2f07-4cb3-a641-9f3ecf72ce26
> >  # xfs_admin -u /dev/mapper/mpath1-part1
> >  warning: UUID in AG 1 differs to the primary SB
> >  UUID = 118e731c-aca8-4c78-99d4-df297258dd63
> 
> OK, what you need to do is find out what the UUID in the secondary
> SB in AG 1 is, and check that they are swapped. i.e:
> 
> # xfs_db -c "sb 0" -c "p uuid" /dev/mapper/mpath0-part1
> UUID = <XXX>
> # xfs_db -c "sb 1" -c "p uuid" /dev/mapper/mpath0-part1
> UUID = <YYY>
> 
> And from the other block device, I'd expect you to see:
> 
> # xfs_db -c "sb 0" -c "p uuid" /dev/mapper/mpath1-part1
> UUID = <YYY>
> # xfs_db -c "sb 1" -c "p uuid" /dev/mapper/mpath1-part1
> UUID = <XXX>
> 
> If that is the case, then you need to reconstruct the primary
> superblock from the info in the secondary superblock using xfs_db,
> and then you'll need to run xfs_repair to detect fix all the
> inconsistencies that were introduced. You need to copy these fileds
> from the secondary SB to the primary if they are different:
> 
> blocksize
> dblocks
> rblocks
> rextents
> uuid
> logstart
> rextsize
> agblocks
> agcount
> rbmblocks
> logblocks
> versionnum
> sectsize
> inodesize
> inopblock
> blocklog
> sectlog
> inodelog
> inopblog
> agblklog
> rextslog
> imax_pct
> inoalignmt
> unit
> width
> dirblklog
> logsectlog
> logsectsize
> logsunit
> features2
> bad_features2
> 
> Note that these are not all the fields in the superblock. You do not
> want to copy the ones not mentioned, even if they are different in
> value.
> 

Thanks for this, it's terrifically useful to know about this.
I didn't dare fire up xfs_db, but perhaps its not so bad after all.

> > 
> > We tried mounting with -oro,nouuid,norecovery, but that didn't help:
> >  # mount -oro,nouuid,norecovery /dev/mapper/mpath0-part1 /recover
> >  # ls /recover/
> >  # ls: reading directory /recover/: Structure needs cleaning
> >  # umount /recover
> 
> No surprise there.
 
I was surprised because I thought nouuid would ignore the SB uuid and
assume the log uuid was correct. Presumably xfs detected some other
inconsistency?

What is supposed to happen if I had mounted it with just -onouuid ?

> > We tried xfs_logprint - the log had the same uuid in all the entries
> > that were printed out. This did not match the uuid of the SB.
> 
> Which means that you might be lucky and the only metadata written to
> the wrong block device was the superblock.
> 

Ok. We were thinking this indicated that we'd been lucky but could not
figure out how to take advantage of that.

> > By now we were running low on time, so we tried xfs_repair.
> > We tried one filesystem with -L and one without.
> > The former produced the expected jumble of inode-numbered files,
> > which we are in the process of piecing together.
> > The latter seemed to preserve the directory structure a bit better,
> > though there was still some jumbling-up.
> > I won't tax you with the full logs.
> > 
> > That's the story. Opinions?
> 
> Well, seeing as you've already run repair, I think you've probably
> made a mess that can't be cleaned up. I'd be checking all the data
> is intact once you've cleaned up the messed up directory
> structure.
> 

Yep, we're doing that now.

> Not much else I can suggest at this point apart from point out that
> it is better to ask questions before trying to fix a screwup rather
> than after attempting to undo the damage and making the situation
> unrecoverable......
> 

We felt we didn't have time to wait for help, unfortunately.

Thanks for your reply, though, it is very helpful and much appreciated.
I'll report back with how we went recovering things, in a few days.

Kind regards
Vince

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
