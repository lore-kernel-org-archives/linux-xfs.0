Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8DFC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 23:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiCUXQx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 19:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbiCUXQf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 19:16:35 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6116E287;
        Mon, 21 Mar 2022 16:04:51 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so622393pjf.1;
        Mon, 21 Mar 2022 16:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G7jMixt6b3OD+MuuupnMNeSqFlpF3eH8Wb+10CWse58=;
        b=c/GhpERwWgOUyotaWXt3IX8NNAUnZG3abweOaWHFJXQMr5D08GbkkDm+p5BPq7smAt
         rRyU/37PLJs1BoTkWveaY2r4ixixGCp3FHDojfssZcHoCJQR5QL6ezn5lDEHseLrHp8V
         VZzg6rf9EpVXaKpw9V7DBGj8S+h4C9u+FtHvtnSfgSdx8jmlOt9TZwYolDbjk8IbJpvQ
         kkP+Fy6hosnuDr5McMcS9ewZ/S1TEwa9ywHfy8AyLbWLIOSPMcCIKogcx0XXuIObxW0k
         0jTmHp89Ny3QQaRBPs8Vh4wHUxCzz8YJfe2uksDapZzwU2iafneVkKWeLZmn22D+3QRO
         8ALQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=G7jMixt6b3OD+MuuupnMNeSqFlpF3eH8Wb+10CWse58=;
        b=pX/UDvy8QpDdOSeuSqE1jhR6/KAxXqSkHxwD7cFJaMzRhaqRRHzleSKkJoJVTiWOlr
         BOp/nvcn64suvIBidDkQDXnxx9BNHmjlAUDewfnBFb9PFhtPKGT3YMStqT+1kPVfIZsw
         dCPJCNrE/ijsNkClEy8Cq0wrZaLKYIlcHYOdqe21KPhd45o5tvv6H1Sl/3Gx3JOgR/v6
         zdf+BtK3gzbgA/tht7DL7mOgYpbIbPFLMeRPpdS2up0HHSAKhmKVe2rFNAfiQO2tU6hr
         50CjuB69aifnIGNVYoxktkn3AcgSpwoTUzMLkrjmA1w/cpiytYgKevtC7+j2xaW6fJuA
         HaLg==
X-Gm-Message-State: AOAM531nLiwYnjcNhT6aDfznVXphzDgMUznmfD5mMq/mDzAqZ6nkTRNz
        ns6XuRNv68+sy1CikuusKMc=
X-Google-Smtp-Source: ABdhPJzHx2j4/gUSvgpsWO4s5x+rir2NZ9b3fHiwscgWR7iKd2BJplomhH8zi0yvqOArOWOC83yRkA==
X-Received: by 2002:a17:902:ab41:b0:153:2c4b:4eee with SMTP id ij1-20020a170902ab4100b001532c4b4eeemr15562810plb.48.1647903886856;
        Mon, 21 Mar 2022 16:04:46 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id cd20-20020a056a00421400b004fa7d1b35b6sm10343972pfb.80.2022.03.21.16.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 16:04:46 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 21 Mar 2022 13:04:45 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Dan Schatzberg <schatzberg.dan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        linux-block <linux-block@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] loop: add WQ_MEM_RECLAIM flag to per device workqueue
Message-ID: <YjkEjYVjLuo8imtn@slm.duckdns.org>
References: <e0a0bc94-e6de-b0e5-ee46-a76cd1570ea6@I-love.SAKURA.ne.jp>
 <YjNHzyTFHjh9v6k4@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <5542ef88-dcc9-0db5-7f01-ad5779d9bc07@I-love.SAKURA.ne.jp>
 <YjS+Jr6QudSKMSGy@slm.duckdns.org>
 <61f41e56-3650-f0fc-9ef5-7e19fe84e6b7@I-love.SAKURA.ne.jp>
 <YjiuGnLVjj0Ouxtd@slm.duckdns.org>
 <886dee4b-ea74-a352-c9bf-cac16acffaa9@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <886dee4b-ea74-a352-c9bf-cac16acffaa9@I-love.SAKURA.ne.jp>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

On Tue, Mar 22, 2022 at 07:53:49AM +0900, Tetsuo Handa wrote:
> On 2022/03/22 1:55, Tejun Heo wrote:
> > No, just fix the abusers. There are four abusers in the kernel and they
> > aren't difficult to fix.
> 
> So, are you expecting that a change shown below happens, by adding WQ_MEM_RECLAIM
> flag to all WQs which may hit "workqueue: WQ_MEM_RECLAIM %s:%ps is flushing
> !WQ_MEM_RECLAIM %s:%ps" warning? Otherwise, __WQ_LEGACY flag will continue
> serving as a hack for suppressing this warning.

If you convert them to all of them in the flush chain to use
alloc_workqueue() w/ MEM_RECLAIM, the warning will go away.

>  #define create_workqueue(name)						\
> -	alloc_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, 1, (name))
> +	alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, (name))
>  #define create_freezable_workqueue(name)				\
> -	alloc_workqueue("%s", __WQ_LEGACY | WQ_FREEZABLE | WQ_UNBOUND |	\
> +	alloc_workqueue("%s", WQ_FREEZABLE | WQ_UNBOUND |	\
>  			WQ_MEM_RECLAIM, 1, (name))
>  #define create_singlethread_workqueue(name)				\
> -	alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
> +	alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, name)

But why are you dropping the flag from their intended users?

Thanks.

-- 
tejun
