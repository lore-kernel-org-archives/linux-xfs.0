Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qADHhUsQ109200 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 11:43:30 -0600
Message-ID: <50A2873A.8080707@sgi.com>
Date: Tue, 13 Nov 2012 11:45:30 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs_db: flush devices before exiting
References: <1352444578-14600-1-git-send-email-david@fromorbit.com>
	<1352444578-14600-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1352444578-14600-2-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/09/12 01:02, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Test 287 uses xfs_db to change 32-bit project ID support while the
> filesystem is unmounted. On a large filesystem the test was failing
> due to the mount not seeing the feature bit in the superblock.
>
> xfs_db uses a different address space to the filesystem when it is
> mounte dby the kernel, so the only way to keep them coherent is to
> ensure that all buffered data is written to disk before the other
> entity tries to read it. xfs_db uses buffered IO, but does not close
> the devices when it exits, thereby leaving changes it has written in
> the block device cache rather than on disk. Hence when th ekernel
> tries to mount the filesystem, it reads what is on disk and does not
> see xfs_db's changes.
>
> Fix this by ensuring that xfs_db flushes it's changes to disk before
> it exits by caling libxfs_device_close(). This fsyncs the data and
> flushes the caches to ensure that it is present on disk before
> xfs_db exits.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good. Consistent to mkfs.xfs and xfs_repair.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
