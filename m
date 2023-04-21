Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5123EC7618E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 16:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbjDUQPA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 12:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbjDUQO7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 12:14:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236AE19B6
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 09:14:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1218651A0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 16:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1473AC433EF;
        Fri, 21 Apr 2023 16:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682093697;
        bh=HDpl0FZKBoBtsq9FJoXsbQXUJEl0YP2ykOfOTDmQH7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RRmXBoxjnsm8uY/3CTFUySlZMUkfjs8dOa6GOPuIML6TedfmJ8v+7M9cfyEUt99Ld
         F3J6ZsbcORwnj/5sTB4Sb5b8jYPPvRKK/w+2h37yidE+Xssa841fVn+VWnEyoMSh+X
         RrMXEQUqUh2cn2Zuupe5K5zqhDbkvZm7gPGdcKg8ovzzWSbypBbyUgcGSp1IcqZEqz
         uPXaDIp+WQnxbhHEx5yP5eLdaKFe/kbtUz+BYdKAWGYT+LKs9vT3+H4kWWizz74Pw7
         IvOKUse1U6i9h8j1Z7zeulowZe7Qt6Hc3bOTDMXFW8aCJC06B8yIaEFVZMwuEV+lZf
         Pa8sBIAVBPHRw==
Date:   Fri, 21 Apr 2023 09:14:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Hironori Shiina <shiina.hironori@gmail.com>,
        linux-xfs@vger.kernel.org, Donald Douwsma <ddouwsma@redhat.com>,
        Hironori Shiina <shiina.hironori@fujitsu.com>
Subject: Re: [RFC PATCH V3] xfsrestore: fix rootdir due to xfsdump bulkstat
 misuse
Message-ID: <20230421161456.GP360895@frogsfrogsfrogs>
References: <20201116080723.1486270-1-hsiangkao@redhat.com>
 <20220928191052.410437-1-shiina.hironori@fujitsu.com>
 <YzXhMJmbEsEueRKy@magnolia>
 <b706af2d-c897-438e-a735-e0bd66c6b33a@sandeen.net>
 <LAvnQdcGzRYtveHjS-tySO1gRNmy5raB5aJrBSZwWew8UvwsG4yAVHofbI7CK0c5H1-ZpnLimrxtGYVwKHmbGg==@protonmail.internalid>
 <20230419154045.GG360889@frogsfrogsfrogs>
 <20230421091006.nodvelbpuztwoir6@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421091006.nodvelbpuztwoir6@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2023 at 11:10:06AM +0200, Carlos Maiolino wrote:
> Hi Darrick.
> 
> > > >> This patch adds a '-x' option (another awkward thing is that
> > > >> the codebase doesn't support long options) to address
> > > >> problamatic images by searching for the real dir, the reason
> > > >> that I don't enable it by default is that I'm not very confident
> > > >> with the xfsrestore codebase and xfsdump bulkstat issue will
> > > >> also be fixed immediately as well, so this function might be
> > > >> optional and only useful for pre-exist corrupted dumps.
> > > >
> > > > As far as fixing xfsdump -- wasn't XFS_BULK_IREQ_SPECIAL_ROOT supposed
> > > > to solve that problem by enabling dump to discover it it's really been
> > > > passed the fs root directory?
> > >
> > > Yes, but as I understand it this patch is to allow the user to recover
> > > from an already corrupted dump, at restore time, right?
> > 
> > Right, though I still haven't seen any patches to dump to employ
> > XFS_BULK_IREQ_SPECIAL_ROOT to avoid spitting out bad dumps in the first
> > place.  I think the heuristic that we applied is probably good enough,
> > but we might as well query the kernel when possible.
> > 
> > > This still feels like deep magic in xfsdump that most people struggle
> > > to understand, but it seems clear to me that the changes here are truly
> > > isolated to the new "-x" option - IOWs if "-x" is not specified, there is
> > > no behavior change at all.
> > >
> > > Since this is intended to attempt recovery from an already-corrupted
> > > dump image as a last resort, and given that there are already some xfstests
> > > in place to validate the behavior, I feel reasonably comfortable with
> > > merging this.
> > 
> > Documentation nit: Can restore detect that it's been given a corrupt
> > dump, and if so, should it warn the user to rerun with -x?
> > 
> > --D
> 
> I am assuming that even though you have concerns about not having
> XFS_BULK_IREQ_SPECIAL_ROOT employed in dump yet (and the documentation nit :),
> you are not opposed to have this patch merged?

Correct.  Consider this my somewhat passive-aggressive prod not to
forget to improve dump's "I'm doing something stupid" detector.

--D

> 
> -- 
> Carlos Maiolino
