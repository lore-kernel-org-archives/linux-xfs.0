Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8RFWx2B111503 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 10:32:59 -0500
Date: Thu, 27 Sep 2012 10:34:15 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: more efficient way to print out inode->block mappings?
Message-ID: <20120927153415.GI13214@sgi.com>
References: <50643AF7.7060106@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50643AF7.7060106@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Hey Linda,

On Thu, Sep 27, 2012 at 04:39:35AM -0700, Linda Walsh wrote:
> I want to be able to rapidly determine the diffs between 2 volumes.
> 
> Special note 1 is an active lvm snapshot of the other -- meaning it is
> frozen in time, but otherwise should look identical the the file system
> as it was when it was snapped.
> 
> Sooo... a way of speeding checks is finding out what blocks allocated to the indoes
> are different, since as the new volume gets used, I had hoped that differing
> block numbers might give me a clue as to what had changed..

Differing block maps for the same inode on the two filesystems will give you a
clue that there are changes but it isn't perfect:

Consider xfs_fsr.  This might change block numbers for a file but the contents
stayed the same.

Also consider an overwrite situation.  The contents of the file are overwritten
and have changed but the block map stayed the same.  To detect that we'd need
some kind of generation number on every extent, and we don't have that.

At this time I don't think we have a solid way to tell you which blocks of a
file are different without actually comparing them.  I think you are stuck
looking at the mtime and then doing a full comparison.

Have you looked into using the xfs bulkstat ioctl interfaces?
XFS_IOC_FSBULKSTAT won't get you the block map, but maybe it would be useful to
you.  xfs_bmap is using XFS_IOC_GETBMAP*, but it sounds like you've already
considered that.  Maybe a creative invocation of xfsdump?

Let me know if I misunderstood and went off the rails.  ;)

HTH,
Ben

> Nevertheless, trying to read the blocks allocated/inode with bmap is sorta slow.
> I've tried to optimize it by starting a pty session to xfs_db and issuing inode/bmap
> commands -- but I have to wait for a prompt to come back to know that the command
> has finished, and I'm not really sure it's really returning more than 1 line
> for any file. -- though interactively, I can find a file with a large ACL, and see
> it has both a data and attr bmap.  I also haven't seen what output would look like
> if the file(or dir) was split -- as, so far, have only seen
> files/dirs returned that
> have 1 allocation/file,
> 
> So what the means is that I'm not sure about synchronization between commands output
> and the input I read in -- even though I read in the input after
> every command. -- but even with
> a minimal timeout of 1ms, and keeping track of commands outstanding
> and replies (as measured
> by 'prompts' recieved, I'm far from convinced it's doing the right
> thing -- and it still
> slow going 1 inode at a time over a pty interface.
> 
> I thought of trying to use blockget -v and parsing the output.  I
> figured that would
> have the least latency and likely be the fastest way to dump the mappings -- BUT
> it seems I can't get it to work on an active file system.  So how
> can I get that block
> info dumped without blockget?  I've already told blockget it's in -r
> only mode... so it
> shouldn't try to repair inconsistencies...and 99.999% is going to be
> what I want and any
> inconsistencies, I can check manually be checking the files through
> the mounted interface.
> 
> Oddly, and likely I'm confused about something, but when  i try to
> print the log/log_print,
> it says it is an invalid log 1 byte long, so even if it were played out, I don't
> think it would make much difference in the final results.
> 
> Is it possible to do what I want w/o writing a special util/C prog to dump this?
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
