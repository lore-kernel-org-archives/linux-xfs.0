Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 15:07:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m32M7PR1003507
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 15:07:29 -0700
Date: Thu, 3 Apr 2008 08:07:50 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Serious XFS crash
Message-ID: <20080402220750.GJ103491721@sgi.com>
References: <20080325185453.3a1957dd@galadriel.home> <20080325233611.GW103491721@sgi.com> <20080401140035.46470306@galadriel.home> <20080402055831.GG103491721@sgi.com> <20080402133003.4bb043e4@galadriel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080402133003.4bb043e4@galadriel.home>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Wed, Apr 02, 2008 at 01:30:03PM +0200, Emmanuel Florac wrote:
> Le Wed, 2 Apr 2008 15:58:31 +1000 vous écriviez:
> 
> > The log is rather garbled - can you repost? Also, XFS usually outputs
> > an error message before the stack trace; can you make sure you
> > paste that as well (if it exists)?
> 
> Well I attached the relevant part of kern.log; the message just before
> the crash is not very clear... You can see the other messages relevant
> to the disk error too.

Like the fact reiser is also complaining about corrupted blocks?

> Mar  6 06:25:04 system3 kernel: 3w-9xxx: scsi0: AEN: WARNING (0x04:0x0023): Sector repair completed:port=6, LBA=0xE6E2A.
> Mar  6 06:25:04 system3 kernel: ReiserFS: warning: is_tree_node: node level 28784 does not match to the expected one 1
> Mar  6 06:25:04 system3 kernel: ReiserFS: sda1: warning: vs-5150: search_by_key: invalid format found in block 753671. Fsck?
> Mar  6 06:25:04 system3 kernel: ReiserFS: sda1: warning: vs-13070: reiserfs_read_locked_inode: i/o failure occurred trying to find stat data of [18404 18463 0x0 SD]

and:

> Mar  6 10:42:46 system3 kernel: 0x0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> Mar  6 10:42:46 system3 kernel: Filesystem "md0": XFS internal error xfs_alloc_read_agf at line 2190 of file fs/xfs/xfs_alloc.c.  Caller 0xc01f4b88

That's an AGF made up of zeros instead of real metadata. Something has
trashed it - perhaps a "sector repair"?

> Mar  6 10:42:46 system3 kernel: Please umount the filesystem, and rectify the problem(s)
> Mar  6 10:51:19 system3 kernel: 3w-9xxx: scsi0: AEN: WARNING (0x04:0x0023): Sector repair completed:port=6, LBA=0xE6E00.
> Mar  6 10:51:20 system3 kernel: 3w-9xxx: scsi0: AEN: WARNING (0x04:0x0023): Sector repair completed:port=6, LBA=0xE6DCA.

I'd go and find whatever disk is located at LBA 0xE6DCA-0xE6E2A and
replace it - if there are that many repairs needed on it, it's likely
to be failing....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
