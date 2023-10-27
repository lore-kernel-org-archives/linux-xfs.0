Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8203EC25B47
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Oct 2023 23:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbjJ0XLq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Oct 2023 19:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjJ0XLq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2023 19:11:46 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B319B1AC
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2023 16:11:43 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6b77ab73c6fso1887880b3a.1
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2023 16:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698448303; x=1699053103; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ejs8dtCJvZZG2EjYMdD3cKIzcmIuqMP36dRKJPKZMwM=;
        b=eKayqfVkuGUg/vwEi0AkcIsH+zMTVlKAoawDO3T+bZomsEWX5OPXrrdfBiUGkP/9ne
         f/wbDK+iUmr2vdZz7EASw2qmPtVKJxwtjwlCoYJiDslRuCn0kT91Kigej5gpoCNEgT9X
         0eMUtG689kyZqS+FT/2T37WLQ9ulPlnCpRlwFB2Tx9jsQTX5Jv/uC0yQBkxbOO6aLBKm
         1/+mf0o9/NBm5uq+Q9WHzrjHwsGBh6L+7OoD1UYlKLFkiZL0pKOb7rKhYpTtsLxRdjXo
         AQ3PUMF8+92k8lVFESgfx5yug8cW/8WsrJHE0FiiEuupZoAFyPkdAeN/4jEB3AU0tAMC
         /y4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698448303; x=1699053103;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ejs8dtCJvZZG2EjYMdD3cKIzcmIuqMP36dRKJPKZMwM=;
        b=pYZfM4jKjiXpzoc5SYo/dfqNg2axdOM2tVAgg0V0VHo5p0TxJDZ7IkEKTBi+fUuFsB
         HOmcwT1A04LcGu4t0gVHjGx11HV221C1OdYt/lTSiUQINWIzpJ6DRq2pV+oCdJp/LcqS
         ekSdQmNbTsOXYFedsIdw7lCQ46E78COmKQKUomsqYY7RtT00awe3nOfrJb9Sax9zeYTV
         jE6Dk7+776lJ0ra9Xfx/+RqtvBZIAv6Y3FcQNHVp0vcBFYCW7PHPbO2FWgZF/B7WzcD5
         y9XwwWTE7bbloQiXx+7NJC0wotNQcDIzkGT8dJIiR+mqjx+hkBNX+TxnnElYoPO3PzUb
         bVqQ==
X-Gm-Message-State: AOJu0YxjQgrY/J0lfNAOmW6BGjcdmqKF4RTc11ow1jywLPPPGOWyutmC
        x0NcoyCFiSbvzJT54cVv0aM=
X-Google-Smtp-Source: AGHT+IEuqZ5QCPcWlbMoZZt/5OrZ0fxwiquEPU/2bC1NphCBM2mhO1zOZOQMSakFlEyV1zro4HmJyg==
X-Received: by 2002:a05:6a00:148c:b0:693:43b5:aaf3 with SMTP id v12-20020a056a00148c00b0069343b5aaf3mr5254096pfu.13.1698448303002;
        Fri, 27 Oct 2023 16:11:43 -0700 (PDT)
Received: from google.com ([2601:647:4701:18d0:55d7:6231:beb9:158b])
        by smtp.gmail.com with ESMTPSA id c22-20020aa78816000000b0068790c41ca2sm1897663pfo.27.2023.10.27.16.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Oct 2023 16:11:42 -0700 (PDT)
Date:   Fri, 27 Oct 2023 16:11:40 -0700
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v2] xfs: up(ic_sema) if flushing data device fails
Message-ID: <ZTxDrGmO_J2r7xQK@google.com>
References: <20231025225848.3437904-1-leah.rumancik@gmail.com>
 <ZTm1n2I3bif0h4er@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTm1n2I3bif0h4er@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 26, 2023 at 11:41:03AM +1100, Dave Chinner wrote:
> Hmmmm. So we'll leave an unreferenced, unlocked iclog in a SYNCING
> state where something else can access it, then hope that the
> shutdown gets to it first and that it cleans it all up? That doesn't
> seem completely safe to me.
> 
> At entry to this function, if the log is already shut down, it runs
> xlog_state_done_syncing() to force the iclog and it's attached state
> to be cleaned up before dropping the lock and returning.
> 
> If I look at xlog_ioend_work(), if it gets an error it does the
> shutdown, then calls xlog_state_done_syncing() to clean up the iclog
> and attached state, then drops the lock.
> 
> Hence it appears to me that the error handling for a fatal errors in
> IO submission should match the io completion error handling. i.e the
> error stack for this function should look like this:
> 
> ....
> 	if (xlog_is_shutdown(log))
> 		goto out_done_sync;
> ....
> 	if (error)
> 		goto out_do_shutdown;
> ....
> out_do_shutdown:
> 	xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> out_done_sync:
> 	xlog_state_done_syncing(iclog);
> 	up(&iclog->ic_sema);
> }
> 
> Thoughts?
Sure, that makes sense to me and will make things more consistent. I'll
send out a new version. Thanks for the review!

- Leah

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
