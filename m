Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B92CC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 22:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjKIWFy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 17:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjKIWFy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 17:05:54 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F2F3ABF
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 14:05:52 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-5bd306f86a8so1140895a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Nov 2023 14:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1699567551; x=1700172351; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YYzy64d1NITtT78icmadImLgpfBYJU9cucbwTdDu3zE=;
        b=tM0yVDYO7Y+qXe6+kgkIzW4y8KluvVLudZp4aRCMuuLuDBYJ1av0432VoXL3Qt8G3C
         RMHDIpA3ljQfvJc8AERN9tZ/7kR6ORlJf1c+AHuGNPHwuB6qzsdCPe57KDnGFGo/FIxW
         eJ2Hq9ofcHlDAK8OLpTcgtcYsnjKeknIi6bZH5dU7nrzK5gj1D9NikvkRyEDuqSOwWxq
         k21ux7C+lOLVJSOArSFLo6f4uKTznrmHmNAWlU5Yu1Wr8+JokKDKh0ACQzL/3eR27IA6
         j4E+golEucHae292bcDnlxqKi6YBHRZZFiFu8QZJMeKbQcGgNafA4FbTA6A+kvvDmKMG
         znlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699567551; x=1700172351;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YYzy64d1NITtT78icmadImLgpfBYJU9cucbwTdDu3zE=;
        b=cByUf1VnGsoNA9Urwkv73U2FZZRvniKnIgdTpcopcE5Y788wLZ5FE4q9+eRETIheNS
         kz6/jbiWlbSMviIfaWmdsErzNXIIgZmHm1Mt7iRrMTziuYLgadm3AAjHwd8dBf29T1RN
         JCyPmNMBH/Llg8fCfsCspdHeNZixqdjlbUh4K2nOAf1rVTq38Ac6bdsG91KBklHc+BJm
         T6ahfVRvfv8KGFxajpMKqwqfEz550gQPaVzHLPFnJtrzOMGyBAo7ezaesY5hxVqWPlyn
         h4C+Dh6ursilXkOR16YcPiydERrtmxHaizw8tV3WXM+rGXFWxpIjse7m6iv40MH43KsZ
         h+Kg==
X-Gm-Message-State: AOJu0YxN753Kn17d3uVK1/tcK++KJYJPRenWmv1I7VflrB+9w62LgiW/
        MjHQKbeTzw/riqh5K7C53MSrPw==
X-Google-Smtp-Source: AGHT+IG5YvRraybhEJbqF6C3jRMHU08k2oZwK/+NKj8+VF4oFdeBKPKcLUhXfc64ztrBxed94etEJQ==
X-Received: by 2002:a05:6a20:440b:b0:185:aaf5:c034 with SMTP id ce11-20020a056a20440b00b00185aaf5c034mr304993pzb.60.1699567551628;
        Thu, 09 Nov 2023 14:05:51 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id v10-20020a62c30a000000b00692cb1224casm11665474pfg.183.2023.11.09.14.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Nov 2023 14:05:50 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1r1D9o-00AUQz-03;
        Fri, 10 Nov 2023 09:05:48 +1100
Date:   Fri, 10 Nov 2023 09:05:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chandan Babu R <chandanbabu@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        catherine.hoang@oracle.com, cheng.lin130@zte.com.cn,
        dchinner@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, osandov@fb.com
Subject: Re: [GIT PULL] xfs: new code for 6.7
Message-ID: <ZU1XvBwugPhhQ93S@dread.disaster.area>
References: <87fs1g1rac.fsf@debian-BULLSEYE-live-builder-AMD64>
 <CAHk-=wj3oM3d-Hw2vvxys3KCZ9De+gBN7Gxr2jf96OTisL9udw@mail.gmail.com>
 <20231108225200.GY1205143@frogsfrogsfrogs>
 <20231109045150.GB28458@lst.de>
 <20231109073945.GE1205143@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109073945.GE1205143@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2023 at 11:39:45PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 09, 2023 at 05:51:50AM +0100, Christoph Hellwig wrote:
> > On Wed, Nov 08, 2023 at 02:52:00PM -0800, Darrick J. Wong wrote:
> > > > Also, xfs people may obviously have other preferences for how to deal
> > > > with the whole "now using tv_sec in the VFS inode as a 64-bit sequence
> > > > number" thing, and maybe you prefer to then update my fix to this all.
> > > > But that horrid casts certainly wasn't the right way to do it.
> > > 
> > > Yeah, I can work on that for the rt modernization patchset.
> > 
> > As someone who has just written some new code stealing this trick I
> > actually have a todo list item to make this less horrible as the cast
> > upset my stomache.  But shame on me for not actually noticing that it
> > is buggy as well (which honestly should be the standard assumption for
> > casts like this).
> 
> Dave and I started looking at this too, and came up with: For rtgroups
> filesystems, what if rtpick simply rotored the rtgroups?  And what if we
> didn't bother persisting the rotor value, which would make this casting
> nightmare go away in the long run.  It's not like we persist the agi
> rotors.

I think we could replace it right now with an in-memory rotor like
the mp->m_agfrotor. It really does not need to be persistent; the
current sequence based algorithm devolves to sequential ascending
block order allocation targets once the sequence number gets large
enough.

Further, the (somewhat) deterministic extent distribution it is
trying to acheive (i.e. even distribution across the rt dev) is
really only acheivable in write-once workloads.  The moment we start
freeing space on the rtdev, the free space is no longer uniform and
does not match the pattern the sequence-based target iterates. Hence
the layout the search target attempts to create is unacheivable and
largely meaningless.

IOWs, we may as well just use an in-memory sequence number or a
random number to seed the allocation target; they will work just as
well as what we have right now without the need for persistent
sequence numbers.

Also, I think that not updating the persistent sequence number is
fine from a backwards compatibility perspective - older kernels will
just use it as it does now and newer kernels will just ignore it...

I say we just kill the whole sequence number in atime thing
completely....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
