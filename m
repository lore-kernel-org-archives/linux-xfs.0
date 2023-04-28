Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3073C77B61
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Apr 2023 02:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjD1CbQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 22:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjD1CbP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 22:31:15 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60411268D
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:31:14 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b5465fc13so7206727b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682649074; x=1685241074;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SJqxXWRjh2s5gpe+xmNMaO8MtPDaty7rJrPInDTaisw=;
        b=aFyq2Hn2zSM02E7NiY2aqeNQpHTKRyEWrvEYLBsp6vh1i/3HW+EVYjy7vIZMDI+115
         oiv/A4Q/UADX7lfom+zckPwH5zOaqoUXNZ/WgyVgNY93iMK8suTYBpvPIr0Jp4oGe68P
         w/JczCzfvBfvjuixhBrJjUdHAngsbpnWOBl1HyFylIPn6or59OwUf0+tgqwHinJf0DqN
         C3Gjvlw0mrhFnk6t7NwkrRcyXNh4haavzbvOYcxP2rc4d6ubZm7HVl06uncKuRmOERmU
         jUn4piyIF2WWiF580u3Q8NVDYIg02GfuaR7N9ROozpcJ2g36VnpLe1G/p7ur/0iL+vsV
         MtOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682649074; x=1685241074;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SJqxXWRjh2s5gpe+xmNMaO8MtPDaty7rJrPInDTaisw=;
        b=TQbMmWaMvYRz7CMFqTP+O2MAlvjRLqaoZitZnHiLNYq4WDcrRYarPZX9n6dQasGBcY
         s+8sjK/iPwQ3iJEAeHOPTZta4yYSrk5ccognREsxVEM40FTOvDr1mFnjYJMTGWzhLpmT
         k5zLUPd0evlD62dm8jvcOY8GYQTKTTQvAz0gzv/igcS/Sy53c1N7nwkDzPD/Xsd9Z5KL
         nubZRtu5vLiX0/MKiaquB/hicllq4IrRDHp7D/9CYI2UzyavHMoSPi3KzJNxKXQuKgKw
         YqaA8pqEm7/oOB3YrHrRQrgO7nnOQfGOTfEaMXa7KjArDsxoYhi+hkRTEJ+BqK7wtava
         1q0Q==
X-Gm-Message-State: AC+VfDxy1krlYwI8xO5jgGEzp8Efan06GeTFpyDULORd/7piyxcbR+3d
        HpKOL63o1anWc2hbHid1irfOGw==
X-Google-Smtp-Source: ACHHUZ7GFvJbmIVeIa4lTSEKtyNeakythG93Cw3OriMjtd7Z7HpyoV3hqz/8GIzyZtLaDhZ0pfyhSQ==
X-Received: by 2002:a05:6a00:999:b0:63b:7a55:ae89 with SMTP id u25-20020a056a00099900b0063b7a55ae89mr5335704pfg.27.1682649073858;
        Thu, 27 Apr 2023 19:31:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id m1-20020a655641000000b0052871962579sm4942307pgs.63.2023.04.27.19.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 19:31:13 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1psDt8-008iMB-QJ; Fri, 28 Apr 2023 12:31:10 +1000
Date:   Fri, 28 Apr 2023 12:31:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: don't allocate into the data fork for an
 unshare request
Message-ID: <20230428023110.GV3223426@dread.disaster.area>
References: <168263573426.1717721.15565213947185049577.stgit@frogsfrogsfrogs>
 <168263575686.1717721.6010345741023088566.stgit@frogsfrogsfrogs>
 <20230428021346.GQ3223426@dread.disaster.area>
 <20230428022055.GG59213@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428022055.GG59213@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 27, 2023 at 07:20:55PM -0700, Darrick J. Wong wrote:
> On Fri, Apr 28, 2023 at 12:13:46PM +1000, Dave Chinner wrote:
> > On Thu, Apr 27, 2023 at 03:49:16PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > For an unshare request, we only have to take action if the data fork has
> > > a shared mapping.  We don't care if someone else set up a cow operation.
> > > If we find nothing in the data fork, return a hole to avoid allocating
> > > space.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/xfs_iomap.c |    5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > Looks ok, but I'm unsure of what bad behaviour this might be fixing.
> > Did you just notice this, or does it fix some kind of test failure?
> 
> I noticed it while I was running the freespace defrag code in djwong-dev
> with tracepoints turned on.  THere was a math bug that I was trying to
> sort out that resulted in FUNSHARE being called on a hole, and I was
> surprised that it would create a delalloc reservation and then convert
> it to an unwritten extent instead of going straight to an unwritten
> extent.
> 
> AFAICT it has no user visible effect other than not wasting cycles on
> pointless work.

Ok. If you add that to the commit message, then consider it

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
