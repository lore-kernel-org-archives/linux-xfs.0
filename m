Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF28C433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 14:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5F8664F72
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 14:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhBCObF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 09:31:05 -0500
Received: from verein.lst.de ([213.95.11.211]:51543 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232184AbhBCObE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 09:31:04 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9CAEB68C4E; Wed,  3 Feb 2021 15:30:18 +0100 (CET)
Date:   Wed, 3 Feb 2021 15:30:17 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH -next] xfs: Fix unused variable 'mp' warning
Message-ID: <20210203143017.GA28844@lst.de>
References: <1612341558-22171-1-git-send-email-zhangshaokun@hisilicon.com> <20210203093037.v2bhmjqrq7n5mlxx@wittgenstein> <20210203124117.GA16923@lst.de> <20210203134734.4oameuq262qdejwl@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203134734.4oameuq262qdejwl@wittgenstein>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 02:47:34PM +0100, Christian Brauner wrote:
> In the final version of you conversion (after the file_user_ns()
> introduction) we simply pass down the fp so the patch needs to be?
> 
> If you're happy with it I can apply it on top. I don't want to rebase
> this late. I can also send it separate as a reply in case this too much
> in the body of this mail.
> 
> Patch passes cross-compilation for arm64 and native x864-64 and xfstests
> pass too:

Let's wait for an ACK from Darrick, but I'd be fine with this.
