Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4FDC7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 20:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240442AbjDFUtZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 16:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240516AbjDFUtL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 16:49:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1A0E058
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 13:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680813908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hlliibCO4sNcXALnaTXV8AY6so6PWo4TfdquJ/Ysd8k=;
        b=OY8islJ1corMLxr2RhFciC73poUWVv6eVbegmDmWTClopB6v/YmvtTJDIhMvGPsviRLXJN
        D2XVncQ5mpx0Gcc55raG3muAK+RcP0BunUgXUmeP8ThCnIR9UWjVQsJhTffseOJcGLpSFd
        +ZVuKSuRlOYZy2BSzQGbqMb8rimOAD0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-bBU0gs_JOfi84pikR_Vu4w-1; Thu, 06 Apr 2023 16:45:07 -0400
X-MC-Unique: bBU0gs_JOfi84pikR_Vu4w-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-746b617d095so12178385a.0
        for <linux-xfs@vger.kernel.org>; Thu, 06 Apr 2023 13:45:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680813906; x=1683405906;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hlliibCO4sNcXALnaTXV8AY6so6PWo4TfdquJ/Ysd8k=;
        b=i4lDfo/ZOK9bv9sCuDQ7KHSHou1+POr4jmRZnWGSPcb8JoGyPftm6jKChYZu5RwX5Y
         ZYEi2tdCn7yKylyPcHhg+BcP+A5qaU59g7j4FjTtRlVueSi8IS0eaoWA5JvRbo45Sp/F
         pkQ4QkLxRi/lUZ21ogNWtOSe9oXCjDygewOcypEsVbbKgtOzyP1Un2iK9kIcp3enzk0p
         ywco8H8BrFTSOl5qZlFoAtoQ3cOX8r30SXv9OmLGrK20zAp/mSSYdOp0HyxKuWgPJDiA
         IzVRELO2ePJiLH4EmIbegQ1qDl/V1K2az7TifDJgwY3DHqmiVO1o4mmW3tfyI1TXmQaw
         hc6g==
X-Gm-Message-State: AAQBX9cYZd9Awpi8He4IR0ybLW9mkHGc6x3em41ksgKlTy5kxcX1htUP
        QHbMaxWFkraWWE6zvxRglFXVFeIh9KyJfq6jQSp95rpMw/L0FkwA9Pa1ZGdX3KAEgEwt984Paq4
        g1eEQ6BtilUpo/qpJC9IxeJLbHO5a
X-Received: by 2002:a05:6214:3018:b0:5af:3a13:202d with SMTP id ke24-20020a056214301800b005af3a13202dmr744163qvb.4.1680813905800;
        Thu, 06 Apr 2023 13:45:05 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y1KJ4vprLWmq2m/5KZ8L4Bi2Rxr9Vn0WKqzah+7elFypEf8sf0YtUFBzrza/xRbtyRgeE1YQ==
X-Received: by 2002:a05:6214:3018:b0:5af:3a13:202d with SMTP id ke24-20020a056214301800b005af3a13202dmr744126qvb.4.1680813905342;
        Thu, 06 Apr 2023 13:45:05 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id lz7-20020a0562145c4700b005dd8b9345d9sm137125qvb.113.2023.04.06.13.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 13:45:04 -0700 (PDT)
Date:   Thu, 6 Apr 2023 16:45:02 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        NeilBrown <neilb@suse.de>, Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 2/2] mm: vmscan: refactor reclaim_state helpers
Message-ID: <ZC8vTi3SlKwnYv5i@x1n>
References: <20230405185427.1246289-1-yosryahmed@google.com>
 <20230405185427.1246289-3-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230405185427.1246289-3-yosryahmed@google.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi, Yosry,

On Wed, Apr 05, 2023 at 06:54:27PM +0000, Yosry Ahmed wrote:

