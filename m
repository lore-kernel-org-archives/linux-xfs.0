Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0CC0C04FDF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 09:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbjG0J0o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 05:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbjG0J0Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 05:26:25 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48005581
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 02:15:59 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-56366112d64so76442a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 02:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690449359; x=1691054159;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pSf6nVkdhsvxhtXxVh7cgsa4dxLg7VE+dk8AIIS4uIA=;
        b=gs/PU4tG46kQg+lGivKEpQm67BWRBr/3B5K5J0ZjcDJiH4VmN/xAYLr567/KvCeKyO
         Sxv9KoDe1Fgjt2T5xGL5ntjIo2URj6N4iyAFFdnIg9R3abku7q3pHpjtx5uyfVGaAvYO
         XtiYYOqXBfNiFu1rjUbVMMYVt5QxVT4/F43UKIFaCuAs9bCstLLngxCL3ODWliEci9Sz
         ElL4V2hOOxLgo9+060cMLFPSS0lDlqR1ZhVgYCnGDkIpUHSxXftLLIhthhd9SgFzYboG
         fvp5YOTqEFeGRzV75GGLb7yIHnFGlXJ5ArnypIHw3PlhSwR6sQo5O1DaMDPfX3YeBn9C
         fAww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690449359; x=1691054159;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pSf6nVkdhsvxhtXxVh7cgsa4dxLg7VE+dk8AIIS4uIA=;
        b=d1W0iFJIM/A54jzI28qOI+p9ednCerHuAYIr64/OLwO68wdPga8TutMqaaXBbuRkxT
         l0SSPOMehc5+il8G2it3o2eNUOYDHt464D4LeaIeqpYo9c6lRRuj5RjLedUHkFZJs7S+
         gCGXcuZOT7JLkFqDMwKojzbtR1+3Eco03z/T/Pl8zuPySEMwPoVxYOEbqnnRWsf8IqXF
         H1AQaCUcOW73yCsZiONTvVEB/0+Z55RNnrO6FAmoPV/Xdv1CjI1xJ2llJskwWMUjKRYW
         mEFsDRODXuvfUEmapOXKKqMhiGMHJIT4IZ/6Fa4MVRRhCU2qVhGoM0H3pIMER0B8AZyf
         SB5Q==
X-Gm-Message-State: ABy/qLaQX+Fs00H5B7hOVuck1lFhg1BTFUdbPFwk7K+U2VtAg8sE4AmO
        cvvox++VyLE0vXibAbw6uPXt4A==
X-Google-Smtp-Source: APBJJlFWNasuQyGNPy0hcIGkgu46yCpujoddgwDeBo2nmYNJTDqcdO/STO03uju2nKSJGm9+FY3b7g==
X-Received: by 2002:a17:90a:7c48:b0:268:38a7:842e with SMTP id e8-20020a17090a7c4800b0026838a7842emr4155117pjl.2.1690449358970;
        Thu, 27 Jul 2023 02:15:58 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id bv21-20020a17090af19500b0026596b8f33asm2403500pjb.40.2023.07.27.02.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jul 2023 02:15:58 -0700 (PDT)
Message-ID: <8f8aa0d6-8f5c-958d-096d-d4c6d3e71e7a@bytedance.com>
Date:   Thu, 27 Jul 2023 17:15:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH v3 29/49] md/raid5: dynamically allocate the md-raid5
 shrinker
Content-Language: en-US
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-erofs@lists.ozlabs.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-nfs@vger.kernel.org, linux-mtd@lists.infradead.org,
        rcu@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
 <20230727080502.77895-30-zhengqi.arch@bytedance.com>
