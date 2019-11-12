Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 446CCC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 14:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F4C521E6F
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 14:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfKLORA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 09:17:00 -0500
Received: from verein.lst.de ([213.95.11.211]:56050 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbfKLORA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Nov 2019 09:17:00 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1F9FA68BE1; Tue, 12 Nov 2019 15:16:58 +0100 (CET)
Date:   Tue, 12 Nov 2019 15:16:57 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, y2038@lists.linaro.org,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC 4/5] xfs: extend inode format for 40-bit timestamps
Message-ID: <20191112141657.GC10922@lst.de>
References: <20191112120910.1977003-1-arnd@arndb.de> <20191112120910.1977003-5-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112120910.1977003-5-arnd@arndb.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Amir just send another patch dealing with the time stamps.  I'd suggest
you chime into the discussion in that thread.
