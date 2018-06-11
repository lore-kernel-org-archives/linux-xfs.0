Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57146 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932740AbeFKSA7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jun 2018 14:00:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5BHttXa136620
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 18:00:58 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2jgecxdsxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 18:00:58 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5BI0vPk024052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 18:00:57 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5BI0vq2013599
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 18:00:57 GMT
Date: Mon, 11 Jun 2018 11:00:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 23/27] xfsprogs: Do not use namechecks on parent
 pointers
Message-ID: <20180611180052.GE22045@magnolia>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
 <1528607272-11122-24-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1528607272-11122-24-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Jun 09, 2018 at 10:07:48PM -0700, Allison Henderson wrote:
> Attribute names of parent pointers are not strings.  So
> avoid doing namechecks for these attributes.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  repair/attr_repair.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 8b1b8a7..b8b0768 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -308,8 +308,9 @@ process_shortform_attr(
>  		/* namecheck checks for / and null terminated for file names.
>  		 * attributes names currently follow the same rules.
>  		*/
> -		if (namecheck((char *)&currententry->nameval[0],
> -						currententry->namelen))  {
> +		if (!(currententry->flags & XFS_ATTR_PARENT) &&
> +			namecheck((char *)&currententry->nameval[0],
> +			currententry->namelen))  {
>  			do_warn(

Please don't indent the condition tests to the same column as the code.
Either line them up with the if parentheses or double-tab them.

if (!(currententry->flags & XFS_ATTR_PARENT) &&
    namecheck((char *)&currententry->nameval[0],
		currententry->namelen)) {
	do_warn(...);
}

>  	_("entry contains illegal character in shortform attribute name\n"));
>  			junkit = 1;
> @@ -470,8 +471,9 @@ process_leaf_attr_local(
>  	xfs_attr_leaf_name_local_t *local;
>  
>  	local = xfs_attr3_leaf_name_local(leaf, i);
> -	if (local->namelen == 0 || namecheck((char *)&local->nameval[0],
> -							local->namelen)) {
> +	if (!(entry->flags & XFS_ATTR_PARENT) &&
> +		(local->namelen == 0 || namecheck((char *)&local->nameval[0],
> +		local->namelen))) {

Why skip the namelen checks when it's a parent pointer?  Isn't the pptr
corrupt if the (ino, gen, offset) data is length zero?

>  		do_warn(
>  	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
>  			i, da_bno, ino, local->namelen);
> @@ -525,13 +527,15 @@ process_leaf_attr_remote(
>  
>  	remotep = xfs_attr3_leaf_name_remote(leaf, i);
>  
> -	if (remotep->namelen == 0 || namecheck((char *)&remotep->name[0],
> -						remotep->namelen) ||
> +	if (!(entry->flags & XFS_ATTR_PARENT) &&
> +			(remotep->namelen == 0 ||
> +			namecheck((char *)&remotep->name[0],
> +				remotep->namelen) ||
>  			be32_to_cpu(entry->hashval) !=
>  				libxfs_da_hashname((unsigned char *)&remotep->name[0],
>  						remotep->namelen) ||
>  			be32_to_cpu(entry->hashval) < last_hashval ||
> -			be32_to_cpu(remotep->valueblk) == 0) {
> +			be32_to_cpu(remotep->valueblk) == 0)) {

Do parent pointer attrs ever end up using a remote value block to store
the name?  If so, I think you only want to skip the namecheck, not the
namelen/hashval/valueblk checks, right?

--D

>  		do_warn(
>  	_("inconsistent remote attribute entry %d in attr block %u, ino %" PRIu64 "\n"), i, da_bno, ino);
>  		return -1;
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
