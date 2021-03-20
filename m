Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DD7C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Mar 2021 02:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC8126197F
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Mar 2021 02:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhCTCJ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 22:09:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31442 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229512AbhCTCJs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Mar 2021 22:09:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616206186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0C0oSk8sjoBBt4yGuT8zcKdxgJ4m7PJpplto9j1nBxc=;
        b=dVq0XIsO1Po8Dj+Rl0drrwrnlRAR9ftwvOo2YKYfxE0MDACBzs73njH7E/C46MdpKZyQ/u
        ZhQMbmw/MoxmjLjGJiHY6YDTJVp0eoNsAlV3C4JbO+3zSACit1ik2Jcdivp9H1nfQUhEBG
        eIREkCbS/OtHsC/vi362oTT5rxJMcs0=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-WzYQb-OiO5qE86l1zuBxJA-1; Fri, 19 Mar 2021 22:09:44 -0400
X-MC-Unique: WzYQb-OiO5qE86l1zuBxJA-1
Received: by mail-pg1-f198.google.com with SMTP id p1so25608510pgi.16
        for <linux-xfs@vger.kernel.org>; Fri, 19 Mar 2021 19:09:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0C0oSk8sjoBBt4yGuT8zcKdxgJ4m7PJpplto9j1nBxc=;
        b=XWnVjdEMEndvWKC6oT05cpPLY4Juws9VBNlUPfzFal1dvCX9kp2LyZnBtTJ0ADPa9t
         flddNPurND4fPPckbjmVYaC//2ds0sNDz9Dzv6NZWPuTZr40gZmjkNtLW738WIh2lfb9
         1HDCPSuxU1P69uL67aJ1cI1jDtMTUYZT9ceqoxcxjsEfivNwLhvacHf71F4I/G0OObhA
         Yog3S/gN+RZHUvDLkQXEGuJlTcrL92D9rOQKmZsisJ1S09MPWosiHJy1g/RT8YFhJkBN
         0lI/Pth1/D9ti6hl5So4sBIu6iEvrQ2vP7Hm8rsE8foFySNkR1NqzzBYKoteAUzopqvE
         g9Jg==
X-Gm-Message-State: AOAM532eQO1JQQkNZbtALZjAJbL1wOH3xefL+79Hmw7tjVZIn+iOd5K9
        2ZJq1mQD2LJfqEixQb9ZvTpF64xb4PQ1JrNYjG0+H6XJgWyqmmdJc46yheLU1m/a/Spzve25Prc
        PF/KC23LMxAHG4drf0SrG
X-Received: by 2002:a62:5e02:0:b029:1ed:8bee:6132 with SMTP id s2-20020a625e020000b02901ed8bee6132mr12071284pfb.48.1616206182995;
        Fri, 19 Mar 2021 19:09:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqgavdds5As5oDWZYzTK3oCYiyBcBnIzesbXU/vnBtLzKgXynrKG/ZGg7RoHsqNpBZ81HHKw==
X-Received: by 2002:a62:5e02:0:b029:1ed:8bee:6132 with SMTP id s2-20020a625e020000b02901ed8bee6132mr12071272pfb.48.1616206182748;
        Fri, 19 Mar 2021 19:09:42 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l3sm6560134pfc.81.2021.03.19.19.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 19:09:42 -0700 (PDT)
Date:   Sat, 20 Mar 2021 10:09:31 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/7] repair: Phase 6 performance improvements
Message-ID: <20210320020931.GA1608555@xiangao.remote.csb>
References: <20210319013355.776008-1-david@fromorbit.com>
 <20210319013845.GA1431129@xiangao.remote.csb>
 <20210319182221.GU22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210319182221.GU22100@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 11:22:21AM -0700, Darrick J. Wong wrote:
> On Fri, Mar 19, 2021 at 09:38:45AM +0800, Gao Xiang wrote:
> > On Fri, Mar 19, 2021 at 12:33:48PM +1100, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > This is largely a repost of my current code so that Xiang can take
> > > over and finish it off. It applies against 5.11.0 and the
> > > performance numbers are still valid. I can't remember how much of
> > > the review comments I addressed from the first time I posted it, so
> > > the changelog is poor....
> > 
> > Yeah, I will catch what's missing (now looking the previous review),
> > and follow up then...
> 
> :)
> 
> While you're revising the patches, you might as well convert:
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> into:
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> because Exchange is so awful for inline replies that I don't use that
> email address anymore.

Yeah, I'm just starting sorting out all previous opinions
and patches diff. Will update in the next version.

Thanks,
Gao Xiang

> 
> --D
> 
> > Thanks,
> > Gao Xiang
> > 
> 

