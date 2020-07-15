Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D31BDC433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 15:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2AD720672
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 15:37:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EpTYU2an"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgGOPhb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 11:37:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46024 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgGOPhb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 11:37:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FFMBan106292;
        Wed, 15 Jul 2020 15:37:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=tg+pjwJaLKnQJGGDeBCtRXT92PamLhl1eyyAkt0G20w=;
 b=EpTYU2anLIFT5V20uaClUQ6C5oYYaH5VRV8Rao8N55fKeFrEMQtBTshtfBaA+71cU7/Z
 TFfq7ZBtKtwK4usRK3BR+LdDqPJyXMOGLRirgUyVEOoOPJJWgpJcDocLA/3KuchnGzeS
 81f/ZDZDdKy4vrRDYu+IFitiJ5T5iap43wpQnVKQ0G+VzlYV34aUyXqB2Oi10TAlg4ko
 VgQhpnV4mu7QAatiE/eT3O1tDUnlxG7K4+LiUod5MNyXNoKKZ0BOCX0PzLtr+7cRT/jg
 TCM+gOvm2wmSi6HrSCR0CYG59jnRtOnsRv6UficzROTlownwu0JHkmPUPMzb3Aew8zis 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3274urc77y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 15:37:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FFNdAx010951;
        Wed, 15 Jul 2020 15:37:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32a4cqrsb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 15:37:25 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06FFbM7i026054;
        Wed, 15 Jul 2020 15:37:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 08:37:22 -0700
Date:   Wed, 15 Jul 2020 08:37:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 1/5] xfs: Remove kmem_zone_alloc() usage
Message-ID: <20200715153721.GC3151642@magnolia>
References: <20200710091536.95828-1-cmaiolino@redhat.com>
 <20200710091536.95828-2-cmaiolino@redhat.com>
 <20200710160804.GA10364@infradead.org>
 <20200710222132.GC2005@dread.disaster.area>
 <20200713091610.kooniclgd3curv73@eorzea>
 <20200713161718.GW7606@magnolia>
 <20200715150659.crao7yuq3hkh3tmq@eorzea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715150659.crao7yuq3hkh3tmq@eorzea>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 suspectscore=1 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150125
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 05:06:59PM +0200, Carlos Maiolino wrote:
> > > No problem in splitting this change into 2 patches, 1 by unconditionally use
> > > __GFP_NOFAIL, and another changing the behavior to use NOFAIL only inside a
> > > transaction.
> > > 
> > > Regarding the PF_FSTRANS flag, I opted by PF_MEMALLOC_NOFS after reading the
> > > commit which removed PF_FSTRANS initially (didn't mean to ignore your suggestion
> > > Dave, my apologies if I sounded like that), but I actually didn't find any commit
> > > re-adding PF_FSTRANS back. I searched most trees but couldn't find any commit
> > > re-adding it back, could you guys please point me out where is the commit adding
> > > it back?
> > 
> > I suspect Dave is referring to:
> > 
> > "xfs: reintroduce PF_FSTRANS for transaction reservation recursion
> > protection" by Yang Shao.
> > 
> > AFAICT it hasn't cleared akpm yet, so it's not in his quiltpile, and as
> > he doesn't use git there won't be a commit until it ends up in
> > mainline...
> > 
> 
> Thanks, I think I'll wait until it hits the mainline before trying to push this
> series then.

FWIW I could be persuaded to take that one via one of the xfs/iomap
trees if the author puts out a revised patch.

--D

> 
> -- 
> Carlos
> 
