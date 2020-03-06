Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A390C3F2C6
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 18:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B29F2073D
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 18:06:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ZKn4HsWX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCFSGV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 13:06:21 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39093 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgCFSGU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 13:06:20 -0500
Received: by mail-qt1-f194.google.com with SMTP id e13so2368615qts.6
        for <linux-xfs@vger.kernel.org>; Fri, 06 Mar 2020 10:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=R+D+YVFzBpab/a/oETyd8JOhX8+iIXuD/xsu7I7jDGU=;
        b=ZKn4HsWX/wihRX43168ygKelXIq7IyE6tQUrLFthMbVhuNo7Np6HDZi+yjviWK7i7o
         xe/EaRY5KIB7ZCsWyxufmuNZdirAQ/w5ARb1cz9E1dohLSB/1gUUV2zj7dHI5vKR925n
         UaTlj/KVOXAOuE/Kuk1LO572OHELhFxdgKtrGMWhnwU4kI1pNMTYeEY7Dm7yM7GnnVJF
         BW+BYMUjrZdcqOgN3TLdcIYtyPQWN0KkvSCalbphWlbjppqfNiYn/lKOaGZgHUZuO++8
         QCRACRYdjE3sYwA/XX/uDMTS1FJ5SicmD/+V2mjtfD6AwDv6yS9/TlfF5asP/D2rxV2o
         O6Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=R+D+YVFzBpab/a/oETyd8JOhX8+iIXuD/xsu7I7jDGU=;
        b=LyRBoj74O1ga+Xn28H5xd1X1SLXpVn1LU8ienYiFKbqCdrBBlRa+3vtdtEnefTUuKL
         O0IoWN/xZQiekvoJU0V+/4gBjPuMKfZVGLEuinqNxD+Dp0uIrAR7fWwQ7U68Yv8AVaiK
         Q7i7yb6+MSrUZvrMLMBwyiLomAu3vaFaCRnLdEcReOCnyQm3bWzf1rMCo3Y7YeOz5kMV
         5V5DBVFPG+ZIF/NXCBi1iYQwuaUyizbWLxQiFFBeXuWbMsnrwuqlP3YZDUT/AgfK/Mdi
         Pr88E83RuZCd5E8bi1Nf0w4BjMpJDqFEPXvQNeFYOL16CImW85pES0WFIJBVbgumCO0a
         e6tw==
X-Gm-Message-State: ANhLgQ0VAFhUUMCYFvmkYaZtkR8+vk//eWqZCttJgGum9sTXgAkr5inV
        947tBYEOCBVzBu5KAMVLfpfQ6g==
X-Google-Smtp-Source: ADFU+vtq9tuPue0e9HMIEhPhxGZdSyNFOdSSTFY4idpbWjNKVga+V85943xnitNqOUvFR/ZFt7kPFA==
X-Received: by 2002:ac8:130d:: with SMTP id e13mr2323731qtj.363.1583517979511;
        Fri, 06 Mar 2020 10:06:19 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id z4sm15670862qtm.69.2020.03.06.10.06.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 06 Mar 2020 10:06:18 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jAHMY-0006GF-E1; Fri, 06 Mar 2020 14:06:18 -0400
Date:   Fri, 6 Mar 2020 14:06:18 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Josef Bacik <josef@toxicpanda.com>,
        lsf-pc <lsf-pc@lists.linuxfoundation.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, bpf@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [LSFMMBPF TOPIC] Killing LSFMMBPF
Message-ID: <20200306180618.GN31668@ziepe.ca>
References: <b506a373-c127-b92e-9824-16e8267fc910@toxicpanda.com>
 <20200306160548.GB25710@bombadil.infradead.org>
 <1583516279.3653.71.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583516279.3653.71.camel@HansenPartnership.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 09:37:59AM -0800, James Bottomley wrote:
> On Fri, 2020-03-06 at 08:05 -0800, Matthew Wilcox wrote:
> [...]
> > 2. Charge attendees $300 for a 3-day conference.  This seems to be
> > the going rate (eg BSDCan, PGCon).  This allows the conference to be
> > self-funding without sponsors, and any sponsorship can go towards
> > evening events, food, travel bursaries, etc.
> 
> Can I just inject a dose of reality here:  The most costly thing is
> Venue rental (which comes with a F&B minimum) and the continuous Tea
> and Coffee.  Last year for Plumbers, the venue cost us $37k and the
> breaks $132k (including a lunch buffet, which was a requirement of the
> venue rental).  Given we had 500 attendees, that, alone is $340 per
> head already.  Now we could cut out the continuous tea and coffee ...
> and the espresso machines you all raved about last year cost us about
> $7 per shot.  But it's not just this, it's also AV (microphones and
> projectors) and recording, and fast internet access.  That all came to
> about $100k last year (or an extra $200 per head).  So you can see,
> running at the level Plumbers does you're already looking at $540 a
> head, which, co-incidentally is close to our attendee fee.  To get to
> $300 per head, you lot will have to give up something in addition to
> the espresso machines, what is it to be?

Yes, I can confirm this from another smaller hotel-style conference
I've been involved organizing on occasion. $600-$800 is required to
break even without major sponsorship $$ for the ~100 people mark, and
that is without the usual food and venue perks we see at
plumbers/lsfmm.

Jason
