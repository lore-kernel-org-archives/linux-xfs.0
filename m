Return-Path: <SRS0=0TO6=3H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79CAC32771
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 04:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2B2C2072B
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 04:39:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sXcuYB9W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgAREjy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 23:39:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47486 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgAREjy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 23:39:54 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00I4d1eo194943;
        Sat, 18 Jan 2020 04:39:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=AZw/IikVLl1PHoi1gscTObibL0jAEWWsy6NS/tMqPes=;
 b=sXcuYB9WPYBmZKTarse+EYDY7FtUPQnY7ATA7LPcKKxd7iQ3TRnE7dNR4N8BYyfR7yG5
 KHDn/RupGEQZCmlluYoiWDp9hd/wynnSJb0gPfAneuhup7XcpD4oWzIZH6oN4n4W6cNR
 nZBK8LHW8B8aG2wpOX2tQyTt33cMPnw7t7VsQ7yYQzFyqCQPbDdpYhBU6u+pVsnv1pa5
 50+i/KVz27mSvY9TXBHkJnR3W8cisV4+4lXVv1ZDUGkhKqZJDPUkW0HFMlC3mr3csdKL
 BE3y1rnb210eEz7OWY9rZc+M7dgfykWBYd7sdURECVZ7+aw4FynvAUIgr8Tnw2lmD7Yd NQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xksypr5jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jan 2020 04:39:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00I4cfZi017570;
        Sat, 18 Jan 2020 04:39:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xksc34gh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jan 2020 04:39:49 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00I4dmNG006582;
        Sat, 18 Jan 2020 04:39:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jan 2020 20:39:48 -0800
Date:   Fri, 17 Jan 2020 20:39:47 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: stop using ->data_entry_p()
Message-ID: <20200118043947.GO8257@magnolia>
References: <2cf1f45b-b3b2-f630-50d5-ff34c000b0c8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cf1f45b-b3b2-f630-50d5-ff34c000b0c8@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9503 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001180037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9503 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001180037
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 17, 2020 at 05:17:11PM -0600, Eric Sandeen wrote:
> The ->data_entry_p() op went away in v5.5 kernelspace, so rework
> xfs_repair to use ->data_entry_offset instead, in preparation
> for the v5.5 libxfs backport.
> 
> This could later be cleaned up to use offsets as was done
> in kernel commit 8073af5153c for example.

See, now that you've said that, I start wondering why not do that?

:D

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> I'll munge this patch in mid-libxfs-sync, just before the
> ->data_entry_p removal patch.
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index 4ac0084e..2494f3c4 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -580,7 +580,7 @@ process_dir2_data(
>  
>  	d = bp->b_addr;
>  	bf = M_DIROPS(mp)->data_bestfree_p(d);
> -	ptr = (char *)M_DIROPS(mp)->data_entry_p(d);
> +	ptr = (char *)d + M_DIROPS(mp)->data_entry_offset;
>  	badbest = lastfree = freeseen = 0;
>  	if (be16_to_cpu(bf[0].length) == 0) {
>  		badbest |= be16_to_cpu(bf[0].offset) != 0;
> @@ -646,7 +646,7 @@ process_dir2_data(
>  			do_warn(_("\twould junk block\n"));
>  		return 1;
>  	}
> -	ptr = (char *)M_DIROPS(mp)->data_entry_p(d);
> +	ptr = (char *)d + M_DIROPS(mp)->data_entry_offset;
>  	/*
>  	 * Process the entries now.
>  	 */
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 91d208a6..d61b2ae7 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1530,7 +1530,7 @@ longform_dir2_entry_check_data(
>  
>  	bp = *bpp;
>  	d = bp->b_addr;
> -	ptr = (char *)M_DIROPS(mp)->data_entry_p(d);
> +	ptr = (char *)d + M_DIROPS(mp)->data_entry_offset;
>  	nbad = 0;
>  	needscan = needlog = 0;
>  	junkit = 0;
> @@ -1590,7 +1590,7 @@ longform_dir2_entry_check_data(
>  				break;
>  
>  			/* check for block with no data entries */
> -			if ((ptr == (char *)M_DIROPS(mp)->data_entry_p(d)) &&
> +			if ((ptr == (char *)d + M_DIROPS(mp)->data_entry_offset) &&
>  			    (ptr + be16_to_cpu(dup->length) >= endptr)) {
>  				junkit = 1;
>  				*num_illegal += 1;
> @@ -1659,7 +1659,7 @@ longform_dir2_entry_check_data(
>  			do_warn(_("would fix magic # to %#x\n"), wantmagic);
>  	}
>  	lastfree = 0;
> -	ptr = (char *)M_DIROPS(mp)->data_entry_p(d);
> +	ptr = (char *)d + M_DIROPS(mp)->data_entry_offset;
>  	/*
>  	 * look at each entry.  reference inode pointed to by each
>  	 * entry in the incore inode tree.
> @@ -1834,7 +1834,7 @@ longform_dir2_entry_check_data(
>  			       (dep->name[0] == '.' && dep->namelen == 1));
>  			add_inode_ref(current_irec, current_ino_offset);
>  			if (da_bno != 0 ||
> -			    dep != M_DIROPS(mp)->data_entry_p(d)) {
> +			    dep != (void *)d + M_DIROPS(mp)->data_entry_offset) {

Er.... void pointer arithmetic?

(Though I really do wish the original author of the kernel patchset had
supplied a xfsprogs port of the kernel patches so we maintainers don't
get stuck doing all the porting work...)

--D

>  				/* "." should be the first entry */
>  				nbad++;
>  				if (entry_junked(
> 