From:   Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <20230727080502.77895-30-zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2023/7/27 16:04, Qi Zheng wrote:
> In preparation for implementing lockless slab shrink, use new APIs to
> dynamically allocate the md-raid5 shrinker, so that it can be freed
> asynchronously using kfree_rcu(). Then it doesn't need to wait for RCU
> read-side critical section when releasing the struct r5conf.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   drivers/md/raid5.c | 25 ++++++++++++++-----------
>   drivers/md/raid5.h |  2 +-
>   2 files changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 85b3004594e0..fbb4e6f5ff43 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7414,7 +7414,7 @@ static void free_conf(struct r5conf *conf)
>   
>   	log_exit(conf);
>   
> -	unregister_shrinker(&conf->shrinker);
> +	shrinker_free(conf->shrinker);
>   	free_thread_groups(conf);
>   	shrink_stripes(conf);
>   	raid5_free_percpu(conf);
> @@ -7462,7 +7462,7 @@ static int raid5_alloc_percpu(struct r5conf *conf)
>   static unsigned long raid5_cache_scan(struct shrinker *shrink,
>   				      struct shrink_control *sc)
>   {
> -	struct r5conf *conf = container_of(shrink, struct r5conf, shrinker);
> +	struct r5conf *conf = shrink->private_data;
>   	unsigned long ret = SHRINK_STOP;
>   
>   	if (mutex_trylock(&conf->cache_size_mutex)) {
> @@ -7483,7 +7483,7 @@ static unsigned long raid5_cache_scan(struct shrinker *shrink,
>   static unsigned long raid5_cache_count(struct shrinker *shrink,
>   				       struct shrink_control *sc)
>   {
> -	struct r5conf *conf = container_of(shrink, struct r5conf, shrinker);
> +	struct r5conf *conf = shrink->private_data;
>   
>   	if (conf->max_nr_stripes < conf->min_nr_stripes)
>   		/* unlikely, but not impossible */
> @@ -7718,18 +7718,21 @@ static struct r5conf *setup_conf(struct mddev *mddev)
>   	 * it reduces the queue depth and so can hurt throughput.
>   	 * So set it rather large, scaled by number of devices.
>   	 */
> -	conf->shrinker.seeks = DEFAULT_SEEKS * conf->raid_disks * 4;
> -	conf->shrinker.scan_objects = raid5_cache_scan;
> -	conf->shrinker.count_objects = raid5_cache_count;
> -	conf->shrinker.batch = 128;
> -	conf->shrinker.flags = 0;
> -	ret = register_shrinker(&conf->shrinker, "md-raid5:%s", mdname(mddev));
> -	if (ret) {
> -		pr_warn("md/raid:%s: couldn't register shrinker.\n",
> +	conf->shrinker = shrinker_alloc(0, "md-raid5:%s", mdname(mddev));
> +	if (!conf->shrinker) {

Here should set ret to -ENOMEM, will fix.

> +		pr_warn("md/raid:%s: couldn't allocate shrinker.\n",
>   			mdname(mddev));
>   		goto abort;
>   	}
>   
> +	conf->shrinker->seeks = DEFAULT_SEEKS * conf->raid_disks * 4;
> +	conf->shrinker->scan_objects = raid5_cache_scan;
> +	conf->shrinker->count_objects = raid5_cache_count;
> +	conf->shrinker->batch = 128;
> +	conf->shrinker->private_data = conf;
> +
> +	shrinker_register(conf->shrinker);
> +
>   	sprintf(pers_name, "raid%d", mddev->new_level);
>   	rcu_assign_pointer(conf->thread,
>   			   md_register_thread(raid5d, mddev, pers_name));
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 97a795979a35..22bea20eccbd 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -670,7 +670,7 @@ struct r5conf {
>   	wait_queue_head_t	wait_for_stripe;
>   	wait_queue_head_t	wait_for_overlap;
>   	unsigned long		cache_state;
> -	struct shrinker		shrinker;
> +	struct shrinker		*shrinker;
>   	int			pool_size; /* number of disks in stripeheads in pool */
>   	spinlock_t		device_lock;
>   	struct disk_info	*disks;
