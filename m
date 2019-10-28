Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A28CA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 18:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C266B214B2
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 18:24:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PVV1WThI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404379AbfJ1SYh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 14:24:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34316 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403849AbfJ1SYh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 14:24:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SINVv1164683;
        Mon, 28 Oct 2019 18:24:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=1fyRe9+7NPiVtmGDX8qyDfcFM1pE0frZT5FK0I6Ooo4=;
 b=PVV1WThIynQ/9sDRZQtc5KiPKYwAn/xtlIiazPXhjBoZrK397Zh69pgF8JN1fibaQDA1
 sNl5O1xVtTsks1K+X6fe2vR6kocMKDcDMAej36hIuAQmJS842qKSNCr7WdLDEIUsxYR3
 HeXh9Hgw12jzwcHG1T9XshxuGXoHxl0mZguvGf0nkiSoqFIeZIk33koz26euyurvxDXB
 xaCbe4c9dUsGN2RJGle8tVpAg4wztwTkP5tkzI2mhCD2ygmSOel1SKDMoxN2o4vvM+2z
 FzO4cpIEPe5647Ii5YOo5+lgBrmi3JWzLK8P6KECFNZRuykgfhJOmTSYkFooqJRzXtEm QQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vvdju3yng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 18:24:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SIOFh9100956;
        Mon, 28 Oct 2019 18:24:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vw09g7ny6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 18:24:16 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SINHcY016234;
        Mon, 28 Oct 2019 18:23:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 11:23:17 -0700
Date:   Mon, 28 Oct 2019 11:23:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: namecheck directory entry names before listing
 them
Message-ID: <20191028182316.GX15222@magnolia>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
 <157198050564.2873445.4054092614183428143.stgit@magnolia>
 <20191028181915.GD26529@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028181915.GD26529@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910280177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 02:19:15PM -0400, Brian Foster wrote:
> On Thu, Oct 24, 2019 at 10:15:05PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Actually call namecheck on directory entry names before we hand them
> > over to userspace.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_dir2_readdir.c |   16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> > index 283df898dd9f..a8fb0a6829fd 100644
> > --- a/fs/xfs/xfs_dir2_readdir.c
> > +++ b/fs/xfs/xfs_dir2_readdir.c
> ...
> > @@ -208,6 +214,11 @@ xfs_dir2_block_getdents(
> >  		/*
> >  		 * If it didn't fit, set the final offset to here & return.
> >  		 */
> > +		if (!xfs_dir2_namecheck(dep->name, dep->namelen)) {
> > +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > +					 dp->i_mount);
> > +			return -EFSCORRUPTED;
> > +		}
> 
> xfs_trans_brelse(..., bp) (here and in _leaf_getdents())?

Will fix.

--D

> Brian
> 
> >  		if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
> >  			    be64_to_cpu(dep->inumber),
> >  			    xfs_dir3_get_dtype(dp->i_mount, filetype))) {
> > @@ -456,6 +467,11 @@ xfs_dir2_leaf_getdents(
> >  		filetype = dp->d_ops->data_get_ftype(dep);
> >  
> >  		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
> > +		if (!xfs_dir2_namecheck(dep->name, dep->namelen)) {
> > +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > +					 dp->i_mount);
> > +			return -EFSCORRUPTED;
> > +		}
> >  		if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
> >  			    be64_to_cpu(dep->inumber),
> >  			    xfs_dir3_get_dtype(dp->i_mount, filetype)))
> > 
> 
