Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C01C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09F2B206D8
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:41:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WypQISLj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgEPRln (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 13:41:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38222 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgEPRlk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 May 2020 13:41:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHfai2146716;
        Sat, 16 May 2020 17:41:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=KyST4tpVIAh789dZJIXElSP8DHvJUZMANwav/jJN4/E=;
 b=WypQISLjxaquJ+VOikvShIr0Q32h0oAVbIeK27oAlXi0dsuu+2Rwzzp0IwslNduzkYYC
 jzb52wT6Svod7R2+Q53CC0LdHyG6IXOFjDavnypYSKfHVI6goIJdAZJgM5GQ7WbvefxQ
 Msy3hRKfKW9hdpkjNKKGxLD53zFB9pcL2by71F88Dy45wrJTMEgJzGMr/Ki7t0VaQa80
 uswmiZViK+x3LU6qOidX1A6auK5EK6Pq1T4/ZAECS0IONGUpbBM3WvO8kAh1E9zYmB1e
 qtoodI4iaS2h/NlizUCf1TPc4gUsKobp39eLJ87s9HMYAzwLCxqh+iuuw8npAbvitZLf Gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31284khdtk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 17:41:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHcttW188384;
        Sat, 16 May 2020 17:41:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3127gh3sx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 17:41:31 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04GHfUOP006035;
        Sat, 16 May 2020 17:41:31 GMT
Received: from localhost (/10.159.131.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 May 2020 10:41:30 -0700
Date:   Sat, 16 May 2020 10:41:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 06/12] xfs: don't reset i_delayed_blks in xfs_iread
Message-ID: <20200516174123.GV6714@magnolia>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-7-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=1
 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005160159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:34:17AM +0200, Christoph Hellwig wrote:
> i_delayed_blks is set to 0 in xfs_inode_alloc and can't have anything
> assigned to it until the inode is visible to the VFS.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Seems fine to me...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 3aac22e892985..329534eebbdcc 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -663,8 +663,6 @@ xfs_iread(
>  	if (error)
>  		goto out_brelse;
>  
> -	ip->i_delayed_blks = 0;
> -
>  	/*
>  	 * Mark the buffer containing the inode as something to keep
>  	 * around for a while.  This helps to keep recently accessed
> -- 
> 2.26.2
> 
