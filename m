Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2291D7F3F
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 13:13:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0377D30405F
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 11:13:47 -0700 (PDT)
Received: from mail-ie0-f176.google.com (mail-ie0-f176.google.com
	[209.85.223.176]) by cuda.sgi.com with ESMTP id
	6HCMc5EFf9cTrfYw (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 18 May 2013 11:13:44 -0700 (PDT)
Received: by mail-ie0-f176.google.com with SMTP id at1so11423397iec.35
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 11:13:43 -0700 (PDT)
Message-ID: <5197C4C1.4050009@gmail.com>
Date: Sat, 18 May 2013 14:13:21 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/30] xfsprogs: Initial CRC support
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1368789205-19969-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 05/17/2013 07:12 AM, Dave Chinner wrote:
> Hi Folks,
>
> This is the first real "works ok" CRC patchset for xfsprogs. It
> provides full support for mkfs.xfs and xfs_repair, and partial
> read-only support for xfs_db.
>
> For mkfs.xfs, it does everything properly, and filesystems that are
> freshly made also run cleanly through xfs_repair and mount and run
> just fine.

This seemed to be worthy of early note:

xfs/031 30s ...[  587.843478] XFS (sdb6): Version 5 superblock detected. 
This kernel has EXPERIMENTAL support enabled!
[  587.843478] Use of these features in this kernel is at your own risk!
*** Error in `/sbin/mkfs.xfs': malloc(): smallbin double linked list 
corrupted: 0x0907f7d0 ***

The test doesn't seem to finish, but Ctrl-c ends the test cleanly.  No 
dmesg stuff is added, and strace doesn't show anything between the mount 
message and the error message.  I'll need to re-enable tracers to 
provide a trace...and as traces can be huge, I'll wait on your advice.

[BTW, the "30s" reference time is from the non-CRC run of your patched 
xfsprogs.  The non-CRC run looked good.]

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
