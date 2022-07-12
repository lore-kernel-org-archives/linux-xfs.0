Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A52C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jul 2022 01:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiGLBUn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 21:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiGLBUn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 21:20:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7517B5A459
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 18:20:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CF016164B
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 01:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605FCC34115;
        Tue, 12 Jul 2022 01:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657588841;
        bh=ikd7QzlofJZiBxlo2sOcIg5vaMpYvJuWJzF2Tr+LPGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CaQhKP/NCBV6wDbirm2tM3ZSJ7t0CUy4S6k5wzkpCv3/j/xfBnmk9kalj3PRzNOI7
         i+Oby2Rg2VckVhbprwbqEAtQwxzQbcJtBhqPSBJ5FGxUXNrQKShIl6FMDC7OWWs1ox
         MceDh5S3EfPCbIV5pLE9w1AJpH3uNaOBIcYL0UyYs1roo6simdcEcz+XfCycc/wMAm
         jBiWRgAKath00HDD+He+WTLrnyFtYv6DTk29gk+DVZa61AGqTVVLARObzHp9ayLEE5
         kTn2fX/oj/RJri3Bvx2xUTwregGJv7/tuX7YPWpseo30hFXiXep127obdHuuhkmYDV
         7qdjK8WsXphTA==
Date:   Mon, 11 Jul 2022 18:20:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com
Subject: Re: [PATCH 1/5] xfs: convert XFS_IFORK_PTR to a static inline helper
Message-ID: <YszMaH4fLe0S6Jp7@magnolia>
References: <165740691606.73293.12753862498202082021.stgit@magnolia>
 <165740692193.73293.17607871779448850064.stgit@magnolia>
 <Ysu0iYgkaGdg6oVJ@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ysu0iYgkaGdg6oVJ@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 10, 2022 at 10:26:33PM -0700, Christoph Hellwig wrote:
> On Sat, Jul 09, 2022 at 03:48:42PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > We're about to make this logic do a bit more, so convert the macro to a
> > static inline function for better typechecking and fewer shouty macros.
> > No functional changes here.
> 
> No arguments about the inline which is always a good idea.  But is
> there much of a point in changing the naming?  The old one nicely
> sticks out just like XFS_I and VFS_I have been inline functions for
> a long time.

I personally am not that bothered by shouty function names, but Dave
has asked for shout-reduction in the past, so every time I convert
something I also change the case.

AFAIK it /is/ sort of a C custom that macros get loud names and
functions do not so that you ALWAYS KNOW, erm, when you're dealing with
a macro that could rain bad coding conventions down on your head.

--D
