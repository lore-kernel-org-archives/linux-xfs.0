Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A521BCA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 15:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 733FC205C9
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 15:26:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XqTHCFay"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503189AbfJXP05 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 11:26:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52394 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503092AbfJXP04 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 11:26:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9OFCFCp024232;
        Thu, 24 Oct 2019 15:26:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=tKOXPCOO8J/tujBXgifCM8jucA35KQUpEXZGLFmWElA=;
 b=XqTHCFayBtvhyIransDUuR/pYvqt1RtuOkWI1xylkPz3+RU/gjjzyc5zj6uDyuVtGYbm
 20xfbjFmw7WLOs29S5Ns0CiCoopsy16E+WegRRwsrkK8i3p1rY1rU3wxDpK5q3pOO3iR
 7uQsDmph1SOW/EmyiSo13PIY7pSKrNLbv+X5rNjL+UozoPQ0uJcGzPTzNq/IrWc4+vpi
 EZ17hEJ+UR0aYpMQdlb4gWi7hOCowRF3rOg2OBUOYK0zcFd05Xqav3BtE6sF1QuExJ+w
 TmENpPjWS20WlQRI5XysyQfkhv2c3DNGVMzRYFbACeuRGvvaEa25K+dE28B1iVWoTJIh hg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vqteq4d86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 15:26:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9OF3UhD014516;
        Thu, 24 Oct 2019 15:26:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vtm24r2am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 15:26:19 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9OFQCZS004864;
        Thu, 24 Oct 2019 15:26:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 08:26:11 -0700
Date:   Thu, 24 Oct 2019 08:26:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v7 06/17] xfs: use kmem functions for struct xfs_mount
Message-ID: <20191024152611.GQ913374@magnolia>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
 <157190346680.27074.12024650426066059590.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157190346680.27074.12024650426066059590.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=884
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910240139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=963 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910240139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 03:51:06PM +0800, Ian Kent wrote:
> The remount function uses the kmem functions for allocating and freeing
> struct xfs_mount, for consistency use the kmem functions everwhere for
> struct xfs_mount.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks fine (there are direct callers of kmalloc for anyone who wants to
take on a small cleanup...)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index a0805b74256c..896609827e3c 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1535,7 +1535,7 @@ xfs_mount_alloc(
>  {
>  	struct xfs_mount	*mp;
>  
> -	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
> +	mp = kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
>  	if (!mp)
>  		return NULL;
>  
> @@ -1749,7 +1749,7 @@ xfs_fs_fill_super(
>   out_free_names:
>  	sb->s_fs_info = NULL;
>  	xfs_free_names(mp);
> -	kfree(mp);
> +	kmem_free(mp);
>   out:
>  	return error;
>  
> @@ -1781,7 +1781,7 @@ xfs_fs_put_super(
>  
>  	sb->s_fs_info = NULL;
>  	xfs_free_names(mp);
> -	kfree(mp);
> +	kmem_free(mp);
>  }
>  
>  STATIC struct dentry *
> 
