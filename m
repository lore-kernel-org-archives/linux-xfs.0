Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C72C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 17:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239723AbiC3RLR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 13:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236395AbiC3RLQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 13:11:16 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452AA46B24
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 10:09:31 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id r13so42837862ejd.5
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 10:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=f7Hw5EOmIQu18d7FUqzTU59z6D5kFx1+GrlB8/bVCZs=;
        b=MBIJUXZj80CWB9EDXSrg951unUnDYeUWWGtU8EoUiaRLPFu+kEPBDgx3LMm2wBJepU
         doc47/AK7eKWcbxwBX7tjG0q4UHW5nK8ENAvPC9MvJ/x/1tQT9611DWr+8B6RUo0oKAA
         kOpsEUTfqPtSa6pw/3zdVes6wBWFrmziix48E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=f7Hw5EOmIQu18d7FUqzTU59z6D5kFx1+GrlB8/bVCZs=;
        b=BHW21uzAPZp9rogv2hunRfRpGeLdRco8QFMP1QuL5BaQBgFy5Tx1hsKUssTUvYDEOk
         4G2DtmajG/VxFKI8Eb8Dbo9lQVsDGsaB936aoPtx7Nvwda8syqev8N5bI1CLfSz0YFb0
         Rrq3WCJMgMw/mLB+B6yrb5MtNbSEJ4Kf3dmEaapSVg7zj3UoeIm99nmhbVf79HsPAbDR
         0ahGwe8WqrNyrbehXyjoMao/uTduyFB5rbETETu12RuDj1jnfZ2b7NguMtYpEYMZ5SCP
         j/OdWVTHg0L0zxkygN3eYQ/1fl6YAqg8lURJggD1kO25PFdCK7aRguLo77kJJCiOj9dR
         Bh2g==
X-Gm-Message-State: AOAM530zv/fAjnC6nu1wSqbXDhRru0P7Htzsg63RxKaYGwRcTndZ2/qF
        ZQb45mLCbjG0rWk0AbWfIHYMbQ==
X-Google-Smtp-Source: ABdhPJzgFPc7M9VK6PWzH9GoSX3eNxg4olOw+WE7By+bwhbRZQyQaB/aZjucjEcD2xD+/gsVfxQFTA==
X-Received: by 2002:a17:906:7746:b0:6ce:a12e:489f with SMTP id o6-20020a170906774600b006cea12e489fmr530032ejn.551.1648660169789;
        Wed, 30 Mar 2022 10:09:29 -0700 (PDT)
Received: from localhost ([2620:10d:c093:400::5:c1bb])
        by smtp.gmail.com with ESMTPSA id n25-20020aa7db59000000b00415965e9727sm9838412edt.18.2022.03.30.10.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 10:09:29 -0700 (PDT)
Date:   Wed, 30 Mar 2022 18:09:28 +0100
From:   Chris Down <chris@chrisdown.name>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Dave Chinner <david@fromorbit.com>, Petr Mladek <pmladek@suse.com>,
        Jonathan Lassoff <jof@thejof.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <YkSOyC+vEMVSDsdU@chrisdown.name>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
 <YkMKyN9w0S8VFJRk@alley>
 <20220330003457.GB1544202@dread.disaster.area>
 <YkREmrfoTcqOYbma@chrisdown.name>
 <20220330124739.70edca36@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220330124739.70edca36@gandalf.local.home>
User-Agent: Mutt/2.2.2 (aa28abe8) (2022-03-25)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Steven Rostedt writes:
>On Wed, 30 Mar 2022 12:52:58 +0100
>Chris Down <chris@chrisdown.name> wrote:
>
>> The policy, as with all debugfs APIs by default, is that it's completely
>> unstable and there are no API stability guarantees whatsoever. That's why
>> there's no extensive documentation for users: because this is a feature for
>> kernel developers.
>>
>> 0: https://lwn.net/Articles/309298/
>
>That article you reference states the opposite of what you said. And I got
>burnt by it before. Because Linus stated, if it is available for users, it
>is an ABI.

Hmm, even in 2011 after that article there were discussions about debugfs 
explicitly being the "wild west"[0], no? I heard the same during LSFMM 
discussions during recent years as well. Although I confess that I am not 
frequently in discussions about debugfs so I don't really know where the 
majority opinion is nowadays.

Either way, as discussed the contents wouldn't be the ABI (as with my 
/proc/self/smaps allusion), the file format would be, so it wouldn't imply that 
printk() calls themselves or their locations become an ABI.

0: https://lwn.net/Articles/429321/
