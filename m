Return-Path: <SRS0=UWJz=XS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D43C04EBF
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 12:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B301920867
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 12:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730643AbfIWMZd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Sep 2019 08:25:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44252 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730431AbfIWMZd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Sep 2019 08:25:33 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E5723DFD7
        for <linux-xfs@vger.kernel.org>; Mon, 23 Sep 2019 12:25:32 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id a15so4815685wrq.4
        for <linux-xfs@vger.kernel.org>; Mon, 23 Sep 2019 05:25:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=+i/dMpcvB/XfHD7vTTr0uZmEBJcUa0xapswEEtc85DU=;
        b=CzTHpnF9KEibAtSbEj4t9kjMGBltMaQ5X/CKt3gDDrObBbZaq2M19wHKWrMZit6XAG
         VUa34nVuB9GgjbGXJdScz9m9H4ARpi5b2xx/gGvHIaOJ2yZdD165CJKBwM1SMZJjOPvx
         DnJICbMUUm4lcYbgt8FNQwQfBV2UvnsVWvWdePH7J4tdVUU/jF0/PCf/IUsP7/dYJaeQ
         a2nzP/4aeo+uwjOpBXv67vSlhsb0i5ifiUk29/X7GHGBWgpaHtIQk2MPcBf91fQkGhbu
         3lyzJEYagnCDcorVunMngWsl8qs5++KsmB8uI660xmrwkHhDlSMt+dBeHR4/Fzz744dU
         g1mg==
X-Gm-Message-State: APjAAAVKW3pKgQNu5nTxdDWgdbf+UDyhTNSq/vfDXdt2ANdlKov4IDyX
        1Rm87iscBBD0jmccfY95R1lyw+iCh+xcrwWcl9ZK8cB+SYYpJoyjnl99A551hmCInxAtjGWjmvu
        2LzJoCBJwSA/ImTZvJdde
X-Received: by 2002:a5d:4985:: with SMTP id r5mr11975377wrq.139.1569241531065;
        Mon, 23 Sep 2019 05:25:31 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxjfNpRuhbH4A325dDVanu1EiKYtf+b2vFsayiaxNETdcpHBjelg8uv12MHlUYH2QL8dmUJfQ==
X-Received: by 2002:a5d:4985:: with SMTP id r5mr11975364wrq.139.1569241530830;
        Mon, 23 Sep 2019 05:25:30 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id z6sm9534961wro.16.2019.09.23.05.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 05:25:30 -0700 (PDT)
Date:   Mon, 23 Sep 2019 14:25:28 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/2] xfs: cap longest free extent to maximum allocatable
Message-ID: <20190923122527.2a2epdm5dmg5ucdf@pegasus.maiolino.io>
Mail-Followup-To: Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
References: <20190918082453.25266-1-cmaiolino@redhat.com>
 <20190918082453.25266-2-cmaiolino@redhat.com>
 <20190918122726.GA29377@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918122726.GA29377@bfoster>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 08:27:26AM -0400, Brian Foster wrote:
> On Wed, Sep 18, 2019 at 10:24:52AM +0200, Carlos Maiolino wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Cap longest extent to the largest we can allocate based on limits
> > calculated at mount time. Dynamic state (such as finobt blocks)
> > can result in the longest free extent exceeding the size we can
> > allocate, and that results in failure to align full AG allocations
> > when the AG is empty.
> > 
> > Result:
> > 
> > xfs_io-4413  [003]   426.412459: xfs_alloc_vextent_loopfailed: dev 8:96 agno 0 agbno 32 minlen 243968 maxlen 244000 mod 0 prod 1 minleft 1 total 262148 alignment 32 minalignslop 0 len 0 type NEAR_BNO otype START_BNO wasdel 0 wasfromfl 0 resv 0 datatype 0x5 firstblock 0xffffffffffffffff
> > 
> > minlen and maxlen are now separated by the alignment size, and
> > allocation fails because args.total > free space in the AG.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> 
> Seems fine, but what about the bma.minlen alignment fix (in
> xfs_bmap_btalloc()) Dave suggested in the previous thread?

I forgot to git add that while playing with this set :P

> 
> Brian
> 
> >  fs/xfs/libxfs/xfs_alloc.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 372ad55631fc..35b39fc863a0 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -1989,7 +1989,8 @@ xfs_alloc_longest_free_extent(
> >  	 * reservations and AGFL rules in place, we can return this extent.
> >  	 */
> >  	if (pag->pagf_longest > delta)
> > -		return pag->pagf_longest - delta;
> > +		return min_t(xfs_extlen_t, pag->pag_mount->m_ag_max_usable,
> > +				pag->pagf_longest - delta);
> >  
> >  	/* Otherwise, let the caller try for 1 block if there's space. */
> >  	return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
> > -- 
> > 2.20.1
> > 

-- 
Carlos
