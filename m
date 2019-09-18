Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8EC6C4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 16:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84CB0218AE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 16:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbfIRQuD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 12:50:03 -0400
Received: from verein.lst.de ([213.95.11.211]:34549 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbfIRQuD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Sep 2019 12:50:03 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8590D68B20; Wed, 18 Sep 2019 18:50:00 +0200 (CEST)
Date:   Wed, 18 Sep 2019 18:50:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: shortcut xfs_file_release for read-only file
 descriptors
Message-ID: <20190918165000.GB19316@lst.de>
References: <20190916122041.24636-1-hch@lst.de> <20190916122041.24636-3-hch@lst.de> <20190916125323.GC41978@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916125323.GC41978@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 08:53:23AM -0400, Brian Foster wrote:
> Didn't Dave have a variant of this patch for dealing with a
> fragmentation issue (IIRC)? Anyways, seems fine:

I don't really remember one.  But maybe Dave can chime in.
