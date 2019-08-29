Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA507C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 15:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7F1C2173E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 15:58:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A/DtKC7R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfH2P61 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 11:58:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47560 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfH2P60 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 11:58:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TFv1QD048799;
        Thu, 29 Aug 2019 15:58:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=lMW6N2bwmogq9O0bgtjDn1mqGzCNO70KGvYTDD6sG6o=;
 b=A/DtKC7RuoOUO3Y/WDVC5XPyZiAxXzWYcXBsUJ4sY9vLHthBcq0FxAYeEGVmuXz8VVXt
 ILhcl50EgveLFLSSFhGPsJ2/cpOs3a2V2a2firZi338NKvw3vTqAP+jZGz4psAhGKEx3
 0SKrnCZCViny8HTHxoiga55Npm4NW7Ql9SRGFN2tFNQJccL7+pSFqKthOb5loBDn/BDb
 iUdmW+jZU90k4lqCZJn5aF99Mx0bWvuoviB8tvxwcefh04x57AXUuQNvM0aBkXCB+gIV
 fR2pVjtlotNIbYE6obF7k4glZ0wf3+cmnB3MXufGNv6NBJNsMqHlhJyc8ZI/nSNtw5Ld sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uphcyg97y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 15:58:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TFicpw049243;
        Thu, 29 Aug 2019 15:58:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2untev8ewu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 15:58:20 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TFwJSt021258;
        Thu, 29 Aug 2019 15:58:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 15:58:19 +0000
Date:   Thu, 29 Aug 2019 08:58:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Austin Kim <austindh.kim@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Use WARN_ON rather than BUG() for bailout
 mount-operation
Message-ID: <20190829155818.GF5354@magnolia>
References: <20190828064749.GA165571@LGEARND20B15>
 <20190829075655.GD18966@infradead.org>
 <CADLLry7s=-v5cjAmu04rKad-ycOycO1UCPTpC+exL6MqbzUGtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADLLry7s=-v5cjAmu04rKad-ycOycO1UCPTpC+exL6MqbzUGtw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 09:59:17PM +0900, Austin Kim wrote:
> 2019년 8월 29일 (목) 오후 4:56, Christoph Hellwig <hch@infradead.org>님이 작성:
> >
> > On Wed, Aug 28, 2019 at 03:47:49PM +0900, Austin Kim wrote:
> > > If the CONFIG_BUG is enabled, BUG() is executed and then system is crashed.
> > > However, the bailout for mount is no longer proceeding.
> > >
> > > For this reason, using WARN_ON rather than BUG() could prevent this situation.
> > > ---
> > >  fs/xfs/xfs_mount.c | 3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > >
> > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > index 322da69..10fe000 100644
> > > --- a/fs/xfs/xfs_mount.c
> > > +++ b/fs/xfs/xfs_mount.c
> > > @@ -213,8 +213,7 @@ xfs_initialize_perag(
> > >                       goto out_hash_destroy;
> > >
> > >               spin_lock(&mp->m_perag_lock);
> > > -             if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
> > > -                     BUG();
> > > +             if (WARN_ON(radix_tree_insert(&mp->m_perag_tree, index, pag))){
> >
> > Please make this a WARN_ON_ONCE so that we don't see a flodding of
> > messages in case of this error.
> >
> Hello, Mr. Christoph
> Thanks for good feedback.
> If the kernel log is flooded with error message, as you pointed out,
> it may cause other side-effect.(e.g: system non-responsive or lockup)
> 
> To. Mr. Darrick J. Wong
> If you or other kernel developers do not disagree with the
> idea(WARN_ON_ONCE instead of WARN_ON),
> do I have to resend the patch with new revision?

Yes, and please add your Signed-off-by in the new revision.

--D

> The title, the commit message and patch might be changed as followings;
> ======
> xfs: Use WARN_ON_ONCE rather than BUG() for bailout mount-operation
> 
> If the CONFIG_BUG is enabled, BUG() is executed and then system is crashed.
> However, the bailout for mount is no longer proceeding.
> 
> For this reason, using WARN_ON_ONCE rather than BUG() could prevent
> this situation.
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 322da69..d831c13 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -213,8 +213,7 @@ xfs_initialize_perag(
>                         goto out_hash_destroy;
> 
>                 spin_lock(&mp->m_perag_lock);
> -               if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
> -                       BUG();
> +               if (WARN_ON_ONCE(radix_tree_insert(&mp->m_perag_tree,
> index, pag))) {
>                         spin_unlock(&mp->m_perag_lock);
>                         radix_tree_preload_end();
>                         error = -EEXIST;
> ======
> 
> BR,
> Guillermo Austin Kim
