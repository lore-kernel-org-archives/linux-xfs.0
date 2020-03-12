Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4459CC10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 09:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28EA720691
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 09:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgCLJBb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 05:01:31 -0400
Received: from verein.lst.de ([213.95.11.211]:35571 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbgCLJBb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Mar 2020 05:01:31 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9884F68C4E; Thu, 12 Mar 2020 10:01:28 +0100 (CET)
Date:   Thu, 12 Mar 2020 10:01:28 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Tommi Rantala <tommi.t.rantala@nokia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix regression in "cleanup
 xfs_dir2_block_getdents"
Message-ID: <20200312090128.GA11127@lst.de>
References: <20200312085728.22187-1-tommi.t.rantala@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312085728.22187-1-tommi.t.rantala@nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 10:57:28AM +0200, Tommi Rantala wrote:
> Commit 263dde869bd09 ("xfs: cleanup xfs_dir2_block_getdents") introduced
> a getdents regression, when it converted the pointer arithmetics to
> offset calculations: offset is updated in the loop already for the next
> iteration, but the updated offset value is used incorrectly in two
> places, where we should have used the not-yet-updated value.
> 
> This caused for example "git clean -ffdx" failures to cleanup certain
> directory structures when running in a container.
> 
> Fix the regression by making sure we use proper offset in the loop body.
> Thanks to Christoph Hellwig for suggestion how to best fix the code.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Fixes: 263dde869bd09 ("xfs: cleanup xfs_dir2_block_getdents")
> Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
