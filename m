Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF19713AA2D
	for <linux-xfs@vger.kernel.org>; Thu, 16 Apr 2026 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776358454; cv=none; b=eaGMGJwW+KNunws5ogI1wjXBaAl9zqczuXgwWnAhwvLtVfAaUniQhmZkdqqK+3OqCFG9JwInSHFXwQZ/a0zfxH0tsqQw/DEBU+TY1CcLQNlhtWts0pkjY6HAMpZ6DO+BJeL/DLsgtOThYA8z1+tmvd3PDS0EWwwL/nfY5IAJzeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776358454; c=relaxed/simple;
	bh=0//tjg8rpXA25jkUeSQ63gVkKeuGlKd/OT7roZ/pau4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=myiodQh/MTU+9rF/K4mRb9k8GeI+xZ2mQpAQvMrPmHvqyqiUSfyz5lu7cOozYRTO1TwULWf6fIUR+iwcUSzUFk2wEUOE4Y3Sq+A7MFkwyW4Ws7Kytd6NToG9lvoqUkuqULHrj9uDPYBE+gSPoYw6yv88izSmzHadLWZZEUuTEQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nnyG1Jgc; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nnyG1Jgc"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82418b0178cso4334596b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Apr 2026 09:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776358453; x=1776963253; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:date:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8LJpmivbSlaORaKGrO6bdls+IzjUDvHIFx1V0s83E+8=;
        b=nnyG1Jgc1lA3alp7vwubKG/+SGky5Bsv5ZfsxN17vKdODvOK59Fumsb9XIAYOjJ/gS
         XAK0KycU1yY6C5l9CuhKQckgTMqXDuK4/8AkahDnTbVHfakIQ0LFCLnkliiOQcC0xa/B
         23JuRH9QyZGg4lf8Pex6KSFz4KJhnEWhSGq98C6UJqQ2SYgF3Fpl4GGGFsFMKXr90o05
         zQaqdPcwZWhymItwJRLGRS0ndS8j2vvz18ReI/2BWdjGgiJjgVVP7exgls7kw9irXJ+a
         cgnIUGwiCjJubG7zVHAkQ4RngHE+AtXBPulx0ddn1Gy8hx3jNPqPmXneLwz5tvV/RL+w
         +5+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776358453; x=1776963253;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8LJpmivbSlaORaKGrO6bdls+IzjUDvHIFx1V0s83E+8=;
        b=GNZApWte8Y/v5Ukf9mkxKMPzfBKjNaW5NUVMyi64/EI1Wqq0BcN0pYZ6TGCerObeCH
         6xE2tGcEiwV6Ja+O/Wl6jMr5ng6Wa9uJrFnE7irPl98cKq85Nf4j5o4yhbA5+3ZyPAr5
         h7rock3WlHhQKu3CpuBATi9d2OT/fflIjmL1rE18bWFCLhjd+t1KJS49k9aN+wXyn3EC
         RwITtWZBXNXzJ8uiTmHNNPjrVupxxvonOmr6b0w+fl6LRP0/q9k0gi43hsleI8SCaUOy
         NZkEH3NYk09bfgamDFwgpx23vKnLNBh56UX7S2UxuIdLHNs7dGzzGOP3cDX/cJ4rlIqI
         7EwQ==
X-Forwarded-Encrypted: i=1; AFNElJ/L5jFLO5jXE4uk7D1/SK07LqIamh32+BqUMu1NA/IljuzWJkF2GDcTzeGsWmvcGaAbqsaOmnEgs4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdbLmBZrEJIv1AdnMb9CFomlIdW47Qe/qZVWkDSSPvC1aG9x1p
	S79VeH3X9lAxmYqi3y3VbbQiDPGbbzxSfG3MrzygkMKuu6FCp5yScrD5
X-Gm-Gg: AeBDietJUnM0lEJMJJkYOrhJj/nSCv3J8H5i82+MgewxvsPE9XCqSvy/IYmLB9euVti
	cPpn8r2tmbvsf8VA4xg+dJbGw/XQNOcME+bXm85DqZfQIfeohKEZGWTZ6zMBY8+nHTAZifVBxWj
	jueZEip2XfmyInNOG2W4047shos5IqYkCirLlqMt6U/F3x6adygHtbAF4O32xPR1PDmFWmCdJyk
	ATDFQgQLndGY8HWHoj05mOOZMmdWFWlMqHNh97cbL4+gbyHhcXgndTrHEVkeUU26xPXAcjjDr9G
	nL6Xdc0rsyLAptWaBb8LOXdk4L3dK/2J0iKbDp48jRy/n23NgbaF0SLa4MAUPThVcYXuKLM0ra7
	awJqyZg//qY20ERKitT3OgQXBeA6zL+CEZPdw1yvskRLR3O+W9Oi33XbxBw997k1ShzIxaL5Yio
	tGAtazvHu7op+nAwfthE8xe9Pe/AEkwtc=
X-Received: by 2002:a05:6a00:80f:b0:82f:4386:7989 with SMTP id d2e1a72fcca58-82f8889c55fmr88933b3a.24.1776358452987;
        Thu, 16 Apr 2026 09:54:12 -0700 (PDT)
Received: from zlang-mailbox ([64.176.226.21])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e0b56sm6929972b3a.37.2026.04.16.09.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 09:54:12 -0700 (PDT)
From: Zorro Lang <zorro.lang@gmail.com>
X-Google-Original-From: Zorro Lang <zlang@kernel.org>
Date: Fri, 17 Apr 2026 00:54:06 +0800
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, dlemoal@kernel.org, 
	hans.holmberg@wdc.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: add a test for number of open zones on
 conventional devices
Message-ID: <aeEUGkFh5IQtQRfV@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, 
	"Darrick J. Wong" <djwong@kernel.org>, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260414075613.544106-1-hch@lst.de>
 <20260414185914.GB150005@frogsfrogsfrogs>
 <20260415052239.GA26559@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415052239.GA26559@lst.de>

On Wed, Apr 15, 2026 at 07:22:39AM +0200, Christoph Hellwig wrote:
> On Tue, Apr 14, 2026 at 11:59:14AM -0700, Darrick J. Wong wrote:
> > > +_require_scratch_nocheck
> > > +_require_odirect
> > > +_require_non_zoned_device $SCRATCH_DEV
> > > +_require_non_zoned_device $SCRATCH_RTDEV
> > 
> > Seems fine to me still, though I wonder if you still need to check
> > SCRATCH_RTDEV if you're opencoding the mkfs/mount calls?
> 
> This can be dropped now, thanks!

Will remove it when I merge it. Thanks!
