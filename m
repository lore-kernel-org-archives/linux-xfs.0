Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFAE4C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 14:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB53A60FF3
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 14:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhDNOic (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 10:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231938AbhDNOic (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Apr 2021 10:38:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 585B461164;
        Wed, 14 Apr 2021 14:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618411090;
        bh=uZvrx1oh4w3LMjYMt7kypC1d3HN1r4vqYZk30Fhmb+k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cC3w8bEvrKTaMZrZNjuYTx96QCy8l56aGcRl8L0A7tyym+L0ByoP2WCpqTX3451ig
         7tCvb923uj4vughZu5bgG7dgCrW3O0XM3ihCs6iIyR+p/ONNUcggiAZaEfBXnSZ7b/
         4xO6yeQinf0vt3Be7ndIc71U2QtCdqDJNKbfHLDnji6VSWqykUDqkQa87Q1PPFqR5C
         4sVzFl4yPeX0k8bp4Gu0k0wRcquRNpDehhh/E7JEJ7kOVFN8RdZm3vENhFyoREQ2Of
         Mv3wICaNnFos7msgObGAxx7dE/8866Q/KDeA7NLsOgxie66GotGkcVc8grfO9ZjOZD
         hQ927yxTwzMBg==
Date:   Wed, 14 Apr 2021 07:38:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 9/9] xfs/305: make sure that fsstress is still running
 when we quotaoff
Message-ID: <20210414143809.GY3957620@magnolia>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
 <161836232608.2754991.16417283237743979525.stgit@magnolia>
 <20210414062135.GK1602505@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414062135.GK1602505@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 14, 2021 at 07:21:35AM +0100, Christoph Hellwig wrote:
> On Tue, Apr 13, 2021 at 06:05:26PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Greatly increase the number of fs ops that fsstress is supposed to run
> > in in this test so that we can ensure that it's still running when the
> > quotaoff gets run.  1000 might have been sufficient in 2013, but it
> > isn't now.
> 
> How long does this now run?

The same amount of time (~15s per _exercise) as before -- we start
fsstress in the background, wait 10 seconds, run quotaoff, wait 5 more
seconds, and then kill the fsstress process.  Bumping nrops to 1 million
gives fsstress enough work to do that it probably won't exit on its own
before the quotaoff completes.

FWIW the fastest storage I have can run about ~100000 fsstress ops per
minute, so I figured that 1 million ought to do for now.

--D
