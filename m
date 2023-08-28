Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87DC5C83F12
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Aug 2023 21:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjH1VsX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Aug 2023 17:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbjH1Vry (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2023 17:47:54 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A190102
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2023 14:47:51 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-68a3f1d8be2so2936682b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2023 14:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693259271; x=1693864071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l2Awjadgsn6o45zGGWH6IhuKCzZvu1aY7Gy1m4xJoJs=;
        b=K+xDvLLppe/c6GQc+L6yd8jNaCcce7hLDkGO/ij2gfsrqHeu34bnrJoTyNp2K2xRxA
         gh+o0UpHW5V8A//amFzjc1+Ed5BnQqZIor0fLzb3Jlx6mxC4+KLi00ZRHYzUeJVP+aGZ
         xgmo5B5No1GrznJ/RvRzrRCgB4pKGCwDGYsmnGMmvmgQd6RW8vbnj8NgKhmnOX1sHadB
         Wwkd9D5uLWeNY95rPOeyjrguPL0xfy2xzqlemCJREkaD2v+0R3Y1JP/C+3YiGIJyhXXN
         0PcY0cHjlAc4Lauz4vJhl1txGTMx1q2yUvkpU3q+8iryPLJJRRjr2UF7O0drnmH1/vxh
         SM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693259271; x=1693864071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l2Awjadgsn6o45zGGWH6IhuKCzZvu1aY7Gy1m4xJoJs=;
        b=KZy3668jYVXxmqpMG8EKr+t8Gui/wLmM3kbnG2LqxP96wx+XB6kyQAbK8EtS+DAoGg
         PEU5gG9r42Mli3ZCrHv+91AhHh/nCrkfXvSzgyA/XHAzovk7m/M3Mhl5+SZpQaMprOI0
         pbgIcH2hd5rcDCxh3dX6rFMjCbt7ATwzEXbOdGXGCSgNTI/6MS2E9MHJ918X0SMD8COo
         DyOe9RMWdcmaQ9MoJwdcHY1CA+9IqXjakAaZpe+NDoxxuw35/bGDnNHcjuhkh3GrBeVL
         wdmzXQxTuvR0xhZMIgUkAEiQ8LqBh5U37h5hCUNlnj+KrC/wW6pxFSJqc4PNgHlmnhGm
         c7nQ==
X-Gm-Message-State: AOJu0YyrJQbmH43NwtVyugjn5jqzY+3Z+XNL2RwQh9NboAMab6WwZPN9
        VLx5LcVDyzZr00huKdJ3Y70e6k+sh3H2eW62agw=
X-Google-Smtp-Source: AGHT+IHYQbonbhKrbzAilg6k0UqhGwStQIW4DLGQSnq4f6bSjS+boVUBVM3Hrkdg63qIMZsCPb4hhA==
X-Received: by 2002:a05:6a20:dd97:b0:134:dc23:2994 with SMTP id kw23-20020a056a20dd9700b00134dc232994mr23276720pzb.31.1693259270860;
        Mon, 28 Aug 2023 14:47:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id s12-20020aa7828c000000b0065438394fa4sm7356491pfm.90.2023.08.28.14.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 14:47:50 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qak5L-007o6z-0B;
        Tue, 29 Aug 2023 07:47:47 +1000
Date:   Tue, 29 Aug 2023 07:47:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 2/3] xfs: don't allow log recovery when unknown rocompat
 bits are set
Message-ID: <ZO0WA2EwtEa5n0bC@dread.disaster.area>
References: <169291929524.220104.3844042018007786965.stgit@frogsfrogsfrogs>
 <169291930662.220104.8435560164784332097.stgit@frogsfrogsfrogs>
 <ZOf+7PqbeHj1Qs3y@dread.disaster.area>
 <20230825040417.GF17912@frogsfrogsfrogs>
 <20230828190822.GB28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828190822.GB28186@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 28, 2023 at 12:08:22PM -0700, Darrick J. Wong wrote:
