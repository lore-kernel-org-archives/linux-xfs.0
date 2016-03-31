Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 225677CA3
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 06:14:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 97E1DAC004
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 04:14:35 -0700 (PDT)
Received: from mail-pa0-f68.google.com (mail-pa0-f68.google.com
	[209.85.220.68]) by cuda.sgi.com with ESMTP id h7FS2LYj6xSo2JZQ
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Mar 2016 04:14:34 -0700 (PDT)
Received: by mail-pa0-f68.google.com with SMTP id hn5so7956413pac.2
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 04:14:34 -0700 (PDT)
Date: Thu, 31 Mar 2016 19:14:30 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] xfs: add missing break in xfs_parseargs()
Message-ID: <20160331111046.GA2059@eguan.usersys.redhat.com>
References: <1459415583-26981-1-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459415583-26981-1-git-send-email-guaneryu@gmail.com>
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
To: xfs@oss.sgi.com
Cc: esandeen@redhat.com

On Thu, Mar 31, 2016 at 05:13:03PM +0800, Eryu Guan wrote:
> Commit 2e74af0e1189 ("xfs: convert mount option parsing to tokens")
> missed a 'break;' in xfs_parseargs() which causes mount to fail with
> "-o pqnoenforce" option. xfs/050 catches this failure.
> 
> XFS (vda6): Super block does not support project and group quota together

Forgot to mention that it only fails for v4 xfs, but v5 xfs enables
group quota automatically in this case.

Thanks,
Eryu

> 
> Fixes: 2e74af0e1189 ("xfs: convert mount option parsing to tokens")
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> ---
>  fs/xfs/xfs_super.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d760934..361564e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -350,6 +350,7 @@ xfs_parseargs(
>  		case Opt_pqnoenforce:
>  			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
>  			mp->m_qflags &= ~XFS_PQUOTA_ENFD;
> +			break;
>  		case Opt_gquota:
>  		case Opt_grpquota:
>  			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
> -- 
> 2.5.5
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
