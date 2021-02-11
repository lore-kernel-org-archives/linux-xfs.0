Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3AB7C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 01:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F92164DAE
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 01:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhBKBa7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 20:30:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229745AbhBKBa7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Feb 2021 20:30:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C44B564EC9;
        Thu, 11 Feb 2021 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613007018;
        bh=xoV3cBZWeb9t5cwuiKsu77GD/GGNNChUf8ef+6fC0v8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oyzF9P6LHwbiQfC9f50KdkTYyl0rkji2A9NVTIAtwY6mh+78MpxvlMKp8e3Qtefyc
         NFuH/FFfS1kfx3sCv8kw7JeLuLJRtRw4TMHX0nk5gf5TKS4tGAePa/f1QAgnhfsa7V
         Gx5u0NumKilVwPcY4fjVMSr3gtsdFJuBnvRAFDy7O5Z67ZCG2QRvKlBMI52ZhYED5Y
         94DvBU7abTwrprDC2blfadXfz0gUDZy0k9S4YRsoHKXN56oaIq8ElW999HjDhgystt
         1DqRZ3xyVjJv2BGVsmBYvUc3fY4yqKjx5u08Mlyv3I6pNg2S2/c86Ap2JI9SxquyQu
         6QtLZC8gG5Usg==
Date:   Wed, 10 Feb 2021 17:30:17 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs_repair: add a testing hook for NEEDSREPAIR
Message-ID: <20210211013017.GB7193@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284385516.3057868.355176047687079022.stgit@magnolia>
 <20210209172131.GG14273@bfoster>
 <20210209181738.GU7193@magnolia>
 <20210209185939.GK14273@bfoster>
 <20210209195920.GZ7193@magnolia>
 <acfe3b90-9364-85d5-84e7-7a1b888bae9e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acfe3b90-9364-85d5-84e7-7a1b888bae9e@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 10, 2021 at 03:41:52PM -0600, Eric Sandeen wrote:
> On 2/9/21 1:59 PM, Darrick J. Wong wrote:
> >> # ./repair/xfs_repair -c needsrepair=1 /dev/test/scratch 
> >> Phase 1 - find and verify superblock...
> >> Marking filesystem in need of repair.
> >> writing modified primary superblock
> >> Phase 2 - using internal log
> >>         - zero log...
> >> ERROR: The filesystem has valuable metadata changes in a log which needs to
> >> ...
> >> # mount /dev/test/scratch /mnt/
> >> mount: /mnt: wrong fs type, bad option, bad superblock on /dev/mapper/test-scratch, missing codepage or helper program, or other error.
> >> #
> >>
> >> It looks like we can set a feature upgrade bit on the superblock before
> >> we've examined the log and potentially discovered that it's dirty (phase
> >> 2). If the log is recoverable, that puts the user in a bit of a bind..
> > Heh, funny that I was thinking that the upgrades shouldn't really be
> > happening in phase 1 anyway--
> > 
> > I've (separately) started working on a patch to make it so that you can
> > add reflink and finobt to a filesystem.  Those upgrades require somewhat
> > more intensive checks of the filesystem (such as checking free space in
> > each AG), so I ended up dumping them into phase 2, since the xfs_mount
> > and buffer cache aren't fully initialized until after phase 1.
> > 
> > So, yeah, the upgrade code should move to phase2() after log zeroing and
> > before the AG scan.
> 
> Oh, whoops - 
> 
> based on this, I think that the prior patch
> [PATCH 08/10] xfs_repair: allow setting the needsrepair flag
> needs to be adjusted as well, right; we don't want to set it in phase 1
> or we might set it then abort on a dirty log and the user is stuck.
> 
> So maybe I should merge up through 
> 
> [PATCH 07/10] xfs_repair: set NEEDSREPAIR when we deliberately corrupt directories
> 
> and hold off on the rest? Or should I just hold off on the series and let
> you reassemble (again?)

Yeah, I'll push out v5 tomorrow morning with all this cleaned up.

--D

> (Am I right that the upgrade bits will need to be moved and the series resent?)
> 
> -Eric
