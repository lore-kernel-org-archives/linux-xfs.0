Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9781AC88CB2
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Aug 2023 01:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236866AbjHYBIG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 21:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236825AbjHYBIC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 21:08:02 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566F819BB
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 18:08:00 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-68a3e943762so411336b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 18:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1692925680; x=1693530480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sJTwoUEN7tegE32Os8kMKhgZ7OMsjUDVyMzuMZGsvTM=;
        b=l0HS0d9GKBnAf6zkcjGUEXrRUYwYy+92CKbodsEMTnJNrRhq7cqQQK310E0cFDqHnr
         Qfcj4frXaKr9N5z1f0at/JO1U9Z3NaX9P28GmK8byeAXoiwbBsrgVku2sqwjsUzhlqOY
         SDuWpUOs01G/YWt27meNMOLmuR7BC5suDlbsHcBPVe9h+qL25i+KHbnpd+q40p9QaStt
         3OB55HxIP9lcSycIJiw8ZG44DP2qRD8cZ8H1vxWgGwsa6vQJ+AQyQg7Yk4bZ5qA6Ults
         DY73AT7FqGl2Q26zbUD9ok3IcecMhbILih8FXTJFiX5P0GmgRDbgzMNOpcuuEqUdhaHJ
         OSRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692925680; x=1693530480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJTwoUEN7tegE32Os8kMKhgZ7OMsjUDVyMzuMZGsvTM=;
        b=ATBqbFSj8PBXfu0g16lh7NxSRC7Ojvhvrk28pLP3m4KynbmQA+ma0bWoG39vTxdepJ
         ve2y3M+ArA/8/JQfGwf71ou/TyFsBBnII6xAuWxLqOlGDuzwm2dSFcbsBzASf7WgCIGZ
         sKMJ71sq51Ofp9L8hKOqQ3V4lMQa0GYIS89VfOTJWsIq+Qwhvm5vCkrLHq49BrtMaS0N
         f/rrCmosIRHyvOPBEqmd9gQmYpzFCNlnO0t11f9Ng7Yz3uhBHVb/L8ysTGUAyBBJbkx6
         0J+ybLvTiU2ysnO3XuoUW0SX+FE/Nvje3vg4Vu35xClpgKSk87MfRT99SDTRDekkPNCx
         qh4w==
X-Gm-Message-State: AOJu0YxR6b4DZu1THxd7/5LqO7/g9PfIDcsw9RMsDsehnC9I0W68tguv
        SjBxQkbZQN4b7IkG5Ide1Q6RFw==
X-Google-Smtp-Source: AGHT+IHYXALciN8wYiNN2om1CcP9stoSf2+r8G9Km+7nGxAARyyhOTmIaX78NT5f/71EY31zKpUoIg==
X-Received: by 2002:a05:6a20:4421:b0:140:22b0:9ddd with SMTP id ce33-20020a056a20442100b0014022b09dddmr23486787pzb.0.1692925679813;
        Thu, 24 Aug 2023 18:07:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id x12-20020aa793ac000000b0068782960099sm343232pff.22.2023.08.24.18.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 18:07:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qZLIq-0067fx-1Y;
        Fri, 25 Aug 2023 11:07:56 +1000
Date:   Fri, 25 Aug 2023 11:07:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 2/3] xfs: don't allow log recovery when unknown rocompat
 bits are set
Message-ID: <ZOf+7PqbeHj1Qs3y@dread.disaster.area>
References: <169291929524.220104.3844042018007786965.stgit@frogsfrogsfrogs>
 <169291930662.220104.8435560164784332097.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169291930662.220104.8435560164784332097.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 24, 2023 at 04:21:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't allow log recovery to proceed on a readonly mount if the primary
> superblock advertises unknown rocompat bits.  We used to allow this, but
> due to a misunderstanding between Dave and Darrick back in 2016, we
> cannot do that anymore.  The XFS_SB_FEAT_RO_COMPAT_RMAPBT feature (4.8)
> protects RUI log items, and the REFLINK feature (4.9) protects CUI/BUI
> log items, which is why we can't allow older kernels to recover them.

Ok, this would work for kernels that don't know waht the
REFLINK/RMAP features are, but upstream kernels will never fail to
recover these items because these are known ROCOMPAT bits.

The reason this problem exists is that we've accidentally
conflated RO_COMPAT with LOG_INCOMPAT. If RUI/CUI/BUI creation had
of set a log incompat bit whenever they are used (similar to the
new ATTRI stuff setting log incompat bits), then older kernels
would not have allow log recovery even if the reflink/rmap RO_COMPAT
features were set and they didn't understand them.

However, we can't do that on current kernels because then older
kernels that understand reflink/rmap just fine would see an unknown
log incompat bit and refuse to replay the log. So it comes back to
how we handle unknown ROCOMPAT flags on older kernels, not current
upstream kernels.

i.e. this patch needs to be backported to kernels that don't know
anything about RMAP/REFLINK to be useful to anyone. i.e. kernels
older than 4.9 that don't know what rmap/reflink are.  I suspect
that there are very few supported kernels that old that this might
get backported to.

Hence I wonder if this change is necessary at all.  If we can
guarantee that anything adding a new log item type to the journal
sets a LOG_INCOMPAT flag, then we don't need to change the RO_COMPAT
handling in current kernels to avoid log recovery at all - the
existing LOG_INCOMPAT flag handling will do that for us....

Yes, we can have a new feature that is RO_COMPAT + LOG_INCOMPAT; the
reflink and rmap features should have been defined this way as
that's where we went wrong. It's too late to set LOG_INCOMPAT for
them, and so the only way to fix old supported kernels is to prevent
log recovery when unknown RO_COMPAT bits are set.

Hence I don't see this solution as necessary for any kernel recent
enough to support rmap/reflink, nor do I see it necessary to protect
against making the same mistake about RO_COMPAT features in the
future. Everyone now knows that a log format change requires
LOG_INCOMPAT, not RO_COMPAT, so we should not be making that mistake
again.....

Thoughts?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
