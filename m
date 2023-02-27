Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCB1C7EE23
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Feb 2023 00:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjB0AKQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Feb 2023 19:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjB0AKP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Feb 2023 19:10:15 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE9AB76B
        for <linux-xfs@vger.kernel.org>; Sun, 26 Feb 2023 16:10:14 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id x34so4422194pjj.0
        for <linux-xfs@vger.kernel.org>; Sun, 26 Feb 2023 16:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Eh6e29MTS78inc95RvxVitPn9VdWzVoZiaCQdVbhYo=;
        b=JOGsZ10SsnvSukmoee6jALBvstX1SQgePYtUnAOjtDLvLRTgaFawICRQ4/MiGmsHRx
         45Spk52leH3Ug+e3AqYF3zIHdVWx9GUBHNvQzDfX5kgVnW3lpVX3GRWNbS257/A/5fkE
         a5IsZ9UwoJkr4oFQkYmcCzyCcQIgmWiYKCXc2aSfrVMQWDLrcAG7CfJ9fY0mvvy8/Wlg
         lf20pyBNjjPLXQK1EUFNrv/FlllGuoVbGXI08KqCuzu7hs4rdFcpAWKFnPdUNgy2i/hn
         uh+JQyHLLTARDZX8MWoJEJ+oyypRknVcElBnb48ioFuPbynEZSdMXIzX/uMvOJfOGLP1
         K+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Eh6e29MTS78inc95RvxVitPn9VdWzVoZiaCQdVbhYo=;
        b=JH30Ug7Q1P+iQHfzgGbhmNp0s2LYfHlxAiIax13MWR117xPt/k0FbwV68JGpMr0iPy
         VSp+2EFyhOP6B8oqxpzz+okL7ZTHtoIa2Er7psWO/Gg5ftLT03SX8WiT16e1rn+/rjMo
         fHoTGCxWkdQvbMW6Xe7CE2wuc9eJ4QY68ATYrBIVIRK4TmR0kmN7kcmwRBWsQg+8mv/N
         5xhQngsS3EGgc3eDJsRBeBlIb3y3XOMq+8DYRlZL17tKJIvjU4b/7BtEm6tZFfQJVX8C
         fp7onfUy9InCkMPrnLRbga+szhx3t8JHS+ZEY76JdKfs6NDiNB1Ynz1uKkxgtVztaEK2
         +dRg==
X-Gm-Message-State: AO0yUKXOzLMNp/bst9DYXJdmYjMnjjY98dMVIwC/GC6s0KHKisWrtP4p
        9kruqAfG4n4ymyOhBbLU4PkNt2+r/Bw2zGrD
X-Google-Smtp-Source: AK7set+TykWH+l1unKzzABA9py4+gsulnqRqI3O1SU/B80svYu66Eklz4Hn7YvMNEGdZ4mrX4s0NYg==
X-Received: by 2002:a17:903:41cd:b0:19c:171a:d342 with SMTP id u13-20020a17090341cd00b0019c171ad342mr26570878ple.37.1677456614311;
        Sun, 26 Feb 2023 16:10:14 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id a11-20020a170902900b00b0019a9637b2d3sm3150610plp.279.2023.02.26.16.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 16:10:13 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pWR5n-002Wz2-9C; Mon, 27 Feb 2023 11:10:11 +1100
Date:   Mon, 27 Feb 2023 11:10:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Aravinda Herle <araherle@in.ibm.com>
Subject: Re: [RFCv3 3/3] iomap: Support subpage size dirty tracking to
 improve write performance
Message-ID: <20230227001011.GA360264@dread.disaster.area>
References: <cover.1677428794.git.ritesh.list@gmail.com>
 <9650ef88e09c6227b99bb5793eef2b8e47994c7d.1677428795.git.ritesh.list@gmail.com>
 <20230226234814.GX360264@dread.disaster.area>
 <Y/vxlVUJ31PZYaRa@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/vxlVUJ31PZYaRa@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 26, 2023 at 11:56:05PM +0000, Matthew Wilcox wrote:
> On Mon, Feb 27, 2023 at 10:48:14AM +1100, Dave Chinner wrote:
> > > +static void iomap_iop_set_range_dirty(struct folio *folio,
> > > +		struct iomap_page *iop, size_t off, size_t len)
> > > +{
> > > +	struct inode *inode = folio->mapping->host;
> > > +	unsigned int nr_blocks = i_blocks_per_folio(inode, folio);
> > > +	unsigned first = (off >> inode->i_blkbits);
> > > +	unsigned last = ((off + len - 1) >> inode->i_blkbits);
> > 
> > first_bit, last_bit if we are leaving this code unchanged.
> 
> first_blk, last_blk, surely?

Probably.

And that's entirely my point - the variable names need to
describe what they contain...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
