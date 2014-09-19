Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 477BC7F3F
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2014 01:38:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B9A34AC002
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 23:37:57 -0700 (PDT)
Received: from mail-pd0-f177.google.com (mail-pd0-f177.google.com
	[209.85.192.177]) by cuda.sgi.com with ESMTP id
	SGtn38TxfUp9dbCu (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Sep 2014 23:37:52 -0700 (PDT)
Received: by mail-pd0-f177.google.com with SMTP id y10so1939795pdj.22
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 23:37:52 -0700 (PDT)
Date: Fri, 19 Sep 2014 14:37:48 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] xfstests: remove check_scratch_fs in btrfs/012
Message-ID: <20140919063748.GA13950@dhcp-13-216.nay.redhat.com>
References: <1409714759-9805-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1409714759-9805-1-git-send-email-bo.li.liu@oracle.com>
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
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Sep 03, 2014 at 11:25:59AM +0800, Liu Bo wrote:
> From: Liu Bo <liub.liubo@gmail.com>
> 
> btrfs/012 is a case to verify btrfs-convert feature, it converts an ext4 to
> btrfs firstly and do something, then rolls back to ext4.
> 
> So at last we have a ext4 on the scratch device, but setting _require_scratch
> will force a btrfsck on a ext4 fs because $FSTYP here is btrfs, and it ends up
> with a failure report of _check_btrfs_filesystem.
> 
> Now that we have deliberately check the final ext4 fs in btrfs/012, just do not
> set _require_scratch in this case.
> 
> Signed-off-by: Liu Bo <liub.liubo@gmail.com>
> ---
>  tests/btrfs/012 | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tests/btrfs/012 b/tests/btrfs/012
> index f7e5da5..12f6462 100755
> --- a/tests/btrfs/012
> +++ b/tests/btrfs/012
> @@ -52,7 +52,6 @@ _cleanup()
>  # Modify as appropriate.
>  _supported_fs btrfs
>  _supported_os Linux
> -_require_scratch

The test still requires a scratch device, so we cannot simply remove
this line. Now we can use _require_scratch_nocheck helper, and it
works fine based on my test.

Thanks,
Eryu

>  
>  BTRFS_CONVERT_PROG="`set_prog_path btrfs-convert`"
>  MKFS_EXT4_PROG="`set_prog_path mkfs.ext4`"
> -- 
> 1.8.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
