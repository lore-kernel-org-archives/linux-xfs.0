Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D455C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 23:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEB9A619CB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 23:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhC3XDQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 19:03:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21484 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232793AbhC3XCo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 19:02:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617145363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k4jI6dEQ5nml1gZN7Uo8vP4ETrnz6ic9u1E3e02IAms=;
        b=ZfvnEVceCap6ZWnjYScdV/TCigBBjzCC0OzH1s4ag6E7Ym4sdwqAQ+WMPKy2yJHJJpD0hR
        YKc1qldIwzIygRFQIQWU9JavG94MB/RlVwAExUMnq2lOV5n3RYSP1MV9QWRcgZfUyHtMTn
        HlElHweku141bTcMqWwJ+48BXxbRfZM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-2pDtCc4kOuy7kCWbHj5a7Q-1; Tue, 30 Mar 2021 19:02:41 -0400
X-MC-Unique: 2pDtCc4kOuy7kCWbHj5a7Q-1
Received: by mail-pl1-f200.google.com with SMTP id y19so120931pll.8
        for <linux-xfs@vger.kernel.org>; Tue, 30 Mar 2021 16:02:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=k4jI6dEQ5nml1gZN7Uo8vP4ETrnz6ic9u1E3e02IAms=;
        b=eO696LL4inRuUIr+driLwKnz1IuyXoM+VMDPWG8/sDZ+/lTp42Tls1sulQ5B1A1VvT
         cYn+WyP+xv/LDWX1nfpdz+7Thx6Eg2c4Uj089fLKYJ2hXH8AMFx0t2dmFvCNRfAMo5KX
         O2mVZiLsXTHI3jspQmVUjXGsoXhVYImqcP15N1S7+fKQlazQoWGPOjwGRkn0YV0htZGY
         DyEg9HUHxYjsGoL+ZUuxaRFcnAwAWn/C+5wNji7AXjVBmItpMUWJ00yzFrcl1IsfWBDv
         rLpL7/wCtKeI3DqVA29xwttvExVQfFRjM2B2vUS9dFCTHd25zwklYZUar6tSNAOejlXz
         HEhw==
X-Gm-Message-State: AOAM5301RTU5KeNEWaXDtBQlmcvllBfWLXCdFS7G+dIrJ/gGFGI0FvXA
        6kXoW4aEoR6mU33h/5DZqaYl1N12RDnRzmZ6XebyolIR8y//hdJ2F/c2mgTzeMFQNkuiZ/XZX4g
        RN0/PtZPeX1ULP1LN0LVc
X-Received: by 2002:a17:902:b10a:b029:e7:137c:307a with SMTP id q10-20020a170902b10ab02900e7137c307amr538463plr.71.1617145360400;
        Tue, 30 Mar 2021 16:02:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYN3B59y7+wzTKLDLpcRTzfd2EMxmSU+cAu6DFlB1+k8VSiI6rG4QIQdKdqFH6JAuUYMir0A==
X-Received: by 2002:a17:902:b10a:b029:e7:137c:307a with SMTP id q10-20020a170902b10ab02900e7137c307amr538435plr.71.1617145360101;
        Tue, 30 Mar 2021 16:02:40 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d14sm167343pji.22.2021.03.30.16.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 16:02:39 -0700 (PDT)
Date:   Wed, 31 Mar 2021 07:02:29 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Gao Xiang <hsiangkao@aol.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/8] repair: turn bad inode list into array
Message-ID: <20210330230229.GB3589611@xiangao.remote.csb>
References: <20210330142531.19809-1-hsiangkao@aol.com>
 <20210330142531.19809-2-hsiangkao@aol.com>
 <20210330221858.GV63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210330221858.GV63242@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 31, 2021 at 09:18:58AM +1100, Dave Chinner wrote:
> On Tue, Mar 30, 2021 at 10:25:24PM +0800, Gao Xiang wrote:
> > From: Gao Xiang <hsiangkao@redhat.com>
> > 
> > Just use array and reallocate one-by-one here (not sure if bulk
> > allocation is more effective or not.)
> 
> Did you profile repairing a filesystem with lots of broken
> directories? Optimisations like this really need to be profile
> guided and the impact docuemnted. That way reviewers can actually
> see the benefit the change brings to the table....

