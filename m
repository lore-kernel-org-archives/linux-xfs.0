Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A083C7EE2A
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 22:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjEQWLj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 May 2023 18:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjEQWLh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2023 18:11:37 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1ADA30E6
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 15:11:36 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1ae4f28454bso10594305ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 15:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684361496; x=1686953496;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HqDaQVw3Us3Yxixpj/wi6ttDpBT3+i46/Yur+ix1SDQ=;
        b=cRTFDQc4i30qW8BHRDgqrci7SMSETpLevWrkMvHmGKdAUp8Io3DppNRa4LDTI1rvM1
         raGaZR9fIJduNz5fXkwpgFDZHD780Zdlt9BKXbS4c6nTJcHzIbsiqJniJYkcDA38m/oE
         /4EmBl3fP44crzr0HrON7+MvfINqAg/nzOozRjda7hbpEgFqmBFz3FTzv5tZj8R15fYm
         rpp76SDa+e+MbXn5jYPn6cHoTnDCNErVaPYVh1BrQm6tz829le3a4mXCHg6njXDOgWUM
         FzS1XgUcPJwZ2HKdMVHId9bJBO10trytXLZrLwmbsY6diWG8ulS6yuFNWy/ylVFcTTGF
         xx7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684361496; x=1686953496;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HqDaQVw3Us3Yxixpj/wi6ttDpBT3+i46/Yur+ix1SDQ=;
        b=CYPs7U4S1j/mmQtrWCl26Q2bRxHgh6VXXTnR2fsW6tGE62PKRBZEj1Zh7xCQQkMkhB
         /Mz2JPZYsM10DNKcfcrviSAJEUTFE1WkEi22cJBxVME+xD4ymNJ3fgtcg/bTwVZj97V/
         uwfKFPLVOtbMb7cW/bN4KR2QRHsnObgecsk49S4EY/n//froFDzzyrp3bz7/w92pAg0T
         mciojzu8oioIYl8fR06RvAkHnZKQzAtfDDswM0PsXwf74MivCSRRV79S0Cg5LGi6QPAr
         BQK+A/GE9t+yTEpp8KDFWcOEDWIADwmeT0GnEsG7CfK5aMF+lU4eA22SPuv9ZhPfZaMx
         seGw==
X-Gm-Message-State: AC+VfDyJPEKFuBMQCU/nga9gYWBNegXzNrrODAvHa44WfhV6hTnURf+k
        oO6fLU5glFC8g5FfhrEJkcZh0q2tvJFy4KTQg4w=
X-Google-Smtp-Source: ACHHUZ6mfy8CnmU8Nm/8s7+M6U9UV9M8Z8SAJvmutJENHaJuxHe1KAMz4LWHN8Ds8nYBYksnRzXpyQ==
X-Received: by 2002:a17:903:192:b0:1ac:7260:80a7 with SMTP id z18-20020a170903019200b001ac726080a7mr305130plg.43.1684361496111;
        Wed, 17 May 2023 15:11:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id o6-20020a170902bcc600b001ae0a4b1d3fsm8175842pls.153.2023.05.17.15.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 15:11:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1pzPMq-000iHB-0u;
        Thu, 18 May 2023 08:11:32 +1000
Date:   Thu, 18 May 2023 08:11:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: performance regression between 6.1.x and 5.15.x
Message-ID: <ZGVRFAH2QKwpcPBD@dread.disaster.area>
References: <20230510165055.01D5.409509F4@e16-tech.com>
 <20230511013410.GY3223426@dread.disaster.area>
 <20230517210740.6464.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517210740.6464.409509F4@e16-tech.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 17, 2023 at 09:07:41PM +0800, Wang Yugui wrote:
> > This indicates that 35% of writeback submission CPU is in
> > __folio_start_writeback(), 13% is in folio_clear_dirty_for_io(), 8%
> > is in filemap_get_folios_tag() and only ~8% of CPU time is in the
> > rest of the iomap/XFS code building and submitting bios from the
> > folios passed to it.  i.e.  it looks a lot like writeback is is
> > contending with the incoming write(), IO completion and memory
> > reclaim contexts for access to the page cache mapping and mm
> > accounting structures.
> > 
> > Unfortunately, I don't have access to hardware that I can use to
> > confirm this is the cause, but it doesn't look like it's directly an
> > XFS/iomap issue at this point. The larger batch sizes reduce both
> > memory reclaim and IO completion competition with submission, so it
> > kinda points in this direction.
> > 
> > I suspect we need to start using high order folios in the write path
> > where we have large user IOs for streaming writes, but I also wonder
> > if there isn't some sort of batched accounting/mapping tree updates
> > we could do for all the adjacent folios in a single bio....
> 
> 
> Is there some comment from Matthew Wilcox?
> since it seems a folios problem?

None of these are new "folio problems" - we've known about these
scalability limitations of page-based writeback caching for over 15
years. e.g. from 2006:

https://www.kernel.org/doc/ols/2006/ols2006v1-pages-177-192.pdf

The fundamental problem is the huge number of page cache objects
that buffered IO must handle when moving multiple GB/s to/from
storage devices. Folios offer a way to mitigate that by reducing
the number of page cache objects via using large folios in the
write() path, but we have not enabled that functionality yet.

If you want to look at making the iomap path and filemap_get_folio()
paths allocate high order folios, then that will largely mitigate
the worst of the performance degredation.

Another possible avenue is to batch all the folio updates in the IO
completion path. We currently do that one folio at a time, so a
typical IO might be doing a several dozen (or more) page cache
updates that largely could be done as a single update per IO. Worse
is that these individual updates are typically done under exclusive
locking, so this means the lock holds are no only more frequent than
they need to be, they are also longer than they need to be.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
