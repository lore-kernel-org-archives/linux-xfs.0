Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8D7C432C0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 05:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F5322068E
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 05:44:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XOrpVf1k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfKUFoB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Nov 2019 00:44:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54578 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfKUFoB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Nov 2019 00:44:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAL5d60O103366;
        Thu, 21 Nov 2019 05:43:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=BQVafsuHxeLwKsbP1Rsx1SYn4KP4/9yWs9cKSju387k=;
 b=XOrpVf1kbC8m4KliAHVG2VFUHpMwRbedsj+aqp/7wvBwt/oxXCql0jJU17YW1kHYTqxW
 OtWSVwGnE4nVMVsY+Gfiw5tjBl5YGz2QUNCJQk9ynDBL5cjGA9uCNhpaEV02ILI4cBBe
 OCEOKxLsPeaQkKolGpvB1yHTrd76fuC5lyw1cWkr2sAy0cptaWq/1SE7nTBOCpRhA5t2
 NLgZlzJiOYX5bGCdE5n+h1LHW+XcyvBwPlQZGPgCW9O2IKhkkyIF1FRJtvv/hdZSzsaI
 toVzinrllCDt3elk2cNwxHCFKNHghaPQ/F1mAu/YHO4ZBFee9r8Yuo9y4rNoEbc1m6ip rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wa8hu1tyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 05:43:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAL5h4NQ023457;
        Thu, 21 Nov 2019 05:43:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2wda05bwyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 05:43:54 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAL5hrp8008308;
        Thu, 21 Nov 2019 05:43:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 21:43:53 -0800
Date:   Wed, 20 Nov 2019 21:43:52 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, dchinner@redhat.com
Subject: Re: [PATCH 4/4] xfs: Remove kmem_free()
Message-ID: <20191121054352.GW6219@magnolia>
References: <20191114200955.1365926-1-cmaiolino@redhat.com>
 <20191114200955.1365926-5-cmaiolino@redhat.com>
 <20191114210000.GL6219@magnolia>
 <20191115142055.asqudktld7eblfea@orion>
 <20191115172322.GO6219@magnolia>
 <20191118083008.ttbikkwmrjy4k322@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118083008.ttbikkwmrjy4k322@orion>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911210052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911210051
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 18, 2019 at 09:30:08AM +0100, Carlos Maiolino wrote:
> On Fri, Nov 15, 2019 at 09:23:22AM -0800, Darrick J. Wong wrote:
> > On Fri, Nov 15, 2019 at 03:20:55PM +0100, Carlos Maiolino wrote:
> > > On Thu, Nov 14, 2019 at 01:00:00PM -0800, Darrick J. Wong wrote:
> > > > On Thu, Nov 14, 2019 at 09:09:55PM +0100, Carlos Maiolino wrote:
> > > > > This can be replaced by direct calls to kfree() or kvfree() (whenever
> > > > > allocation is done via kmem_alloc_io() or kmem_alloc_large().
> > > > > 
> > > > > This patch has been partially scripted. I used the following sed to
> > > > > replace all kmem_free() calls by kfree()
> > > > > 
> > > > >  # find fs/xfs/ -type f -name '*.c' -o -name '*.h' | xargs sed -i \
> > > > >    's/kmem_free/kfree/g'
> > > > 
> > > > Coccinelle? ;)
> > > 
> > > /me Doesn't understand the reference but thinks Darrick is talking about
> > > Coccinelle fancy brand :P
> > > 
> > > /me is adept to conference-wear :D
> > 
> > http://coccinelle.lip6.fr/
> > 
> > The semantic patch thing, because understanding the weird spatch
> > language is slightly less infuriating than making tons of minor code
> > changes by hand. :P
> 
> Oh, I didn't know about this. Thanks. The name could be something different
> other than a fashion brand making googling for it easier :(
> 
> > > I can't really say we will have any benefits in segmenting it by using kvfree()
> > > only where kmem_alloc_{large, io} is used, so I just relied on the comments
> > > above kvfree(), and well, we have an extra function call and a few extra
> > > instructions using kvfree(). So, even though it might be 'slightly' faster, this
> > > might build up on hot paths when handling millions of kfree().
> > > 
> > > But, at the end, I'd be lying if I say I spotted any significant difference.
> > 
> > <nod> Though the way I see it, kfree vs. kvfree is another bookkeepping
> > detail that xfs developers will have to keep straight.  But maybe that's
> > fine for the dozen or so specialized users of _io and _large?  What do
> > others think?
> 
> Ok, if we decide to move everything to kvfree() I'll just send a V2 of this
> patch, which should apply cleanly on top of the other 3.
> 
> > 
> > > Btw, Dave mentioned in a not so far future, kmalloc() requests will be
> > > guaranteed to be aligned, so, I wonder if we will be able to replace both
> > > kmem_alloc_large() and kmem_alloc_io() by simple calls to kvmalloc() which does
> > > the job of falling back to vmalloc() if kmalloc() fails?!
> > 
> > Sure, but I'll believe that when I see it.  And given that Christoph
> > Lameter seems totally opposed to the idea, I think we should keep our
> > silly wrapper for a while to see if they don't accidentally revert it or
> > something.
> > 
> 
> Sure, I don't have any plans to do it now in this series or in a very near
> future, I just used the email to share the idea :P

Eh, well, FWIW I took a second look at all the kvfree/kfree and decided
that the usage was correct.  For future reference, please do the
straight change as one patch and straighten out the usages as a separate
patch.

In any case it seemed to test ok over the weekend (and still seems ok
with your series from today), so...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Thanks for the review.
> 
> -- 
> Carlos
> 
