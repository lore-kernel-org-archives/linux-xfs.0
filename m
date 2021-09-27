Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 958D9C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 20:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77DF8611C2
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 20:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbhI0Uez (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 16:34:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235825AbhI0Uez (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Sep 2021 16:34:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34620611C0;
        Mon, 27 Sep 2021 20:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632774797;
        bh=buL/qb8RcZqlPo/8umuuBFD2b7KhLami86wxWWLj5hM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mhRTQsdaZ/MNwIocwALh97gYBOu6tqo47q6d3xPazQV8hGbeOkl+h6BhUiXcOcdzp
         tHfYCAjdVA5zoO4guI8AAbgypyu5hq3LoxMWFRgGZYsHeg4qDIyCHxwLjLNwRVvS3i
         FSr2O4xGzv8hhsa/qLnu0+5FQZg/S0+H6Js4OHvOjmLhhVCvAkR48L2zqP7DWHo85s
         yB/k04HQSh8xn+bZptqnVcARsBo3u8R8lXU+o7wzHNh9nrjMYago3sU8MtlLHq1o0+
         8Q1cCC53zrUsznCu22bMe82Nh8y8mnpq1VdGHjJEMxxoQCMUaXjoAMfxAtlaz1hXOH
         rKxXrPfMjJeFg==
Date:   Mon, 27 Sep 2021 13:33:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, david@fromorbit.com
Subject: Re: [PATCH V2 4/5] libxfs: add kernel-compatible completion API
Message-ID: <20210927203316.GV570615@magnolia>
References: <20210924140912.201481-1-chandan.babu@oracle.com>
 <20210924140912.201481-5-chandan.babu@oracle.com>
 <a268ae0e-01c4-c0cc-5144-adb9128d5d3a@sandeen.net>
 <8735pt2bkj.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735pt2bkj.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 25, 2021 at 03:59:00PM +0530, Chandan Babu R wrote:
> On 25 Sep 2021 at 04:32, Eric Sandeen wrote:
> > On 9/24/21 9:09 AM, Chandan Babu R wrote:
> >> From: Dave Chinner <dchinner@redhat.com>
> >> This is needed for the kernel buffer cache conversion to be able
> >> to wait on IO synchrnously. It is implemented with pthread mutexes
> >> and conditional variables.
> >> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> >
> > I am inclined to not merge patches 4 or 5 until there's something that
> > uses it. It can be merged and tested together with consumers, rather
> > than adding unused code at this point.  Thoughts?
> >
> 
> I think I will let Dave answer this question since I believe he most likely
> has a roadmap on when the consumers will land.

Technically speaking, one /could/ port xfs_scrub to use the kernel
completion API instead of calling pthread APIs directly, but I don't see
much gain from churning that.

--D

> -- 
> chandan
