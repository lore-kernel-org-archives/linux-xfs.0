Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDB5C4321E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Dec 2022 02:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiLACng (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Nov 2022 21:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiLACnf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2022 21:43:35 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC91A326CC
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 18:43:33 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so600293pjd.5
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 18:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oIfsju+FFj49HB7JpJx7BcFuQqxoVzT7pFhtla5kBbc=;
        b=Xpn5XkG4fEavYcL8QdoNnwS1c/sXEg+Q2wH/QmDGlMdsvEvm85GO+ObmFyFJVH2Eqt
         2oMj3016/WLtLyU33UNo+kmu0jTyi85FTVJKNaPYvLaTqHxFlbvfslmyktE1AluuEEO5
         HguvkZVGIRC5L+f1fxcZLxUfu2dUaR96VY3ca9grMfJeN5SHmyRuc7nGlLmijis25UmM
         hb5bRt2Pl3j/kiqDJNZ0fmWQ1jUevUe4JHN18v/ipbmXPFz4JHMbjNtpW1ffER0hT+oh
         jKeRg/ScOaHuFhcvs/+d16KQV0H2m8QT4jLmaJBV7yG3OqJlDSi2hBdRd1L1u3n0nJ1+
         l7Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oIfsju+FFj49HB7JpJx7BcFuQqxoVzT7pFhtla5kBbc=;
        b=LmhYTVcTCozFaZXHwdMc7DwQI3aCjC8QTZlyV8nDlSSYbETCCToMF7kch1z18Jvv3q
         0YGmiIgk+qExqF70dmH3vG0fcnpaY5cFVMbrnKnmAe8Xnqss58UCjrWXkFSLAG8gycfF
         ++FJJnRqvxcYMDjb3J0evxDENmjWiATQBO7NaK3niCELJN7GR/GTgZKsY6cIUlqjnKpL
         ghO4cdoXW4bu1QBlVwXhn3lGuU8RGIs3v+XzQFa6tlnvHlQsi99a34b0GqMW/hh+6ZBw
         ARf+P/r230w5RSFvwB85Nr3kHJLUpUVo8L/ZNQeww3xHAwyVKDSRcdYGNE34olirhGdS
         Qikw==
X-Gm-Message-State: ANoB5pn3zbopqgqddNmBg7WzTu+87KOoLHhpYh3j9QBPe93xdrv3n7IA
        NZOgv689As/JCQTY8UgzoOqRqEaFps3A9Q==
X-Google-Smtp-Source: AA0mqf5Rlb+Y2Lmx8+0JlEe6oEn76lX43Ws/Z+S3fI8YAmv7SK82WvgT70mNHl4/fkzFvwYIqU8xXA==
X-Received: by 2002:a17:902:6bc6:b0:186:fb90:5758 with SMTP id m6-20020a1709026bc600b00186fb905758mr46250243plt.115.1669862613371;
        Wed, 30 Nov 2022 18:43:33 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id z23-20020aa79497000000b0056bd59eaef0sm2067830pfk.4.2022.11.30.18.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 18:43:32 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p0ZXt-0033kZ-RT; Thu, 01 Dec 2022 13:43:29 +1100
Date:   Thu, 1 Dec 2022 13:43:29 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] [RFC] iomap: zeroing needs to be pagecache aware
Message-ID: <20221201024329.GN3600936@dread.disaster.area>
References: <20221201005214.3836105-1-david@fromorbit.com>
 <Y4gMhHsGriqPhNsR@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4gMhHsGriqPhNsR@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 30, 2022 at 06:08:04PM -0800, Darrick J. Wong wrote:
> On Thu, Dec 01, 2022 at 11:52:14AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Unwritten extents can have page cache data over the range being
> > zeroed so we can't just skip them entirely. Fix this by checking for
> > an existing dirty folio over the unwritten range we are zeroing
> > and only performing zeroing if the folio is already dirty.
> 
> Hm, I'll look at this tomorrow morning when I'm less bleary.  From a
> cursory glance it looks ok though.
> 
> > XXX: how do we detect a iomap containing a cow mapping over a hole
> > in iomap_zero_iter()? The XFS code implies this case also needs to
> > zero the page cache if there is data present, so trigger for page
> > cache lookup only in iomap_zero_iter() needs to handle this case as
> > well.
> 
> I've been wondering for a while if we ought to rename iomap_iter.iomap
> to write_iomap and iomap_iter.srcmap to read_iomap, and change all the
> ->iomap_begin and ->iomap_end functions as needed.  I think that would
> make it more clear to iomap users which one they're supposed to use.
> Right now we overload iomap_iter.iomap for reads and for writes if
> srcmap is a hole (or SHARED isn't set on iomap) and it's getting
> confusing to keep track of all that.

*nod*

We definitely need to clarify this - I find the overloading
confusing at the best of times.  No idea what the solution to this
looks like, though...

> I guess the hard part of all that is that writes to the pagecache don't
> touch storage; and writeback doesn't care about the source mapping since
> it's only using block granularity.

Yup, that's why this code needs the IOMAP_F_STALE code to be in
place before we can use the page cache lookups like this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
