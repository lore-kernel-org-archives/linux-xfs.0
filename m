Return-Path: <SRS0=DNa4=W5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99DE5C3A59B
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Sep 2019 07:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 796BE2339D
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Sep 2019 07:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbfIBH7t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Sep 2019 03:59:49 -0400
Received: from verein.lst.de ([213.95.11.211]:47909 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729910AbfIBH7t (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Sep 2019 03:59:49 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7CE79227A8A; Mon,  2 Sep 2019 09:59:46 +0200 (CEST)
Date:   Mon, 2 Sep 2019 09:59:46 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add a xfs_valid_startblock helper
Message-ID: <20190902075946.GB29137@lst.de>
References: <20190830102411.519-1-hch@lst.de> <20190830102411.519-2-hch@lst.de> <20190830150650.GA5354@magnolia> <20190830153253.GA20550@lst.de> <20190901073634.GA11777@lst.de> <20190901203140.GP5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190901203140.GP5354@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 01, 2019 at 01:31:40PM -0700, Darrick J. Wong wrote:
> It's been mildly helpful for noticing when my online/offline repair
> prototype code totally screws up, but at that point so much magic smoke
> is already pouring out everywhere that it's hard not to notice. :)

That suggests to just keep the macro as I submitted it, maybe with
a big fat comment explaining the usage.
