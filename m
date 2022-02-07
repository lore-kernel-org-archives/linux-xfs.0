Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068F0C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Feb 2022 17:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiBGRVo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Feb 2022 12:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383791AbiBGRJP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Feb 2022 12:09:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13671C0401D5
        for <linux-xfs@vger.kernel.org>; Mon,  7 Feb 2022 09:09:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2D8D61149
        for <linux-xfs@vger.kernel.org>; Mon,  7 Feb 2022 17:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE264C004E1;
        Mon,  7 Feb 2022 17:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644253754;
        bh=/M02WtFHI48LJZ3Gpe8Tp7B8zEi8z/oa3rDkSj6UnLY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dRDu/drPnHFo+eylP8O+Qjz6SB4RYwTutn08oLk+1nhbdiUF7yg4t08wC7JwDYWtr
         kRo39bPu5zfYzcqQrYmbIgT+Jvhx1T8oCqcuV/TIcoDjjWsrKSJX4BtOUBXITMrI4q
         LZFFfk52ozhPBT5s5DIPetkvVER75KzgS+uSIp2IEarn0mEwOcFO0R9V07fdgN9X34
         gHQoN+Foh4a+wyvRwJPlX9mUGilCE0jTWNK+UBupR9+bw8i1M3/HGjgSkpHMywUMuB
         vpR8UwcOeKYsgLrNq14F/ElUMngzSxsNcH2J47r4ATB9a49sbte4S2bhhCa8feTzCA
         qdStnDX1ASCiQ==
Date:   Mon, 7 Feb 2022 09:09:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 04/17] libfrog: move the GETFSMAP definitions into libfrog
Message-ID: <20220207170913.GA8313@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263811682.863810.12064586264139896800.stgit@magnolia>
 <bb88560e-bbdf-80c5-b4d6-6c00f4ab3ef1@sandeen.net>
 <20220205003618.GU8313@magnolia>
 <20220207010541.GE59729@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207010541.GE59729@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 07, 2022 at 12:05:41PM +1100, Dave Chinner wrote:
> On Fri, Feb 04, 2022 at 04:36:18PM -0800, Darrick J. Wong wrote:
> > On Fri, Feb 04, 2022 at 05:18:12PM -0600, Eric Sandeen wrote:
> > > On 1/19/22 6:21 PM, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Move our private copy of the GETFSMAP definition into a libfrog header
> > > > file that (preferentially) uses the system header files.  We have no
> > > > business shipping kernel headers in the xfslibs package, but this shim
> > > > is still needed to build fully functional xfsprogs on old userspace.
> > > 
> > > Hm. Fine, but I wonder if we can get a bit more intentional about how
> > > we handle this kind of thing, I understand why we copy this stuff into
> > > xfsprogs early, but then we never know how to get rid of it.
> > > 
> > > Do we /need/ to build fully functional xfsprogs on old userspace?
> > > (really: systems with old kernel headers?)  How far back do we go,
> > > I wonder?  Anyway...
> > 
> > TBH we could probably get rid of these entirely, assuming nobody is
> > building xfsprogs with old kernel headers for a system with a newer
> > kernel?
> 
> Just fiddle the autoconf rules to refuse to build if the system
> headers we need aren't present. It just means that build systems
> need to have the userspace they intend to target installed in the
> build environment.

GETFSMAP premiered in 4.12, so I'm going to take this response (and the
lack of any others) as a sign that I can respin this patch to require
recent kernel headers instead of providing our own copy.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
