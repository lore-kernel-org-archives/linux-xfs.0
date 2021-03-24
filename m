Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6053C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 01:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A11D5619EE
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 01:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbhCXB1v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 21:27:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54687 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231855AbhCXB1J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 21:27:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616549228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xIUAoKHrX02DWmVb4uBZzEIDmKz7PMTcr/9V1s8kDY8=;
        b=dp21sLdUZFJ3lkVopuHPfgZwcrN0f6mpch1EptCY/9SIW0+d0ky/auSXYIwq6qSJ23Gx2f
        swhjlbuD+uL15aK1vP3BBVPzDq2H3Rwa9ambJwMa0Jl0LGuNqglA9I9zcIjhdrS+RwpPQQ
        M1r7ucZ/Gw2Z0wPG27V2ofMCUmyLR1c=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-SN3240FiPrWNLMV0h9KytQ-1; Tue, 23 Mar 2021 21:27:07 -0400
X-MC-Unique: SN3240FiPrWNLMV0h9KytQ-1
Received: by mail-pg1-f199.google.com with SMTP id q36so555343pgb.23
        for <linux-xfs@vger.kernel.org>; Tue, 23 Mar 2021 18:27:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xIUAoKHrX02DWmVb4uBZzEIDmKz7PMTcr/9V1s8kDY8=;
        b=BXvqF2ERdnDMHZLE1WfLh6SsERUhY5SlFA3YnbI7o74rVpnhkNm7NijjXQiS/szR91
         l9hJ+x2V26Gw1/wx6+jb3KAzXB+y5Mhiz+6iJV5fNc8TN7ZodhAlzTKs9IdQdBX9YbzH
         hDDc12TGS4S/7olhi/z1vqJdyUevFWBMfPeQkMtvpJ5rnO3bx3rqXJevwi6iVk1aX6Au
         P7crFCDduvrkUcnrezlLTEcatdPWhmMd7Kn5AYF0OFoYXN7dhzqQz1QsWs91sGLFhX7P
         udtij710XSV9h6m/lbM+eQ9cqIL5fPTqFSYyr+HuYOSHMTiIWn2fdSWG5R95/yRdzXcg
         Vs8A==
X-Gm-Message-State: AOAM532mIhY0nu0EGyiAlOdWfovTT7Bz+5aJWjk5K1tJ3f/rd6ez/rN/
        duBaajZMFOTzKnnEX2rPneFETrTwSB6b8sDwwGAHgxQAGKY/uN1rZ/Uy5crWs8Vy/i5in06fG+j
        LZLREhcg40WiVi8zlrczy
X-Received: by 2002:a63:1820:: with SMTP id y32mr869635pgl.157.1616549225873;
        Tue, 23 Mar 2021 18:27:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzMaA0pwpvJrKtkJckcxMdamqjfeMrKuldvL3h3Ohbh3cSmuR/7WQOWpsyK9bwn6NJ+blunQ==
X-Received: by 2002:a63:1820:: with SMTP id y32mr869625pgl.157.1616549225611;
        Tue, 23 Mar 2021 18:27:05 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v18sm420651pgo.0.2021.03.23.18.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 18:27:05 -0700 (PDT)
Date:   Wed, 24 Mar 2021 09:26:55 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/7] repair: Phase 6 performance improvements
Message-ID: <20210324012655.GA2245176@xiangao.remote.csb>
References: <20210319013355.776008-1-david@fromorbit.com>
 <20210319013845.GA1431129@xiangao.remote.csb>
 <20210319182221.GU22100@magnolia>
 <20210320020931.GA1608555@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210320020931.GA1608555@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave and Darrick,

On Sat, Mar 20, 2021 at 10:09:31AM +0800, Gao Xiang wrote:
> On Fri, Mar 19, 2021 at 11:22:21AM -0700, Darrick J. Wong wrote:
> > On Fri, Mar 19, 2021 at 09:38:45AM +0800, Gao Xiang wrote:
> > > On Fri, Mar 19, 2021 at 12:33:48PM +1100, Dave Chinner wrote:
> > > > Hi folks,
> > > > 
> > > > This is largely a repost of my current code so that Xiang can take
> > > > over and finish it off. It applies against 5.11.0 and the
> > > > performance numbers are still valid. I can't remember how much of
> > > > the review comments I addressed from the first time I posted it, so
> > > > the changelog is poor....
> > > 
> > > Yeah, I will catch what's missing (now looking the previous review),
> > > and follow up then...
> > 
> > :)
> > 
> > While you're revising the patches, you might as well convert:
> > 
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > into:
> > 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > because Exchange is so awful for inline replies that I don't use that
> > email address anymore.
> 
> Yeah, I'm just starting sorting out all previous opinions
> and patches diff. Will update in the next version.
> 

Sorry for bothering... After reading the previous discussion for a while,
I'm fine with the trivial cleanups. Yet, it seems that there are mainly 2
remaining open discussions unsolved yet...

1 is magic number 1000,
https://lore.kernel.org/r/20201029172045.GP1061252@magnolia

while I also don't have better ideas of this (and have no idea why queue
depth 1000 is optimal compared with other configurations), so it'd be better
to get your thoughts about this in advance (e.g. just leave it as-is, or...
plus, I don't have such test setting with such many cpus)

2 is the hash size modificiation,
https://lore.kernel.org/r/20201029162922.GM1061252@magnolia/

it seems previously hash entires are limited to 64k, and this patch relaxes
such limitation, but for huge directories I'm not sure the hash table
utilization but from the previous commit message it seems the extra memory
usage can be ignored.

Anyway, I'm fine with just leave them as-is if agreed on these.

Thanks,
Gao Xiang

> Thanks,
> Gao Xiang
> 
> > 
> > --D
> > 
> > > Thanks,
> > > Gao Xiang
> > > 
> > 

