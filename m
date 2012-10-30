Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UKET8W070045 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 15:14:29 -0500
Message-ID: <509035FB.2080402@sgi.com>
Date: Tue, 30 Oct 2012 15:18:03 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] 289: Test that filesystem sends discard requests
	only on free sectors
References: <1350549946-17192-1-git-send-email-tracek@redhat.com>
	<1350549946-17192-3-git-send-email-tracek@redhat.com>
In-Reply-To: <1350549946-17192-3-git-send-email-tracek@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On 10/18/2012 03:45 AM, Tomas Racek wrote:
> This is done by comparing free sectors reported by some FS utility
> (dumpe2fs/xfs_db) and actual discard commands sent to device obtained
> via blk tracer in debugfs.
>
> Currently supported FS are ext[34], xfs; device with discard support is
> not required, the test creates loop device for this purpose.
>
> Signed-off-by: Tomas Racek <tracek@redhat.com>
> ---
>   289     | 169 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   289.out |   5 ++
>   group   |   1 +
>   3 files changed, 175 insertions(+)
>   create mode 100755 289
>   create mode 100644 289.out
>


This will not work for 3.x kernels, but they 2.6 and 3.x both use the 
same path.

> +debugfs=$($MOUNT_PROG | grep debugfs | cut -d " " -f3)
> +[ -n $debugfs ] || _notrun "This test requires mounted debugfs"

As you use $debugfs quite a bit from here on, suggest doing something like:

debugfs=/sys/kernel/debug
if [ ! -d $debugfs ]; then
    _notrun "This test requires mounted debugfs"
fi

Other than that it looks great.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
