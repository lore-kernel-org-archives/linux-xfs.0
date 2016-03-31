Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D1D5D7CA3
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 10:04:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 42B46AC001
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 08:04:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nDVE94TEDc2Vv8Ta for <xfs@oss.sgi.com>;
	Thu, 31 Mar 2016 08:04:41 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 9DF8917248
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 10:04:41 -0500 (CDT)
Subject: Re: [PATCH] xfs: add missing break in xfs_parseargs()
References: <1459415583-26981-1-git-send-email-guaneryu@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56FD3C89.1080400@sandeen.net>
Date: Thu, 31 Mar 2016 10:04:41 -0500
MIME-Version: 1.0
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

On 3/31/16 4:13 AM, Eryu Guan wrote:
> Commit 2e74af0e1189 ("xfs: convert mount option parsing to tokens")
> missed a 'break;' in xfs_parseargs() which causes mount to fail with
> "-o pqnoenforce" option. xfs/050 catches this failure.
> 
> XFS (vda6): Super block does not support project and group quota together
> 
> Fixes: 2e74af0e1189 ("xfs: convert mount option parsing to tokens")
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Ugh, how did I miss that; I thought I scripted that whole change.

Thanks for catching it!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

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
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
