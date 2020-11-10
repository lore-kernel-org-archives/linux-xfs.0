Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E34CC388F7
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F03AE20809
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgKJSck (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:32:40 -0500
Received: from verein.lst.de ([213.95.11.211]:36964 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgKJSck (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Nov 2020 13:32:40 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id B57BB67373; Tue, 10 Nov 2020 19:32:37 +0100 (CET)
Date:   Tue, 10 Nov 2020 19:32:37 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        fdmanana@kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] vfs: separate __sb_start_write into blocking and
 non-blocking helpers
Message-ID: <20201110183237.GA29662@lst.de>
References: <160494580419.772573.9286165021627298770.stgit@magnolia> <160494581731.772573.9685036230289776579.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160494581731.772573.9685036230289776579.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
