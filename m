Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5DCC4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 16:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B0D221907
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 16:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfIRQtm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 12:49:42 -0400
Received: from verein.lst.de ([213.95.11.211]:34546 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbfIRQtl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Sep 2019 12:49:41 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E234C68B20; Wed, 18 Sep 2019 18:49:38 +0200 (CEST)
Date:   Wed, 18 Sep 2019 18:49:38 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove xfs_release
Message-ID: <20190918164938.GA19316@lst.de>
References: <20190916122041.24636-1-hch@lst.de> <20190916122041.24636-2-hch@lst.de> <20190916125311.GB41978@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916125311.GB41978@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 08:53:11AM -0400, Brian Foster wrote:
> The caller might not care if this call generates errors, but shouldn't
> we care if something fails? IOW, perhaps we should have an exit path
> with a WARN_ON_ONCE() or some such to indicate that an unhandled error
> has occurred..?

Not sure there is much of a point.  Basically all errors are either
due to a forced shutdown or cause a forced shutdown anyway, so we'll
already get warnings.
