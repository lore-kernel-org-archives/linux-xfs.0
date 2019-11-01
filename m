Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC7DCA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 19:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A0A1217D9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 19:36:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LuWqN4w7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfKATge (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 15:36:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57348 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfKATge (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 15:36:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1JYCLx190595;
        Fri, 1 Nov 2019 19:36:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=SQSoO3EJRWpQdLT7ut6b52c1KOmQv4EEH/NU/OxHgyg=;
 b=LuWqN4w7BrN59LUsi4H0qTgjLcbDU0JR3P7lsXsLRlTq1ADPfiDUjNAPo/twUv6OGkYq
 hc/3i29SvI6a1uDEAG3rXpt2EtaZLWm+8ZfvVrBJhbS/RktbVFXyHQ50jDhYpkVyklY7
 wMvIwrJmA5rtAmH2X6v8r0mzOVoMZEyReLE6iu/IaPtF/XW0hCs7e0jm4avk3xfx7lEk
 OgP+NFPlsj6NybkMiKtErIk0hR1Yel7eY4DVsYCOgBa25DmXJQEMhmfSrRMzTr6mOTIW
 4NPE8CasXrZLpvL2PvLX2h091prlA2bmZMUjwlrX6AEn8Jw1CyAlzHMe7XAmFRbA0Fev xA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vxwhg3q9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 19:36:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1JXN1C168181;
        Fri, 1 Nov 2019 19:36:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w0ruru2d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 19:35:59 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA1JZxWr004866;
        Fri, 1 Nov 2019 19:35:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 12:35:59 -0700
Date:   Fri, 1 Nov 2019 12:35:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v8 08/16] xfs: refactor suffix_kstrtoint()
Message-ID: <20191101193556.GF15222@magnolia>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
 <157259464504.28278.7881741705300582881.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157259464504.28278.7881741705300582881.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:50:45PM +0800, Ian Kent wrote:
> The mount-api doesn't have a "human unit" parse type yet so the options
> that have values like "10k" etc. still need to be converted by the fs.
> 
> But the value comes to the fs as a string (not a substring_t type) so
> there's a need to change the conversion function to take a character
> string instead.
> 
> When xfs is switched to use the new mount-api match_kstrtoint() will no
> longer be used and will be removed.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |   38 +++++++++++++++++++++++++++++---------
>  1 file changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index bdf6c069e3ea..0dc072700599 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -108,14 +108,17 @@ static const match_table_t tokens = {
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
> @@ -140,6 +143,23 @@ suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
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
> @@ -151,7 +171,7 @@ suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
>   * path, and we don't want this to have any side effects at remount time.
>   * Today this function does not change *sb, but just to future-proof...
>   */
> -STATIC int
> +static int
>  xfs_parseargs(
>  	struct xfs_mount	*mp,
>  	char			*options)
> @@ -194,7 +214,7 @@ xfs_parseargs(
>  				return -EINVAL;
>  			break;
>  		case Opt_logbsize:
> -			if (suffix_kstrtoint(args, 10, &mp->m_logbsize))
> +			if (match_kstrtoint(args, 10, &mp->m_logbsize))
>  				return -EINVAL;
>  			break;
>  		case Opt_logdev:
> @@ -210,7 +230,7 @@ xfs_parseargs(
>  				return -ENOMEM;
>  			break;
>  		case Opt_allocsize:
> -			if (suffix_kstrtoint(args, 10, &size))
> +			if (match_kstrtoint(args, 10, &size))
>  				return -EINVAL;
>  			mp->m_allocsize_log = ffs(size) - 1;
>  			mp->m_flags |= XFS_MOUNT_ALLOCSIZE;
> 
