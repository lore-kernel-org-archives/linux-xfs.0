Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E80F8C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3E4B206BE
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593088960;
	bh=QTKVIlJyYkq9x8igprDkk4WuBfCk37WJUWpBu7U0Lv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=qb5xSt5Qatu6PEDVL9fG1iwQLnXah1s9eD7lIdy8Uy8v9zPxOI89g2oxyNiTFCsWr
	 mNFeVrbKyeL/3B2ZBj2EnFhiFfiN+lSFDXdUGXZHgwmzWJymDVLXehmX3bXTFTLsMc
	 5E+V9wN1SCvOX1/ijf/ysG/u4w/uMTSykSTf9ncQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404518AbgFYMmj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 08:42:39 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36587 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404765AbgFYMmi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 08:42:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id 17so5783986wmo.1;
        Thu, 25 Jun 2020 05:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zqYYU+XzLTo4RZ3+vh2KfRtchjL+OjYySOUllgC9oo8=;
        b=LzksH/QjS06oxtxtx5uT+9yAfGlHdc/hEVx539NjsuFbdjtaIhhKIeEXkL8BvwyDiu
         S3JGcqI5iFYUxK/kDBstsrXSSk0h8ApAmSnbV8bp/P1wJD0we7OTMeVR29fam6gl8DTA
         1VkUyBjkb1Xlh1sOnZcbIpqiDpBu3yyzPm+jIfU6C/NKnSLlrSthKltC9Toztn/GM3Qs
         N7Tl3Z5gKbxriRKVdMajbvgrNDs0Up/Un9LYQHWqvsNqekUEbqY7LxefmiKV5/iovvsz
         JOcTwzP98Z3dsnckKzLeer7zsI5/5h3UwILjQIkwmu7DrSM3g0J9fjNs+QTeb6xxt0N6
         +JhQ==
X-Gm-Message-State: AOAM5318DXRU55DawIgJJWlF4Y7ysqYB215iqa92uSUAJrGvFwLKRLWw
        0nM8octfpneLYS6nqSomxlxGh19q
X-Google-Smtp-Source: ABdhPJwrxoXQ+HCO1VVYYUvEmwFEOPYklBv2D67vfvs9fNB1wlADT0sE5tlgxNrUNZ128ZofveX60g==
X-Received: by 2002:a1c:80c8:: with SMTP id b191mr3021699wmd.37.1593088956395;
        Thu, 25 Jun 2020 05:42:36 -0700 (PDT)
Received: from localhost (ip-37-188-168-3.eurotel.cz. [37.188.168.3])
        by smtp.gmail.com with ESMTPSA id t5sm11739610wmj.37.2020.06.25.05.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 05:42:35 -0700 (PDT)
Date:   Thu, 25 Jun 2020 14:42:34 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/6] mm: Replace PF_MEMALLOC_NOIO with memalloc_noio
Message-ID: <20200625124234.GM1320@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-2-willy@infradead.org>
 <20200625122239.GJ1320@dhcp22.suse.cz>
 <20200625123418.GB7703@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625123418.GB7703@casper.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 25-06-20 13:34:18, Matthew Wilcox wrote:
> On Thu, Jun 25, 2020 at 02:22:39PM +0200, Michal Hocko wrote:
> > On Thu 25-06-20 12:31:17, Matthew Wilcox wrote:
> > > We're short on PF_* flags, so make memalloc_noio its own bit where we
> > > have plenty of space.
> > 
> > I do not mind moving that outside of the PF_* space. Unless I
> > misremember all flags in this space were intented to be set only on the
> > current which rules out any RMW races and therefore they can be
> > lockless. I am not sure this holds for the bitfield you are adding this
> > to. At least in_memstall seem to be set on external task as well. But
> > this would require double checking. Maybe that is not really intended or
> > just a bug.
> 
> I was going from the comment:
> 
>         /* Unserialized, strictly 'current' */
> (which you can't see from the context of the diff, but is above the block)
> 
> The situation with ->flags is a little more ambiguous:
> 
> /*
>  * Only the _current_ task can read/write to tsk->flags, but other
>  * tasks can access tsk->flags in readonly mode for example
>  * with tsk_used_math (like during threaded core dumping).
>  * There is however an exception to this rule during ptrace
>  * or during fork: the ptracer task is allowed to write to the
>  * child->flags of its traced child (same goes for fork, the parent
>  * can write to the child->flags), because we're guaranteed the
>  * child is not running and in turn not changing child->flags
>  * at the same time the parent does it.
>  */

OK, I have obviously missed that.

> but it wasn't unsafe to use the PF_ flags in the way that you were.
> It's just crowded.
> 
> If in_memstall is set on other tasks, then it should be moved to the
> PFA flags, which there are plenty of.
> 
> But a quick grep shows it only being read on other tasks and always
> set on current:
> 
> kernel/sched/psi.c:     *flags = current->in_memstall;
> kernel/sched/psi.c:      * in_memstall setting & accounting needs to be atomic wrt
> kernel/sched/psi.c:     current->in_memstall = 1;
> kernel/sched/psi.c:      * in_memstall clearing & accounting needs to be atomic wrt
> kernel/sched/psi.c:     current->in_memstall = 0;
> kernel/sched/psi.c:     if (task->in_memstall)

Have a look at cgroup_move_task. So I believe this is something to be
fixed but independent on your change.

Feel free to add
Acked-by: Michal Hocko <mhocko@suse.com>

> kernel/sched/stats.h:           if (p->in_memstall)
> kernel/sched/stats.h:           if (p->in_memstall)
> kernel/sched/stats.h:   if (unlikely(p->in_iowait || p->in_memstall)) {
> kernel/sched/stats.h:           if (p->in_memstall)
> kernel/sched/stats.h:   if (unlikely(rq->curr->in_memstall))
> 
> so I think everything is fine.

-- 
Michal Hocko
SUSE Labs
