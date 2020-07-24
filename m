Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80539C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 07:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5099920748
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 07:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j/GJPcn/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgGXHgm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 03:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgGXHgm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 03:36:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBC4C0619D3
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 00:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jPWSjFqV2AeXXx4TRZ3nZzNy0yJKNQcU/3sTZCZ1lnk=; b=j/GJPcn/x1a5di4J4jgWBDPzgP
        jg+rlkG/Gd0XHl6vitRHmVMXQBr9JjQj50TvYYyuBxeVBiOKZqEQsehHP9+DVyCdjv3IU6fQHubHd
        EnA9zwDr3WHWyUAZ5mUWHi/dOVZkg0dKDHaC5BqrPFH8/c8mBhO5apfFT9btu2uFgaUs5tC6UoExR
        5Yyy7oc5A9bVMxfhf4Aod1yGTCom0urP5NzH+DuJSi70BppQLir2ogQS/e2ioeZP0ljqOBtTtzGbv
        AVuTKgtk8irVJo0PgCmtMUfukLEbStM8DNCpWYJbsHuHeHDRShnwQ3f+mTjsQD+MoAfF/zmWhNPsr
        lr/ni0HA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jysFz-0006hj-Nz; Fri, 24 Jul 2020 07:36:39 +0000
Date:   Fri, 24 Jul 2020 08:36:39 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: Need to slow things down for a few days...
Message-ID: <20200724073639.GA23472@infradead.org>
References: <20200723172113.GP3151642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723172113.GP3151642@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 23, 2020 at 10:21:13AM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> I wrenched my back last night (blah blah too much internal process
> stress and sitting) and need a few days rest.  I still intend to make a
> post-rc6 for-next push, though I've noticed that fstests runtime has
> slipped by about 30%.
> 
> I can't tell if it's the result of iomap directio falling back to
> buffered writes, or Carlos' kmem conversion, or even Allison's delayed
> attrs series, but I'll know in a few hours.  I added all three a few
> days ago to see what would happen. :P
> 
> In the meantime, I'll be hobbling along in the slow lane because sitting
> down is not a good idea and I can only standing-desk it for so long. :(

Oh well, get better soon!
