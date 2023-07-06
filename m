Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40AE5EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jul 2023 22:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjGFWQX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 18:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGFWQW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jul 2023 18:16:22 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3671B6
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jul 2023 15:16:21 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-666ecf9a081so966675b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 06 Jul 2023 15:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1688681780; x=1691273780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gjIb6tmwnrF5Ll5QlyVKURdTTik2ZwZRo0YZWdDknVY=;
        b=bZvfpaPZa+pHnR09Y+aAeUc7Qr+vZvwNZpk1Ayb7V0IF0xYybtIi29CMmEb7kUCMrW
         caLuJtZ5etCFkRYKlNyYNHbKlDOHcWjY86RjrHXIBrLIIzVuEUaAR/RPkXysaS4qIeAY
         prlQ68tS9AUIhZcP/LKKSXuD8YDeQ5OwIkqYtaQH3MfIkBec6T3GBDVKKtiUu+kcwZyr
         mWqJ4IdpVZfjtvl8AQkjSUKRAi4F4ns6GqeX0QSiM5RS0G6blRUoueA8J3y3bjyRuqRW
         BpDitM89+wJ8A3Ayb7cx0Lhv7vbRjw1m3kTOpH7X+UVEXkX2PP5RV9tGeGwyejaaYa0S
         aIxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688681780; x=1691273780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gjIb6tmwnrF5Ll5QlyVKURdTTik2ZwZRo0YZWdDknVY=;
        b=e/JO5F7iRZgqE9dSbuc7cweixAg3TZi+edj3CJuSDfj+gIR/+avQinmCq3dGCHNsGO
         Wi/jjL+jkgOmSvAnFBscfVvHcGdFhuVRobAAl1Y8Gw6iOU96fLXnPJPoPejC5VM5HQKg
         3xfYaz4OtT0fTVaiut6gnzzWIecJnFebTf8Jv6uurC+l5QDFmtRAFZxZn7LlWSlOMSfr
         BeJOy2kRAw49xGlq6WBbF+G+xkcJKyCdhmdzm1r8c3Yg++QilgzvnxQ95Oq02FCBKQaV
         ruZdsbbJZx0SXG43mYQN2WVBOOctFzdvBBpLZMWjVubqGA8hm2ukUbmRn8Xe5Q8Uyc9I
         szhQ==
X-Gm-Message-State: ABy/qLZl11JkyWKIccuPrU0L0FAjk4Jw91z/u4b8bPNw9wJgFkuNzff/
        LiX3vrS14oWZlDxi8rXSNC3esg==
X-Google-Smtp-Source: APBJJlG95Vu7cBkFRnhj6EVLKsbfAt9NNwkXNbcfsh1u774X+5XUkeD2DHbUN/D2dE3qoNhtVfWp/A==
X-Received: by 2002:a05:6a20:6a1e:b0:127:6bda:a2ae with SMTP id p30-20020a056a206a1e00b001276bdaa2aemr3604919pzk.10.1688681780461;
        Thu, 06 Jul 2023 15:16:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-214-123.pa.vic.optusnet.com.au. [49.186.214.123])
        by smtp.gmail.com with ESMTPSA id u5-20020aa78385000000b0067777e960d9sm1703553pfm.155.2023.07.06.15.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 15:16:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qHXGr-002yEM-1j;
        Fri, 07 Jul 2023 08:16:17 +1000
Date:   Fri, 7 Jul 2023 08:16:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Aravinda Herle <araherle@in.ibm.com>
Subject: Re: [PATCHv11 8/8] iomap: Add per-block dirty state tracking to
 improve performance
Message-ID: <ZKc9MUXq6dKkQvSP@dread.disaster.area>
References: <bb0c58bf80dcdec96d7387bc439925fb14a5a496.1688188958.git.ritesh.list@gmail.com>
 <87jzvdjdxu.fsf@doe.com>
 <ZKb9DAKIE13XSrVf@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKb9DAKIE13XSrVf@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 06, 2023 at 06:42:36PM +0100, Matthew Wilcox wrote:
> On Thu, Jul 06, 2023 at 08:16:05PM +0530, Ritesh Harjani wrote:
> > > @@ -1645,6 +1766,11 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
> > >  	int error = 0, count = 0, i;
> > >  	LIST_HEAD(submit_list);
> > >  
> > > +	if (!ifs && nblocks > 1) {
> > > +		ifs = ifs_alloc(inode, folio, 0);
> > > +		iomap_set_range_dirty(folio, 0, folio_size(folio));
> > > +	}
> > > +
> > >  	WARN_ON_ONCE(ifs && atomic_read(&ifs->write_bytes_pending) != 0);
> > >  
> > >  	/*
> > > @@ -1653,7 +1779,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
> > >  	 * invalid, grab a new one.
> > >  	 */
> > >  	for (i = 0; i < nblocks && pos < end_pos; i++, pos += len) {
> > > -		if (ifs && !ifs_block_is_uptodate(ifs, i))
> > > +		if (ifs && !ifs_block_is_dirty(folio, ifs, i))
> > >  			continue;
> > >  
> > >  		error = wpc->ops->map_blocks(wpc, inode, pos);
> > > @@ -1697,6 +1823,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
> > >  		}
> > >  	}
> > >  
> > > +	iomap_clear_range_dirty(folio, 0, end_pos - folio_pos(folio));
> > >  	folio_start_writeback(folio);
> > >  	folio_unlock(folio);
> > >  
> > 
> > I think we should fold below change with this patch. 
> > end_pos is calculated in iomap_do_writepage() such that it is either
> > folio_pos(folio) + folio_size(folio), or if this value becomes more then
> > isize, than end_pos is made isize.
> > 
> > The current patch does not have a functional problem I guess. But in
> > some cases where truncate races with writeback, it will end up marking
> > more bits & later doesn't clear those. Hence I think we should correct
> > it using below diff.
> 
> I don't think this is the only place where we'll set dirty bits beyond
> EOF.  For example, if we mmap the last partial folio in a file,
> page_mkwrite will dirty the entire folio, but we won't write back
> blocks past EOF.  I think we'd be better off clearing all the dirty
> bits in the folio, even the ones past EOF.  What do you think?

Clear the dirty bits beyond EOF where we zero the data range beyond
EOF in iomap_do_writepage() via folio_zero_segment()?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
