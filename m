Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C20CCC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Nov 2022 00:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiKPA53 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Nov 2022 19:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiKPA52 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2022 19:57:28 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBB63204D
        for <linux-xfs@vger.kernel.org>; Tue, 15 Nov 2022 16:57:27 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id c15-20020a17090a1d0f00b0021365864446so845726pjd.4
        for <linux-xfs@vger.kernel.org>; Tue, 15 Nov 2022 16:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H06oQQHBFOJW8pw2jS0c6jV1S5y28zjyrixRsNPgW0Q=;
        b=HI4ITdJnZ1QlzhiDZG8cev0p44OiRsy1fMHTso+5bebi+FCE8U4VBFNDdaAUQkVfC/
         72QHcWTkqCGjkA9G3rbLE7hHZrEJaHcbSse+bRCWixhyVlCxfViu+6/jWce51S3OjSYT
         loNiWTjnX+Bqdvj3IaTI1ISTyeF1kugMkrTn3Iw9RGlf1N6PRjddQ083749FV0T6F8tg
         lGPDyHYkzVxsx/OamFSPMvfA20NYHyUpJo3SUjX9Rjpj4x96ldWLcZ8usTW+mIK2nGUw
         QIketR4+dfspx6nqlgTjSTcQmmC2i3yV2o/kE7py/sUsJ2YsiPZiELLjh1eVrpKA1S1h
         MPPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H06oQQHBFOJW8pw2jS0c6jV1S5y28zjyrixRsNPgW0Q=;
        b=0PORCVW2vWYDRz98b5mt+/XdqpUO/kdA/cVdLhd3wO53OAWXuaZ1ZTZ3b0gSSefQuX
         Oud2KCfVhvUlY14m+m5FRBoHisNOV7SZuRIZyeAykTHsZHn4dChizJQtw2fJ1g8Uy8S0
         i/+Zwhtx9UKZ9jrtqcGGEYZ8v3SGAyUVokFcMEzal+2PKN02EhxfFRKonWuIAXvbkyBD
         zv6gZ+M0tyAPFuHHdAg9s3tZhCgDh/WamGsERtiAAHOznlOAZgPJVR3EOdyW3IRJzSIN
         9e/VSu8gD4HWxakyfZKyb0U6FaR35c6EehyBkeVDGP53lMkroLpNO0lHVSptLgj/vITf
         Ty0g==
X-Gm-Message-State: ANoB5pkgttjqTJyu2EZzW0GtU1bvQcnYdAYqHo1ecfH5WWAtutL+ZG7L
        WRQN0upCtrl2b61vp66aJjHPrQ==
X-Google-Smtp-Source: AA0mqf4tTcINpQhCQSelNAY/ulYfrY350QUXdEI8ey/EHpUUfK2L8jxk7ANheUHMVzA4IwCsGl0IAA==
X-Received: by 2002:a17:90a:7d09:b0:213:971d:902e with SMTP id g9-20020a17090a7d0900b00213971d902emr1072490pjl.123.1668560247065;
        Tue, 15 Nov 2022 16:57:27 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id b24-20020aa79518000000b0056afd55722asm9403628pfp.153.2022.11.15.16.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 16:57:26 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ov6jz-00Ei8u-W4; Wed, 16 Nov 2022 11:57:24 +1100
Date:   Wed, 16 Nov 2022 11:57:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 6/9] xfs: xfs_bmap_punch_delalloc_range() should take a
 byte range
Message-ID: <20221116005723.GA3600936@dread.disaster.area>
References: <20221115013043.360610-1-david@fromorbit.com>
 <20221115013043.360610-7-david@fromorbit.com>
 <Y3NRfgxWcenyCe+i@infradead.org>
 <Y3Qhbi0aGDe+QG22@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3Qhbi0aGDe+QG22@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 15, 2022 at 03:48:33PM -0800, Darrick J. Wong wrote:
> On Tue, Nov 15, 2022 at 12:44:46AM -0800, Christoph Hellwig wrote:
> > On Tue, Nov 15, 2022 at 12:30:40PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > All the callers of xfs_bmap_punch_delalloc_range() jump through
> > > hoops to convert a byte range to filesystem blocks before calling
> > > xfs_bmap_punch_delalloc_range(). Instead, pass the byte range to
> > > xfs_bmap_punch_delalloc_range() and have it do the conversion to
> > > filesystem blocks internally.
> > 
> > Ok, so we do this here.   Why can't we just do this earlier and
> > avoid the strange inbetween stage with a wrapper?
> 
> Probably to avoid rewriting the previous patch with this units change,
> is my guess.  Dave, do you want to merge with this patch 4?  I'm
> satisfied enough with patches 4 and 6 that I'd rather get this out to
> for-next for further testing than play more patch golf.

The fact that Christoph NAK'd exporting mapping_seek_hole_data()
this time around is just Plain Fucking Annoying. He didn't say
anything in the last thread about it after I explained why I used
it, so I had assumed it was all OK.

I've already been playing patch golf all morning now to rearrange
all the deck chairs to avoid exporting mapping_seek_hole_data().
Instead we now have an exported iomap function that wraps
mapping_seek_hole_data, and the wrapper function I added in patch 4
is now the callback function that is passed 3 layers deep into the
iomap code.

Hence the xfs_buffered_write_delalloc_punch() function needs to
remain - we can't elide it entire like this patch does - because now
we need a callback function that we can provide to the iomap code so
we avoid coupling internal XFS implementation functions to external
VFS APIs.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
