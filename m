Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43EDDC43460
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 05:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A2AF610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 05:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347993AbhDNF7q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 01:59:46 -0400
Received: from verein.lst.de ([213.95.11.211]:57387 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348396AbhDNF7q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Apr 2021 01:59:46 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A6FD168AFE; Wed, 14 Apr 2021 07:59:23 +0200 (CEST)
Date:   Wed, 14 Apr 2021 07:59:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove XFS_IFEXTENTS
Message-ID: <20210414055923.GA24575@lst.de>
References: <20210412133819.2618857-1-hch@lst.de> <20210412133819.2618857-8-hch@lst.de> <20210414003744.GU3957620@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414003744.GU3957620@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 13, 2021 at 05:37:44PM -0700, Darrick J. Wong wrote:
> <shrug> Seeing how we already had a go-round where Dave and stumbled
> over each other about the somewhat duplicative flags and format fields
> I'm inclined to take this sooner or later just to eliminate the
> ambiguity...

Do you want me to resend for the comment that Brian wants to see, or
do you want to just fold that in?
