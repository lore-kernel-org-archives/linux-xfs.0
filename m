Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B57C2B9F7
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 11:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A012261248
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 11:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhEZLzt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 07:55:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27033 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232664AbhEZLys (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 07:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622029996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IHeisxzu8lF0mP/iUQT+KJQVCZzoy89Pa1g0ImJdlJY=;
        b=LY7fVEfF2jywvtGFjeE7Q539g9gI2vozKMAxf+nGjYcmXQfB2GpRrsFlR4icnDTtP99gla
        dzCrFI9qS3JRjCD+xaDJG6u3HV8wlCjgJIA2iu829uJaAR0EhVjfeb/s06woN6hcxYFdqU
        WR89kIDxD38O16mN2KRb8qf3+qWIBEk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-vTqiIC_0NgqOumbNHwGhSA-1; Wed, 26 May 2021 07:53:14 -0400
X-MC-Unique: vTqiIC_0NgqOumbNHwGhSA-1
Received: by mail-qv1-f71.google.com with SMTP id w4-20020a0c8e440000b02901f0640ffdafso993994qvb.13
        for <linux-xfs@vger.kernel.org>; Wed, 26 May 2021 04:53:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IHeisxzu8lF0mP/iUQT+KJQVCZzoy89Pa1g0ImJdlJY=;
        b=rWN+lo93esUD49MVRqDaETioHcxR9XGeupYXFeHn5WoTdiDKKAH8l3rjXacSU20rVl
         dFTTazP6ghilfJtqM+Ph//2Ze9TA7LLW8/zEN7ZKSnm2hfO3+KsbC/hdcoMQSRD95RvI
         14YAFfboi5WrFeW8kKQ4ILgSCdeUVAHjHqZokhKT7idqAPo406LobdezlhMe8aH23xH5
         RzEtutxJCPQPkIVkbbMvywi6D47dUPatWjzaq5O7HJLA9kqtp+VOhbZfqowzNbOPkSoa
         R1lSht14AGmF+hghQ9gum7F4yrht85T+/lpj+t/jfkOte8rj8p1ZFVr3NPzK31GU91i3
         /UuA==
X-Gm-Message-State: AOAM531qX6IzAO5/0WcOaQviRLnDn21a92f0466UjBg0pwkE5EVqWl9g
        CHcI7k1cnii8/agYLQLEWhfbVsa5Zz1x2ct00MKglVaq08L8cjKOwFBlqdEDZdJrOFNCATgkXK2
        E/puEtHjJyy+Opwfld6p1
X-Received: by 2002:a05:620a:10b5:: with SMTP id h21mr39637518qkk.261.1622029993815;
        Wed, 26 May 2021 04:53:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxv2Jvd0lLcvOhwHDNZzGpyogUpFHt3F2f6jz+w4p/srruiatyswmrgG93ID12SbSwH9SvVfQ==
X-Received: by 2002:a05:620a:10b5:: with SMTP id h21mr39637500qkk.261.1622029993588;
        Wed, 26 May 2021 04:53:13 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id b18sm1376775qkh.63.2021.05.26.04.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 04:53:13 -0700 (PDT)
Date:   Wed, 26 May 2021 07:53:11 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>
Subject: Re: patch review scheduling...
Message-ID: <YK42pwKb48UnzOpR@bfoster>
References: <20210526012704.GH202144@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526012704.GH202144@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 25, 2021 at 06:27:04PM -0700, Darrick J. Wong wrote:
> Hello list, frequent-submitters, and usual-reviewer-suspects:
> 
> As you've all seen, we have quite a backlog of patch review for 5.14
> already.  The people cc'd on this message are the ones who either (a)
> authored the patches caught in the backlog, (b) commented on previous
> iterations of them, or (c) have participated in a lot of reviews before.
> 
> Normally I'd just chug through them all until I get to the end, but even
> after speed-reading through the shorter series (deferred xattrs,
> mmaplock, reflink+dax) I still have 73 to go, which is down from 109
> this morning.
> 
> So, time to be a bit more aggressive about planning.  I would love it if
> people dedicated some time this week to reviewing things, but before we
> even get there, I have other questions:
> 
> Dave: Between the CIL improvements and the perag refactoring, which
> would you rather get reviewed first?  The CIL improvments patches have
> been circulating longer, but they're more subtle changes.
> 
> Dave and Christoph: Can I rely on you both to sort out whatever
> conflicts arose around reworking memory page allocation for xfs_bufs?
> 
> Brian: Is it worth the time to iterate more on the ioend thresholds in
> the "iomap: avoid soft lockup warnings" series?  Specifically, I was
> kind of interested in whether or not we should/could scale the max ioend
> size limit with the optimal/max io request size that devices report,
> though I'm getting a feeling that block device limits are all over the
> place maybe we should start with the static limit and iterate up (or
> down?) from there...?
> 

I was starting to think about the optimal I/O size thing yesterday given
the latest feedback. I think it makes sense and it's probably easy
enough to incorporate, but if you're asking me about patch processing
logistics, IMO none of the changes or outstanding feedback since the v2
(inline w/ v1) are terribly important to fix the original problem.

Most of the feedback since v2 has been additive (i.e. "fix this problem
too") or surmising about inconsequential things like cond_resched()
usage or whether the threshold should be defined based on pages or not.
v2 used a large threshold to avoid things like risk of
unintended/unexpected consequences causing a revert down the line and
reintroducing the soft lockup problem, which is otherwise easily fixable
without significant change to functional behavior (given the current
worst case of unbound aggregation). So since you ask and after having
thought about it, if you're looking for a targeted fix to merge sooner
rather than later I think the smart thing to do is stick with v2 and
rebase the subsequent changes to reduce interrupt context latency and
general completion latency on top of that. (In fact, I probably should
have done that for v3.)

Brian

> Everyone else: If you'd like to review something, please stake a claim
> and start reading.
> 
> Everyone else not on cc: You're included too!  If you like! :)
> 
> --D
> 

