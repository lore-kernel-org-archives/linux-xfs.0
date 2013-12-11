Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 96E637FA3
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 19:49:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 58F0C8F8049
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 17:49:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id G4Kvxj7sjxBGj3Ck for
	<xfs@oss.sgi.com>; Tue, 10 Dec 2013 17:49:26 -0800 (PST)
Message-ID: <52A7C4A4.1020108@redhat.com>
Date: Tue, 10 Dec 2013 20:49:24 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: Q: about xfs pre-allocation
References: <52A75820.9090004@tlinx.org>
In-Reply-To: <52A75820.9090004@tlinx.org>
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
To: LA Walsh <xfs@tlinx.org>, xfs-oss <xfs@oss.sgi.com>

On 12/10/2013 01:06 PM, LA Walsh wrote:
> 
> Could someone comment on my [mis-]understanding in regards to
> what the note below said that was posted by someone else
> to another list.  The pre-allocation behavior for XFS that the
> note describes doesn't jive w/what I thought happened and I
> was wondering if my brain was out of date or something (at
> least in regards to this topic! ;-)).  Names elided from
> Original Message, below for no great reason...
> 
> I thought file space pre-allocation ended when you closed the file??
> 

XFS normally frees post-eof preallocation on close, but there is the
possibility for the preallocated space to hang around longer if a file
is opened, written and closed repeatedly. You could observe this by
repeatedly doing an open/write/close cycle on a file with xfs_io. After
a few cycles, you'll see the blocks allocated to the file exceed the
size of the file.

> But this note from the open-suse list indicates that, at least
> with ext2, a kernel thread removes this later. 
> I thought the FS-space allocator gave *preference* to having the
> next file start at least "filesize%('allocsize || 64K')" from
> the end of the previous, BUT, if needed it will allocate space
> from the end of the previous file (rounded to fs-blocksize) if
> space is really that tight.
> 

XFS has a background scanning thread for this purpose as of 3.8. It runs
on a 5 minute interval by default and trims the speculative
preallocation from inodes that haven't been written to recently.

Brian

> 
> -------- Original Message --------
> 
> FFFF,
> 
> Modern filesystems use preallocation.
> 
> Per <http://ext2.sourceforge.net/2005-ols/paper-html/node6.html> ext2
> already had it by 2005.
> 
> That means when a file is created and written to they automatically
> allocate a unused tail at the end of each file.
> 
> Then some time later (hours / days) they have a background kernel
> thread that scavenges any tails that are still unused.
> 
> The positive is that files (like logs) growing slowly over time won't
> get fragmented so badly.
> 
> The bad is that for highspeed filesystem filling tasks like a massive
> rsync, the disk usage is anomalously high for a while (hours / days).
> 
> With XFS you can disable pre-allocation via the allocsize mount
> parameter.  (That parameter has been around many years. so yes 11.4
> has preallocation for XFS at a minimum and ext3/ext4 I think.)
> 
> allocsize=size
> 
> Sets the buffered I/O end-of-file preallocation size when doing
> delayed allocation writeout (default size is 64KiB). Valid values for
> this option are page size (typically 4KiB) through to 1GiB, inclusive,
> in power-of-2 increments.
> 
> size = 0 disables preallocation and is probably smart on your
> distination backup disk.
> 
> I assume other filesystems have a way to disable preallocation as well.
> 
> FYI: I don't know how to determine the total amount of preallocation
> space on a filesystem.  I'm sure it can be done somehow.
> 
> gggg
> ----
> 
> To unsubscribe, e-mail: opensuse+unsubscribe@opensuse.org
> To contact the owner, e-mail: opensuse+owner@opensuse.org
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
