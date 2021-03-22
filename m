Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD05C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 07:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD36861974
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 07:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhCVHEt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 03:04:49 -0400
Received: from verein.lst.de ([213.95.11.211]:53737 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhCVHEp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Mar 2021 03:04:45 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id F199D68C4E; Mon, 22 Mar 2021 08:04:41 +0100 (CET)
Date:   Mon, 22 Mar 2021 08:04:41 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 3/4] fs: introduce fsuidgid_has_mapping() helper
Message-ID: <20210322070441.GC3299@lst.de>
References: <20210320122623.599086-1-christian.brauner@ubuntu.com> <20210320122623.599086-4-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210320122623.599086-4-christian.brauner@ubuntu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 20, 2021 at 01:26:23PM +0100, Christian Brauner wrote:
> Don't open-code the checks and instead move them into a clean little
> helper we can call. This also reduces the risk that if we ever change
> something we forget to change all locations.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