[...]

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c82bd89f90364..049e39202e6ce 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -188,18 +188,6 @@ struct scan_control {
>   */
>  int vm_swappiness = 60;
>  
> -static void set_task_reclaim_state(struct task_struct *task,
> -				   struct reclaim_state *rs)
> -{
> -	/* Check for an overwrite */
> -	WARN_ON_ONCE(rs && task->reclaim_state);
> -
> -	/* Check for the nulling of an already-nulled member */
> -	WARN_ON_ONCE(!rs && !task->reclaim_state);
> -
> -	task->reclaim_state = rs;
> -}
> -
>  LIST_HEAD(shrinker_list);
>  DECLARE_RWSEM(shrinker_rwsem);
>  
> @@ -511,6 +499,59 @@ static bool writeback_throttling_sane(struct scan_control *sc)
>  }
>  #endif
>  
> +static void set_task_reclaim_state(struct task_struct *task,
> +				   struct reclaim_state *rs)
> +{
> +	/* Check for an overwrite */
> +	WARN_ON_ONCE(rs && task->reclaim_state);
> +
> +	/* Check for the nulling of an already-nulled member */
> +	WARN_ON_ONCE(!rs && !task->reclaim_state);
> +
> +	task->reclaim_state = rs;
> +}

Nit: I just think such movement not necessary while it loses the "git
blame" information easily.

Instead of moving this here without major benefit, why not just define
flush_reclaim_state() right after previous set_task_reclaim_state()?

> +
> +/*
> + * flush_reclaim_state(): add pages reclaimed outside of LRU-based reclaim to
> + * scan_control->nr_reclaimed.
> + */
> +static void flush_reclaim_state(struct scan_control *sc,
> +				struct reclaim_state *rs)
> +{
> +	/*
> +	 * Currently, reclaim_state->reclaimed includes three types of pages
> +	 * freed outside of vmscan:
> +	 * (1) Slab pages.
> +	 * (2) Clean file pages from pruned inodes.
> +	 * (3) XFS freed buffer pages.
> +	 *
> +	 * For all of these cases, we have no way of finding out whether these
> +	 * pages were related to the memcg under reclaim. For example, a freed
> +	 * slab page could have had only a single object charged to the memcg
> +	 * under reclaim. Also, populated inodes are not on shrinker LRUs
> +	 * anymore except on highmem systems.
> +	 *
> +	 * Instead of over-reporting the reclaimed pages in a memcg reclaim,
> +	 * only count such pages in global reclaim. This prevents unnecessary
> +	 * retries during memcg charging and false positive from proactive
> +	 * reclaim (memory.reclaim).
> +	 *
> +	 * For uncommon cases were the freed pages were actually significantly
> +	 * charged to the memcg under reclaim, and we end up under-reporting, it
> +	 * should be fine. The freed pages will be uncharged anyway, even if
> +	 * they are not reported properly, and we will be able to make forward
> +	 * progress in charging (which is usually in a retry loop).
> +	 *
> +	 * We can go one step further, and report the uncharged objcg pages in
> +	 * memcg reclaim, to make reporting more accurate and reduce
> +	 * under-reporting, but it's probably not worth the complexity for now.
> +	 */
> +	if (rs && global_reclaim(sc)) {
> +		sc->nr_reclaimed += rs->reclaimed;
> +		rs->reclaimed = 0;
> +	}
> +}
> +
>  static long xchg_nr_deferred(struct shrinker *shrinker,
>  			     struct shrink_control *sc)
>  {
> @@ -5346,10 +5387,7 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>  		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
>  			   sc->nr_reclaimed - reclaimed);
>  
> -	if (global_reclaim(sc)) {
> -		sc->nr_reclaimed += current->reclaim_state->reclaimed_slab;
> -		current->reclaim_state->reclaimed_slab = 0;
> -	}
> +	flush_reclaim_state(sc, current->reclaim_state);
>  
>  	return success ? MEMCG_LRU_YOUNG : 0;
>  }
> @@ -6474,10 +6512,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>  
>  	shrink_node_memcgs(pgdat, sc);
>  
> -	if (reclaim_state && global_reclaim(sc)) {
> -		sc->nr_reclaimed += reclaim_state->reclaimed_slab;
> -		reclaim_state->reclaimed_slab = 0;
> -	}
> +	flush_reclaim_state(sc, reclaim_state);

IIUC reclaim_state here still points to current->reclaim_state.  Could it
change at all?

Is it cleaner to make flush_reclaim_state() taking "sc" only if it always
references current->reclaim_state?

>  
>  	/* Record the subtree's reclaim efficiency */
>  	if (!sc->proactive)
> -- 
> 2.40.0.348.gf938b09366-goog
> 

-- 
Peter Xu

