Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C1AC4360C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 06:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B45F920867
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 06:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbfJHGMb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Oct 2019 02:12:31 -0400
Received: from verein.lst.de ([213.95.11.211]:43917 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728297AbfJHGMb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Oct 2019 02:12:31 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6910568B20; Tue,  8 Oct 2019 08:12:26 +0200 (CEST)
Date:   Tue, 8 Oct 2019 08:12:25 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 09/11] xfs: remove the fork fields in the writepage_ctx
 and ioend
Message-ID: <20191008061225.GA27652@lst.de>
References: <20191006154608.24738-1-hch@lst.de> <20191006154608.24738-10-hch@lst.de> <20191007215944.GC16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007215944.GC16973@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 08, 2019 at 08:59:44AM +1100, Dave Chinner wrote:
> On Sun, Oct 06, 2019 at 05:46:06PM +0200, Christoph Hellwig wrote:
> > In preparation for moving the writeback code to iomap.c, replace the
> > XFS-specific COW fork concept with the iomap IOMAP_F_SHARED flag.
> 
> "In preparation for switching XFS to use the fs/iomap writeback
> code..."?
> 
> I suspect the IOMAP_F_SHARED hunk I pointed out in the previous
> patch should be in this one...

All these made a whole lot more sense before Darrick reshuffled the
code.  In my original version I started massaging the XFS code so that
it can be moved to iomap without functional changes, but Darrick wanted
the iomap code added in one series and then XFS switched over, which
made a lot of things more confusing than they were intended to be.
