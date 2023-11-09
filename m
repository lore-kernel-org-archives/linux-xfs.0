Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C6FC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 00:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbjKIAu1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 19:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjKIAu0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 19:50:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC471990
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 16:50:24 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAF3C433C8;
        Thu,  9 Nov 2023 00:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699491023;
        bh=a1Zj7j8F68LiLGMlmISWvq4JS6TcNxNlSF2oJ1Dqa5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qPVS7JNNDfWiBl5NyLlWZdYNDnfUxgUpWKLQBsWwSXGw3uj/VX/75XgWy970fI/g6
         nH8URicY7gzDKA2mqkNf0gvu7zpR1sJ9bWjfzK7CPOQNzeJiuesrKUeTjmUkxeZ4pN
         XDZD6meh+zGeYwjQKsC4uVp1AD2SUiOIBhswjvi0MAh4jyuIVEYvZ0tO5fxxhzoynY
         ryWhePsKye3OCIR4IRLkyy6IOCrZTTd9q3j3IlqknOEAJdvAHE2RQ8DeC1a19rQlwL
         bDbvFYelVSjupaXeqZEHhhrl9BvAr7dtdkT9IPkJ4JikqQ4N+Tq+N2S1ANe2/3fLyA
         Er2yLrCjBDQ2Q==
Date:   Wed, 8 Nov 2023 16:50:23 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_scrub: allow auxiliary pathnames for sandboxing
Message-ID: <20231109005023.GB1205143@frogsfrogsfrogs>
References: <168506074508.3746099.18021671464566915249.stgit@frogsfrogsfrogs>
 <168506074522.3746099.11941443473290571582.stgit@frogsfrogsfrogs>
 <ZUn55/68v2VfQHCX@infradead.org>
 <20231107183511.GN1205143@frogsfrogsfrogs>
 <ZUs3Lex9NS55gXy3@infradead.org>
 <20231108074406.GL1758611@frogsfrogsfrogs>
 <ZUs9dh6Eft0rWrul@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUs9dh6Eft0rWrul@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 07, 2023 at 11:49:10PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 07, 2023 at 11:44:06PM -0800, Darrick J. Wong wrote:
> > > So if you make the pretty print mount point a new variable and pass
> > > that first this would become say:
> > > 
> > > 	xfs_scrub -p /home -b /tmp/scrub
> > > 
> > > ad should still be fine.  OR am I missing something?
> > 
> > Nope, you're not missing anything.  I could have implemented it as
> > another CLI switch and gotten the same result.  The appearance of
> > "/tmp/scrub" in comm is a bit ugly, but I'm not all that invested in
> > avoiding that.
> 
> So I'd definitively prefer that.  With the existing option remaining
> the one it operates on, and the new designating the pretty printing.
> 
> > > But scrub has by definition full access to the fs as it's scrubbing
> > > that.  But I guess that access is in the kernel code, which we trust
> > > more than the user space code?
> > 
> > Yep.  Scrub runs with CAP_SYS_RAWIO, but I want to make it at least a
> > little harder for people who specialize in weird ld exploits and the
> > like. :)
> 
> Yes.  It's also good for the other reason you pointed out.

LOL, and I even forgot that the original version of this patch actually
did it with '-A /tmp/scrub/'.  Well, good on the commit message for
reminding me of that.  So,

	SERVICE_MODE=1 xfs_scrub -b -M /tmp/scrub/ /home/

it is, then.

--D
