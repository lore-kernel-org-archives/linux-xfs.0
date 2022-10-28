Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58421C38A02
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 19:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJ1Tw0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 15:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiJ1TwZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 15:52:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18D9245EA8;
        Fri, 28 Oct 2022 12:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ffjXFJfInRuY4KexRLpq5bVKkJ2P7hPt+j48cm2aYeA=; b=qAS/JAFmFk9DKJdgkhy5AeqPBP
        KLXBfQyUgyZrToj2OeJ8E57MV6wv2GSdVchdawCnUrYWp+I56BaSJvMPIAzwiaeStiBqQc46XqJZ6
        bqRheLwJOKrmLdgLsBbEjG4/X+BNqO7wUNqoa0gUgMzhnW8K8Lgi1EF0Tyzz+qZhy1PCyJey7V7xD
        Gw2cKHhmQ8iYLf0RrJ5Ww6271NSOHJSjS/Vz590QrJVa9x4kV5OXCkOrdIWkAmnGc7XUWyObrz2D4
        K4PvHsFgE+Xphrf5qVleUhs5q478YAONr/HwAtraPJdp+te9KW9MD0wFikm7IbDZd87REelkhKDH8
        ycubKXoA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ooVOy-001VKK-9S; Fri, 28 Oct 2022 19:52:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 322EE30029C;
        Fri, 28 Oct 2022 21:52:19 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 18A482C26AB85; Fri, 28 Oct 2022 21:52:19 +0200 (CEST)
Date:   Fri, 28 Oct 2022 21:52:18 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Yujie Liu <yujie.liu@intel.com>, oe-lkp@lists.linux.dev,
        lkp@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        fengwei.yin@intel.com, ying.huang@intel.com,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [tip:x86/core] [kallsyms] f138918162:
 WARNING:CPU:#PID:#at_fs/xfs/xfs_message.c:#xfs_buf_alert_ratelimited.cold-#[xfs]
Message-ID: <Y1wy8nvCWmXssMnY@hirez.programming.kicks-ass.net>
References: <202210241614.2ae4c1f5-yujie.liu@intel.com>
 <Y1kDEmLeRA2UGeF8@hirez.programming.kicks-ass.net>
 <Y1kiuTIYobR4nexS@hirez.programming.kicks-ass.net>
 <Y1nobODPLUjcteJ0@yujie-X299>
 <2543dfb1-d9dc-0888-dbea-e420a19d732c@intel.com>
 <Y1qv3ku6ULHy8hOF@magnolia>
 <Y1q2/fdvXI67MRch@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1q2/fdvXI67MRch@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 27, 2022 at 06:51:09PM +0200, Peter Zijlstra wrote:
> 
> > However, I noticed that the callsite in the WARNING: message has changed
> > from the usual 'asswarn' (which is the caller of WARN_ON) to
> > 'xfs_buf_alert_ratelimited', which seems totally wrong since XFS log
> > recovery doesn't touch xfs_buf objects at all.
> 
> Yeah; and I've meanwhile found more cases where it goes sideways.
> 
> I'll revert this patch and try an alternative approach. I'll post
> patches tomorrow or something.

Now posted:

  https://lkml.kernel.org/r/20221028194022.388521751@infradead.org
