Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E363ECA9EC8
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 23:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B552B21D7A
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 23:08:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=mbobrowski-org.20150623.gappssmtp.com header.i=@mbobrowski-org.20150623.gappssmtp.com header.b="P9ne7A9V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441709AbfJQXIW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 19:08:22 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32816 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441706AbfJQXIW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Oct 2019 19:08:22 -0400
Received: by mail-pg1-f195.google.com with SMTP id i76so2232876pgc.0
        for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2019 16:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbobrowski-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=98GpYLRwSkTQW+31mE56KMoWjsDPbX3fOPDTfwNIEJY=;
        b=P9ne7A9VWvIgJ2CO0Eq3g3Kuwsg77OIPUU+GUMXqFkhK5opoPq3Il7YFz+76EO/J+t
         7QHE4Aa6cQMU7X2JhpLe3yAyTAaLF5dtPVAkZa0M2g4Ixr6Usjl5mItPREAGWevki8rq
         ngIG77OZuG6GQMqfLAtfu/F/e9wekmOYLZQWeo38NfDgj/NkBIO4ScpZr00AYYlcZZC5
         OKtHkwEQDctGBeSTwEH9caCaMmriRHAgWvOHonl9dKWoOkGJwRoKWfM4geEtbeDP/Ico
         tCrVeZ/0+dk1GqzmjU9kl/zbuu3nmGqOiLdOxNzZH49j0tNMfIHi9qcb5fo8To4wJQHP
         xRRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=98GpYLRwSkTQW+31mE56KMoWjsDPbX3fOPDTfwNIEJY=;
        b=Z8VOioyqu4nv7yhFkauQdrklPNIA+9A+7ETDPp+i3rQtVJciEv/itojOP0wUw6/D/N
         SzdVlp+5VpqzchejmUHv0iu5Xl4Nl9mTrO4S70S5hUft8H4fO7jn39M6RhRPdk09ev5u
         8rFGMsFg5Ty2Kplzr59Tf1HtfQO1Ttrj/wZ1vUwtiTaEpVszF4xtK4UIE0mhP2SLVg/c
         k7q6smkFvP1O85CSSrmA+HW8209nC63/7ZuQ2v7kWoZ2PnNxW9Oz1WrY9yn8f9tvtMWG
         o3emuezeWym1gz6OKFo+TS0yajvkIdKrKSAesynzN+sUuR8ATCEkb4FiloRpGDDYqqKF
         /T8g==
X-Gm-Message-State: APjAAAWlOoW0gteM/LOrXOikGewWvBTfhe7VP1TJ9SqCDH9RwE16V6fu
        Vc7Elm7xSoVYugfR6jGGcru4gX5TX2NJ
X-Google-Smtp-Source: APXvYqyYF3m9FhGnMdMs4e2xcow7BtBbKNzso2k1mf749r04JEdi6TI4LKrua9x0eLSiK5Xnypurvw==
X-Received: by 2002:a63:41c7:: with SMTP id o190mr6771050pga.6.1571353701420;
        Thu, 17 Oct 2019 16:08:21 -0700 (PDT)
Received: from bobrowski ([110.232.114.101])
        by smtp.gmail.com with ESMTPSA id t11sm3418848pjy.10.2019.10.17.16.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 16:08:20 -0700 (PDT)
Date:   Fri, 18 Oct 2019 10:08:14 +1100
From:   Matthew Bobrowski <mbobrowski@mbobrowski.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 01/14] iomap: iomap that extends beyond EOF should be
 marked dirty
Message-ID: <20191017230814.GB31874@bobrowski>
References: <20191017175624.30305-1-hch@lst.de>
 <20191017175624.30305-2-hch@lst.de>
 <20191017183917.GL13108@magnolia>
 <20191017215613.GN16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017215613.GN16973@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 18, 2019 at 08:56:13AM +1100, Dave Chinner wrote:
> On Thu, Oct 17, 2019 at 11:39:17AM -0700, Darrick J. Wong wrote:
> > On Thu, Oct 17, 2019 at 07:56:11PM +0200, Christoph Hellwig wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > When doing a direct IO that spans the current EOF, and there are
> > > written blocks beyond EOF that extend beyond the current write, the
> > > only metadata update that needs to be done is a file size extension.
> > > 
> > > However, we don't mark such iomaps as IOMAP_F_DIRTY to indicate that
> > > there is IO completion metadata updates required, and hence we may
> > > fail to correctly sync file size extensions made in IO completion
> > > when O_DSYNC writes are being used and the hardware supports FUA.
> > > 
> > > Hence when setting IOMAP_F_DIRTY, we need to also take into account
> > > whether the iomap spans the current EOF. If it does, then we need to
> > > mark it dirty so that IO completion will call generic_write_sync()
> > > to flush the inode size update to stable storage correctly.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Looks ok, but need fixes tag.  Also, might it be wise to split off the
> > ext4 section into a separate patch so that it can be backported
> > separately?
> 
> I 've done a bit more digging on this, and the ext4 part is not
> needed for DAX as IOMAP_F_DIRTY is only used in the page fault path
> and hence can't change the file size. As such, this only affects
> direct IO. Hence the ext4 hunk can be added to the ext4 iomap-dio
> patchset that is being developed rather than being in this patch.

Noted, thanks Dave. I've incorporated the ext4 related change into my patch
series.

--<M>--
