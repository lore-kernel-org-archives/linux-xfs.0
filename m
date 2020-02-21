Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1EBAC35646
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 15:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C55AB20679
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 15:21:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QlljwFwf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgBUPVj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 10:21:39 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44678 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbgBUPVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 10:21:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LFHek6017622;
        Fri, 21 Feb 2020 15:21:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=PVKvBg4GsIy9NxI6n+19KCbNSWmdeI4aiTuyGvvWktE=;
 b=QlljwFwfQ5gJz5I7G3SUJNm7K1RO1HQMzwrDcka9F6c0CgWn4r/cDYLIYEU3IM+o5Ztm
 JIjsUfY38XJNM7qrMz0T9lzno86x/Nwv2hlji1k5dc8y1qI9wieXvnqFcLxpdyS5JFrj
 BiO3T2qc/KW2vcPZBxmccE6VSqGgsIgIr/J44dy4x3PiAtPwkRO9xxQKDcz3gnJDOtMt
 dbEXyaGdogQwHu1iWPTZQY9kvQpM8Z0nCy+hQrf6a5hsd0Kc8UzTQQ04Xll7Itrmtgxf
 Uu7w4WcXCYjKptjvCLjKMMB6MwmCTsskTqY0okJkpZSjsrnhLyJhwZ+BV43KnJdZguC3 +g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2y8udks4s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 15:21:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LFKFYq163863;
        Fri, 21 Feb 2020 15:21:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2y8ud90gad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 15:21:31 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01LFLUqw024088;
        Fri, 21 Feb 2020 15:21:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 07:21:30 -0800
Date:   Fri, 21 Feb 2020 07:21:29 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 20/31] xfs: open code ATTR_ENTSIZE
Message-ID: <20200221152129.GK9506@magnolia>
References: <20200221141154.476496-1-hch@lst.de>
 <20200221141154.476496-21-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221141154.476496-21-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 06:11:43AM -0800, Christoph Hellwig wrote:
> Replace a single use macro containing open-coded variants of
> standard helpers with direct calls to the standard helpers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

Yay less macro,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_attr_list.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 0fe12474a952..c97e6806cf1f 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -545,12 +545,6 @@ xfs_attr_list_int(
>  	return error;
>  }
>  
> -#define	ATTR_ENTBASESIZE		/* minimum bytes used by an attr */ \
> -	(((struct attrlist_ent *) 0)->a_name - (char *) 0)
> -#define	ATTR_ENTSIZE(namelen)		/* actual bytes used by an attr */ \
> -	((ATTR_ENTBASESIZE + (namelen) + 1 + sizeof(uint32_t)-1) \
> -	 & ~(sizeof(uint32_t)-1))
> -
>  /*
>   * Format an attribute and copy it out to the user's buffer.
>   * Take care to check values and protect against them changing later,
> @@ -586,7 +580,10 @@ xfs_attr_put_listent(
>  
>  	arraytop = sizeof(*alist) +
>  			context->count * sizeof(alist->al_offset[0]);
> -	context->firstu -= ATTR_ENTSIZE(namelen);
> +
> +	/* decrement by the actual bytes used by the attr */
> +	context->firstu -= round_up(offsetof(struct attrlist_ent, a_name) +
> +			namelen + 1, sizeof(uint32_t));
>  	if (context->firstu < arraytop) {
>  		trace_xfs_attr_list_full(context);
>  		alist->al_more = 1;
> -- 
> 2.24.1
> 
