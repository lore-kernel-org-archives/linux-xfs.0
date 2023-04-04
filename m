Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A3A1C6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 23:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236064AbjDDXai (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 19:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjDDXai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 19:30:38 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236FA171A
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 16:30:37 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso35565286pjb.2
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 16:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1680651036;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vUXX2qCMFyorNG/8GNmEJb965QnYIz3xjvMWdzo8/fE=;
        b=tOtEuPnFTEBMtqRjG/Z8Q2RNRFzft4i/NO7xq5jxwsTP9QHHk7vGkYcbsggsWHIipa
         xZ86QY7tiSB4wbXepT3wj38sa/JJn+FHqYd0x/wPiBcOrs0u0uP+tLPtmVnECWees0Lq
         GQRF8prFcD7L9pUcMPVWm3pvY8m/h06LiA0VCxYXLW1JUpCD+gGbNx2Fe64+IaZY3NVZ
         b0WZjOrxkUZs5rWrdAeuZOLcS8jUyy71kUmT2HevZg7vK96jl4fRvRI3BW2M6DWN8QgW
         SWAMz5qH421V6z5noV+vZy7V9YyMJcD0epJgBJiMJcDotw52VU0y2Bh+r6+zSWVvJwzv
         t3Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680651036;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vUXX2qCMFyorNG/8GNmEJb965QnYIz3xjvMWdzo8/fE=;
        b=oR97cezDO9qw7rr2mK+F+jpIqLPFAOqgwT8Jt1mqIzKwmGpOqJKq1cCDmB/aJ96LMV
         B2yt9rDpqVJ2g6xqof9DFR9yU3UHT5mQvEYUt7srv0BgffHK+zGHbH+7/cUfhcm3SWa3
         8gI36l6ybXxmM0OULqaHiNFmpIVMOySkM7u2Cc/aZEQvsRo5zxNy/ETe2YDxxuDnoh0p
         ZKOczPoX1CaOWFMztKh1gYGgVvh4q7Cl9my4zVANWEWiN+pPwWcUyfiNzIWcvvGb5IzS
         cd8scrsrS9hw2rzbSvfnsV9l0EdXlv2xoYgJ+YWOIo5hrcx3jV96thU5YdRZyhtcI0NH
         2sjg==
X-Gm-Message-State: AAQBX9eDZL4vpgZuEQyQWFkTPcnkm6duUPmjpzuxFpvDae1XwjBwRJoG
        BVX9DBSXEjgMIFg59h4hHwTTeYoSdvNOXtpHtkM=
X-Google-Smtp-Source: AKy350ZAzRgIFBF/fgVbH5EDZsNO2dVYe3nNEpkGcnpZpx5TjJiRqYh0o3SsD4XGQPPo6A8DX8o5Mw==
X-Received: by 2002:a17:903:228e:b0:1a1:a727:a802 with SMTP id b14-20020a170903228e00b001a1a727a802mr643902plh.19.1680651036571;
        Tue, 04 Apr 2023 16:30:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-91-157.pa.nsw.optusnet.com.au. [49.181.91.157])
        by smtp.gmail.com with ESMTPSA id jf2-20020a170903268200b001a27e5ee634sm8865453plb.33.2023.04.04.16.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 16:30:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pjq6i-00H7IJ-S7; Wed, 05 Apr 2023 09:30:32 +1000
Date:   Wed, 5 Apr 2023 09:30:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: stabilize the tolower function used for
 ascii-ci dir hash computation
Message-ID: <20230404233032.GL3223426@dread.disaster.area>
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <168062802637.174368.12108206682992075671.stgit@frogsfrogsfrogs>
 <CAHk-=whe9kmyMojhse3cZ-zpHPfvGf_bA=PzNfuV0t+F5S1JxA@mail.gmail.com>
 <20230404183214.GG109974@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230404183214.GG109974@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 04, 2023 at 11:32:14AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 04, 2023 at 10:54:27AM -0700, Linus Torvalds wrote:
> > On Tue, Apr 4, 2023 at 10:07 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > +       if (c >= 0xc0 && c <= 0xd6)     /* latin A-O with accents */
> > > +               return true;
> > > +       if (c >= 0xd8 && c <= 0xde)     /* latin O-Y with accents */
> > > +               return true;
> > 
> > Please don't do this.
> > 
> > We're not in the dark ages any more. We don't do crazy locale-specific
> > crud. There is no such thing as "latin1" any more in any valid model.
> > 
> > For example, it is true that 0xC4 is 'Ä' in Latin1, and that the
> > lower-case version is 'ä', and you can do the lower-casing exactly the
> > same way as you do for US-ASCII: you just set bit 5 (or "add 32" or
> > "subtract 0xE0" - the latter is what you seem to do, crazy as it is).
> > 
> > So the above was fine back in the 80s, and questionably correct in the
> > 90s, but it is COMPLETE GARBAGE to do this in the year 2023.
> 
> Yeah, I get that.  Fifteen years ago, Barry Naujok and Christoph merged
> this weird ascii-ci feature for XFS that purportedly does ... something.
> It clearly only works properly if you force userspace to use latin1,
> which is totally nuts in 2023 given that the distros default to UTF8
> and likely don't test anything else.  It probably wasn't even a good
> idea in *2008*, but it went in anyway.  Nobody tested this feature,
> metadump breaks with this feature enabled, but as maintainer I get to
> maintain these poorly designed half baked projects.

It was written specifically for a NFS/CIFS fileserver appliance
product and Samba needed filesystem-side CI to be able to perform
even vaguely well on industry-standard fileserver benchmarketing
workloads that were all the rage at the time.

Because of the inherent problems with CI and UTF-8 encoding, etc, it
was decided that Samba would be configured to export latin1
encodings as that covered >90% of the target markets for the
product. Hence the "ascii-ci" casefolding code could be encoded into
the XFS directory operations and remove all the overhead of
casefolding from Samba.

In various "important" directory benchmarketing workloads, ascii-ci
resulted in speedups of 100-1000x. These were competitive results
comapred to the netapp/bluearc/etc appliances of the time in the
same cost bracket.  Essentially, it was a special case solution to
meet a specific product requirement and was never intended to be
used outside that specific controlled environment.

Realistically, this is the one major downside of "upstream first"
development principle.  i.e. when the vendor product that required
a specific feature is long gone, upstream still has to support that
functionality even though there may be no users of it remaining
and/or no good reason for it continuing to exist.

I'd suggest that after this is fixed we deprecate ascii-ci and make
it go away at the same time v4 filesystems go away. It was, after
all, a feature written for v4 filesystems....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
