Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B043DC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 20:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88E352075E
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 20:01:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aSjSuQso"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgHRUB6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 16:01:58 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20706 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726675AbgHRUB5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 16:01:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597780915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZWWapVsW4gpQEIu2n5B3MaMa4FVFV+urol1Vn5uNIWI=;
        b=aSjSuQsowm0SYVk+oEBCMUKwSaLnx0wCDV4jfZo4kIxTvqQByPmEhv20NKAkbnKrAaSqOp
        20gRLHvsLaA6xGdwO1AGQWzrt/D8UI3EGbPV5rtFl32aWGFmYLoZamIB+YxF8VBHFpKXSQ
        ZV3aegNjo1QVOtwp2TQ8vCDiQ1yR6kA=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-JYoVm-YHPK6kibU_fs4fmQ-1; Tue, 18 Aug 2020 16:01:53 -0400
X-MC-Unique: JYoVm-YHPK6kibU_fs4fmQ-1
Received: by mail-pf1-f200.google.com with SMTP id b16so9898059pft.18
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 13:01:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZWWapVsW4gpQEIu2n5B3MaMa4FVFV+urol1Vn5uNIWI=;
        b=qStIbSIOj+Av8PdTr84ARnuVdLiPs2amIyTqsIKEqi4Mw+rBsSTkQW6CWACT4RLe71
         6uBtOoXBxQRKcZujGZ83UOWBa/u2uB4O6OlAbUuJ3JL9H55JAiREY5m9pz3IQlk0d7Wp
         8wHdXpNMa3I9xtcaKURNrBSMkSe2ozDEI4SZLy4IYjlmMnrfKE8Pn9uOD4t+lhLGr1rp
         ScNENXFIPv02X5dqYQjZ7mF2FjNVQJLPlXSRIL+CUtKS85LwXnc7MB1Lur+ryKliW9kn
         7lwerFkeSuh90+cPyOB2uE1cMTi6+1Z/IZnW4Rc9GM5AYfM/4TNIvyUITiIZXGh6Wy42
         wnJA==
X-Gm-Message-State: AOAM532lmOZ4eVqOC1UnIQ8kksqDDjg2vEXNc0eoJ520VjO9K6ydSUbF
        guUrsm8mMLVqL4gpRVViEwlpK+ujoN1Uk06sfgfKtlrfNPdaiRZrBTaApPCxbAaYxJPnz3fGWki
        kaGgUDbQlfqNjWgqm/bRf
X-Received: by 2002:a65:6a55:: with SMTP id o21mr1690706pgu.64.1597780912324;
        Tue, 18 Aug 2020 13:01:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIh+DNWrBo3UKApdFeN2w1oC/ON2qmNuwAZOgsPOAiy4RKtSlwz6kVVld3Cv2wskuHFQVoFg==
X-Received: by 2002:a65:6a55:: with SMTP id o21mr1690682pgu.64.1597780912025;
        Tue, 18 Aug 2020 13:01:52 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h5sm26336470pfk.0.2020.08.18.13.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 13:01:51 -0700 (PDT)
Date:   Wed, 19 Aug 2020 04:01:41 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/13] xfs: in memory inode unlink log items
Message-ID: <20200818200141.GA11372@xiangao.remote.csb>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200818181745.GL6107@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818181745.GL6107@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 11:17:45AM -0700, Darrick J. Wong wrote:
> On Wed, Aug 12, 2020 at 07:25:43PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > This is a cleaned up version of the original RFC I posted here:
> > 
> > https://lore.kernel.org/linux-xfs/20200623095015.1934171-1-david@fromorbit.com/
> > 
> > The original description is preserved below for quick reference,
> > I'll just walk though the changes in this version:
> > 
> > - rebased on current TOT and xfs/for-next
> > - split up into many smaller patches
> > - includes Xiang's single unlinked list bucket modification
> > - uses a list_head for the in memory double unlinked inode list
> >   rather than aginos and lockless inode lookups
> > - much simpler as it doesn't need to look up inodes from agino
> >   values
> > - iunlink log item changed to take an xfs_inode pointer rather than
> >   an imap and agino values
> > - a handful of small cleanups that breaking up into small patches
> >   allowed.
> 
> Two questions: How does this patchset intersect with the other one that
> changes the iunlink series?  I guess the v4 of that series (when it
> appears) is intended to be applied directly after this one?

(confirmed from IRC) Yeah, I looked through this patchset these days
and sent out another rebased version and yes it can be applied directly
instead.

also put a link here:
https://lore.kernel.org/r/20200818133015.25398-1-hsiangkao@redhat.com

Sorry for that I shouldn't use --in-reply-to as deep as this way.

Thanks,
Gao Xiang

