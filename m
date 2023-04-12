Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4DEC7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 01:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjDLBEv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 21:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDLBEu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 21:04:50 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D25B3ABB
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 18:04:49 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id m18so9652545plx.5
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 18:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1681261489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UHPrm8+fNc340gvmuwxVGYY5bSW5rqb0R1ORM1Uwmao=;
        b=umzRb545rnWDkLY+XA6CThUZoM+8YMJNs6DYKoQvXXLO+knY0iqEV9RHLohzibB2xy
         7AI2eRIdAjwJep/IYExRvIIO0IHcSnH/BFxbUF2EHL9h4H75av1Ha5ICXVIRWbMgWMu1
         xyY8ERgJI/sOSZ+q8p66vjTMj8FewaupACOkK7XKWsyCNwNrNXav4buJz2i3/6Ot8UIT
         7ylX/63GZM8Zny6zoahhBGwROOMk94FcUbRs4x5lfIuQ0ZVc7nnSUwEu4ZLZczMWv6Rh
         5Q6SKjweAyyJ/XwXt8rX7sP1+bBs0Iq7e1xAz3WweoKnNBZWL4CUeQD6KlPhbMpj/TIp
         SaqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681261489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UHPrm8+fNc340gvmuwxVGYY5bSW5rqb0R1ORM1Uwmao=;
        b=dl1wGLhFAGRzFtoi8aodpCE7U9rcFLM3DPUQQG9e2R/tWi9I1zQtHLs7kX35abTNdy
         ig+pUeWVI4q2SvSixi2bG90PEPza0vQL62WcVYyCI1HoLe0Zx+V7VYwy83DkrmTq2YMW
         7r8frq2t/FWpPqVBRjZkDzZlTCK4gcdkAxXqt37Wg+sIMPQV8rE5MtN+JOeQfpU+Vwzg
         XRk3fhUKWOkpplFA9RNwohBAefqPXsUrNhS9lmhhfueOu/yPxLUgKuU/xMePLR65VabB
         My9kwTd++yQqmM6ykWtKma2SY4mfXupYPzKXMzz/nVv9bliG4T6ELNC3S0zjSEpbPj0n
         dbsg==
X-Gm-Message-State: AAQBX9cNPRIRrCArjs+94TQyNCf4zstXOjZtoFOjV93gKFH1ZsnVeb1S
        /O1SMBUTpCcLtigjZHZE4vlv6g==
X-Google-Smtp-Source: AKy350YmVakErORRlTOPJvRIF6fsmfhiQCJwhZ15abufamY9zBt3OXMO8RbbRf7n99YEZ283GfRh9Q==
X-Received: by 2002:a17:902:d4c3:b0:1a2:c05b:151c with SMTP id o3-20020a170902d4c300b001a2c05b151cmr5800747plg.34.1681261488963;
        Tue, 11 Apr 2023 18:04:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id x9-20020a1709028ec900b0019a773419a6sm10270058plo.170.2023.04.11.18.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 18:04:48 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pmOuj-002IyJ-5K; Wed, 12 Apr 2023 11:04:45 +1000
Date:   Wed, 12 Apr 2023 11:04:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     allison.henderson@oracle.com, dchinner@redhat.com, hch@lst.de,
        linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE online fsck 1/2] xfs-linux:
 scrub-strengthen-rmap-checking updated to d95b1fa39fab
Message-ID: <20230412010445.GH3223426@dread.disaster.area>
References: <168123761359.4118338.3332729538416597681.stg-ugh@frogsfrogsfrogs>
 <20230412002028.GG3223426@dread.disaster.area>
 <20230412002406.GO360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412002406.GO360889@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 05:24:06PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 12, 2023 at 10:20:28AM +1000, Dave Chinner wrote:
> > On Tue, Apr 11, 2023 at 11:29:58AM -0700, Darrick J. Wong wrote:
> > > Hi folks (mostly Dave),
> > > 
> > > The scrub-strengthen-rmap-checking branch of the xfs-linux repository at:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git
> > > 
> > > has just been updated for your review.  These are all the accumulated
> > > fixes for online scrub, as well as the design document for the entire
> > > online fsck effort.
> > > 
> > > This code snapshot has been rebased against recent upstream, freshly
> > > QA'd, and is ready for people to examine.  For veteran readers, the new
> > > snapshot can be diffed against the previous snapshot; and for new
> > > readers, this is a reasonable place to begin reading.  For the best
> > > experience, it is recommended to pull this branch and walk the commits
> > > instead of trying to read any patch deluge.  Mostly it's tweaks to
> > > naming and APIs that Dave mentioned last week.
> > 
> > Ok, I've been through all the changes since the last version, it
> > looks good to me.
> > 
> > Consider the entire series:
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Yayyyy!!  Thank you!!!!!!
> 
> Do you want me to send a pull request for the whole thing?

Yes please.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
