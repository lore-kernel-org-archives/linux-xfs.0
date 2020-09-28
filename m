Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F70C2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 06:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39E4C20BED
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 06:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgI1GUh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 02:20:37 -0400
Received: from verein.lst.de ([213.95.11.211]:34344 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgI1GUh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Sep 2020 02:20:37 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2503F67373; Mon, 28 Sep 2020 08:20:35 +0200 (CEST)
Date:   Mon, 28 Sep 2020 08:20:34 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        bfoster@redhat.com
Subject: Re: [PATCH 1/4] xfs: remove xfs_defer_reset
Message-ID: <20200928062034.GA15425@lst.de>
References: <160125006793.174438.10683462598722457550.stgit@magnolia> <160125007449.174438.15988765709988942671.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160125007449.174438.15988765709988942671.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 27, 2020 at 04:41:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove this one-line helper.

Maybe expand the rationale here a little more?

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
