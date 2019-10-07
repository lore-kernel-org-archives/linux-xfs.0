Return-Path: <SRS0=GEoz=YA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D32C47404
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 05:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34C0E2067B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 05:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfJGFsn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 01:48:43 -0400
Received: from verein.lst.de ([213.95.11.211]:34712 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727225AbfJGFsn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Oct 2019 01:48:43 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5649C68AFE; Mon,  7 Oct 2019 07:48:39 +0200 (CEST)
Date:   Mon, 7 Oct 2019 07:48:38 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] iomap: add tracing for the readpage / readpages
Message-ID: <20191007054838.GA15655@lst.de>
References: <20191006154608.24738-1-hch@lst.de> <20191006154608.24738-2-hch@lst.de> <20191006224324.GR13108@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191006224324.GR13108@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 06, 2019 at 03:43:24PM -0700, Darrick J. Wong wrote:
> > +iomap-y				+= trace.o \
> 
> I think this patch is missing fs/iomap/trace.c ?

It does.  The file is in my tree, but I never did a git-add for it..
