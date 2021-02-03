Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 456F8C433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 17:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE3A664DD4
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 17:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbhBCRRV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 12:17:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231402AbhBCRRN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 12:17:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C2B964DD4;
        Wed,  3 Feb 2021 17:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612372593;
        bh=GIELvPkEGLUKOVvuTg9XybH4Ug2UeirXkqrQPAXeiTY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MMpgvSWr2fCeZHUjyH0a+RyYWzo4ofLkFFSaX4arEdjXokiTHMt0tW5NLabIupH+u
         sMFUt04TGyLIEVtGtvT25pn1EcpV0xsvZiaLvgzB5nGS3IEMgndRXIL3RMrfgQiTcb
         8bYy6nZcpHf8aq4/eahEC/8/AlBVeVlRMQfAejQWlzzpmz4hIMjVTDbORi/Ll5SN0G
         xwuI7k4ZbTPhnhkh+WsEFCDCnx+5PP1lgG7OdEl3FdNm+9KbElQPr1i1X5OvuJr869
         ZQf9yPM+doTdw4c0PXMbgNCarGi/A+vnjPrIAb+hYEyUvPUmhnzvRiMeBR0mbvMQrP
         7jGYrKxCwJZqg==
Date:   Wed, 3 Feb 2021 09:16:33 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH -next] xfs: Fix unused variable 'mp' warning
Message-ID: <20210203171633.GX7193@magnolia>
References: <1612341558-22171-1-git-send-email-zhangshaokun@hisilicon.com>
 <20210203093037.v2bhmjqrq7n5mlxx@wittgenstein>
 <20210203124117.GA16923@lst.de>
 <20210203134734.4oameuq262qdejwl@wittgenstein>
 <20210203143017.GA28844@lst.de>
 <20210203144125.pofpp5xmrumztt35@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203144125.pofpp5xmrumztt35@wittgenstein>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 03:41:25PM +0100, Christian Brauner wrote:
> On Wed, Feb 03, 2021 at 03:30:17PM +0100, Christoph Hellwig wrote:
> > On Wed, Feb 03, 2021 at 02:47:34PM +0100, Christian Brauner wrote:
> > > In the final version of you conversion (after the file_user_ns()
> > > introduction) we simply pass down the fp so the patch needs to be?
> > > 
> > > If you're happy with it I can apply it on top. I don't want to rebase
> > > this late. I can also send it separate as a reply in case this too much
> > > in the body of this mail.
> > > 
> > > Patch passes cross-compilation for arm64 and native x864-64 and xfstests
> > > pass too:
> > 
> > Let's wait for an ACK from Darrick, but I'd be fine with this.
> 
> Sounds good!
> Christian

Seems fine to me, but can one of you please send this as a proper patch?
:)

FWIW I really would prefer we make the tooling smart enough to shut up
about "unused" variables and "dead" code simply because we #define'd
their usage out of existence.  But since refactoring gcc/clang is
probably even more of an ocean-boiling approach I'll just invite you all
to join the XFS quota refactoring party. :P

--D
