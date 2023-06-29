Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB47EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 14:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjF2Ozn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 10:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjF2Ozm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 10:55:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49671FC1
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 07:55:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5277661466
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 14:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36A4C433C0;
        Thu, 29 Jun 2023 14:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688050535;
        bh=jkuuvYNOShlxKJtijp9RkG8EN/rshCpp2XxFtubTGwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sl/rmVAp0sqbYd2wvHGgmlxLBUXbysOXeQyQvdSPDVP34XJN1PeYCuAdasXYPeUrk
         QLEyghbnFDVIGbJpyCfJomKTn6EfoQ46NxzVcKlu+b9qSEFMiNGmtlr8FMWmJKnMkQ
         eGrakdpzi0JwjD3ZDoXpfX+yL04LxP+kJ9+gCR9S8bPS+YvWlvHmHc6vpNB4UMQLqZ
         QylPEP+XX/oipwMvLUNUZwn+JxvcStPhksMWpeS4cs3VjBzwn18ByQt7holbrYyttM
         xVcDHKaH2IIE3XSgVJfBRfqKXjMTM1Grt11jTBe78qjLzpgwM/c4JzeKe4OBZH2Nku
         ApBA6jrNeciXg==
Date:   Thu, 29 Jun 2023 07:55:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 217604] Kernel metadata repair facility is not available,
 but kernel has XFS_ONLINE_REPAIR=y
Message-ID: <20230629145535.GC11441@frogsfrogsfrogs>
References: <bug-217604-201763@https.bugzilla.kernel.org/>
 <bug-217604-201763-INXcwbWsOM@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-217604-201763-INXcwbWsOM@https.bugzilla.kernel.org/>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 29, 2023 at 07:10:35AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=217604
> 
> j.fikar@gmail.com changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>              Status|NEW                         |RESOLVED
>          Resolution|---                         |DOCUMENTED
> 
> --- Comment #2 from j.fikar@gmail.com ---
> OK Dave, I'll do that. Maybe the help for XFS_ONLINE_REPAIR can mention that it
> is not yet working, to avoid future confusion.

Both kernel and userspace yell EXPERIMENTAL when you invoke any part of
the online fsck system; I thought that was sufficient...

--D

> Actually, I was reporting another kernel bug (vmalloc error), which was
> probably seen before and currently it is in network drivers (no idea, why it is
> there).
> 
> I'm telling you, as it might be XFS related. I see the bug exactly once a day
> and when I look at my cron.daily jobs, it happens during xfs_fsr run.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=217502
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.
