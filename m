Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E36AC34056
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 17:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7762D24656
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 17:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582134905;
	bh=eVeQ/mTIkSZTE7t1rD7g6y/UcW49xwb+BPH50vx+jNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=xeXXIfaEQ+53O7vSwV8RrzuLUgSmrviT9Kq87U55Uvpk2+eFccCRaixaA57k8YNme
	 3l6KfsEw0w7kPsfLrM6D9ly94w1WNiJaHu95i0vj48ZpRpF4XVAHpIIaD+TATY3cqM
	 FYq8GAqwhbCXqGmHGIY0PzMVqDl6jRwDonCfIBr4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgBSRzF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 12:55:05 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38894 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbgBSRzF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 12:55:05 -0500
Received: by mail-pf1-f195.google.com with SMTP id x185so434421pfc.5
        for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2020 09:55:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ToVfXzPQ4+53N/H1N5Kb1eTGlGA3O9T78XIIDJ0rMPM=;
        b=Z7Yo9fF84rkxjRydfzeutDWG+FiBepZa4E2zjYi0JjgQzdQxSFfVuztpD/AITHP3aD
         PzAh7G0uyoaaE6A9F159V7Df2m1rrnFT4JnMmS0eCymw3SiyVjidBtOxf7VtlUeE8IPt
         TK++FB3qHgswVc/eO6RDE8E5u5Bm+b3ljGrw4zuN7n0eMr4NaeW+4hv0U7aNS+MasB81
         tT3tIJ8UcVJZQK7AO4sC7n9BB887IE81BII4MzsYHlMv3P2Ws1D/6s7ydD+YWUN7hpdm
         NfFSc7QEkjeGK1q9bcvDdru+f+vFseXvDLFVzhGg1WIWZATKYUIucj1HVSbwq1/zPZSf
         iZhQ==
X-Gm-Message-State: APjAAAV05xgxC53lbanK7zN/shEjdTRiCfrOlg4Tvdfo85wUjlXrhNFl
        CdnN/Tx2s5O3D9QhLP5SQE8=
X-Google-Smtp-Source: APXvYqz2B3TKN/XPPUoqQRqpNMf2U75LGTHwK0O5T9IqCTUEi9sPG1GE5wY9ChadhTk/WjTzvDcVVg==
X-Received: by 2002:a63:be09:: with SMTP id l9mr7183198pgf.439.1582134904218;
        Wed, 19 Feb 2020 09:55:04 -0800 (PST)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id t16sm322570pgo.80.2020.02.19.09.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 09:55:03 -0800 (PST)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 5B2FD402D7; Wed, 19 Feb 2020 17:55:02 +0000 (UTC)
Date:   Wed, 19 Feb 2020 17:55:02 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Richard Wareing <rwareing@fb.com>, linux-xfs@vger.kernel.org,
        Anthony Iliopoulos <ailiopoulos@suse.de>,
        Yong Sun <YoSun@suse.com>
Subject: Re: Modern uses of CONFIG_XFS_RT
Message-ID: <20200219175502.GS11244@42.do-not-panic.com>
References: <20200219135715.GZ30113@42.do-not-panic.com>
 <20200219143227.aavgzkbuazttpwky@andromeda>
 <20200219143824.GR11244@42.do-not-panic.com>
 <20200219170945.GN9506@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219170945.GN9506@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 09:09:45AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 19, 2020 at 02:38:24PM +0000, Luis Chamberlain wrote:
> > On Wed, Feb 19, 2020 at 03:32:27PM +0100, Carlos Maiolino wrote:
> > > On Wed, Feb 19, 2020 at 01:57:15PM +0000, Luis Chamberlain wrote:
> > > > I hear some folks still use CONFIG_XFS_RT, I was curious what was the
> > > > actual modern typical use case for it. I thought this was somewhat
> > > > realted to DAX use but upon a quick code inspection I see direct
> > > > realtionship.
> > > 
> > > Hm, not sure if there is any other use other than it's original purpose of
> > > reducing latency jitters. Also XFS_RT dates way back from the day DAX was even a
> > > thing. But anyway, I don't have much experience using XFS_RT by myself, and I
> > > probably raised more questions than answers to yours :P
> > 
> > What about another question, this would certainly drive the users out of
> > the corners: can we remove it upstream?
> 
> My DVR and TV still use it to record video data.

Is anyone productizing on that though?

I was curious since most distros are disabling CONFIG_XFS_RT so I was
curious who was actually testing this stuff or caring about it.

> I've also been pushing the realtime volume for persistent memory devices
> because you can guarantee that all the expensive pmem gets used for data
> storage, that the extents will always be perfectly aligned to large page
> sizes, and that fs metadata will never defeat that alignment guarantee.

For those that *are* using XFS in production with realtime volume with dax...
I wonder whatcha doing about all these tests on fstests which we don't
have a proper way to know if the test succeeded / failed [0] when an
external logdev is used, this then applies to regular external log dev
users as well [1].

Which makes me also wonder then, what are the typical big users of the
regular external log device?

Reviewing a way to address this on fstests has been on my TODO for
a while, but it begs the question of how much do we really care first.
And that's what I was really trying to figure out.

Can / should we phase out external logdev / realtime dev? Who really is
caring about this code these days?

[0] https://github.com/mcgrof/oscheck/blob/master/expunges/linux-next-xfs/xfs/unassigned/xfs_realtimedev.txt
[1] https://github.com/mcgrof/oscheck/blob/master/expunges/linux-next-xfs/xfs/unassigned/xfs_logdev.txt

  Luis
