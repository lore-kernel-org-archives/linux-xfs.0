Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8CEC7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 00:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjFFA7l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 20:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjFFA7j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 20:59:39 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D52103
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 17:59:38 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-654f8b56807so2844943b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 05 Jun 2023 17:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686013178; x=1688605178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z94cWk++FVTGgTIt5xudaBs/LJn+eiynth+R7asUFbI=;
        b=ukOmLoaWkFTm9BNy9uU9at1dAVDhNgsWBUFjEKeUjzvWbkT2vOj4A+v03oWUffxBQw
         cLscJwfXN38xksRSZLFvALQ+mjH8Cqn3dIiouK85TirWC5ebvaLva9dHSdwKvDXWwd5X
         LDXk4k8Z7Bof//ycU8gB0iJ77e/8oeBazOx7uYjYUgEO9UeHia9E5RZka8TkqQOnH5AG
         XEo2pEi4Upt9h54SYGxNofHTujl+st7Yn4EeorY1pHkI91H+AtpWuN64jLt6lHoM1ka1
         PuUz2/aaGidiFgmfhYXQJ5OInGj4py/jHaozuXzxa8ti9f/o9Rs32LRSxIHVqpntVrFQ
         6pVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686013178; x=1688605178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z94cWk++FVTGgTIt5xudaBs/LJn+eiynth+R7asUFbI=;
        b=SJ8x6A2FlFO6ZmuylkYPoiYgSQ4RnulyLnAbDcdioOcC9YDXA2ozfEoOLT+zcWJ9+1
         C0qGf4B4Ojqatr4F3TZ7p6dzj+QhKcbICokxHJIoOq3dPxyu1XXxXgGVqiOrYZz1ZcDP
         1Q3YnX/9dIjpkLa+cn713W8vYUhuVyUpgB7WrfTFWYxusQf2PG18I7S0/3143Z+OYpo+
         AqNN60t6ASbPq5PiWC8zRGtoaok13JPuU/HOt5e3pRM3qGMMdZ/uBkhawGLiv+uRx/Ec
         jXIeUVk83zHfoKrB9hJJCVt/Oki5leb3FXfCGQtkfLlqd363rWL7XMiKvAwGWCP8MiGz
         1F4g==
X-Gm-Message-State: AC+VfDyF5YwCy95FuO/XSxz+H2yJxc9fa33+z36614e/UU8z/5JWTLMc
        0GpQARZOYCKb29bPlWwzrY61og==
X-Google-Smtp-Source: ACHHUZ77T/D9Yy9OPawYkW0rSTecC9MeStnA9ABhnsuHJ6NuXkqUa5ft1A6Yj5lxY8dm0gpvheYUSA==
X-Received: by 2002:a05:6a20:4295:b0:d5:73ad:87c2 with SMTP id o21-20020a056a20429500b000d573ad87c2mr799823pzj.56.1686013178266;
        Mon, 05 Jun 2023 17:59:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id r9-20020a632b09000000b0052c9d1533b6sm6357199pgr.56.2023.06.05.17.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 17:59:37 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q6L2t-008If8-05;
        Tue, 06 Jun 2023 10:59:35 +1000
Date:   Tue, 6 Jun 2023 10:59:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfs: for-next rebased to d4d12c02bf5f
Message-ID: <ZH6E9+5uZNbnc4G3@dread.disaster.area>
References: <ZH1tiD4z4/revqp3@dread.disaster.area>
 <20230606000951.GK1325469@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606000951.GK1325469@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 05:09:51PM -0700, Darrick J. Wong wrote:
> On Mon, Jun 05, 2023 at 03:07:20PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > I just rebased the for-next tree to correct a bad fixes tag in
> > the tree that was flags by a linux-next sanity check. The code is
> > the same, just a commit message needed rewriting, but that means all
> > the commit change and you'll need to do forced update if you pulled
> > the branch I pushed a few hours ago.
> > 
> > -Dave.
> > 
> > ----------------------------------------------------------------
> > 
> >   git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
> > 
> >   Head Commit: d4d12c02bf5f768f1b423c7ae2909c5afdfe0d5f
> > 
> >   xfs: collect errors from inodegc for unlinked inode recovery (2023-06-05 14:48:15 +1000)
> > 
> > ----------------------------------------------------------------
> > Darrick J. Wong (1):
> >       xfs: fix broken logic when detecting mergeable bmap records
> > 
> > Dave Chinner (9):
> >       xfs: buffer pins need to hold a buffer reference
> >       xfs: restore allocation trylock iteration
> >       xfs: defered work could create precommits
> >       xfs: fix AGF vs inode cluster buffer deadlock
> >       xfs: fix double xfs_perag_rele() in xfs_filestream_pick_ag()
> >       xfs: fix agf/agfl verification on v4 filesystems
> >       xfs: validity check agbnos on the AGFL
> >       xfs: validate block number being freed before adding to xefi
> >       xfs: collect errors from inodegc for unlinked inode recovery
> > 
> > Geert Uytterhoeven (1):
> >       xfs: Fix undefined behavior of shift into sign bit
> 
> Hmm, I don't see "xfs: fix ag count overflow during growfs" in here.

No, I didn't pick it up because it conflicted with other bug fix
stuff I am currently working on and I needed to look at it in more
detail before doing anything with it. I hadn't followed the
development of the patch at all, and it was up to v4 so I was going
to need to spend a little bit of time on it to see what the history
of it was first....

> Dave, do you want to do another 6.4 bug release, or throw things back
> over the wall so I can merge all the rest of the pending fixes for 6.5?

If you want, you can pick it up once I've sent a pull request for
the current set of fixes in for-next. That will be later this week;
it needs to spend a couple of days in linux-next before that
happens, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
