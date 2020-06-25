Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5811AC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 20:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34D57207D8
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 20:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593117377;
	bh=xHAULP2sx5bSgv96jgAd64VBhDEHqS29bD6Eq8nUFAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=UywOi6/4wnd0tn8kqb42ub5ASgTpSobcknSzlpvK2XQIska4dXChjgMeQHlIOFCsN
	 KuVe8+/t8iZxXDuCMRhrHnCVJTEBsDBi/JvItFJf5I6bCWwzCLeNaH07WaJM0amGN5
	 uQKKxDoOQlFcrLLNzhEwIs484PBJ80xCsE0Qjl3I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405072AbgFYUgQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 16:36:16 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:37160 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404952AbgFYUgQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 16:36:16 -0400
Received: by mail-ej1-f66.google.com with SMTP id mb16so7275884ejb.4;
        Thu, 25 Jun 2020 13:36:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rO9wobKDdJfB6GpyJylYAIJ+kYKUiyATVCtaBeDI+fw=;
        b=uOcxQeelA24/Lg0nZPPuLL/Vwiu4S7nffOhYaeTfohI2o7tubip6D9C0qov+2esBO3
         XC1/Ht/PduI+y6XOc/sx1zswM093dryH2hqLkl610Mbo2pJ7ejvga5CMmpWcsuOpWiy5
         Rl1GAA3w8bpUKbnD+/e6sY+qRg1AfsYrYxHfRj0mbhfgSiadnryFU4T7hvpE+QB7Sav9
         Ist8iBCjuQX8isRIBQ11cbqATUgiXZMaN6hRIyZPcTNP0kMUWb2Nu2TLL3I5B3O+VTrV
         Rfzcr+V2tvwOXzC7LGRSsa7cxM5VmA61vw3ODM2Q7ZR4BNg5LdzZcxPfXsmWJigMg0io
         J/zA==
X-Gm-Message-State: AOAM530xckj2lFofpjmL3fM7Gy/+N6MVVb3VhYbA+/ZLSMGX8D8xt4lJ
        VLN/CniEQOnnVZXBAzhaHpI=
X-Google-Smtp-Source: ABdhPJzfhS7g3k5+vRs6JczdAsbHFNdSSLshuu/AhvsQ7cPrZgwO71TfhCq9ltNkBnPaHiW49BYdog==
X-Received: by 2002:a17:906:4f87:: with SMTP id o7mr30542289eju.233.1593117374457;
        Thu, 25 Jun 2020 13:36:14 -0700 (PDT)
Received: from localhost (ip-37-188-168-3.eurotel.cz. [37.188.168.3])
        by smtp.gmail.com with ESMTPSA id bs18sm3790352edb.38.2020.06.25.13.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 13:36:13 -0700 (PDT)
Date:   Thu, 25 Jun 2020 22:36:11 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
        Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH 0/6] Overhaul memalloc_no*
Message-ID: <20200625203611.GS1320@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625184832.GP7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625184832.GP7606@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 25-06-20 11:48:32, Darrick J. Wong wrote:
> On Thu, Jun 25, 2020 at 12:31:16PM +0100, Matthew Wilcox (Oracle) wrote:
> > I want a memalloc_nowait like we have memalloc_noio and memalloc_nofs
> > for an upcoming patch series, and Jens also wants it for non-blocking
> > io_uring.  It turns out we already have dm-bufio which could benefit
> > from memalloc_nowait, so it may as well go into the tree now.
> > 
> > The biggest problem is that we're basically out of PF_ flags, so we need
> > to find somewhere else to store the PF_MEMALLOC_NOWAIT flag.  It turns
> > out the PF_ flags are really supposed to be used for flags which are
> > accessed from other tasks, and the MEMALLOC flags are only going to
> > be used by this task.  So shuffling everything around frees up some PF
> > flags and generally makes the world a better place.
> 
> So, uh, how does this intersect with the patch "xfs: reintroduce
> PF_FSTRANS for transaction reservation recursion protection" that
> re-adds PF_TRANS because uh I guess we lost some subtlety or another at
> some point?

This is independent, really. It just relocates the NOFS flag. PF_TRANS
is reintroduced for a different reason. When I have replaced the
original PF_TRANS by PF_MEMALLOC_NOFS I didn't realized that xfs doesn't
need only the NOFS semantic but also the transaction tracking so this
cannot be a single bit only. So it has to be added back. But
PF_MEMALLOC_NOFS needs to stay for the scoped NOFS semantic.

Hope this clarifies it a bit.
-- 
Michal Hocko
SUSE Labs
