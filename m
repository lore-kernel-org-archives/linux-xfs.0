Return-Path: <SRS0=ZB14=6Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2043C54E8B
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF69A24966
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgEJHLT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 May 2020 03:11:19 -0400
Received: from verein.lst.de ([213.95.11.211]:59176 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgEJHLT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 10 May 2020 03:11:19 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 170E868C7B; Sun, 10 May 2020 09:11:17 +0200 (CEST)
Date:   Sun, 10 May 2020 09:11:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] db: add a comment to agfl_crc_flds
Message-ID: <20200510071116.GB17094@lst.de>
References: <20200509170125.952508-1-hch@lst.de> <20200509170125.952508-4-hch@lst.de> <20200509170712.GQ6714@magnolia> <20200509171011.GA31656@lst.de> <d3683956-96b8-1308-9e66-2db56432da17@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3683956-96b8-1308-9e66-2db56432da17@sandeen.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 12:32:01PM -0500, Eric Sandeen wrote:
> > Yes.  That's what I mean, but after seems to be less confusing.
> so:
> 
> /* the bno array is after the actual structure */
> 
> right?  I can just do that on merge.

Looks ok.
