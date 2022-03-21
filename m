Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 892A6C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 16:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347470AbiCUQ5W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 12:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbiCUQ5V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 12:57:21 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A3F1697AB;
        Mon, 21 Mar 2022 09:55:56 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id p8so15955679pfh.8;
        Mon, 21 Mar 2022 09:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=84PjI1Xh1Qx0fz81RF/NBjcvbn+e5vLzO7R3KL6cZ6M=;
        b=O7L/u1zqiqTEAADMB58qcGSh/kszr/vuohrUtSkCSUTf+jriLFeP+728iwtOLleWpY
         o3ewhkfLB4cHyje5Q+q7+djmzOMJuJqx20Mhk9YEL1ON3MAaLI4ghhhqS7tLa7zltEa2
         Pa3+quQhQG/OZ/oadPBqBjUbCcRu7drtuzOKRY24VTrIy0pwkm+F8L3x1cbGxouAvrvc
         mWQS9J7H4NYi2VoCJRHqAoHdzjsbtTCf5pT6JfEZAMpla9inxDc17Cn4Ej6zZ1D9QuFQ
         t5qvet7fbcZYTpxc2XkWsy26FeXL3djSBQ9BKxt7eDUCmXbSiSyiK/k/pulTU4DLR5Oo
         mfsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=84PjI1Xh1Qx0fz81RF/NBjcvbn+e5vLzO7R3KL6cZ6M=;
        b=UAJ1A4gtJS8zuPVC5kxWpAdYk+j0cXvCOz1JWWSwN2sKpUdj4a0gdsZFQyjpyKLktU
         bENFbo+x0ZmZhz5ckvXFCRlWEZUntvBkwHOoT84yqPwKe3g+V/VqxO4ZASDEUR4SQxk8
         IajNFFtgRY+6p1gwlVYL00w0uq2whmYZSn1fHBXdUzbvAolFYkTh2Q4hk998ftR0kZdL
         Ef0VRdI/S5OeMMNzZH85Hk+o3hujPZXeK+85+Xx406oRBu4bT8/rYOjSeMa80413045N
         EPye2bVqZ5tDOdC+F6oUEo3WKsyiEbvyMSc3KDvdoZCrPxT2eXZ8aP5jE+wfh1zYkK5w
         k6og==
X-Gm-Message-State: AOAM5303iPwMwg6w5vkrfY9gcp4EyJpO2fNc6CEEHNknJnjEMeqEg2tK
        pPppp2OARhmNjcrHkx7dpi8=
X-Google-Smtp-Source: ABdhPJwszLC/dCZbMz8J6SJGLQE3FEAiykaov2Ralj+R5++YubpTng8hS7sUrV3JBn61ux3gPNBMWg==
X-Received: by 2002:a05:6a00:b87:b0:4fa:a79a:72e7 with SMTP id g7-20020a056a000b8700b004faa79a72e7mr3930966pfj.68.1647881755940;
        Mon, 21 Mar 2022 09:55:55 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id u126-20020a637984000000b0038147b4f53esm14835165pgc.93.2022.03.21.09.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 09:55:55 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 21 Mar 2022 06:55:54 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Dan Schatzberg <schatzberg.dan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        linux-block <linux-block@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] loop: add WQ_MEM_RECLAIM flag to per device workqueue
Message-ID: <YjiuGnLVjj0Ouxtd@slm.duckdns.org>
References: <e0a0bc94-e6de-b0e5-ee46-a76cd1570ea6@I-love.SAKURA.ne.jp>
 <YjNHzyTFHjh9v6k4@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <5542ef88-dcc9-0db5-7f01-ad5779d9bc07@I-love.SAKURA.ne.jp>
 <YjS+Jr6QudSKMSGy@slm.duckdns.org>
 <61f41e56-3650-f0fc-9ef5-7e19fe84e6b7@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61f41e56-3650-f0fc-9ef5-7e19fe84e6b7@I-love.SAKURA.ne.jp>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

On Sat, Mar 19, 2022 at 11:02:51AM +0900, Tetsuo Handa wrote:
> Is the intent of __WQ_LEGACY flag to indicate that "this WQ was created
> using deprecated interface" ? But such intention no longer holds true.
> 
> Despite __WQ_LEGACY flag is described as "internal: create*_workqueue()",
> tegra194_cpufreq_probe()/scsi_add_host_with_dma()/iscsi_host_alloc()/
> iscsi_transport_init() are passing __WQ_LEGACY flag using alloc_workqueue()
> interface. Therefore, __WQ_LEGACY flag is no longer a meaningful indicator of
> "internal: create*_workqueue()". Description for __WQ_LEGACY flag needs an
> update.
...
> Given that the legacy create_workqueue() interface always implied WQ_MEM_RECLAIM flag,
>
> maybe it is better to make alloc_workqueue() interface WQ_MEM_RECLAIM by default.

That actually is pretty expensive when added up, which is why we went for
the shared worker pool model in the first place.

> That is, obsolete WQ_MEM_RECLAIM flag and __WQ_LEGACY flag, and introduce a new flag
> (e.g. WQ_MAY_SHARE_WORKER) which is passed to alloc_workqueue() interface only when
> it is absolutely confident that this WQ never participates in memory reclaim path and
> never participates in flush_workqueue()/flush_work() operation.

No, just fix the abusers. There are four abusers in the kernel and they
aren't difficult to fix.

Thanks.

-- 
tejun
