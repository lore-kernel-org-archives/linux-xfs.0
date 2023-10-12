Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2FBCDB482
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 05:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377005AbjJLFDG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 01:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbjJLFDD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 01:03:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB52F90;
        Wed, 11 Oct 2023 22:03:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B116C433C7;
        Thu, 12 Oct 2023 05:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697086982;
        bh=enaIyQuN9O9QyeA7mFd0Zm5bRkaXTlbjysu/4ev9O+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d2279sfv2+VCGh5tPTNPX2YYxwh3uewPwR7UeFXwv3VHEp50RSpXVUsCgdKl1Erez
         4taagbP1tCKqxHgF7BtNEQQJ80BQjnsp0eFPWYIfy0gvwTdWHgzG32VA3F6DtrXSK7
         8XXivhdCJqgym9YliPfnuceGOTYtME2JrKV4+EhXdGt7/rpTbBtO/MLHrAbf2DoTQc
         PAWKIpNp/dOTOfnQcw6q2Vzdeka1vfCqycuvYxWDw6o4zoGlFIkLL5vjqQfSSQbfJM
         kJEGSKXplAA8BG7z4SY93MUYZP+lpg8PnpNY7xlwnwXpJLOAHlbN/N+nP+rsDhjrwq
         cYvhv9Aun5UHQ==
Date:   Wed, 11 Oct 2023 22:03:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/178: don't fail when SCRATCH_DEV contains random
 xfs superblocks
Message-ID: <20231012050301.GG21283@frogsfrogsfrogs>
References: <169687550821.3948976.6892161616008393594.stgit@frogsfrogsfrogs>
 <169687551395.3948976.8425812597156927952.stgit@frogsfrogsfrogs>
 <ZST2zRvtMrU0KlkN@infradead.org>
 <20231011191025.GX21298@frogsfrogsfrogs>
 <ZSd1i6nRut0FedmA@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSd1i6nRut0FedmA@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 09:26:51PM -0700, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 12:10:25PM -0700, Darrick J. Wong wrote:
> > I'm pretty sure I've seen some NVME SSDs where you can issue devicewide
> > DISCARDs and slowly watch the namespace utilization go down over tens of
> > minutes; and reads will only eventually start returning zeroes.
> 
> Well, the second part is broken.  The first part is fine, and I've briefly
> consulted with a firmware team implementing such a feature.  It just needs
> to make sure to return zeroes right after the return of the discard
> even if the blocks aren't erased yet, including after a powerfail.
> (anyone who knows the XFS truncate / hole punch code will have a vague
> idea of how that could work).
> 
> > However, that's orthogonal to this patch -- if the device doesn't
> > support discard, _scratch_mkfs won't zero the entire disk to remove old
> > dead superblocks that might have been written by previous tests.  After
> > we shatter the primary super, the xfs_repair scanning code can still
> > trip over those old supers and break the golden output.
> 
> True.  I have to admit I stopped reading the patch after the unmap
> description.  I'll take another look.

<nod> I think I'll update the next version of this patch to substitute
the paragraph that I wrote above for all the misleading ramblings about
DISCARD.  Today's revisit of that clod block device doesn't show the
weird stale reads that disappear behavior, so it's entirely possible
that they've fixed it already.

--D
