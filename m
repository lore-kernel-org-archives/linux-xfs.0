Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF55C433B4
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Apr 2021 16:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0696561132
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Apr 2021 16:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhDHQbK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Apr 2021 12:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231480AbhDHQbK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Apr 2021 12:31:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A64EC61104;
        Thu,  8 Apr 2021 16:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617899458;
        bh=+KVz9VGwFSlrhkFM7neS1Y2sbkuQSYRqabZwmtH9irU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cMq21/PkTiSDh5kdpr9j51qKprpcqBPWSB6U3rKlISg/q3T8pK/p0I1kXWI4kPu58
         dEFiVmoaKsQY/8zcuCT8WGPXq/kyiTZmmjBLJLlttr5owh3f+l/E9WrY/MFM3eOeXF
         /7/gCy9decRoTSJGsUbJPE2y9YiVVeOIbgYcSy3SFgUYBgfIuuEqSQX+xGFlaBlvsP
         cU5B2wHfasaTRZcKhmc029qjmY/6lLPidUBpuHg4I6mOJ7D3ZfqP5aqaElHb/Re8Bh
         s7Or0v2j+F5BoLJS3UPYLgju6QlnfSgL1qU1LEIRr9mN2KmWfiEQ841peQ1av3Bn06
         SF9+oFGPit5SQ==
Date:   Thu, 8 Apr 2021 09:30:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: get rid of the ip parameter to xchk_setup_*
Message-ID: <20210408163058.GU3957620@magnolia>
References: <20210408010114.GT3957620@magnolia>
 <20210408121933.GB3848544@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408121933.GB3848544@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 08, 2021 at 01:19:33PM +0100, Christoph Hellwig wrote:
> On Wed, Apr 07, 2021 at 06:01:14PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Now that the scrub context stores a pointer to the file that was used to
> > invoke the scrub call, the struct xfs_inode pointer that we passed to
> > all the setup functions is no longer necessary.  This is only ever used
> > if the caller wants us to scrub the metadata of the open file.
> 
> Even before we had the xfs_inode in struct xfs_scrub, so why detour
> through struct file?

xfs_scrub.fil[ep] is the file corresponding to the fd that userspace
used to call scrub.

xfs_scrub.ip is the file that we're actively checking, if applicable.
This can be a different file than filp if we're checking file-based
metadata such as the rt bitmap and summary files; or if the caller is
doing scrub-by-handle for a non-regular file (e.g. open the root
directory and pass in the ino/gen of a symlink file to check that the
symlink is ok).

Let me respin this with added struct commentary in scrub.h.

--D
