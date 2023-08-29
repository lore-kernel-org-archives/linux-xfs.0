Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706AAC83F17
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240764AbjH2XnP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238337AbjH2Xmo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:42:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB8E1B1
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 16:42:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F5BD62163
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7C8C433C7;
        Tue, 29 Aug 2023 23:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693352561;
        bh=C1r4uu5vY5A5ig/2TVPCSHUaP1cjN9C2CPQUMT5MSpQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nLfPy4EHkHncmv1CfwkHA+wCiCdqcEPrYNnb8cKG6dzlbcBmF0R6Z2YbFBnqvmytP
         35vnJYoPiKjakiJ5/ZliiwRbvsDnHPcdVN+XdGKkZgAYYyPhR5ttOJk9bDpRdekS5A
         wTyFCjOmL2/cY8JqZynzwetsnK7u/nCMgdSmTAcOT4qY+dEk30QlT8TrBOUKaOz3Lj
         omDcgbs8kj7v4Nyes0F+wzaAsNvGrTAAfphEFXzJCHyZl1DZHWj1oIEr54+KzdFzYW
         xX/OePYhnNzBDCeyFrKGnfLKENOrzZHHa/4M/3Wn+OPAu/alRClq8IBll769RXnGk3
         6QMFyN6A/M/Vw==
Date:   Tue, 29 Aug 2023 16:42:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 217769] XFS crash on mount on kernels >= 6.1
Message-ID: <20230829234240.GG28186@frogsfrogsfrogs>
References: <bug-217769-201763@https.bugzilla.kernel.org/>
 <bug-217769-201763-6ooKMqk3mb@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-217769-201763-6ooKMqk3mb@https.bugzilla.kernel.org/>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 09, 2023 at 07:10:03PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=217769
> 
> --- Comment #15 from Richard W.M. Jones (rjones@redhat.com) ---
> No problems.  We had a similar bug reported internally that
> happens on VMware guests, and I'm just trying to rule out VMware
> as a factor.

Does this:
https://lore.kernel.org/linux-xfs/20230829232043.GE28186@frogsfrogsfrogs/T/#u

help in any way?

--D

> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.
