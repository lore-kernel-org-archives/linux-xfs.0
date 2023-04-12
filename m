Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE204C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 00:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjDLAYJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 20:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjDLAYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 20:24:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75536BC
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 17:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10F1E623FB
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 00:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658C1C433D2;
        Wed, 12 Apr 2023 00:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681259047;
        bh=+a7QU3fBSSTLXAwqfeO8liOaTlc007M1oLovqE2VPI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LeWrnKnhABt+rP7KeAu4mNeBdNQEKNJey5kR0PhtSiMgo4Jh7LMpkfmj/khUfsq27
         84kC6Dmx+L6tV5jRFt4pkdDfbumqWh1K49hkf7C9X5MDhpBrzq5LdVhp9UpYhJdxBE
         FCAxWlV1Qvh3xFDQi6hq2LYz9I3R7naXjX2XlmM8AVP7J9r2FjrDCFrHE3ynrNxQiG
         UNETLI0IegrrbnOA6/lLzdsHI0cyhtD80UE6MzWGJAmWvELXbBhc29jhoRBL445gBK
         x0FJZzedvKIted/TOVUlH2CEbMJDJOR9dwnitkWbZsNYv/dkstNjUaO1HvPKpLfGyO
         2xr8wVRFZEmuA==
Date:   Tue, 11 Apr 2023 17:24:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     allison.henderson@oracle.com, dchinner@redhat.com, hch@lst.de,
        linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE online fsck 1/2] xfs-linux:
 scrub-strengthen-rmap-checking updated to d95b1fa39fab
Message-ID: <20230412002406.GO360889@frogsfrogsfrogs>
References: <168123761359.4118338.3332729538416597681.stg-ugh@frogsfrogsfrogs>
 <20230412002028.GG3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412002028.GG3223426@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2023 at 10:20:28AM +1000, Dave Chinner wrote:
> On Tue, Apr 11, 2023 at 11:29:58AM -0700, Darrick J. Wong wrote:
> > Hi folks (mostly Dave),
> > 
> > The scrub-strengthen-rmap-checking branch of the xfs-linux repository at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git
> > 
> > has just been updated for your review.  These are all the accumulated
> > fixes for online scrub, as well as the design document for the entire
> > online fsck effort.
> > 
> > This code snapshot has been rebased against recent upstream, freshly
> > QA'd, and is ready for people to examine.  For veteran readers, the new
> > snapshot can be diffed against the previous snapshot; and for new
> > readers, this is a reasonable place to begin reading.  For the best
> > experience, it is recommended to pull this branch and walk the commits
> > instead of trying to read any patch deluge.  Mostly it's tweaks to
> > naming and APIs that Dave mentioned last week.
> 
> Ok, I've been through all the changes since the last version, it
> looks good to me.
> 
> Consider the entire series:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Yayyyy!!  Thank you!!!!!!

Do you want me to send a pull request for the whole thing?

--D

> -- 
> Dave Chinner
> david@fromorbit.com
