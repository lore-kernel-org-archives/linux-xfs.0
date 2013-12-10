Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3AA887F66
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:06:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BE1FAAC011
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 10:06:28 -0800 (PST)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id hwK3pmtxiPACpW6I (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 10:06:27 -0800 (PST)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id
	rBAI6OaN015656 for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 10:06:26 -0800
Message-ID: <52A75820.9090004@tlinx.org>
Date: Tue, 10 Dec 2013 10:06:24 -0800
From: LA Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Q: about xfs pre-allocation
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>


Could someone comment on my [mis-]understanding in regards to
what the note below said that was posted by someone else
to another list.  The pre-allocation behavior for XFS that the
note describes doesn't jive w/what I thought happened and I
was wondering if my brain was out of date or something (at
least in regards to this topic! ;-)).  Names elided from
Original Message, below for no great reason...

I thought file space pre-allocation ended when you closed the file??

But this note from the open-suse list indicates that, at least
with ext2, a kernel thread removes this later.  

I thought the FS-space allocator gave *preference* to having the
next file start at least "filesize%('allocsize || 64K')" from
the end of the previous, BUT, if needed it will allocate space
from the end of the previous file (rounded to fs-blocksize) if
space is really that tight.


-------- Original Message --------

FFFF,

Modern filesystems use preallocation.

Per <http://ext2.sourceforge.net/2005-ols/paper-html/node6.html> ext2
already had it by 2005.

That means when a file is created and written to they automatically
allocate a unused tail at the end of each file.

Then some time later (hours / days) they have a background kernel
thread that scavenges any tails that are still unused.

The positive is that files (like logs) growing slowly over time won't
get fragmented so badly.

The bad is that for highspeed filesystem filling tasks like a massive
rsync, the disk usage is anomalously high for a while (hours / days).

With XFS you can disable pre-allocation via the allocsize mount
parameter.  (That parameter has been around many years. so yes 11.4
has preallocation for XFS at a minimum and ext3/ext4 I think.)

allocsize=size

Sets the buffered I/O end-of-file preallocation size when doing
delayed allocation writeout (default size is 64KiB). Valid values for
this option are page size (typically 4KiB) through to 1GiB, inclusive,
in power-of-2 increments.

size = 0 disables preallocation and is probably smart on your
distination backup disk.

I assume other filesystems have a way to disable preallocation as well.

FYI: I don't know how to determine the total amount of preallocation
space on a filesystem.  I'm sure it can be done somehow.

gggg
----

To unsubscribe, e-mail: opensuse+unsubscribe@opensuse.org
To contact the owner, e-mail: opensuse+owner@opensuse.org


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
