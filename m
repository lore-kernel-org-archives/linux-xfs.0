Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C12CA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 15:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 528A220650
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 15:38:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T94mN0Vx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503333AbfJXPic (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 11:38:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40872 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503151AbfJXPic (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 11:38:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9OFCl3X021199;
        Thu, 24 Oct 2019 15:38:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Zyc7HDA8wn8wKUZ9hXSOwrDrmOCtw3lcWvQ1w9PeiMk=;
 b=T94mN0VxiYXSnXOSXe/UeT6yLb/VKgr+crqDrozCAruyprfI508eE4BPrWIivttEnChd
 HASQVNaUaeDYCoU14dulN6c4KdCMku4uSwPvHPxc7A14RC0wB18BovlqLCodleBaCSG0
 85OkjNVlqNxwMgUIf0xQQ7pgy8fnzj5jhqYruqQWxftn3Drv1A1+/cLl/FizhrbOKfLp
 x6gtm3m30otLYchHvxYhT9dRrZyraKbfRiV1koLs7bCUZ7eVPoYBpye+4t+xJvaVT+GU
 AEGUY+YJxPS3QTtuJuz3IJBYbnTM+yD6e450Ljlo0t3CnT2sfTWipD2zyysiPKp8taZP hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vqu4r4ae4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 15:38:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9OF4UIO016759;
        Thu, 24 Oct 2019 15:38:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vtjkjy3h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 15:38:06 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9OFc4tO012823;
        Thu, 24 Oct 2019 15:38:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 08:38:04 -0700
Date:   Thu, 24 Oct 2019 08:38:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v7 11/17] xfs: refactor suffix_kstrtoint()
Message-ID: <20191024153803.GU913374@magnolia>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
 <157190349282.27074.327122390885823342.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157190349282.27074.327122390885823342.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910240139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910240139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 03:51:32PM +0800, Ian Kent wrote:
> The mount-api doesn't have a "human unit" parse type yet so the options
> that have values like "10k" etc. still need to be converted by the fs.

Do you have plans to add such a thing to the mount api?  Or port the xfs
helper?  TBH I'd have thought that would show up as one of the vfs
patches at the start of this series.

I guess the patch itself looks fine as temporary support structures for
handling a transition.

--D

> But the value comes to the fs as a string (not a substring_t type) so
> there's a need to change the conversion function to take a character
> string instead.
> 
> When xfs is switched to use the new mount-api match_kstrtoint() will no
> longer be used and will be removed.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_super.c |   38 +++++++++++++++++++++++++++++---------
>  1 file changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 97c3f1edb69c..003ec725d4b6 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -112,14 +112,17 @@ static const match_table_t tokens = {
>  };
>  
>  
> -STATIC int
> -suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
> +static int
> +suffix_kstrtoint(
> +	const char	*s,
> +	unsigned int	base,
> +	int		*res)
>  {
> -	int	last, shift_left_factor = 0, _res;
> -	char	*value;
> -	int	ret = 0;
> +	int		last, shift_left_factor = 0, _res;
> +	char		*value;
> +	int		ret = 0;
>  
> -	value = match_strdup(s);
> +	value = kstrdup(s, GFP_KERNEL);
>  	if (!value)
>  		return -ENOMEM;
>  
> @@ -144,6 +147,23 @@ suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
>  	return ret;
>  }
>  
> +static int
> +match_kstrtoint(
> +	const substring_t	*s,
> +	unsigned int		base,
> +	int			*res)
> +{
> +	const char		*value;
> +	int			ret;
> +
> +	value = match_strdup(s);
> +	if (!value)
> +		return -ENOMEM;
> +	ret = suffix_kstrtoint(value, base, res);
> +	kfree(value);
> +	return ret;
> +}
> +
>  /*
>   * This function fills in xfs_mount_t fields based on mount args.
>   * Note: the superblock has _not_ yet been read in.
> @@ -155,7 +175,7 @@ suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
>   * path, and we don't want this to have any side effects at remount time.
>   * Today this function does not change *sb, but just to future-proof...
>   */
> -STATIC int
> +static int
>  xfs_parseargs(
>  	struct xfs_mount	*mp,
>  	char			*options)
> @@ -206,7 +226,7 @@ xfs_parseargs(
>  				return -EINVAL;
>  			break;
>  		case Opt_logbsize:
> -			if (suffix_kstrtoint(args, 10, &mp->m_logbsize))
> +			if (match_kstrtoint(args, 10, &mp->m_logbsize))
>  				return -EINVAL;
>  			break;
>  		case Opt_logdev:
> @@ -222,7 +242,7 @@ xfs_parseargs(
>  				return -ENOMEM;
>  			break;
>  		case Opt_allocsize:
> -			if (suffix_kstrtoint(args, 10, &iosize))
> +			if (match_kstrtoint(args, 10, &iosize))
>  				return -EINVAL;
>  			iosizelog = ffs(iosize) - 1;
>  			break;
> 
