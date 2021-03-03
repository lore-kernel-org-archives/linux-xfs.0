Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7AAC4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D51764F5C
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbhCDARE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:04 -0500
Received: from verein.lst.de ([213.95.11.211]:35362 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346687AbhCCGo1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 01:44:27 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0C85468B02; Wed,  3 Mar 2021 07:43:35 +0100 (CET)
Date:   Wed, 3 Mar 2021 07:43:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH 1/3] xfs: fix quota accounting when a mount is idmapped
Message-ID: <20210303064335.GB7499@lst.de>
References: <161472409643.3421449.2100229515469727212.stgit@magnolia> <161472410230.3421449.11155796770029064636.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161472410230.3421449.11155796770029064636.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 02:28:22PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Nowadays, we indirectly use the idmap-aware helper functions in the VFS
> to set the initial uid and gid of a file being created.  Unfortunately,
> we didn't convert the quota code, which means we attach the wrong dquots
> to files created on an idmapped mount.
> 
> Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
