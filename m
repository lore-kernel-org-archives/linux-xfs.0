Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4CAC77B73
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Apr 2023 02:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344599AbjD1CU6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 22:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344764AbjD1CU5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 22:20:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1300C269D
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52C5B611F6
        for <linux-xfs@vger.kernel.org>; Fri, 28 Apr 2023 02:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC79C433D2;
        Fri, 28 Apr 2023 02:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682648455;
        bh=EqKqqH+uT5OlzsT/n7oYwz5IozN1zTRyNhMoeyX41R4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F/qmk1jMiv4DbdsvjArbK6Zt9I9gDiaykN7Rr/I3MOgc5FCROwagFLgIup0auNHPY
         1esEeKBs7Z+m9dTOloDKbmyFq34oOhdwsz/vIZHkeU3953fYodPe72lI/Tcib5ppq2
         JKZ+6avs3HQWiwW4Sxa6wVphaKBYh+kTkkVRbXjMcqLOeuOvSqVvkdL6cgtP67SjSD
         nEI8s6xUXg46Fwx2VOP8rJ7r+KelyD7nmnGPT6PE2t1StPRWrVzsGOWdTLKLILoOvS
         gSnPslpN9z97RH0diW7whXyddYynpTbjyv155GgrO2L4eCnkxhhtcmAIBFiMeaTKmh
         pdw0Eg94lHRjw==
Date:   Thu, 27 Apr 2023 19:20:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: don't allocate into the data fork for an
 unshare request
Message-ID: <20230428022055.GG59213@frogsfrogsfrogs>
References: <168263573426.1717721.15565213947185049577.stgit@frogsfrogsfrogs>
 <168263575686.1717721.6010345741023088566.stgit@frogsfrogsfrogs>
 <20230428021346.GQ3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428021346.GQ3223426@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 28, 2023 at 12:13:46PM +1000, Dave Chinner wrote:
> On Thu, Apr 27, 2023 at 03:49:16PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > For an unshare request, we only have to take action if the data fork has
> > a shared mapping.  We don't care if someone else set up a cow operation.
> > If we find nothing in the data fork, return a hole to avoid allocating
> > space.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_iomap.c |    5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Looks ok, but I'm unsure of what bad behaviour this might be fixing.
> Did you just notice this, or does it fix some kind of test failure?

I noticed it while I was running the freespace defrag code in djwong-dev
with tracepoints turned on.  THere was a math bug that I was trying to
sort out that resulted in FUNSHARE being called on a hole, and I was
surprised that it would create a delalloc reservation and then convert
it to an unwritten extent instead of going straight to an unwritten
extent.

AFAICT it has no user visible effect other than not wasting cycles on
pointless work.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
