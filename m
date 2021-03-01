Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFA5C43381
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3D7164DE4
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhCBGQD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 01:16:03 -0500
Received: from vera.ghen.be ([178.21.118.64]:35130 "EHLO vera.ghen.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236134AbhCAWmr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Mar 2021 17:42:47 -0500
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2021 17:42:46 EST
Received: by vera.ghen.be (Postfix, from userid 1000)
        id 4DqFP85fkhz2x9L; Mon,  1 Mar 2021 23:31:56 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hendrickx.be;
        s=21e; t=1614637916;
        bh=yHHo456mNi8vr6XHFtPESuNBZ8YVb/dZthD8FnAVfhY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=bg+w2jmLgHq+jG7bYnlXg78QWCZvHgm9MC2bOqzTuPkouH4eppkpygrhHQx+WSbiY
         7QkWBZmbc4N7jVYU9O+AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hendrickx.be; s=21r;
        t=1614637916; bh=yHHo456mNi8vr6XHFtPESuNBZ8YVb/dZthD8FnAVfhY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=frvhNQR4LC+IS7NCTksvp/01toES8JUPBMeHuW08W1KfATLlJqPRZgvx4Xceixjke
         fEqxmw6rPjlV1lCbqnc+tYFzFsuODTAwU7xiE60zUy73LDqu3P2k0EtB+7f5oDDEOl
         +ET7FZX1ev/xE5C287cdF78ESGUZjXCsNjhH/m42UCbY8/E6FwaDRoJ4nD/Z9s2B4Z
         1HgoJLJ7NL2wbBjAcrQv2Padu39LWijiLzKxzLA8LKHotkZZZeC+GKjhf5kpK0jRLU
         +lDy9KJd517cWtTKPbCoJGw9Zj3NcWlGqKh7adXjtNYhSZqJ3ZcFw+IxF0az/vAwCt
         29oNJkyqFmL6Q==
Date:   Mon, 1 Mar 2021 23:31:56 +0100
From:   Geert Hendrickx <geert@hendrickx.be>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs_admin -O feature upgrade feedback
Message-ID: <YD1rXB4m3jXWWT0E@vera.ghen.be>
References: <YDy+OmsVCkTfiMPp@vera.ghen.be>
 <20210301191803.GE7269@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301191803.GE7269@magnolia>
X-PGP-Key: https://geert.hendrickx.be/pgpkey.asc
X-PGP-Key-Id: C88C1D9ED3861005886BF44ACD718C1F95AD44EA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 01, 2021 at 11:18:03 -0800, Darrick J. Wong wrote:
> On Mon, Mar 01, 2021 at 11:13:14AM +0100, Geert Hendrickx wrote:
> > 1/ xfs_admin responds to every xfs_repair failure with the very generic
> > "Conversion failed, is the filesystem unmounted?"  This isn't very helpful
> > (and left me scratching my head in a number of scenarios), whereas calling
> > xfs_repair directly shows a relevant error message in all cases.  This
> > output should somehow be relayed through xfs_admin - without just dumping
> > the whole xfs_repair output which I know you wanted to avoid.  Maybe by
> > distinguishing more carefully between stderr and stdout?  (Currently, it
> > seems xfs_repair sends its errors to stdout and "normal output" to stderr,
> > and xfs_admin discards xfs_repair's stderr.)
> 
> That's a difficult project -- some of the things repair will complain
> about are a result of whatever the upgrade is (e.g. complaining about
> incorrect inode btree counters when you're in the process of enabling
> the counters) but then there are other things that it probably should
> not be dropping on the floor.



On the other hand, upgrading a filesystem is a one-time operation where
it doesn't hurt to be a bit more verbose by default, compared to regular
maintenance operations where silence indicates success.

(and for large filesystems some progress indication is useful, too.)


	Geert


