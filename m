Return-Path: <SRS0=NxuP=ZL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B5CC432C0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 17:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E132222AB
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 17:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKSRPN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 12:15:13 -0500
Received: from verein.lst.de ([213.95.11.211]:35499 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728541AbfKSRPN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Nov 2019 12:15:13 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 64FC768BFE; Tue, 19 Nov 2019 18:15:11 +0100 (CET)
Date:   Tue, 19 Nov 2019 18:15:11 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 2/9] xfs: improve the xfs_dabuf_map calling conventions
Message-ID: <20191119171511.GA19833@lst.de>
References: <20191116182214.23711-1-hch@lst.de> <20191116182214.23711-3-hch@lst.de> <20191117183521.GT6219@magnolia> <20191118062505.GB4335@lst.de> <20191119171205.GG6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119171205.GG6219@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 19, 2019 at 09:12:05AM -0800, Darrick J. Wong wrote:
> Also, I forgot to mention that some of the comments (particularly
> xfs_dabuf_map) need to be updated to reflect the new "no mapping" return
> style since there's no more @mappedbno, etc.

That is the one comment on xfs_dabuf_map, which in fact is already
wrong in the current tree.  When applying your changes I just removed
the comment entirely as it is a static function with just two callers
right below it.
