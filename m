Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68811CA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 15:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AC8B20650
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 15:43:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oTMkBjO/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409735AbfJXPnx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 11:43:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47106 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409718AbfJXPnx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 11:43:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9OFdMpS045828;
        Thu, 24 Oct 2019 15:43:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=fR3uEVtaVjkVFxn/nm79DLt30qYuOWpnu9afwnvIwg4=;
 b=oTMkBjO/6MeBs858GQBIY4AnttMcn+2+QHmUDjqC3AwTT3mgtQIatqKBw7pKfEJnxY6c
 3cVMEtbslxCJ5Aeeem5m1pSXXt9ZnMohqgfHmGQlqZrw3VEcTJbk4qLtx9FVKXZz2NEs
 plkFa2u3nncG6Ask4R3n2ADJg+pSybzJ0ZOflnQlCNvDDrNmhfPBMEGg+UtUiHDuyUSs
 ZLpzrnpmilUN0mZucJaCXqhU7EJgHe5fY31xAv9uG1FfJTvtqqRZKM/ahxjP0x5QNi4x
 ymX4FRCUlWE0GBdE4ar/FXeENWQnRPLACaSatvaQqDish3PJ52C3MyksMggZbGR/Khd7 mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vqu4r4bfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 15:43:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9OFegeS025169;
        Thu, 24 Oct 2019 15:41:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vtsk53mkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 15:41:25 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9OFeDPf019961;
        Thu, 24 Oct 2019 15:40:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 08:40:13 -0700
Date:   Thu, 24 Oct 2019 08:40:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v7 12/17] xfs: avoid redundant checks when options is
 empty
Message-ID: <20191024154011.GV913374@magnolia>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
 <157190349799.27074.795104447849311945.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157190349799.27074.795104447849311945.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=931
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910240140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910240141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 03:51:38PM +0800, Ian Kent wrote:
> When options passed to xfs_parseargs() is NULL the checks performed
> after taking the branch are made with the initial values of dsunit,
> dswidth and iosizelog. But all the checks do nothing in this case
> so return immediately instead.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 003ec725d4b6..92a37ac0b907 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -211,7 +211,7 @@ xfs_parseargs(
>  	mp->m_logbsize = -1;
>  
>  	if (!options)
> -		goto done;
> +		return 0;
>  
>  	while ((p = strsep(&options, ",")) != NULL) {
>  		int		token;
> @@ -390,7 +390,6 @@ xfs_parseargs(
>  		return -EINVAL;
>  	}
>  
> -done:
>  	if (dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
>  		/*
>  		 * At this point the superblock has not been read
> 
