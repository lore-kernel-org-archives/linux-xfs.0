Return-Path: <SRS0=AY68=YU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CDECA9EAF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 15:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82C8C21850
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 15:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfJ0PTw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Oct 2019 11:19:52 -0400
Received: from verein.lst.de ([213.95.11.211]:58485 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbfJ0PTw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 27 Oct 2019 11:19:52 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C4BED68B05; Sun, 27 Oct 2019 16:19:49 +0100 (CET)
Date:   Sun, 27 Oct 2019 16:19:49 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/4] fs: add generic UNRESVSP and ZERO_RANGE ioctl
 handlers
Message-ID: <20191027151949.GB6199@lst.de>
References: <20191025023609.22295-1-hch@lst.de> <20191025023609.22295-3-hch@lst.de> <20191025054452.GF913374@magnolia> <20191025095005.GA9613@lst.de> <20191026205609.GJ4614@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191026205609.GJ4614@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 27, 2019 at 07:56:09AM +1100, Dave Chinner wrote:
> We should plan to deprecate and remove ALLOCSP/FREESP - they just
> aren't useful APIs anymore, and nobody has used them in preference
> to the RESVSP/UNRESVSP ioctls since they were introduced in ~1998
> with unwritten extents. We probably should have deprecated then 10
> years ago....

I vaguely remember an actually reported bug beeing fixed in the code
just a few years ago, which suggests actual users.  That being said
I'm all for throwing in a deprecation warnings and then see if anyone
screams.  With this series the code becomes more self-contained, and
I have another patch that moves the IOC_RESVP / fallocate implementation
over to use iomap, at which point it is entirely standalone.
