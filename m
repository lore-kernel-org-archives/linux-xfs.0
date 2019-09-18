Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B77C4CEC4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 16:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E75C8218AE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 16:46:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QcDHtyyc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731050AbfIRQqs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 12:46:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43882 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728817AbfIRQqs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 12:46:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gKqOfom8/Mtase3vICV/zwPuJ+/cZuOd5Pv7aZW8U6U=; b=QcDHtyycJTVXhjOPTYTOIOiSR
        CenK62vUEIqoy9VHOGyyyozrw0OhwV1tTkX4mSygxFswzZvC8JBSmsyfij7UCMRnmSd2h33TTREj8
        qV1bOqLw1WBrmSbMR8tNjoVt0GG0P1MiE7UzF33MgbUlnaDsBpJe8CQc9tTP9sRUmgpsBaiskEl9A
        nvzHZA6SHzoACo0aFZoYA75UzngGCq7AF8sxEDoNKjydwev0s+hrwm5lOTMtO0G9xxkWWt0/pJuN6
        ck0o9HfpAkmeLo7yPYnviNzGiIV7vJDU+CwaItROmbgtrxQrwXgAVcHBSU3J1RzYz/yxFeo+VFRCe
        FmNX8M7bA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iAd6N-0006we-UF; Wed, 18 Sep 2019 16:46:47 +0000
Date:   Wed, 18 Sep 2019 09:46:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        zlang@redhat.com
Subject: Re: [PATCH] [RFC] xfs: fix inode fork extent count overflow
Message-ID: <20190918164647.GA20614@infradead.org>
References: <20190911012107.26553-1-david@fromorbit.com>
 <20190911105550.GA23676@infradead.org>
 <20190912010838.GO16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912010838.GO16973@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 12, 2019 at 11:08:38AM +1000, Dave Chinner wrote:
> On Wed, Sep 11, 2019 at 03:55:51AM -0700, Christoph Hellwig wrote:
> > ... and there went my hopes to eventually squeeze xfs_ifork into
> > a single 64-byte cacheline.  But the analys looks sensible.
> 
> Not sure what the issue is here:
> 
> struct xfs_ifork {
>         int64_t                    if_bytes;             /*     0     8 */
>         struct xfs_btree_block *   if_broot;             /*     8     8 */
>         unsigned int               if_seq;               /*    16     4 */
>         int                        if_height;            /*    20     4 */
>         union {
>                 void *             if_root;              /*    24     8 */
>                 char *             if_data;              /*    24     8 */
>         } if_u1;                                         /*    24     8 */
>         short int                  if_broot_bytes;       /*    32     2 */
>         unsigned char              if_flags;             /*    34     1 */
> 
>         /* size: 40, cachelines: 1, members: 7 */
>         /* padding: 5 */
>         /* last cacheline: 40 bytes */
> };
> 
> it's already well inside a 64-byte single cacheline, even with a
> 64bit if_bytes. Yes, I've just pushed it from 32 to 40 bytes, but
> but if that is a problem we could pack some things more tightly...

Ok, I misremembered.  But before it fit into half a cacheline and nicely
aligned slab, and now it doesn't.  Not really as an argument against
the patch because it is clearly needed..
