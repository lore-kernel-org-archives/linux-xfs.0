Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A73ECAAD4
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Aug 2022 09:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiHaJnz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Aug 2022 05:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiHaJnr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Aug 2022 05:43:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97312CD78D
        for <linux-xfs@vger.kernel.org>; Wed, 31 Aug 2022 02:43:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EFAD61AA9
        for <linux-xfs@vger.kernel.org>; Wed, 31 Aug 2022 09:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F0DC433C1;
        Wed, 31 Aug 2022 09:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661939021;
        bh=rt7pURXg9ZNedHDemLpcv6iXZ9TkcN5w4FuO4zZwxK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X16swWlH++XwlXxbM5OP7X1uGpFL0IhGjGTUgwHciuK2is5hbA5uMh+k/gTpgv4RA
         XrZ8Y2Z31PX3zNdd8UdK1cH2evtucPtGMwu8DyHNJ2AMvVaoWBHP2xTr5HjdKIvp2X
         VK5W2/xk4hLtho6ycIQQp1PMmlXKu7d+/zmMuc2iYhD8bvaqNaeWDEIQtGf7HexJ72
         mQms/rp2ChNbyuBA1wJtMwpJX0uib69x7EOf+TM8sLyd4ubPRuoKdgUIMamPsgpYCh
         nzoMmVkziC6rOfSiRjQjOga3mJfI2Lihnt53Ryw1lEk88RmvSDRoelpBkzEBzJYHrF
         44W9hGMa27jHA==
Date:   Wed, 31 Aug 2022 11:43:25 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs for-next updated
Message-ID: <20220831094325.5dwjygbcd5mcibok@andromeda>
References: <20220830115220.5s2nlztp56fbf4xa@andromeda>
 <rlkM2eJNcyQy7rV6YFRttkV5Yq3MmPS6qjlDjTNpzPw-H5ShdMRTb6j_nnN1KmJ4nObvtiv45xwd1cm7No9Nyg==@protonmail.internalid>
 <Yw4o0fBFRqrCHQsY@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yw4o0fBFRqrCHQsY@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 30, 2022 at 08:12:17AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 30, 2022 at 01:52:20PM +0200, Carlos Maiolino wrote:
> > Hi folks,
> >
> > The for-next branch of the xfsprogs repository at:
> >
> >         git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> >
> > has just been updated.
> >
> > This update contains the initial libxfs sync to Linux 6.0 and should be turned
> > into -rc0 once it (hopefully) gets some testing (and no complains) for more people.
> 
> Wooo, welcome, new maintainer! :)

\o/

> 
> > Please, if any questions, let me know.
> 
> For the repair deadlock fix[1], do you want me to pin the primary
> superblock buffer to the xfs_mount like Dave suggested in [2]?

I'd rather have it pinned to the xfs_mount as it's often accessed, do you think
it is doable (you mentioned you've ran into many problems with that)?
I didn't have time to try to reproduce those deadlocks yet though.

> 
> [1] https://lore.kernel.org/linux-xfs/166007921743.3294543.7334567013352169774.stgit@magnolia/
> [2] https://lore.kernel.org/linux-xfs/20220811221541.GQ3600936@dread.disaster.area/

-- 
Carlos Maiolino
