Return-Path: <SRS0=6LQP=Z3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A17ABC43603
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 07:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D9422464D
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 07:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfLEHoh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 02:44:37 -0500
Received: from verein.lst.de ([213.95.11.211]:53845 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbfLEHoh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Dec 2019 02:44:37 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 470D268BFE; Thu,  5 Dec 2019 08:44:35 +0100 (CET)
Date:   Thu, 5 Dec 2019 08:44:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        jstancek@redhat.com
Subject: Re: [PATCH] xfs: fix sub-page uptodate handling
Message-ID: <20191205074435.GA19505@lst.de>
References: <20191204172804.6589-1-hch@lst.de> <20191204215706.GT7335@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204215706.GT7335@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Btw, the subject should say iomap instead of xfs, sorry.
