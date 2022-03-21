Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21FCEC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 23:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbiCUXaH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 19:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiCUX3j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 19:29:39 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A695D328A85;
        Mon, 21 Mar 2022 16:27:28 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mp6-20020a17090b190600b001c6841b8a52so789229pjb.5;
        Mon, 21 Mar 2022 16:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Hh1RoZK4FawxC3f0a2bLkgNzcQFznKw/bRPe/9nXSXc=;
        b=YD4Z62P0H6wDspxBlxgwXmL3Ye9mMkA/YC8aX1BB5EiLzbij/mmBIw0B6aHNRPEBS6
         fVq4K03nZLOn6aJ8/gCbJ7g3HQzejqVrxQys063SfqpPdw6P9GQCdtdXX75ocewRlC5g
         1opg7QvRnNzy+kT4EsWXPdTY+gfEppQ6VrAYL1kCDax1mpJ9DnEHviARGDLpAdf6c7aL
         eu4UwnD8+t5wzJJRH02jUYmC2/j9KQFzMofrMby/jjF8J6du+qd+3vQCBaKhvFK2Ajc2
         DdBsn7omCoJiVwvKYOSQUi0IpaCQ42c/MTdDQgIV2APKxEceSTBnKLYz5M/pR4oRn6e2
         BeMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Hh1RoZK4FawxC3f0a2bLkgNzcQFznKw/bRPe/9nXSXc=;
        b=KyTAsp6j8KCOWgzswA4IKRUnp9WutcOdp1g07HB6T8eQNphogj2pYjeTofz+aHedFY
         rTZEgSmKXKbU9DhXfKI4NyoL4e806s0QcRRMgqDCEl4np7WEumZ3dDEtXKhjGpBQHE8M
         0/fatFLcH3ijI77Y2EjHDGN99LcJ0eFcGSd4MuR6uDEcTPNbIkW0S/PpVnFqzQ/livzw
         xxyflNk8aGNLaNy9KuGQkQmFGXuCmGMMbAl9XpDGhja5p1z0nPG6uf/jP4ZfkxVFJSuw
         1z2nOSRWw9Z8LUf1IsMFao/JmeczND3/AVIgP0BlXNXxGReAt4hl3sP6e1rNBy4hP0jC
         doSA==
X-Gm-Message-State: AOAM530/JKQ4VRsDX0x6qO8d7YrnJ/rekEaAo3bhsPQFtkpHN0yZZMCJ
        Mo/pIRnR4k513k4TGJp7NcM=
X-Google-Smtp-Source: ABdhPJx4S150ue7FtCtDBwGeTVJo5HvHWBmr5O+oCyOd4BodvDzriJEC2IJbwLEmKIzOISICdNTUxw==
X-Received: by 2002:a17:90a:3e4e:b0:1c6:586a:4d6a with SMTP id t14-20020a17090a3e4e00b001c6586a4d6amr1639142pjm.214.1647905248034;
        Mon, 21 Mar 2022 16:27:28 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6664d26eesm20165727pfk.88.2022.03.21.16.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 16:27:27 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 21 Mar 2022 13:27:25 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Dan Schatzberg <schatzberg.dan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        linux-block <linux-block@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] loop: add WQ_MEM_RECLAIM flag to per device workqueue
Message-ID: <YjkJ3S/1c8PxiA2Q@slm.duckdns.org>
References: <e0a0bc94-e6de-b0e5-ee46-a76cd1570ea6@I-love.SAKURA.ne.jp>
 <YjNHzyTFHjh9v6k4@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <5542ef88-dcc9-0db5-7f01-ad5779d9bc07@I-love.SAKURA.ne.jp>
 <YjS+Jr6QudSKMSGy@slm.duckdns.org>
 <61f41e56-3650-f0fc-9ef5-7e19fe84e6b7@I-love.SAKURA.ne.jp>
 <YjiuGnLVjj0Ouxtd@slm.duckdns.org>
 <886dee4b-ea74-a352-c9bf-cac16acffaa9@I-love.SAKURA.ne.jp>
 <YjkEjYVjLuo8imtn@slm.duckdns.org>
 <1c455861-3b42-c530-a99e-cce13e932f53@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c455861-3b42-c530-a99e-cce13e932f53@I-love.SAKURA.ne.jp>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 22, 2022 at 08:17:43AM +0900, Tetsuo Handa wrote:
> On 2022/03/22 8:04, Tejun Heo wrote:
> > But why are you dropping the flag from their intended users?
> 
> As far as I can see, the only difference __WQ_LEGACY makes is whether
> "workqueue: WQ_MEM_RECLAIM %s:%ps is flushing !WQ_MEM_RECLAIM %s:%ps"
> warning is printed or not. What are the intended users?

The old create_workqueue() and friends always imply WQ_MEM_RECLAIM because
they all used to be served dedicated kthreads. The growing number of
kthreads used this way became a headache. There were too many of these
kthreads sitting around doing nothing. In some niche configurations, they
ate up enough PIDs to cause boot failrues.

To address the issue, the new implementation made the workqueues share pools
of workers. However, this means that forward progress can't be guaranteed
under memory pressure, so workqueues which are depended upon during memory
reclaim now need to set WQ_MEM_RECLAIM explicitly to request a dedicated
rescuer thread.

The legacy flushing warning is telling us that those workqueues can be
converted to alloc_workqueue + WQ_MEM_RECLAIM as we know them to be
participating in memory reclaim (as they're flushing one of the explicitly
marked workqueues). So, if you spot them, the right thing to do is
converting all the involved workqueues to use alloc_workqueue() +
WQ_MEM_RECLAIM.

Thanks.

-- 
tejun
