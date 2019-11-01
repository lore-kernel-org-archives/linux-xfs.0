Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 881EBCA9EC9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 04:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EE482083E
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 04:02:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F3LOefIM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfKAECp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 00:02:45 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38720 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbfKAECp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 00:02:45 -0400
Received: by mail-pf1-f196.google.com with SMTP id c13so6097196pfp.5
        for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2019 21:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=34BmgyfVqaaCcuUyLhQdPVb7gObGLSSCd90lxaYvEN0=;
        b=F3LOefIM2SyfmLDqydgprywZNuT/Uyyjry6RJmGtEZ17Y2k2G5msAzz+4TOwkmgrHI
         xayuiIOh0B6ypoAatf8LrJ3UCATfUQd7SxrKN6/5KtLy6l5qF5oBVFTSVSI4ILE7Akxt
         dhN9eH1blfCCUKcMKx3zPtYAzNldiogdmhm4rWHHciYbZjkBl+7kStrWv2gzEkr6cgjU
         +gTVOjUABtYzP74E81qtXDbt7nOOi9abga3u3nJ4l6MLtsKZAtnI0tQfzfX5EjqVzjrh
         hY1RMwtzg8oAHuEdkQyOdaE5ZdnYGb2yXG0ceDIYoXOCSH2v90jpbbC+2OF/7Fhm0fpv
         KIhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=34BmgyfVqaaCcuUyLhQdPVb7gObGLSSCd90lxaYvEN0=;
        b=bloStaAHGAp87zgWrxKMUmwbCqnfVDYQTUDK8jHTWXcBoQSS6ZjR9CIXzo2YOs9sHi
         PhHb/6EFFHZ6fs4GK6CMFWfYbJdjtEt8BEotOgSpulG8Nk1ObKSyfi0DJtUPN6TeeN33
         jLcj3fQ1CmtMO2NA1Yq16R4CbWdVYgZx0z+GYG4XE94q2KMZ6iuXoRx6anG8EvA3aD3R
         0QUlm44pgLHJ8YrWS/T6LfM2/UnaXPZO96X9sTq05f3MfOt7BHzEK7bTUNfXPQRx8NDd
         RTomvADhZC3LaGvRdtxGuCLi6UQGAkP8fv39E+fHd93kT5aZDZvr64hyQjbuUgktUkPE
         fLYQ==
X-Gm-Message-State: APjAAAU9YraSmk2zJUAahlzGwO7SkhR5QMUMonFBNCueYRNbdgBlIxZs
        DhZCV9vk6Jx3g6sNpEDjdhWThFg=
X-Google-Smtp-Source: APXvYqzGHHbV4WI9vXJylbsGuKRxETZYCQhzzJRaEFZk1v5SXG2BnbBr732/cmqzprtoBsVLDF+Qow==
X-Received: by 2002:a62:7553:: with SMTP id q80mr11167208pfc.203.1572580964854;
        Thu, 31 Oct 2019 21:02:44 -0700 (PDT)
Received: from mypc ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 65sm5552528pfv.50.2019.10.31.21.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 21:02:43 -0700 (PDT)
Date:   Fri, 1 Nov 2019 12:02:34 +0800
From:   Pingfan Liu <kernelfans@gmail.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs/log: protect the logging content under xc_ctx_lock
Message-ID: <20191101040234.GA7598@mypc>
References: <20191030133327.GA29340@mypc>
 <1572442631-4472-1-git-send-email-kernelfans@gmail.com>
 <20191031113640.GA54006@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031113640.GA54006@bfoster>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 31, 2019 at 07:36:40AM -0400, Brian Foster wrote:
> Dropped linux-fsdevel from cc. There's no reason to spam -fsdevel with
> low level XFS patches.
> 
> On Wed, Oct 30, 2019 at 09:37:11PM +0800, Pingfan Liu wrote:
[...]
> 
> I'm not following how this is possible. The CIL push above, under
It turns out not to be a bug as I replied to Dave's mail in this thread.
> exclusive lock, removes each log item from ->xc_cil and pulls the log
> vectors off of the log items to form the lv chain on the CIL context.
> This means that the transB commit either updates the lv attached to the
> log item from transA with the latest in-core version or uses the new
> shadow buffer allocated in the commit path of transB. Either way is fine
> because there is no guarantee of per-transaction granularity in the
Yes, no guarantee of per-transaction granularity, but there is a
boundary placed on several effect-merged transactions. That is what
xc_ctx_lock and private chain ctx->lv_chain guarantee.
> on-disk log. The purpose of the on-disk log is to guarantee filesystem
> consistency after a crash.
> 
> All in all, I can't really tell what problem you're describing here. If
> you believe there's an issue in this code, I'd suggest to either try and
> instrument it manually to reproduce a demonstrable problem and/or
> provide far more detailed of a description to explain it.
> 
Sorry that I raise a false alarm. But thank you all for helping me to figure
out through this.

Regards,
	Pingfan
