Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BD6C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 17:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A17B64F87
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 17:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhBCRe0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 12:34:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44949 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhBCReY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 12:34:24 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1l7M28-0006Nk-5C; Wed, 03 Feb 2021 17:33:40 +0000
Date:   Wed, 3 Feb 2021 18:33:38 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH -next] xfs: Fix unused variable 'mp' warning
Message-ID: <20210203173338.lphfvqdrucj32ncg@wittgenstein>
References: <1612341558-22171-1-git-send-email-zhangshaokun@hisilicon.com>
 <20210203093037.v2bhmjqrq7n5mlxx@wittgenstein>
 <20210203124117.GA16923@lst.de>
 <20210203134734.4oameuq262qdejwl@wittgenstein>
 <20210203143017.GA28844@lst.de>
 <20210203144125.pofpp5xmrumztt35@wittgenstein>
 <20210203171633.GX7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210203171633.GX7193@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 09:16:33AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 03, 2021 at 03:41:25PM +0100, Christian Brauner wrote:
> > On Wed, Feb 03, 2021 at 03:30:17PM +0100, Christoph Hellwig wrote:
> > > On Wed, Feb 03, 2021 at 02:47:34PM +0100, Christian Brauner wrote:
> > > > In the final version of you conversion (after the file_user_ns()
> > > > introduction) we simply pass down the fp so the patch needs to be?
> > > > 
> > > > If you're happy with it I can apply it on top. I don't want to rebase
> > > > this late. I can also send it separate as a reply in case this too much
> > > > in the body of this mail.
> > > > 
> > > > Patch passes cross-compilation for arm64 and native x864-64 and xfstests
> > > > pass too:
> > > 
> > > Let's wait for an ACK from Darrick, but I'd be fine with this.
> > 
> > Sounds good!
> > Christian
> 
> Seems fine to me, but can one of you please send this as a proper patch?
> :)

Yeah, for sure!

> 
> FWIW I really would prefer we make the tooling smart enough to shut up
> about "unused" variables and "dead" code simply because we #define'd
> their usage out of existence.  But since refactoring gcc/clang is
> probably even more of an ocean-boiling approach I'll just invite you all
> to join the XFS quota refactoring party. :P

In 2021 that might indeed qualify as a party... :)

Christian
