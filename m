Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E667C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 15:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F395761216
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 15:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhIPPLp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 11:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238608AbhIPPLo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 11:11:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4461561108;
        Thu, 16 Sep 2021 15:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631805024;
        bh=y1P6vj792ZYcyICYRvCk9eE43OQ9VTzfkALrnxR4UdY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t48AXWW4nv4XsDbLr64S9iKMiUS2Mp9SoL+aBElhTAnWWRTMolUwsjmt/Gby+HUAC
         UHbw7CUoBsuWCJ/lHlLqsqxpZWd/ymt/8xJ3a55YlhUM9BHaqIeQglCkRoVTmLDDzs
         eN8/Pt5iVHEjtETJNQhvuu0lCoCfnqFpgKq/B64rBLQhDCP4+huRp3ftL2UAF/fZu3
         SeyOV/6iHo4bgpDUg1L5QVEyG9Z1bm07b+88QdylnlJvkiCrNfV8ev+/wmVc5ExQem
         clOQ3ZtD8Qg0zx3RU+b4iFki8tyLY66CZi9uRC6Eh5zGJiC/WpXFMorMhXZUL1sTu9
         v00ucoQ5CKF5w==
Date:   Thu, 16 Sep 2021 08:10:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 61/61] mkfs: warn about V4 deprecation when creating new
 V4 filesystems
Message-ID: <20210916151024.GC34874@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174752777.350433.15312061958254066456.stgit@magnolia>
 <YULvufnBE3VRfZu8@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YULvufnBE3VRfZu8@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 08:18:17AM +0100, Christoph Hellwig wrote:
> On Wed, Sep 15, 2021 at 04:12:07PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The V4 filesystem format is deprecated in the upstream Linux kernel.  In
> > September 2025 it will be turned off by default in the kernel and five
> > years after that, support will be removed entirely.  Warn people
> > formatting new filesystems with the old format, particularly since V4 is
> > not the default.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks good,
> 
> (assuming you're already dealing with the xfstests fallout)

Already merged to fstests two weeks ago. ;)

(Was there supposed to be a RVB tag here?)

--D
