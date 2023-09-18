Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F154ACD37B4
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Sep 2023 01:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbjIRBho (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Sep 2023 21:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235866AbjIRBha (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2023 21:37:30 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DC911D
        for <linux-xfs@vger.kernel.org>; Sun, 17 Sep 2023 18:37:24 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-3adba522a5dso1307866b6e.2
        for <linux-xfs@vger.kernel.org>; Sun, 17 Sep 2023 18:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695001044; x=1695605844; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7LI9ymsdGiVZWdQwsQNvvvmEPAhraly9Hp7SHOly1W0=;
        b=trBzM+A43Jx8t1o/YyNVT0aLsI17Nu2xuaC0Pxwvfqhh6G1Ne1L597qMpggcDruMg8
         D3R355qAA+jYctt0s1gjjiDr9/MFmnx/EPtut9VlHz2Qzx6bk5uvIhWDR0r7GD1cluuH
         eqtyQ+wUk4ohV/UOgecpn1xEY1FLmYI9EUFUbQVe3TBM1X8LsjEsTKiOp3H+fSxJxux/
         XJYVswLqAX8NJB+MHFqoX+9hdsMGCKd/YbSdz6PKx0WCP7mY2aPp5q/S6Y7Pm2doKbcT
         m0dB5tqtewDt378VKYp5EdWG99xEAdO5bGLFwWuHd2GOZYNLnOS//WBoR5MBR9eqSIvQ
         QpUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695001044; x=1695605844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7LI9ymsdGiVZWdQwsQNvvvmEPAhraly9Hp7SHOly1W0=;
        b=NYVd9RzDoDYdKUfNAdNfxD1YhBL/hNntRF58aq0ssAIsk6dn0bktZrruDpztBy7/Wy
         aiBIjRs9PFsf4bvQvvXdL8NSULypZT5ZLno7rC2pB65fqiJJIW8o6uyoB27FyQuzXKMB
         13CVAusdIMuMtRZVq1tECzJ+KQFBOSAup2ouwoTacQL/0W+5u/9KHKSWXCsbpAuMYOml
         U+ABPUPu9qA6ldUrVZE7iXKhXA+KV9gM4gzwXb9DheBkzuriLCPvFW2VsvbL7aU9TV/x
         sVYHyD7m60q3lciavGc/X1NjGtcEHndzAJT5/amNtr3VMZqjvypBPjpPS5gQoNSw8j6p
         DymQ==
X-Gm-Message-State: AOJu0YyvBXbkTpPA1bkpVcN/savDFiJQRthE/MCgvwEz6QVxeBKKKTKl
        w0VrAVowoSwd6acmDEXSPSaYOczRT3qRvib2i1Q=
X-Google-Smtp-Source: AGHT+IH/SoY8oNCnJz38iT/mrKi7kfS17PiI2BMStlObz3JV6beguLPFkWY0zgMZ1znaCCL6hrWNcA==
X-Received: by 2002:a05:6870:5629:b0:1d5:c417:503e with SMTP id m41-20020a056870562900b001d5c417503emr9011635oao.57.1695001044193;
        Sun, 17 Sep 2023 18:37:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id ga9-20020a17090b038900b0026094c23d0asm6260301pjb.17.2023.09.17.18.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Sep 2023 18:37:23 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qi3CS-0029SM-1p;
        Mon, 18 Sep 2023 11:37:20 +1000
Date:   Mon, 18 Sep 2023 11:37:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: dentry UAF bugs crashing arm64 machines on 6.5/6.6?
Message-ID: <ZQep0OR0uMmR/wg3@dread.disaster.area>
References: <20230912173026.GA3389127@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912173026.GA3389127@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 10:30:26AM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> Shortly after 6.5 was tagged, I started seeing the following stacktraces
> when running xfs through fstests on arm64.  Curiously, x86_64 does not
> seem affected.
> 
> At first I thought this might be caused by the bug fixes in my
> development tree, so I started bisecting them.  Bisecting identified a
> particular patchset[1] that didn't seem like it was the culprit.  A
> couple of days later, one of my arm64 vms with that patch reverted
> crashed in the same way.  So, clearly not the culprit.

I would suggest that this is the same problem as being reported
here:

https://lore.kernel.org/linux-fsdevel/ZOWFtqA2om0w5Vmz@fedora/

due to some kind of screwup with hash_bl_lock() getting broken on
arm64 by commit 9257959a6e5b ("locking/atomic: scripts: restructure
fallback ifdeffery").

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
