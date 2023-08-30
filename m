Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBC2C83F18
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Aug 2023 18:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjH3Sir (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245553AbjH3Pd2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2023 11:33:28 -0400
X-Greylist: delayed 586 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 30 Aug 2023 08:33:24 PDT
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDA4113
        for <linux-xfs@vger.kernel.org>; Wed, 30 Aug 2023 08:33:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ED5CB81F49
        for <linux-xfs@vger.kernel.org>; Wed, 30 Aug 2023 15:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDC4C433C8;
        Wed, 30 Aug 2023 15:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693409016;
        bh=5Nx9DUf6gCO0sCv75NslHcaAOIt1ROrPP+tGtNzidBI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fwAosgNH278hROunJXXCAI6sQafzJb6HMQunZU4fn0t0P30U0AQzCZin1P5XC0Gvq
         xjLf/gYkGc8P4u1Mrwa1OK72NPvuQkqwh0TxzkcUCTIcyvrWoRLNKNhdb+7+hUH8Ik
         yUlpJS9dPYJh720ev9oU+ipCmZ0/6oOpvBkDDjDCEkSkB+DkWtUq1vghlYpCm0BIrw
         TuJO/ZpeDjr4J2hMZLbJFmLI2fxObuIX0ziGRylUf5KqF3hehbnVA6rV32O0ipzO9e
         od3Q31sR7rTTjWhmE19cnq48jOlomz5ve3MB+lF89MhbOIrmjUlouIdK9V4/yWU27o
         wDj1ZoCMKMbEA==
Date:   Wed, 30 Aug 2023 08:23:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 2/2] xfs: fix log recovery when unknown rocompat bits are
 set
Message-ID: <20230830152335.GI28186@frogsfrogsfrogs>
References: <169335056369.3525521.1326787329447266634.stgit@frogsfrogsfrogs>
 <169335057499.3525521.13864967150156919137.stgit@frogsfrogsfrogs>
 <ZO6N/8JBzF3Ev92x@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZO6N/8JBzF3Ev92x@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 30, 2023 at 10:31:59AM +1000, Dave Chinner wrote:
> On Tue, Aug 29, 2023 at 04:09:35PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Fix log recovery to proceed on a readonly mount if the primary sb
> > advertises unknown rocompat bits.  We used to allow this, but due to a
> > misunderstanding between Eric and Darrick back in 2018, we accidentally
> > changed the superblock write verifier to shutdown the fs over that exact
> > scenario.  As a result, the log cleaning that occurs at the end of the
> > mounting process fails.
> > 
> > We now allow writing of the superblock if there are unknown rocompat
> > bits set, but only if the filesystem is read only.  Hence we still have
> > to remove all ro state toggling that occurs around the log mount calls.
> 
> APart from the wording of the commit message, this all looks good.
> It took me a little while to parse what it meant paragraph meant,
> so can I suggest something like:
> 
> 	Log recovery has always run on read only mounts, even where the
> 	primary superblock advertises unknown rocompat bits. Due to a
> 	misunderstanding between Eric and Darrick back in 2018, we accidentally
> 	changed the superblock write verifier to shutdown the fs over that exact
> 	scenario.  As a result, the log cleaning that occurs at the end of the
> 	mounting process fails if there are unknown rocompat bits set.
> 
> 	As we now allow writing of the superblock if there are unknown
> 	rocompat bits set on a RO mount, we no longer want to turn off RO
> 	state to allow log recovery to succeed on a RO mount.  Hence we also
> 	remove all the (now unnecessary) RO state toggling from the log
> 	recovery path.

Ok, I've copied that in verbatim.  Thanks for reviewing these!

--D

> Other than that,
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
