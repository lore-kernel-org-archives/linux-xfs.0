Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 483A4EB64D7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 22:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbjF1W6j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 18:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjF1W6B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 18:58:01 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A7B3583
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 15:58:00 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b801e6ce85so364775ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 15:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687993079; x=1690585079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mpl8xUAlHuvou68TMu+Qsa67vB5BscbCAv/pbMvTSKs=;
        b=jKaOE+j1mlCiUOdI3gf1ekuuYtltcogigdAox23MRNTr4AHY/kRoUk/fxcOzZYmm2h
         9V5bvVZrtk3YvDcWR8GHlwyrpebs474T5Yl5QhDgGxU44EBPJ6jYTuz0gYdJaqoMgMss
         Ouo8p2en8JWdKA4kWzRtPG3Ue0JjxmMrQXDG3h+QCEnR9KvoOuHrVy6vYhY8MuwWOgLv
         0PmMf6wCVxr7EpBTsa46Bb7xnQZ4NbuhsXSn2hr4mRbNgOcwrGp5Iwy/f6P9G9JKK7n3
         F+uCwWAgujsCiD/wvr+DFgj3gbi23GiX4enavGd3MLzXP36hvNldFrBV7ugjf8BeGc2w
         pi1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687993079; x=1690585079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mpl8xUAlHuvou68TMu+Qsa67vB5BscbCAv/pbMvTSKs=;
        b=HVDJ9GCbuUsTfE0p90Z3qaUOKePPRq9K2knlb8l03862DkBqs5S05dS3eaW2gITczV
         OtyfYVC2Ktw7znrjo6wW2ODGZfCwlHsqdgGTcbuE9holHKYWHtkHIKt/5vqIEVsMnlXZ
         CDMcl4G/HEymWPZqxKXHSX5g6An1ZeNjPqWPFp0w4FYpxxISLR3ysG7Tcrk2NHr2EccL
         s43m82pCk1MaRKTbD67U11LhWmNu320/t+FDuwDrin4cUKhLMapVvEuVHVnOLOGT+G6V
         VA2pJ2IMAZOaCXqQaDFRorBdQKWjA9X4L89T8ZGGtOTlpzA+JKQZKssmYz8QC8c0VlF0
         hqFw==
X-Gm-Message-State: AC+VfDx+dUPk4J7L0Gp7eQ7ENVChaKOqKZvgU7LK44b/hsDwePqOt1h2
        jF3xF1mfcJMGwNhtIuIZmFJP5DjEBYvddcT2jWw=
X-Google-Smtp-Source: ACHHUZ7wpjhinYksw1dLTDndvPjVMqSgKVgi/B6PSXDAsSM0tE2Fxz1V+vy0qi0HwMn1E6SF9/I+3Q==
X-Received: by 2002:a17:902:bb16:b0:1b6:c193:96e0 with SMTP id im22-20020a170902bb1600b001b6c19396e0mr2823733plb.1.1687993079578;
        Wed, 28 Jun 2023 15:57:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id px4-20020a17090b270400b0024e37e0a67dsm2409919pjb.20.2023.06.28.15.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 15:57:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qEe6l-00HP0q-2s;
        Thu, 29 Jun 2023 08:57:55 +1000
Date:   Thu, 29 Jun 2023 08:57:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: allow extent free intents to be retried
Message-ID: <ZJy68+W4aw1Hm0d9@dread.disaster.area>
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-5-david@fromorbit.com>
 <20230628174836.GV11441@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628174836.GV11441@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 28, 2023 at 10:48:36AM -0700, Darrick J. Wong wrote:
> On Wed, Jun 28, 2023 at 08:44:08AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > @@ -653,9 +700,29 @@ xfs_efi_item_recover(
> >  		fake.xefi_startblock = extp->ext_start;
> >  		fake.xefi_blockcount = extp->ext_len;
> >  
> > -		xfs_extent_free_get_group(mp, &fake);
> > -		error = xfs_trans_free_extent(tp, efdp, &fake);
> > -		xfs_extent_free_put_group(&fake);
> > +		if (!requeue_only) {
> > +			xfs_extent_free_get_group(mp, &fake);
> > +			error = xfs_trans_free_extent(tp, efdp, &fake);
> > +			xfs_extent_free_put_group(&fake);
> > +		}
> > +
> > +		/*
> > +		 * If we can't free the extent without potentially deadlocking,
> > +		 * requeue the rest of the extents to a new so that they get
> > +		 * run again later with a new transaction context.
> > +		 */
> > +		if (error == -EAGAIN || requeue_only) {
> > +			error = xfs_free_extent_later(tp, fake.xefi_startblock,
> > +					fake.xefi_blockcount,
> > +					&XFS_RMAP_OINFO_ANY_OWNER,
> > +					fake.xefi_type);
> > +			if (!error) {
> > +				requeue_only = true;
> > +				error = 0;
> 
> @error is already zero so this is redundant, right?

Yes. Forgot to remove it when I changed that code to continue and
have errors fall through to the common handling...

> If yes then I'll remove the line on commit,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
