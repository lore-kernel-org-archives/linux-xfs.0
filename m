Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E08C4360C
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 06:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20EA520862
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 06:49:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="OnjfSzDA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="fluV0xv5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbfJDGt4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 02:49:56 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40451 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728264AbfJDGt4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Oct 2019 02:49:56 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 7718B21EBC;
        Fri,  4 Oct 2019 02:49:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 04 Oct 2019 02:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        AH+mFP7U5RCsVHbdEL/HrA0fwsZdzGrS5BO/yTN6sqw=; b=OnjfSzDAkyxx7skY
        7ldmL5tff1pAkh+fVhba6wtIlIXGKLF2YAWke5zvP7RFrYE32HewLOw2c2QL46m7
        h5dyhmrd3vx507Y8pBc1Oth5Ba/k7u0oQGRkYfhiH1emYA6JNr8OkUb3Zuh3FqaG
        fehOa1Qi0JPun1N/ETsHztCnVS5kSFhwQs20y5oJGwPkYT8AcAa4vrahUaFj6FuD
        c8oN+eddSp2I/XK+5OtedVmrVQWjde68dDrFT3mDPGZ+z0VH1GiEwOjaldMfSs7I
        Kp4GUJbwVUWkH8FMNAZfmSTao7R/2AY13GnDEzPIeWKHVRF5rHnEXkT95ZiwTqIQ
        49zzlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=AH+mFP7U5RCsVHbdEL/HrA0fwsZdzGrS5BO/yTN6s
        qw=; b=fluV0xv5SGHlI1tnggnu0T1gpvy06bg/XUzpmuIAAiv+BYLXIi1GYpwiF
        kgNPFlZtrrl437hDxXZM9/p83ku/3VsegnQ+Oz5BU6u1nfHR4MHQClRSCedjkql1
        FqC43l4kKkOdpA9MfJ8zeYaTjiH+7IS0xmiOftg3schM+YS5BA3oYIH4RRnLQWli
        7QD23D+Ww7ide6ILLeZiB7XAZMfNI5uWsK4DVsZINvTJMHLj+i/neynqsE6qmE8/
        0R1bwDovevnnMBl4c5Jm3g9yTeAQw0jvY0G8v5wPXNym73GM4GtjsF3xmvNUuS52
        ufjx9zJ9P2NeSED7U38UdbAlL2ayw==
X-ME-Sender: <xms:kuuWXS7izTDoNACO_tngOC80eFAjGulgTgkVtO7tRAarWXKM6HPM3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrhedtgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    dukeejrddukeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:kuuWXUnvtZng-ttbHJ7UrOM7xj7GUhmTUo-vcU2IYQFQRKOApf2f0Q>
    <xmx:kuuWXRYNRMAOkLiTFbSBE92XaDhPzjJHUtgBHbTmlQd6MF52Q1Rccw>
    <xmx:kuuWXbpOZfJ5cIfIBR7AfeKKnC7xyQ8VEtPCywMJN_IfzHDFQP8CJw>
    <xmx:k-uWXRoYHTH-_ESSnHrQgGpPPNBn-gD3jEk44GdgNdEv5GTUkZDPSQ>
Received: from mickey.themaw.net (unknown [118.208.187.186])
        by mail.messagingengine.com (Postfix) with ESMTPA id 27BB0D6005B;
        Fri,  4 Oct 2019 02:49:51 -0400 (EDT)
Message-ID: <19b70f919a15598c0a4f1a61a3845aaeeb445217.camel@themaw.net>
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
Date:   Fri, 04 Oct 2019 14:49:45 +0800
In-Reply-To: <20191003145635.GJ13108@magnolia>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
         <157009832879.13858.5261547183927327078.stgit@fedora-28>
         <20191003145635.GJ13108@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2019-10-03 at 07:56 -0700, Darrick J. Wong wrote:
> On Thu, Oct 03, 2019 at 06:25:28PM +0800, Ian Kent wrote:
> > There appear to be a couple of missing blkdev_put() in
> > get_tree_bdev().
> 
> No SOB, not reviewable......

It's not expected to be but is needed if anyone wants to test
the series.

I sent this to Al asking if these are in fact missing.
If they are I expect he will push an update to Linus pretty
quickly.

> 
> --D
> 
> > ---
> >  fs/super.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/super.c b/fs/super.c
> > index a7f62c964e58..fd816014bd7d 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -1268,6 +1268,7 @@ int get_tree_bdev(struct fs_context *fc,
> >  	mutex_lock(&bdev->bd_fsfreeze_mutex);
> >  	if (bdev->bd_fsfreeze_count > 0) {
> >  		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> > +		blkdev_put(bdev, mode);
> >  		warnf(fc, "%pg: Can't mount, blockdev is frozen",
> > bdev);
> >  		return -EBUSY;
> >  	}
> > @@ -1276,8 +1277,10 @@ int get_tree_bdev(struct fs_context *fc,
> >  	fc->sget_key = bdev;
> >  	s = sget_fc(fc, test_bdev_super_fc, set_bdev_super_fc);
> >  	mutex_unlock(&bdev->bd_fsfreeze_mutex);
> > -	if (IS_ERR(s))
> > +	if (IS_ERR(s)) {
> > +		blkdev_put(bdev, mode);
> >  		return PTR_ERR(s);
> > +	}
> >  
> >  	if (s->s_root) {
> >  		/* Don't summarily change the RO/RW state. */
> > 

