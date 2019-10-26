Return-Path: <SRS0=KB2e=YT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C61CA9EBD
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Oct 2019 05:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA231222CB
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Oct 2019 05:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfJZFrZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Oct 2019 01:47:25 -0400
Received: from verein.lst.de ([213.95.11.211]:54267 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbfJZFrZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 26 Oct 2019 01:47:25 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CEFAB68B05; Sat, 26 Oct 2019 07:47:22 +0200 (CEST)
Date:   Sat, 26 Oct 2019 07:47:22 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 3/7] xfs: remove the m_readio_log field from struct
 xfs_mount
Message-ID: <20191026054722.GA14648@lst.de>
References: <20191025174026.31878-1-hch@lst.de> <20191025174026.31878-4-hch@lst.de> <851dcbf3-afbf-77fa-bd6e-3e1a8ccba7c7@sandeen.net> <20191025204329.GF4614@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025204329.GF4614@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 26, 2019 at 07:43:29AM +1100, Dave Chinner wrote:
> NFSv2 had a maximum client IO size of 8kB and writes were
> synchronous. The Irix NFS server had some magic in it (enabled by
> the filesystem wsync mount option) that allowed clients to have two
> sequential 8k writes in flight at once, allowing XFS to optimise for
> 16KB write IOs instead of the normal default of 64kB. This
> optimisation was the reason that, at the time (early-mid 90s), SGI
> machines had double the NFS write throughput of any other Unix
> systems.
> 
> I'm surprised we still support NFSv2 at all in this day and age - I
> suspect we should just kill NFSv2 altogether. We need to keep the
> wsync option around for HA systems serving files to NFS and CIFS
> clients, but the 8kB IO size optimisations can certainly die....

Last time I talked to the NFS folks there still were some very obscure
v2 use cases left (embedded devices that can't be upgraded).

But yeah, I'll add a patch to stop overriding rsize/wsize with the
sync option.