> On Thu, Aug 24, 2023 at 09:04:17PM -0700, Darrick J. Wong wrote:
> > On Fri, Aug 25, 2023 at 11:07:56AM +1000, Dave Chinner wrote:
> > > On Thu, Aug 24, 2023 at 04:21:46PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Don't allow log recovery to proceed on a readonly mount if the primary
> > > > superblock advertises unknown rocompat bits.  We used to allow this, but
> > > > due to a misunderstanding between Dave and Darrick back in 2016, we
> > > > cannot do that anymore.  The XFS_SB_FEAT_RO_COMPAT_RMAPBT feature (4.8)
> > > > protects RUI log items, and the REFLINK feature (4.9) protects CUI/BUI
> > > > log items, which is why we can't allow older kernels to recover them.
> > > 
> > > Ok, this would work for kernels that don't know waht the
> > > REFLINK/RMAP features are, but upstream kernels will never fail to
> > > recover these items because these are known ROCOMPAT bits.
> > > 
> > > The reason this problem exists is that we've accidentally
> > > conflated RO_COMPAT with LOG_INCOMPAT. If RUI/CUI/BUI creation had
> > > of set a log incompat bit whenever they are used (similar to the
> > > new ATTRI stuff setting log incompat bits), then older kernels
> > > would not have allow log recovery even if the reflink/rmap RO_COMPAT
> > > features were set and they didn't understand them.
> > > 
> > > However, we can't do that on current kernels because then older
> > > kernels that understand reflink/rmap just fine would see an unknown
> > > log incompat bit and refuse to replay the log. So it comes back to
> > > how we handle unknown ROCOMPAT flags on older kernels, not current
> > > upstream kernels.
> > > 
> > > i.e. this patch needs to be backported to kernels that don't know
> > > anything about RMAP/REFLINK to be useful to anyone. i.e. kernels
> > > older than 4.9 that don't know what rmap/reflink are.  I suspect
> > > that there are very few supported kernels that old that this might
> > > get backported to.
> 
> Seeing as the oldest LTS kernel now is 4.14, I agree with you, let's
> just forget this whole patch and try to remember not to hide LOG
> INCOMPAT features behind RO COMPAT flags again. :)
> 
> If we do that, then all we need to do is change xfs_validate_sb_write
> not to complain about unknown rocompat features if the xfs is readonly,
> and remove all the code that temporarily clears the readonly state
> around the log mount calls.
> 
> Log recovery then goes back to supporting recovery even in the presence
> of unknown rocompat bits, and patch 3 becomes unnecessary...

*nod*

> ...though this below is still true.
> 
> > Hmm.  The most annoying thing about LOG_INCOMPAT features is that
> > turning them on requires a synchronous write to the primary sb along
> > with a transaction to log the sb that is immediately forced to disk.
> > Every time the log cleans itself it clears the LOG_INCOMPAT features,
> > and then we have to do that /again/.
> > 
> > Parent pointers, since they require log intent items to guarantee the
> > dirent and pptr update, cycle the logged xattr LOG_INCOMPAT feature on
> > and off repeatedly.  A couple of weeks ago I decided to elide all that
> > LOG_INCOMPAT cycling if parent pointers are enabled, and fstests runtime
> > went from 4.9 hours back down to 4.4.  (Parent pointers, for whatever
> > reason, got an INCOMPAT feature bit so it's ok).  I was a little
> > surprised that xfs_log_clean ran that much, but there we go.

Sure, but that's only a problem for operations that are a pure
log format change. With parent pointers, we have an INCOMPAT bit
because we have a new attr filter bit that older kernels will flag
as corruption, and that means we don't need a log incompat bit for
the attr logging. IOWs, if xfs_has_parent_pointers() is true, then
we don't need to set the ATTRI log incompat bit, ever, because the
parent pointer incompat feature bit implies ATTRI log items are in use and all
kernels that understand the PP incompat bit also understand the
ATTRI log items....

> > A different way to solve the cycling problem could be to start a timer
> > after the last caller drops l_incompat_xattrs and only clear the feature
> > bit after 5 minutes of idleness or unmount, instead of the next time the
> > log cleans itself.

Well, we only clear it from the xfs_log_worker() if the log needs
covering, so the AIL and iclogs need to be empty before the worker
will clear the incompat bit. That's on a 30s timer already, so
perhaps all we need to do is extend the log covering timeout if
there are incompat log flags set....

> > Alternately, we drop this patch and declare an INCOMPAT_RMAPREFLINKV2
> > feature that wraps up all the other broken bits that we've found since
> > 2016 (overly large log reservations, incorrect units in xattr block
> > reservation calculations, etc.)

It's tempting, but let's try to put that off until we really need
to....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
