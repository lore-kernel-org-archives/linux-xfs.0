Return-Path: <SRS0=4kkz=AY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6FAC433E3
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 16:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A2D820791
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 16:17:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VlL6EK2c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbgGMQR0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 12:17:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58146 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbgGMQR0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 12:17:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DG21N9124921;
        Mon, 13 Jul 2020 16:17:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=TlDCoReV9rMEoB2HMYQU5BwIjms9dZi4+RwYhYC0Cjs=;
 b=VlL6EK2cIEZkOzrOcZOid7kRnUBL4X3YJ0PGtwPgtyaXCeNcKOVhTNm1huHGhO0QH2Is
 8YUYmGgUVjJ8rpFMqpHvr93Sm51G5vp754spHg3xBo8HHaqm/kdC6sb6GEGsCeovL6Q0
 WZD4DvFj5j+cVj4lEiAB6MDYq+XO9CjqCwigVpG07K1t2NYltGkBE4+FAqmWU/0M7RzA
 CUAWLXBlCM8iuwKDagQPu73UCPlHfBLMA0YFLwaUvwXAk0rpPuWYv5btKdTPBXcBecu1
 neYe0EAB57+walMW2nsZQ7PHlg4h4l+l4Z8y+AMg6r0iWrzopUSsmc9yXPi7Al7xH0f9 lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3274ur02jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 16:17:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DG3XfB062639;
        Mon, 13 Jul 2020 16:17:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 327q6qhahg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 16:17:20 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06DGHKEB015922;
        Mon, 13 Jul 2020 16:17:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 09:17:19 -0700
Date:   Mon, 13 Jul 2020 09:17:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 1/5] xfs: Remove kmem_zone_alloc() usage
Message-ID: <20200713161718.GW7606@magnolia>
References: <20200710091536.95828-1-cmaiolino@redhat.com>
 <20200710091536.95828-2-cmaiolino@redhat.com>
 <20200710160804.GA10364@infradead.org>
 <20200710222132.GC2005@dread.disaster.area>
 <20200713091610.kooniclgd3curv73@eorzea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713091610.kooniclgd3curv73@eorzea>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130119
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 11:16:10AM +0200, Carlos Maiolino wrote:
> Hi Dave, Christoph.
> 
> > > > -	ip = kmem_zone_alloc(xfs_inode_zone, 0);
> > > > +
> > > > +	if (current->flags & PF_MEMALLOC_NOFS)
> > > > +		gfp_mask |= __GFP_NOFAIL;
> > > 
> > > I'm a little worried about this change in beavior here.  Can we
> > > just keep the unconditional __GFP_NOFAIL and if we really care do the
> > > change separately after the series?  At that point it should probably
> > > use the re-added PF_FSTRANS flag as well.
> 
> > Checking PF_FSTRANS was what I suggested should be done here, not
> > PF_MEMALLOC_NOFS...
> 
> 
> No problem in splitting this change into 2 patches, 1 by unconditionally use
> __GFP_NOFAIL, and another changing the behavior to use NOFAIL only inside a
> transaction.
> 
> Regarding the PF_FSTRANS flag, I opted by PF_MEMALLOC_NOFS after reading the
> commit which removed PF_FSTRANS initially (didn't mean to ignore your suggestion
> Dave, my apologies if I sounded like that), but I actually didn't find any commit
> re-adding PF_FSTRANS back. I searched most trees but couldn't find any commit
> re-adding it back, could you guys please point me out where is the commit adding
> it back?

I suspect Dave is referring to:

"xfs: reintroduce PF_FSTRANS for transaction reservation recursion
protection" by Yang Shao.

AFAICT it hasn't cleared akpm yet, so it's not in his quiltpile, and as
he doesn't use git there won't be a commit until it ends up in
mainline...

--D

> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
> -- 
> Carlos
> 
