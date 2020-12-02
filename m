Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64CA8C64E7B
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 17:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10AE321D7F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 17:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgLBRPA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Dec 2020 12:15:00 -0500
Received: from verein.lst.de ([213.95.11.211]:55144 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726221AbgLBRPA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Dec 2020 12:15:00 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 47B9067373; Wed,  2 Dec 2020 18:14:16 +0100 (CET)
Date:   Wed, 2 Dec 2020 18:14:16 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     ira.weiny@intel.com, fstests@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Jeff Moyer <jmoyer@redhat.com>, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH] common/rc: Fix _check_s_dax() for kernel 5.10
Message-ID: <20201202171416.GA4268@lst.de>
References: <20201202160701.1458658-1-ira.weiny@intel.com> <b131a2a6-f02f-9a91-4de1-01a77b76577a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b131a2a6-f02f-9a91-4de1-01a77b76577a@sandeen.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 02, 2020 at 11:10:50AM -0600, Eric Sandeen wrote:
> xfstests gets used on distro kernels too, so relying on kernel version isn't
> really something we can use to make determinations like this, unfortunately.
> 
> Probably the best we can do is hope that the change makes it to stable and
> distro kernels quickly, and the old flag fades into obscurity.
> 
> Maybe worth a comment in the test mentioning the SNAFU, though, for anyone
> investigating it when it fails on older kernels?

I think we should explicitly check for the "old" or mixed up flag and
error out.  Given that the other meaning of the bit value should only
be set on mount points it should be easy to test.  That means we will
reliably fail on old and distro kernels, but I think that is the right
thing to do in this case.
