Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A71C001DE
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jul 2023 21:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbjG1Vmi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jul 2023 17:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjG1Vmh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jul 2023 17:42:37 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F151A4209
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jul 2023 14:42:36 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-686f0d66652so2363305b3a.2
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jul 2023 14:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690580556; x=1691185356;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ji2JmgANPkKCfNTtddmVRk0V5dVnD3AEkl+JScVn8bk=;
        b=ZUjHAtOuLCvy5ZIYbMB1q0rc+WPTGeuLd8vfAwBCpGjp8RnybjYObyDgF3l/QzMuMX
         PwXRtFPyMtXztiz5RaPQSKfXorMxTIILWxxHappI8VAxdWTcGTA9Lqzchx2Tq8iRYBTM
         mYzDdKcIVr3ijjaI599w8cRveMdDD7T9A1+Q2UsvIXFvJk2u+a2MTn4LRWjmIjylnUZ8
         SVoaEYMj0THEBYbuVpLuN1dK/qzDfy0MmAMX9GY30cpw+X9KlBcLjz9e5qDswuxO9X5i
         8delmO6FnlQqWel5s4xo1W+a1DSKsKdDMfmvU54BeyhnVdJ0U/UrHLYMTjcfBe3lKriq
         hLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690580556; x=1691185356;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ji2JmgANPkKCfNTtddmVRk0V5dVnD3AEkl+JScVn8bk=;
        b=DDPDq+OY+rWlYPbsc/jOmcvqitUsYDJt9dlyUdhTerzWV6fCH3E5hFSH3gjRKglhc4
         R3Fc6XMBWiSAMe7+EjNOYntcRRM/qhsuptAHDTvoHWXLs+DvqX+0YrW3fWfVmmYgocZo
         rfhXYE4YVcjYTl4XglzFGCfzTAc6RZjIruFy88vDgDHPE7UNThekZQCMYtnt1T1jpTj1
         WPAXsFFBg0GNWH42PTqoc3nx+KhxXgOupxcbguY+LldADb2H1qtexmcT0Tsb1iCbxhCz
         FIr7A45WGj4T279wUiBWdW/CWspriGUa5ryUOmRapEHmY+BwPg74tHwtEBIal4WWJdKX
         mpXw==
X-Gm-Message-State: ABy/qLbdgvlxJtfpkbPoZJSioHiCg10zDpnFDG52nlu4HuDU3VFpUo33
        H5px4HDglGCpg0cLE2gDt0AvpQ==
X-Google-Smtp-Source: APBJJlESyCkDw9MkfDpp+3EnmCnifsGfIbsP4QEz6/EWyfelUUTbfV0SKUMn9nJzgCo7LHQ5As3hlA==
X-Received: by 2002:a05:6a20:7352:b0:122:c6c4:36b1 with SMTP id v18-20020a056a20735200b00122c6c436b1mr3777151pzc.4.1690580556381;
        Fri, 28 Jul 2023 14:42:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id p5-20020a63ab05000000b0054fa8539681sm3998584pgf.34.2023.07.28.14.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 14:42:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qPVEG-00BhZJ-10;
        Sat, 29 Jul 2023 07:42:32 +1000
Date:   Sat, 29 Jul 2023 07:42:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, djwong@kernel.org
Subject: Re: [PATCHSET v6 0/8] Improve async iomap DIO performance
Message-ID: <ZMQ2SEVlqZ59NmSL@dread.disaster.area>
References: <20230724225511.599870-1-axboe@kernel.dk>
 <786a1eda-4592-789b-aaea-e70efbabeaa5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <786a1eda-4592-789b-aaea-e70efbabeaa5@kernel.dk>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 26, 2023 at 05:07:57PM -0600, Jens Axboe wrote:
> On 7/24/23 4:55?PM, Jens Axboe wrote:
> > Hi,
> > 
> > Hi,
> > 
> > This patchset improves async iomap DIO performance, for XFS and ext4.
> > For full details on this patchset, see the v4 posting:
> > 
> > https://lore.kernel.org/io-uring/20230720181310.71589-1-axboe@kernel.dk/
> > 
> >  fs/iomap/direct-io.c | 163 ++++++++++++++++++++++++++++++++-----------
> >  include/linux/fs.h   |  35 +++++++++-
> >  io_uring/rw.c        |  26 ++++++-
> >  3 files changed, 179 insertions(+), 45 deletions(-)
> > 
> > Can also be found here:
> > 
> > https://git.kernel.dk/cgit/linux/log/?h=xfs-async-dio.6
> > 
> > No change in performance since last time, and passes my testing without
> > complaints.
> > 
> > Changes in v6:
> > - Drop the polled patch, it's not needed anymore
> > - Change the "inline is safe" logic based on Dave's suggestions
> > - Gate HIPRI on INLINE_COMP|CALLER_COMP, so polled IO follows the
> >   same rules as inline/deferred completions.
> > - INLINE_COMP is purely for reads, writes can user CALLER_COMP to
> >   avoid a workqueue punt. This is necessary as we need to invalidate
> >   pages on write completions, and if we race with a buffered reader
> >   or writer on the file.
> 
> Dave, are you happy with this one?

I haven't had a chance to look at it yet. Had my head in log hang
bug reports these last few days...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
