Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F870C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 17:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08BD7619C5
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 17:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhC3RcA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 13:32:00 -0400
Received: from verein.lst.de ([213.95.11.211]:59935 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232201AbhC3Rb4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 13:31:56 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 05F8568BEB; Tue, 30 Mar 2021 19:31:55 +0200 (CEST)
Date:   Tue, 30 Mar 2021 19:31:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/20] xfs: merge _xfs_dic2xflags into xfs_ip2xflags
Message-ID: <20210330173154.GA14827@lst.de>
References: <20210329053829.1851318-1-hch@lst.de> <20210329053829.1851318-21-hch@lst.de> <20210330152538.GP4090233@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330152538.GP4090233@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 08:25:38AM -0700, Darrick J. Wong wrote:
> On Mon, Mar 29, 2021 at 07:38:29AM +0200, Christoph Hellwig wrote:
> > Merge _xfs_dic2xflags into its only caller.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> /me wonders if/how this will clash with Miklos' fileattr series, but eh,
> whatever, I don't think it will, and if it does it's easy enough to fix.

Feel free to drop the patch for now, it is not in any way urgent.
