Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 837C57F37
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 08:00:50 -0500 (CDT)
Message-ID: <521DF47E.6060003@sgi.com>
Date: Wed, 28 Aug 2013 08:00:46 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: inode log reservations are too small
References: <1377670235-4168-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1377670235-4168-1-git-send-email-david@fromorbit.com>
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

On 08/28/13 01:10, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> We've been seeing occasional problems with log space leaks and
> transaction underruns such as this for some time:
>
>   XFS (dm-0): xlog_write: reservation summary:
>     trans type  = FSYNC_TS (36)
>     unit res    = 2740 bytes
>     current res = -4 bytes
>     total reg   = 0 bytes (o/flow = 0 bytes)
>     ophdrs      = 0 (ophdr space = 0 bytes)
>     ophdr + reg = 0 bytes
>     num regions = 0
>
> Turns out that xfstests generic/311 is reliably reproducing this
> problem with the test it runs at sequence 16 of it execution. It is
> a 100% reliable reproducer with the mkfs configuration of "-b
> size=1024 -m crc=1" on a 10GB scratch device.
>
> The problem? Inode forks in btree format are logged in memory
> format, not disk format (i.e. bmbt format, not bmdr format). That
> means there is a btree block header being logged, when such a
> structure is never written to the inode fork in bmdr format. The
> bmdr header in the inode is only 4 bytes, while the bmbt header is
> 24 bytes for v4 filesystems and 72 bytes for v5 filesystems.
>
> We currently reserve the inode size plus the rounded up overhead of
> a logging a buffer, which is 128 bytes. That means the reservation
> for a 512 byte inode is 640 bytes. What we can actually log is:
>
> 	inode core, data and attr fork = 512 bytes
> 	inode log format + log op header = 56 + 12 = 68 bytes
> 	data fork bmbt hdr = 24/72 bytes
> 	attr fork bmbt hdr = 24/72 bytes
>
> So, for a v2 inodes we can log at least 628 bytes, but if we split that
> inode over the end of the log across log buffers, we need to also
> another log op header, which takes us to 640 bytes. If there's
> another reservation taken out of this that I haven't taken into
> account (perhaps multiple iclog splits?) or I haven't corectly
> calculated the bmbt format space used (entirely possible), then
> we will overun it.
>
> For v3 inodes the maximum is actually 724 bytes, and even a
> single maximally sized btree format fork can blow it (652 bytes).
> And that's exactly what is happening with the FSYNC_TS transaction
> in the above output - it's consumed 644 bytes of space after the CIL
> context took the space reserved for it (2100 bytes).
>
> This problem has always been present in the XFS code - the btree
> format inode forks have always been logged in this manner. Hence
> there has always been the possibility of an overrun with such a
> transaction. The CRC code has just exposed it frequently enough to
> be able to debug and understand the root cause....
>
> So, let's fix all the inode log space reservations.
>
> [ I'm so glad we spent the effort to clean up the transaction
>    reservation code. This is an easy fix now. ]

Looks good. Thanks for chasing it to the root cause.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
