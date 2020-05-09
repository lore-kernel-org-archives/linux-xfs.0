Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF51C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A33A52184D
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:08:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DpKjxHxZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgEIRIH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:08:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35856 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIRIG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:08:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049H82Fi132512;
        Sat, 9 May 2020 17:08:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=pqfmXgmx4sUTWxRz49kqoAyfxtH8/qD/0AuftnQowrY=;
 b=DpKjxHxZzKWuzVa6x9uKi7Mb9rix39EKCU+zmUJcjs4uAmEU1l/QwfoNmoXNCu0E8Rn/
 im/uyRzY6FfiQXzwNabg+p/XxAgtCnTys/RtbNuN+58KEUybcr3+8i/RwuJxKaPrkg6E
 kiWKw3fPD2ehzcCcUU6oXqb1KLEuwEXxCjvdr7uHz3UWtPZd1Nh14V4mFzplaB23z8pS
 DttqhCSowgIohslNCDzW6YZ+jsF70ydCQDPS3nFQ1cDaiRxN+MMmWeVQLNB9rDAtHFO1
 szpTaX7URRjGFf7ecZvRvJYCQov9snxwKDHxns+kWlDnSS6wcpZFVH+AeL321BQY+eXR UQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30x0n1r00j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 17:08:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049H4kSh175670;
        Sat, 9 May 2020 17:08:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30wwwprhfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 17:08:01 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049H815H003999;
        Sat, 9 May 2020 17:08:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 10:08:01 -0700
Date:   Sat, 9 May 2020 10:08:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] db: cleanup attr_set_f and attr_remove_f
Message-ID: <20200509170800.GR6714@magnolia>
References: <20200509170125.952508-1-hch@lst.de>
 <20200509170125.952508-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509170125.952508-5-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=7 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=7 phishscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=999 adultscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 07:01:21PM +0200, Christoph Hellwig wrote:
> Don't use local variables for information that is set in the da_args
> structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems like a good cleanup,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  db/attrset.c | 67 ++++++++++++++++++++++------------------------------
>  1 file changed, 28 insertions(+), 39 deletions(-)
> 
> diff --git a/db/attrset.c b/db/attrset.c
> index 1ff2eb85..0a464983 100644
> --- a/db/attrset.c
> +++ b/db/attrset.c
> @@ -67,10 +67,9 @@ attr_set_f(
>  	int			argc,
>  	char			**argv)
>  {
> -	struct xfs_inode	*ip = NULL;
> -	struct xfs_da_args	args = { NULL };
> -	char			*name, *value, *sp;
> -	int			c, valuelen = 0;
> +	struct xfs_da_args	args = { };
> +	char			*sp;
> +	int			c;
>  
>  	if (cur_typ == NULL) {
>  		dbprintf(_("no current type\n"));
> @@ -111,8 +110,9 @@ attr_set_f(
>  
>  		/* value length */
>  		case 'v':
> -			valuelen = (int)strtol(optarg, &sp, 0);
> -			if (*sp != '\0' || valuelen < 0 || valuelen > 64*1024) {
> +			args.valuelen = strtol(optarg, &sp, 0);
> +			if (*sp != '\0' ||
> +			    args.valuelen < 0 || args.valuelen > 64 * 1024) {
>  				dbprintf(_("bad attr_set valuelen %s\n"), optarg);
>  				return 0;
>  			}
> @@ -129,35 +129,29 @@ attr_set_f(
>  		return 0;
>  	}
>  
> -	name = argv[optind];
> +	args.name = (const unsigned char *)argv[optind];
> +	args.namelen = strlen(argv[optind]);
>  
> -	if (valuelen) {
> -		value = (char *)memalign(getpagesize(), valuelen);
> -		if (!value) {
> -			dbprintf(_("cannot allocate buffer (%d)\n"), valuelen);
> +	if (args.valuelen) {
> +		args.value = memalign(getpagesize(), args.valuelen);
> +		if (!args.value) {
> +			dbprintf(_("cannot allocate buffer (%d)\n"),
> +				args.valuelen);
>  			goto out;
>  		}
> -		memset(value, 'v', valuelen);
> -	} else {
> -		value = NULL;
> +		memset(args.value, 'v', args.valuelen);
>  	}
>  
> -	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip,
> +	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp,
>  			&xfs_default_ifork_ops)) {
>  		dbprintf(_("failed to iget inode %llu\n"),
>  			(unsigned long long)iocur_top->ino);
>  		goto out;
>  	}
>  
> -	args.dp = ip;
> -	args.name = (unsigned char *)name;
> -	args.namelen = strlen(name);
> -	args.value = value;
> -	args.valuelen = valuelen;
> -
>  	if (libxfs_attr_set(&args)) {
>  		dbprintf(_("failed to set attr %s on inode %llu\n"),
> -			name, (unsigned long long)iocur_top->ino);
> +			args.name, (unsigned long long)iocur_top->ino);
>  		goto out;
>  	}
>  
> @@ -166,10 +160,10 @@ attr_set_f(
>  
>  out:
>  	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
> -	if (ip)
> -		libxfs_irele(ip);
> -	if (value)
> -		free(value);
> +	if (args.dp)
> +		libxfs_irele(args.dp);
> +	if (args.value)
> +		free(args.value);
>  	return 0;
>  }
>  
> @@ -178,9 +172,7 @@ attr_remove_f(
>  	int			argc,
>  	char			**argv)
>  {
> -	struct xfs_inode	*ip = NULL;
> -	struct xfs_da_args	args = { NULL };
> -	char			*name;
> +	struct xfs_da_args	args = { };
>  	int			c;
>  
>  	if (cur_typ == NULL) {
> @@ -223,23 +215,20 @@ attr_remove_f(
>  		return 0;
>  	}
>  
> -	name = argv[optind];
> +	args.name = (const unsigned char *)argv[optind];
> +	args.namelen = strlen(argv[optind]);
>  
> -	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip,
> +	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp,
>  			&xfs_default_ifork_ops)) {
>  		dbprintf(_("failed to iget inode %llu\n"),
>  			(unsigned long long)iocur_top->ino);
>  		goto out;
>  	}
>  
> -	args.dp = ip;
> -	args.name = (unsigned char *)name;
> -	args.namelen = strlen(name);
> -	args.value = NULL;
> -
>  	if (libxfs_attr_set(&args)) {
>  		dbprintf(_("failed to remove attr %s from inode %llu\n"),
> -			name, (unsigned long long)iocur_top->ino);
> +			(unsigned char *)args.name,
> +			(unsigned long long)iocur_top->ino);
>  		goto out;
>  	}
>  
> @@ -248,7 +237,7 @@ attr_remove_f(
>  
>  out:
>  	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
> -	if (ip)
> -		libxfs_irele(ip);
> +	if (args.dp)
> +		libxfs_irele(args.dp);
>  	return 0;
>  }
> -- 
> 2.26.2
> 
