Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA32C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 15:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DD6A2080F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 15:01:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jxWgRXMG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfH2PBu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 11:01:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49912 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfH2PBu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 11:01:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TEsQjD152610;
        Thu, 29 Aug 2019 15:01:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=d8wswmae7bbnm9LXPmWcm4lMM9dtzn7qkr9EcyOkzy4=;
 b=jxWgRXMGGyG6mCXTBbT1yz1FgIBc3hPHTC3WGeSHMOWEvTCYb3IxC0AHtV8kjUOrCgsK
 dm8gF3YZ/o7mRCNH2JJ3frPBQwquNf1iexCSkU2SqmOHWcdsyXgSmFF80wnFYIt49+2s
 G/XiT1kC+R84gqKPBI53fPZM6/7VQHnvSleYosvkNA1F+ipL4v9qqEPrJ4GY8C4MDfH4
 qlxWV71MAiNuvVWfgEfHJvxXuXm7YCrRn0BP9w+1gQCuFBlH1AxFrU+CC10qSgtkUFFP
 byxkQYENUPo8T3ncbEyF8gC2JDL119bJJyZUYlGb85IRhTI6/9iy3M7cvX2MC2JWkbaV 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2upgr785f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 15:01:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TEqlq4082932;
        Thu, 29 Aug 2019 15:01:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2untev5s15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 15:01:37 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TF1ZTu005411;
        Thu, 29 Aug 2019 15:01:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 08:01:35 -0700
Date:   Thu, 29 Aug 2019 08:01:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Austin Kim <austindh.kim@gmail.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Use WARN_ON rather than BUG() for bailout
 mount-operation
Message-ID: <20190829150134.GA5354@magnolia>
References: <20190828064749.GA165571@LGEARND20B15>
 <20190829075655.GD18966@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829075655.GD18966@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 12:56:55AM -0700, Christoph Hellwig wrote:
> On Wed, Aug 28, 2019 at 03:47:49PM +0900, Austin Kim wrote:
> > If the CONFIG_BUG is enabled, BUG() is executed and then system is crashed.
> > However, the bailout for mount is no longer proceeding.
> > 
> > For this reason, using WARN_ON rather than BUG() could prevent this situation.
> > ---
> >  fs/xfs/xfs_mount.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 322da69..10fe000 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -213,8 +213,7 @@ xfs_initialize_perag(
> >  			goto out_hash_destroy;
> >  
> >  		spin_lock(&mp->m_perag_lock);
> > -		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
> > -			BUG();
> > +		if (WARN_ON(radix_tree_insert(&mp->m_perag_tree, index, pag))){
> 
> Please make this a WARN_ON_ONCE so that we don't see a flodding of
> messages in case of this error.

How would it flood?  If the radix tree insertion fails we dump all the
pag structures and fail log recovery / mount / growfs.  I suppose if
one were out of memory and hammering the system hard with repeated mount
calls...

--D
