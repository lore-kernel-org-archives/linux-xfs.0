Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28536C47253
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 17:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FBDF20857
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 17:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgEARIq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 13:08:46 -0400
Received: from verein.lst.de ([213.95.11.211]:47863 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbgEARIq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 May 2020 13:08:46 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 799F268C65; Fri,  1 May 2020 19:08:44 +0200 (CEST)
Date:   Fri, 1 May 2020 19:08:44 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: refactor xfs_inode_verify_forks
Message-ID: <20200501170843.GA21405@lst.de>
References: <20200501081424.2598914-1-hch@lst.de> <20200501081424.2598914-10-hch@lst.de> <20200501155724.GP40250@bfoster> <20200501164009.GB18426@lst.de> <20200501170227.GS40250@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501170227.GS40250@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 01:02:27PM -0400, Brian Foster wrote:
> The associated code replaced in this patch checks the attr fork pointer:
> 
> -               ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
> -               xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
> -                               ifp ? ifp->if_u1.if_data : NULL,
> -                               ifp ? ifp->if_bytes : 0, fa);

Oh, true.  I'll fix this up to keep bisectability.
