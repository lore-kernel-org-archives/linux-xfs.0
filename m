Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 844317F3F
	for <xfs@oss.sgi.com>; Sat,  8 Mar 2014 18:28:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6CD698F8035
	for <xfs@oss.sgi.com>; Sat,  8 Mar 2014 16:28:27 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HK1ChiVv72bUj3QE for <xfs@oss.sgi.com>;
	Sat, 08 Mar 2014 16:28:24 -0800 (PST)
Date: Sun, 9 Mar 2014 11:28:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Hello, I have a question about XFS File System
Message-ID: <20140309002819.GT6851@dastard>
References: <195DE8C60CE24A62A71911FDE0B0DC97@gmail.com>
	<5318DB01.2040102@hardwarefreak.com>
	<279D0A265E5D4AF5B099BFAD4E8B1700@gmail.com>
	<531A4600.7050906@hardwarefreak.com>
	<20140307230915.GS6851@dastard>
	<CAGpXXZLtYiS3gLubA_9vbvT34RUosi91w=+7DYX_J1M3CA3czQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGpXXZLtYiS3gLubA_9vbvT34RUosi91w=+7DYX_J1M3CA3czQ@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Yongmin <dev.yongmin@gmail.com>, Stan Hoeppner <stan@hardwarefreak.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Mar 07, 2014 at 07:38:15PM -0500, Greg Freemyer wrote:
> On Fri, Mar 7, 2014 at 6:09 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Mar 07, 2014 at 04:19:44PM -0600, Stan Hoeppner wrote:
> >> Please reply to the mailing list as well as the individual.
> >>
> >> Note that you stated:
> >>
> >> '...the concentrated part of mine is "Deleted File Recovery"'
> >>
> >> On 3/6/2014 10:02 PM, Yongmin wrote:
> >> >
> >> > Yes! there are no actual file data in journaling part.
> >> >
> >> > BUT, by analyzing journaling part, we can get a Inode Core Information which was deleted.
> >> > In Inode Core, there are many information about the actual data, i.e. start address, file length etc.
> >>
> >> Analyzing the journal code may inform you about structures, but it won't
> >> inform you about on disk locations of the structures and how to find
> >> them.  If a file has been deleted, no information about that is going to
> >> exist in the journal for more than a few seconds before the transaction
> >> is committed and the entry removed from the journal.
> >
> > Well, we don't actually "remove" information from the log. We update
> > pointers that indicate what the active region is, but we never
> > physically "remove" anything from it. IOWs, the information is in
> > the journal until it wraps around and is over written by new
> > checkpoints....
> >
> >> > By using those information, Recovering delete file can be done.
> >> >
> >> > So the analysis of Journaling part is absolutely needed.
> >>
> >> I disagree.  Again, the journal log is unrelated to "deleted file
> >> recovery" in a forensics scenario.
> >>
> >> I think Dave and Jeff both missed the fact that you're interested only
> >> in deleted file recovery, not in learning how the journal works for the
> >> sake of learning how the journal works.
> >
> > Oh, no, I saw it and didn't think it was worth commenting on. I
> > think it's a brain-dead concept trying to do undelete in the
> > filesystem. "recoverable delete" was a problem solved 30 years ago -
> > it's commonly known as a trash bin and you do it in userspace with a
> > wrapper around unlink that calls rename(2) instead. And then "empty
> > trashbin" is what does the unlink and permanently deletes the files.
> 
> As a practicing forensicator, I can say "potentially recoverable
> files" is a heavily used concept.

"forensicator"? I'm so behind on my terminology. :/

Depsite not having some fancy title, I do forensic analysis of
filesystem corpses *every day*.  I have to do this in far more
detail than a typical forensic analysis for data recovery or
security breach post-mortem purposes because I've got to find the
bug in the metadata that lead to the corruption or data loss in the
first place....

> I don't know XFS on disk structure in detail, so I'll comment about
> HFS+ and NTFS.

[snip]

XFS metadata is fully dynamic, so take the problems you have with
HFS btree directory structures and apply it to *every* metadata
structure in XFS.

> As a last resort, data carving tools equivalent to photorec are used.
> Photorec depends on the files not being fragmented and also fails to
> recover any filesystem metadata such as filenames, timestamps, etc.

Well, yes - anyone can grep a disk image for digital signatures and
then hope the files have been stored contiguously.

More advanced users write utilities like xfs_irecover or xfsr that
walk the filesystem looking for inode magic numbers and manually
decode the inode metadata themselves to recover the data they
reference even when the files are not contiguous. These only work on
unconnected inodes, though, because unlinked inodes don't have any
metadata in them that is useful:

xfs_db> inode 1029
xfs_db> p
core.magic = 0x494e
core.mode = 0
core.version = 2
core.format = 2 (extents)
core.nlinkv2 = 0
core.onlink = 0
core.projid_lo = 0
core.projid_hi = 0
core.uid = 0
core.gid = 0
core.flushiter = 2
core.atime.sec = Sun Mar  9 10:44:22 2014
core.atime.nsec = 821908000
core.mtime.sec = Sun Mar  9 10:44:22 2014
core.mtime.nsec = 821908000
core.ctime.sec = Sun Mar  9 10:45:02 2014
core.ctime.nsec = 273908000
core.size = 0
core.nblocks = 0
core.extsize = 0
core.nextents = 0
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 1
next_unlinked = null
u = (empty)
xfs_db> daddr 0x202
xfs_db> p
....
100: 494e0000 02020000 00000000 00000000 00000000 00000000 00000000 00000002
120: 531bab56 30fd5220 531bab56 30fd5220 531bab7e 10538120 00000000 00000000
140: 00000000 00000000 00000000 00000000 00000002 00000000 00000000 00000001
160: ffffffff 00000000 00000000 00000000 00000000 00000000 00000000 00000000
180: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1a0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1c0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1e0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

So, it has non-zero timestamps in it, but everything else is zeroed.
IOWs, you can't get any information about what it contained before
it was unlinked from it by looking at the unlinked inode on disk.

But that wasn't the original question being asked, though. ;)

> At the same time, I'm not familiar with forensic tool, free or
> commercial, that parses the XFS filesystem for live files and
> filesystem metadata such as timestamps.  (I could be wrong, it is not
> something I've had to research in the last few years.)

Finding lost and/or unreferenced *live* metadata is what xfs_repair
does. I've mentioned other tools above that can also be used for
recovering stuff that xfs_repair won't find because it doesn't do a
magic number search of every filesystem block in the fs...

> > Besides, from a conceptual point of view after-the-fact filesystem
> > based undelete is fundamentally flawed. i.e.  the journal is a
> > write-ahead logging journal and so can only be used to roll the
> > filesystem state forwardi in time. Undelete requires having state
> > and data in the journal that allows the filesystem to be rolled
> > *backwards in time*. XFS simply does not record such information in
> > the log and so parsing the log to "undelete files by transaction
> > rollback" just doesn't work.
> 
> I suspect you are assuming the goal is "reliable undelete".  The

No at all.

> typical goal is the identification of potentially recoverable files.
> I don't know if parsing the XFS journal can help with that.

That's exactly the question I answered: journal parsing is mostly
useless for forensic analysis of XFS filesystems with respect to
recovery of deleted files.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
