Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE525C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 02:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0F6C20735
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 02:26:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eneyrjTI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388250AbgEXC0N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 22:26:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50968 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388225AbgEXC0M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 22:26:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04O2MsW5145734;
        Sun, 24 May 2020 02:25:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=1VCjabZiJDRmnuwnThnxvEhCU557oZhFMDQQiAW2whU=;
 b=eneyrjTIPHW3wpZ9Q+z6SsW/wgCamIZkvxV/I0377xwGzp5PPLpO8+vsD1ebU5I2kYfP
 UMtowTxDuqzCkE+kCsAEM/q/vfTp32lYCurhc/VMvLtM7NgGq9dhHT7/SuKOc9rdIQTK
 b1J2DTH2U4fSZ1uTpzKoi7UGQseDIeYUL33LnHi1Uc+oZvBfSLDG7758xo7zP9IPOM2a
 EcrNvvt3QFjyb3xva8Jw1Vo6X2ZZfvYY6tkK/d+4zRHVBA2TDAJ26rWlbLogsZ+mcMB3
 /mC2i8/b/Ah/+C6J1nHPrDKRxsDmGfuF3Svd+ipbEDGKwnOAGWLeZycgwq7GFPnA1Gfl 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 316uskhtug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 24 May 2020 02:25:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04O2NKRR138143;
        Sun, 24 May 2020 02:25:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 317dqvatrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 24 May 2020 02:25:59 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04O2PvNa001887;
        Sun, 24 May 2020 02:25:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 23 May 2020 19:25:56 -0700
Date:   Sat, 23 May 2020 19:25:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: Replace one-element arrays with flexible-array
 members
Message-ID: <20200524022555.GA252930@magnolia>
References: <20200522215542.GA18898@embeddedor>
 <202005221606.A1647A0@keescook>
 <20200523202149.GI29907@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523202149.GI29907@embeddedor>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9630 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005240018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9630 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 cotscore=-2147483648 adultscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005240018
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Please always cc linux-xfs when you're changing fs/xfs code.

*Especially* when it involves changes to ondisk structures.

On Sat, May 23, 2020 at 03:21:50PM -0500, Gustavo A. R. Silva wrote:
> On Fri, May 22, 2020 at 04:06:38PM -0700, Kees Cook wrote:
> > On Fri, May 22, 2020 at 04:55:42PM -0500, Gustavo A. R. Silva wrote:
> > > The current codebase makes use of one-element arrays in the following
> > > form:
> > > 
> > > struct something {
> > >     int length;
> > >     u8 data[1];
> > > };
> > > 
> > > struct something *instance;
> > > 
> > > instance = kmalloc(sizeof(*instance) + size, GFP_KERNEL);
> > > instance->length = size;
> > > memcpy(instance->data, source, size);
> > > 
> > > but the preferred mechanism to declare variable-length types such as
> > > these ones is a flexible array member[1][2], introduced in C99:
> > > 
> > > struct foo {
> > >         int stuff;
> > >         struct boo array[];
> > > };
> > > 
> > > By making use of the mechanism above, we will get a compiler warning
> > > in case the flexible array does not occur last in the structure, which
> > > will help us prevent some kind of undefined behavior bugs from being
> > > inadvertently introduced[3] to the codebase from now on. So, replace
> > > the one-element array with a flexible-array member.
> > > 
> > > This issue was found with the help of Coccinelle and audited
> > > _manually_.
> > > 
> > > [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> > > [2] https://github.com/KSPP/linux/issues/21
> > > [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> > > 
> > > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > > ---
> > >  fs/xfs/libxfs/xfs_log_format.h | 12 ++++++------
> > >  fs/xfs/xfs_extfree_item.c      | 18 +++++++++---------
> > >  fs/xfs/xfs_ondisk.h            |  8 ++++----
> > >  3 files changed, 19 insertions(+), 19 deletions(-)
> > > 

<snip>

> > > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > > index 5f04d8a5ab2a9..ceba638fd99ce 100644
> > > --- a/fs/xfs/xfs_ondisk.h
> > > +++ b/fs/xfs/xfs_ondisk.h
> > > @@ -113,10 +113,10 @@ xfs_check_ondisk_structs(void)
> > >  	/* log structures */
> > >  	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
> > >  	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
> > > -	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	28);
> > > -	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	32);
> > > -	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	28);
> > > -	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	32);
> > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	16);
> > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	16);
> > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	16);
> > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	16);

Seeing as you're changing ondisk structure size checks, I gotta ask:
You /did/ run fstests before and after to make sure that the log
recovery tests still work, right?

--D

> > >  	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
> > >  	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
> > >  	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
> > > -- 
> > > 2.26.2
> > > 
> > 
> > -- 
> > Kees Cook
