Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4745C5DF63
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 14:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBE172187F
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 14:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfKFOn5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 09:43:57 -0500
Received: from verein.lst.de ([213.95.11.211]:51685 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbfKFOn5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Nov 2019 09:43:57 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 397ED68BE1; Wed,  6 Nov 2019 15:43:54 +0100 (CET)
Date:   Wed, 6 Nov 2019 15:43:53 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/2] xfs: add missing early termination checks to
 record scrubbing functions
Message-ID: <20191106144353.GA17196@lst.de>
References: <157301537390.678524.16085197974806955970.stgit@magnolia> <157301538007.678524.17905821115324746213.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157301538007.678524.17905821115324746213.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 05, 2019 at 08:43:00PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Scrubbing directories, quotas, and fs counters all involve iterating
> some collection of metadata items.  The per-item scrub functions for
> these three are missing some of the components they need to be able to
> check for a fatal signal and terminate early.
> 
> Per-item scrub functions need to call xchk_should_terminate to look for
> fatal signals, and they need to check the scrub context's corruption
> flag because there's no point in continuing a scan once we've decided
> the data structure is bad.  Add both of these where missing.

Looks sensible, but take this with a grain of salt as I'm not very
familiar with the scrub code:

Reviewed-by: Christoph Hellwig <hch@lst.de>
