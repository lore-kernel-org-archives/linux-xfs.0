Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF43C5479D
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Jan 2023 00:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjALA3l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Jan 2023 19:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjALA3k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2023 19:29:40 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955E81DDC7
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2023 16:29:39 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id jn22so18527777plb.13
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2023 16:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kdjJ+qFPHeS00NuxsuodVT0aLef/544WpbdFPG95vJc=;
        b=daIIUN9/u4Kn/9NvlKYXfIj5izCgVmqoQZkPuNo3ujpktk9/zGBnZRjcDxCNhHL1Qe
         NNJOPEKKIW02Ps5O+ZHH+OsXiP8BNcTus40O8FHtXyiCosEDynWf/SrqhFaRwVKNoiqA
         oT/uzjEsrr97r7K8jJudZAm7v9zVGfsvljXS7f/FfOEjb2sRoNQstEBUVVZHJqZ+xCdQ
         7AdDFUZEpv2NYUpgpHIGxi736F93t8iPIllmDMmRnqEqCef4wYa4/YqRefQJXDLbN0vR
         PNXzRqfKLissxNE66cd7YaV5xrpl4esALfpVL4zdcyx7eW7e+MDlZn13dGMSLg1ah/vT
         9x0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdjJ+qFPHeS00NuxsuodVT0aLef/544WpbdFPG95vJc=;
        b=COrCREKlB71ZZJkEjaNpJe8/MLoXwkuY1F5Jpvsnt6Ao5I2NHo/V0AdLWAny2nbNxR
         OBTShc94L2OfXSrh+we8kqjkmmItEKwPxbPT8FmdH/lKnDmOMaKEHRv+DeRcEZtaYSFs
         +8MgC2odloPplcn5NOvfleNAZylpVw8VAop5uogIY6pK4iGQRsqdDtfHiTYaMOV+YRRy
         OyXRn+n50xef/7o1jV4E665l9AUfczN8qDEDiPbXY8u9Ggey1hVM4I8uTUt+yBPB7mQ6
         OJOInbQ82gQPM8VPl0dfB6za6PDjJqYKCm9OQPF16D9kMn37rgHeJr/jYYXrJsB4ktfa
         Pu9g==
X-Gm-Message-State: AFqh2krHObnF7DZnoQSvRTA68DNcYLd+DqB5LHiWyLs6RfUbpQkQ/J1v
        M48ZedSNeFONg8yQnxqhdP9Bpg==
X-Google-Smtp-Source: AMrXdXvDN7KNcW+rVaCYvuc2ZDsQTd8oduFefihia9SWmhk9PtRvfRa1f5oPODbU2jAm5uDd4h04Ng==
X-Received: by 2002:a17:902:e345:b0:192:b3d5:44ff with SMTP id p5-20020a170902e34500b00192b3d544ffmr38335681plc.26.1673483379139;
        Wed, 11 Jan 2023 16:29:39 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id o14-20020a170902d4ce00b001886ff822ffsm4210774plg.186.2023.01.11.16.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 16:29:38 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pFlTL-001z5b-LR; Thu, 12 Jan 2023 11:29:35 +1100
Date:   Thu, 12 Jan 2023 11:29:35 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Chandan Babu <chandan.babu@oracle.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 02/14] xfs: document the general theory underlying online
 fsck design
Message-ID: <20230112002935.GD360264@dread.disaster.area>
References: <167243825144.682859.12802259329489258661.stgit@magnolia>
 <167243825188.682859.4316880168755743654.stgit@magnolia>
 <e195587838b284fea6e27934d4bdee210851a40e.camel@oracle.com>
 <Y79InBUODrIaLDmC@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y79InBUODrIaLDmC@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 11, 2023 at 03:39:08PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 11, 2023 at 01:25:12AM +0000, Allison Henderson wrote:
> > On Fri, 2022-12-30 at 14:10 -0800, Darrick J. Wong wrote:
> > > +Primary metadata objects are the simplest for scrub to process.
> > > +The principal filesystem object (either an allocation group or an
> > > inode) that
> > > +owns the item being scrubbed is locked to guard against concurrent
> > > updates.
> > > +The check function examines every record associated with the type
> > > for obvious
> > > +errors and cross-references healthy records against other metadata
> > > to look for
> > > +inconsistencies.
> > > +Repairs for this class of scrub item are simple, since the repair
> > > function
> > > +starts by holding all the resources acquired in the previous step.
> > > +The repair function scans available metadata as needed to record all
> > > the
> > > +observations needed to complete the structure.
> > > +Next, it stages the observations in a new ondisk structure and
> > > commits it
> > > +atomically to complete the repair.
> > > +Finally, the storage from the old data structure are carefully
> > > reaped.
> > > +
> > > +Because ``xfs_scrub`` locks a primary object for the duration of the
> > > repair,
> > > +this is effectively an offline repair operation performed on a
> > > subset of the
> > > +filesystem.
> > > +This minimizes the complexity of the repair code because it is not
> > > necessary to
> > > +handle concurrent updates from other threads, nor is it necessary to
> > > access
> > > +any other part of the filesystem.
> > > +As a result, indexed structures can be rebuilt very quickly, and
> > > programs
> > > +trying to access the damaged structure will be blocked until repairs
> > > complete.
> > > +The only infrastructure needed by the repair code are the staging
> > > area for
> > > +observations and a means to write new structures to disk.
> > > +Despite these limitations, the advantage that online repair holds is
> > > clear:
> > > +targeted work on individual shards of the filesystem avoids total
> > > loss of
> > > +service.
> > > +
> > > +This mechanism is described in section 2.1 ("Off-Line Algorithm") of
> > > +V. Srinivasan and M. J. Carey, `"Performance of On-Line Index
> > > Construction
> > > +Algorithms" <https://dl.acm.org/doi/10.5555/645336.649870>`_,
> > Hmm, this article is not displaying for me.  If the link is abandoned,
> > probably there's not much need to keep it around
> 
> The actual paper is not directly available through that ACM link, but
> the DOI is what I used to track down a paper copy(!) of that paper as
> published in a journal.

PDF version here:

https://minds.wisconsin.edu/bitstream/handle/1793/59524/TR1047.pdf?sequence=1

-Dave.
-- 
Dave Chinner
david@fromorbit.com
