Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BB5C38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 16:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1619C2083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 16:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgEGQLY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 12:11:24 -0400
Received: from verein.lst.de ([213.95.11.211]:47601 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgEGQLV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 May 2020 12:11:21 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0A25968B05; Thu,  7 May 2020 18:11:18 +0200 (CEST)
Date:   Thu, 7 May 2020 18:11:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: libxfs 5.7 resync
Message-ID: <20200507161117.GA718@lst.de>
References: <20200507121851.304002-1-hch@lst.de> <20200507154809.GH6714@magnolia> <20200507155454.GB32006@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507155454.GB32006@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

And FYI, the xfs_check failures also appear with your branch.
