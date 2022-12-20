Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1467AC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 20:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbiLTUjH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 15:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234055AbiLTUjG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 15:39:06 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AABFBF76
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 12:39:05 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d7so13446545pll.9
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 12:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OZkeoY54W1HRGB5xfoUcLNae8+T9uRePdXPQ9NXDoRQ=;
        b=kEmwcwQ10rrEdDizkKBMuKcnlTo09YsXA/R4PDb2ojIt54sLlmBIyosSWTLnCJFsUX
         zSQtBh7rES8z+/3956ta+/o0z/7pTG2ZTr9dSm9i6pR573vdfNW0t3QMt5WOqmfuiaUZ
         OYrwTqo79wKCok1iGo0OTb9ySNa49WswXcbk7YD0mSsNm0CGwcwKIP62ptU5l59OR0tl
         iWBIdPoXdrKFrBElLhUA13HBL1qtsLR/CK1a6Xexbnj5VCpDfOlukCiFc8nBZczYh+Vj
         DHGVQuIQmaFgkuaWtACJju5ukWnpY06yWXf3WtD91y/3SvY+WryRzN+M+X2yAyWHLFqy
         /TpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OZkeoY54W1HRGB5xfoUcLNae8+T9uRePdXPQ9NXDoRQ=;
        b=x4VkIXaj7a86puNVCj4+n2tL0IwODLvvytLzOFqprzkdqaCm3Iug2y9rpj0g87/yAV
         VqRFKBN0a4Yck5t8+3AIbDX3VuPVJLb6x/5sD8JTRBivwbCRMlfnChXc/n0TQ2i5N0Yu
         JgQ2q63BHnuaWGAJwPnqrifEzwsQa0oJ0TPQ5j7Y4A7rsafS65QtdNU5JkctlhVYV2lN
         W5/V2rwbrvVNgRKnEzVWvdumeXyHLsiLUSM/PPyuAr/8scJjHOcCFbJ9VPrCIvmKSMVI
         YBezp6XBOk8hoGMaMaHmtxCzsW3zjpC88irMwkJkZyPkGq8KaW4Qfm+zIpo4vELx0suo
         oqPw==
X-Gm-Message-State: ANoB5pkLsTilz9W/t9hwHL7Rj4+gWGhGSfccgzb3uV9jjM2TXHPlS/0c
        7fYQ4bsCXsLeIJ+mmhEafLh2Wiis9Gxs9ON+
X-Google-Smtp-Source: AA0mqf6LRPpV4klpL5tigGtk+j1mbpwKuo0Qge2IQoi5vbF8dLrT+xSZGzm0NSnhbZu8l0beHKs89A==
X-Received: by 2002:a17:902:d48b:b0:189:63be:8abf with SMTP id c11-20020a170902d48b00b0018963be8abfmr62742406plg.53.1671568745029;
        Tue, 20 Dec 2022 12:39:05 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id jj6-20020a170903048600b00189a50d2a38sm849692plb.38.2022.12.20.12.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 12:39:04 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p7jO9-00Aq6A-Fe; Wed, 21 Dec 2022 07:39:01 +1100
Date:   Wed, 21 Dec 2022 07:39:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix off-by-one error in
 xfs_btree_space_to_height
Message-ID: <20221220203901.GL1971568@dread.disaster.area>
References: <167149469744.336919.13748690081866673267.stgit@magnolia>
 <167149471987.336919.3277522603824048839.stgit@magnolia>
 <20221220050001.GK1971568@dread.disaster.area>
 <Y6HeYJXVhamT589A@magnolia>
 <Y6HfiWz4R55RbW5G@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6HfiWz4R55RbW5G@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 20, 2022 at 08:20:03AM -0800, Darrick J. Wong wrote:
> On Tue, Dec 20, 2022 at 08:10:08AM -0800, Darrick J. Wong wrote:
> > On Tue, Dec 20, 2022 at 04:00:01PM +1100, Dave Chinner wrote:
> > > For future consideration, we don't use maxrecs in this calculation
> > > at all - should we just pass minrecs into the function rather than
> > > an array of limits?
> 
> I prefer to replace all those mxr/mnr array constructs with an explicit
> structure:
> 
> struct xfs_btblock_geometry {
> 	uint16_t	leaf_maxrecs;
> 	uint16_t	leaf_minrecs;
> 
> 	uint16_t	node_maxrecs;
> 	uint16_t	node_minrecs;
> };
> 
> and get rid of all the mp->m_rmap_mxr[leaf != 0] stuff that slows me
> down every time I have to read it.

Yup, that sounds like a great idea - I have to work it out from
first principles every time, too.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