Nope, will do then (since I'm not confident with the target
performance tbh.)

> 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  repair/dir2.c | 34 +++++++++++++++++-----------------
> >  repair/dir2.h |  2 +-
> >  2 files changed, 18 insertions(+), 18 deletions(-)
> > 
> > diff --git a/repair/dir2.c b/repair/dir2.c
> > index eabdb4f2d497..b6a8a5c40ae4 100644
> > --- a/repair/dir2.c
> > +++ b/repair/dir2.c
> > @@ -20,40 +20,40 @@
> >   * Known bad inode list.  These are seen when the leaf and node
> >   * block linkages are incorrect.
> >   */
> > -typedef struct dir2_bad {
> > -	xfs_ino_t	ino;
> > -	struct dir2_bad	*next;
> > -} dir2_bad_t;
> > +struct dir2_bad {
> > +	unsigned int	nr;
> > +	xfs_ino_t	*itab;
> > +};
> >  
> > -static dir2_bad_t *dir2_bad_list;
> > +static struct dir2_bad	dir2_bad;
> >  
> >  static void
> >  dir2_add_badlist(
> >  	xfs_ino_t	ino)
> >  {
> > -	dir2_bad_t	*l;
> > +	xfs_ino_t	*itab;
> >  
> > -	if ((l = malloc(sizeof(dir2_bad_t))) == NULL) {
> > +	itab = realloc(dir2_bad.itab, (dir2_bad.nr + 1) * sizeof(xfs_ino_t));
> > +	if (!itab) {
> >  		do_error(
> >  _("malloc failed (%zu bytes) dir2_add_badlist:ino %" PRIu64 "\n"),
> > -			sizeof(dir2_bad_t), ino);
> > +			sizeof(xfs_ino_t), ino);
> >  		exit(1);
> >  	}
> > -	l->next = dir2_bad_list;
> > -	dir2_bad_list = l;
> > -	l->ino = ino;
> > +	itab[dir2_bad.nr++] = ino;
> > +	dir2_bad.itab = itab;
> >  }
> >  
> > -int
> > +bool
> >  dir2_is_badino(
> >  	xfs_ino_t	ino)
> >  {
> > -	dir2_bad_t	*l;
> > +	unsigned int i;
> >  
> > -	for (l = dir2_bad_list; l; l = l->next)
> > -		if (l->ino == ino)
> > -			return 1;
> > -	return 0;
> > +	for (i = 0; i < dir2_bad.nr; ++i)
> > +		if (dir2_bad.itab[i] == ino)
> > +			return true;
> > +	return false;
> 
> This ignores the problem with this code: it is a O(n * N) search
> that gets done under an exclusive lock. Changing this to an array
> doesn't improve the efficiency of the algorithm at all. It might
> slighty reduce the magnitude of N, but modern CPU prefetchers detect
> link list walks like this so are almost as fast sequentail array
> walks. Hence this change will gain us relatively little when we have
> millions of bad inodes to search.
> 
> IOWs, the scalability problem that needs to be solved here is not
> "replace a linked list", it is "replace an O(n * N) search
> algorithm". We should address the algorithmic problem, not the code
> implementation issue.
> 
> That means we need to replace the linear search with a different
> algorithm, not rework the data structure used to do a linear search.
> We want this search to be reduced to O(n * log N) or O(n). We really
> don't care about memory usage or even the overhead of per-object
> memory allocation - we already do that and it isn't a performance
> limitation, so optimising for memory allocation reductions is
> optimising the wrong thing.
> 
> Replacing the linked list with an AVL tree or radix tree will make
> the search O(log N), giving us the desired reduction in search
> overhead to O(n * log N) and, more importantly, a significant
> reduction in lock hold times.

Obviously, I agree with your idea. Radix tree indexed by inode number
may waste space. I didn't notice that repair code had some AVL
infrastructure, let me try to use AVL instead.

But anyway, I'm not sure if it's a critical problem and if users really
came into bad inode bomb. Use array here just because some previous
review suggestion.

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

