Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE509C47404
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 07:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7562720862
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 07:00:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="vuzEgKX5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="vEOyI+E5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387509AbfJDHAG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 03:00:06 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39323 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387454AbfJDHAF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Oct 2019 03:00:05 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 9621721F18;
        Fri,  4 Oct 2019 03:00:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 04 Oct 2019 03:00:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        W98WzD6/LWbjfLxra7kYFE7V/XLHn/WldB+Kth9YouQ=; b=vuzEgKX5qbtdLH2N
        2xTtGntheFxw0m20F7OYITR+3A0DaRy3tf/IBMnWpxQsfNYI/xJqYLoq09tRjNZw
        pyfeH7NtHtLuYd04gv6rOsptak0j/bdTYOdjNTsndTQB8tP8fDYD2QIj6wfxZNtz
        wiUzi/HMJZFappgpRu/a1kMrQ3qC8nDy1Qnht6TuktIi619gYLXUnZcpyioVvIB1
        vp6/9nY5FcztBTEqekZPKzfXGY7dRHEDrBs60yONMdjT4DyScdh8+d2yv5/Ncxdv
        tX+QW+JVKtVC+nysub4cgx43RhNFbPOzjou6RAus9yrS2P9fVbgQnx7zakEFrfcw
        WjOD3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=W98WzD6/LWbjfLxra7kYFE7V/XLHn/WldB+Kth9Yo
        uQ=; b=vEOyI+E55ft5Lnmc/AMWEEQK34BDQFcAZHGPssFSuln3NXJgvIej/fX3R
        lapsLdwMzgx1+st9arzlGKbqxACwYhPFIEygvxmono8G46gISPVBtvqb2DUNLXvL
        Av79QoecT5ueWrYzNGRKrXKATk0KGgV/Q4+Un1cqWKtUQM+q6ByXJtdd7Bq7MLpp
        M3ibHZwcX8m6HjkH9jhNiEGO7ulAUI5aWR0s4zl5KDa+VnwIDtXWOv8gpQ9BJT2E
        Hn3UvyQxrOphPojb11J7bwJonI7IOyg/x4LEOjgm8Q3TFlkp629dsEipRHbW7Ije
        WHi8QuQYM6OQ8G8IWBwkI/05vt8aA==
X-ME-Sender: <xms:8-2WXYy3Kny_7OwzJxwVpPvcqRLJ7e-gKuXRjJ3Un_9cMxwKy1kMuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrhedtgdeglecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    dukeejrddukeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:9O2WXWpzntCMRk2LJBOqCnIE1-vosm2liOhyYgjFgY7nGakiZw6zuA>
    <xmx:9O2WXbGbYcawoxm5XlQA5RlUF_IXJQVbHgiQW3Ya11-3wneqEwX3xA>
    <xmx:9O2WXUBjNhnWf4mQeg0mKbSeMtpstk_JIq91BdGnxEFz-zyoILaqaQ>
    <xmx:9O2WXcoe20DySiVV1o5f198NOrIB6suWNoX088fNGiIclEnoe_vX_Q>
Received: from mickey.themaw.net (unknown [118.208.187.186])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89A6580062;
        Fri,  4 Oct 2019 03:00:00 -0400 (EDT)
Message-ID: <56611110f8ffd80c6a706504d389d5d59b88c2fe.camel@themaw.net>
Subject: Re: [PATCH v4 02/17] vfs: add missing blkdev_put() in
 get_tree_bdev()
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri, 04 Oct 2019 14:59:57 +0800
In-Reply-To: <19b70f919a15598c0a4f1a61a3845aaeeb445217.camel@themaw.net>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
         <157009832879.13858.5261547183927327078.stgit@fedora-28>
         <20191003145635.GJ13108@magnolia>
         <19b70f919a15598c0a4f1a61a3845aaeeb445217.camel@themaw.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2019-10-04 at 14:49 +0800, Ian Kent wrote:
> On Thu, 2019-10-03 at 07:56 -0700, Darrick J. Wong wrote:
> > On Thu, Oct 03, 2019 at 06:25:28PM +0800, Ian Kent wrote:
> > > There appear to be a couple of missing blkdev_put() in
> > > get_tree_bdev().
> > 
> > No SOB, not reviewable......
> 
> It's not expected to be but is needed if anyone wants to test
> the series.
> 
> I sent this to Al asking if these are in fact missing.
> If they are I expect he will push an update to Linus pretty
> quickly.

But he hasn't responded so perhaps I should have annotated
it, just in case ...

> 
> > --D
> > 
> > > ---
> > >  fs/super.c |    5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/super.c b/fs/super.c
> > > index a7f62c964e58..fd816014bd7d 100644
> > > --- a/fs/super.c
> > > +++ b/fs/super.c
> > > @@ -1268,6 +1268,7 @@ int get_tree_bdev(struct fs_context *fc,
> > >  	mutex_lock(&bdev->bd_fsfreeze_mutex);
> > >  	if (bdev->bd_fsfreeze_count > 0) {
> > >  		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> > > +		blkdev_put(bdev, mode);
> > >  		warnf(fc, "%pg: Can't mount, blockdev is frozen",
> > > bdev);
> > >  		return -EBUSY;
> > >  	}
> > > @@ -1276,8 +1277,10 @@ int get_tree_bdev(struct fs_context *fc,
> > >  	fc->sget_key = bdev;
> > >  	s = sget_fc(fc, test_bdev_super_fc, set_bdev_super_fc);
> > >  	mutex_unlock(&bdev->bd_fsfreeze_mutex);
> > > -	if (IS_ERR(s))
> > > +	if (IS_ERR(s)) {
> > > +		blkdev_put(bdev, mode);
> > >  		return PTR_ERR(s);
> > > +	}
> > >  
> > >  	if (s->s_root) {
> > >  		/* Don't summarily change the RO/RW state. */
> > > 

