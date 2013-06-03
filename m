Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E0A797CBF
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 16:38:32 -0500 (CDT)
Message-ID: <51AD0CD6.80404@sgi.com>
Date: Mon, 03 Jun 2013 16:38:30 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/6] xfs: disable noattr2/attr2 mount options for CRC
	enabled filesystems
References: <1370237332-24757-1-git-send-email-david@fromorbit.com>
	<1370237332-24757-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1370237332-24757-6-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com, xfs@oss.sgi.com

On 06/03/13 00:28, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> attr2 format is always enabled for v5 superblock filesystems, so the
> mount options to enable or disable it need to be cause mount errors.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   Documentation/filesystems/xfs.txt |    3 +++
>   fs/xfs/xfs_super.c                |   11 +++++++++++
>   2 files changed, 14 insertions(+)
>
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 3e4b3dd..83577f0 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -33,6 +33,9 @@ When mounting an XFS filesystem, the following options are accepted.
>   	removing extended attributes) the on-disk superblock feature
>   	bit field will be updated to reflect this format being in use.
>
> +	CRC enabled filesystems always use the attr2 format, and so
Filesystems using the version 5 superblock always use the attr2 format, 
and so
> +	will reject the noattr2 mount option if it is set.
  reject the noattr2 mount option if it is set.
> +
>     barrier
>   	Enables the use of block layer write barriers for writes into
>   	the journal and unwritten extent conversion.  This allows for
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index ea341ce..f62abb2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1373,6 +1373,17 @@ xfs_finish_flags(
>   	}
>
>   	/*
> +	 * CRC enabled filesystems always use attr2 format for attributes.

             V5 filesystems always use attr2 format for attributes.

> +	 */
> +	if (xfs_sb_version_hascrc(&mp->m_sb)&&

...

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
