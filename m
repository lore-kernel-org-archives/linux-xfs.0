Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C516EC433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EF1065028
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhCEIds (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 03:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhCEId3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 03:33:29 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CCEC061574;
        Fri,  5 Mar 2021 00:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3pHxCCeXqcyf84HoM6PDsgF53YTR/HZI3lST9lPHJE8=; b=QTOLyFTj0ATCnqeWzUjd4j0GDA
        mL1rOzNJoXkYQDwS2UdupS5g+rTPNS9YpOxmNMhoWbPYa8j6pL3hotbD1GKOlRwAEj08udN3q7kCB
        hRQtOtz+pMbFWAF5U58TiJ9U4ZwlrHx0rYh4t+tTxKlgrwT5ovEQ1+++u9AwswrkfGPvD0Q2Lh7Om
        FDGwj2Ah9VY5axgPRolhuZbQLC11KdwoEUMeeSNQ9kMv0OGd9DzkDsukwztmdyQW8mF7KSMvv3QsC
        geNZGfsBAduynpBfVEzR2AZnRyVR2fEoYP6E5GQXD837Iz4XyRLxwe3lXokNLHcZXYimwH6pcHxVw
        Tcrd3HZg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lI5tX-00AqJf-0z; Fri, 05 Mar 2021 08:33:13 +0000
Date:   Fri, 5 Mar 2021 08:33:11 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/4] common/rc: fix detection of device-mapper/persistent
 memory incompatibility
Message-ID: <20210305083311.GJ2567783@infradead.org>
References: <161472735404.3478298.8179031068431918520.stgit@magnolia>
 <161472737079.3478298.2584850499235911991.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161472737079.3478298.2584850499235911991.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 03:22:50PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit fc7b3903, we tried to make _require_dm_target smart enough to
> _notrun tests that require a device mapper target that isn't compatible
> with "DAX".  However, as of this writing, the incompatibility stems from
> device mapper's unwillingness to switch access modes when running atop
> DAX (persistent memory) devices, and has nothing to do with the
> filesystem mount options.
> 
> Since filesystems supporting DAX don't universally require "dax" in the
> mount options to enable that functionality, switch the test to query
> sysfs to see if the scratch device supports DAX.
> 
> Fixes: fc7b3903 ("dax/dm: disable testing on devices that don't support dax")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
