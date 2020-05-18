Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D6BC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 06:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8320B20671
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 06:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgERGtB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 02:49:01 -0400
Received: from verein.lst.de ([213.95.11.211]:37065 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgERGtB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 May 2020 02:49:01 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5281768AFE; Mon, 18 May 2020 08:48:59 +0200 (CEST)
Date:   Mon, 18 May 2020 08:48:59 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: dinode reading cleanups v2
Message-ID: <20200518064859.GA19510@lst.de>
References: <20200508063423.482370-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As there were some conflicts due to the code moves for the log
refactoring I've pushed out a new v3 branch here:

    git://git.infradead.org/users/hch/xfs.git xfs-inode-read-cleanup.3

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-inode-read-cleanup.3

The only other change is extra indentation for the local fork verifiers.
I don't think it is worth reposting for that, unless you want me to.
