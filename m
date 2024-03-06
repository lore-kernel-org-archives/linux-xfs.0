Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5519514A83
	for <linux-xfs@vger.kernel.org>; Wed,  6 Mar 2024 20:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709758301; cv=none; b=AtpDwn4bXHKR/P4ARuFjuptL3SDQuT2/SFDqlpzlZe3EQLyZ4AQQyP4Y2zLM+7RyrsVSMTGAkBPKImDa3pK0QIYehOs/FyEQOjEfCx0hUOC2UyCJFMpHPXf6C6JpY6rS/oOBWqEjr65WCW1e/gMCTcIZJcE/E9EXHt48e/nHm2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709758301; c=relaxed/simple;
	bh=bwfGYuFAmPMPl7AIEbCKfXOud3jyl2zDYW7Itt02it0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d0/HBvMCq1OlPFHF0PFM4ZEJJeQBmw5iG26PLJ7ppWkhpeGl8AvEQ8Rsg0q7Zncvt1Owq9RSg5U//tR6sDhOZuhVEjYsphLdaA+1Y4kl6oICF8lwDqQaHgz4XPSlF1PHzBx4IhVg30uyjCgcXcMhuHIlWbxuptPHCQnS9qUXGKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=yx2lU2Gn; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="yx2lU2Gn"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e655a12c81so337848b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 06 Mar 2024 12:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709758299; x=1710363099; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=amvRL2QuIeG48A9mIUILTxOJ17nMhxmLwzEVfPK0XPw=;
        b=yx2lU2GniBqmtdJAICtdapb3UpO7P4OXnnjrnR7FDz6MxQp2RwIMRH2bG1znJxWWko
         4cGG86xA9Up1PMUXEka1y0afyqUQE/kot5GIhrgBSjjRyMl4lzpgEvSO1YxDcQmNyUJp
         5PON14cT8fIlIDbK9AuKTHgaQBqa/hif31wL/g82dAKXQCwsMqzf5bUi0IdlOh0pTcyp
         DvI1GF2gsQ2DZvYJvWUoVE57CTJdxA/cGRqGtwMw6tLeLelfmVvudokohTTTKIZqZ2BB
         8Ha+5oV7ctK0Ufdlb3BWf6r5zdmyZ1vWqEddO2SHtFzOVh7m3qzk4cWElFfks/au/0jb
         aI6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709758299; x=1710363099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=amvRL2QuIeG48A9mIUILTxOJ17nMhxmLwzEVfPK0XPw=;
        b=h+2wdrCAaEMrtBE5eqGm2Q4krNP6F8HAsu7aAH2Cg50BQileeB0cj5GQxP4MXnw0/X
         /JSUQJj6SNPLFp+uhiA5WxZ7KbnCFVIKy8UEVBM7YSkjAHGfUXCfVeFC9+wfj6VYwh1W
         Cl5IhX8OsdBouKDFEhCZfXItLMq/T3ZJeZTD8Mtv+MGJvy3Dv9nJjnQYpC+e5KzR06yb
         6SK6MfvDm2G62bu8Cv/A4E5xFBLYD8Pt29s1heLDOCnj01kT8lKWIiesWA5WqKwiAAzi
         HBfqg79M+axT5kXdviznsean5Pbpsjjt4ZGhXSQaCqXHPMqR+9aaljgzCvOKToMtu/mD
         4r7A==
X-Forwarded-Encrypted: i=1; AJvYcCXJTX/AclNBfBY8N6+HRiKBRfMNrleyzsIcObqU6C4nUfsNwynxgFCwIxWTKW3xMx8tSB+XagCewjL55XDwu1+1DUvM987v/edG
X-Gm-Message-State: AOJu0YyKFvkpmLrYlSJ8vc//+BUIrSLN4/y318kiJzYfNvS7QTOUvTgp
	eakgdMrayeG/NTG9MXFikkg89Osr0icDnvuXxLveuDXmF5PvSel6uVy5Zs1wmGByfGq42K2yqV4
	o
X-Google-Smtp-Source: AGHT+IHCtgIpuodOwNG7cYI/T7BElKqK886S8ic5mAn1IVxU721hA3wRy8WQiE5+8HzR3wkItsNFmA==
X-Received: by 2002:a05:6a20:1590:b0:1a1:e41:3edb with SMTP id h16-20020a056a20159000b001a10e413edbmr1799665pzj.11.1709758299424;
        Wed, 06 Mar 2024 12:51:39 -0800 (PST)
Received: from dread.disaster.area (pa49-179-47-118.pa.nsw.optusnet.com.au. [49.179.47.118])
        by smtp.gmail.com with ESMTPSA id m23-20020aa78a17000000b006e5a915a91fsm10076211pfa.53.2024.03.06.12.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 12:51:38 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rhyEh-00FxcT-2l;
	Thu, 07 Mar 2024 07:51:35 +1100
Date: Thu, 7 Mar 2024 07:51:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Keith Busch <kbusch@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [BUG REPORT] General protection fault while discarding extents
 on XFS on next-20240305
Message-ID: <ZejXV1ll+sbgBP48@dread.disaster.area>
References: <87y1avlsmw.fsf@debian-BULLSEYE-live-builder-AMD64>
 <Zehi_bLuwz9PcbN9@infradead.org>
 <Zeh_e2tUpx-HzCed@kbusch-mbp>
 <ZeiAQv6ACQgIrsA-@kbusch-mbp>
 <ZeiBmGXgxNmgyjs4@infradead.org>
 <ZeiJKmWQoE6ttn6L@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeiJKmWQoE6ttn6L@infradead.org>

On Wed, Mar 06, 2024 at 07:18:02AM -0800, Christoph Hellwig wrote:
> Lookings at this a bit more I'm not sure my fix is enough as the error
> handling is really complex.  Also given that some discard callers are
> from kernel threads messing with interruptibility I'm not entirely
> sure that having this check in the common helper is a good idea.

Yeah, this seems like a problem. The only places that userspace
should be issuing discards directly and hence be interruptible from
are FITRIM, BLKDISCARD and fallocate() on block devices.

Filesystems already handle fatal signals in FITRIM (e.g. see
xfs_trim_should_stop(), ext4_trim_interrupted(),
btrfs_trim_free_extents(), etc), so it seems to me that the only
non-interruptible call from userspace are operations directly on
block devices which have no higher level iteration over the range to
discard and the user controls the range directly.

Perhaps the solution is to change BLKDISCARD/fallocate() on bdev to
look more like xfs_discard_extents() where it breaks the range up
into smaller chunks and intersperses bio chaining with signal
checks.

I suspect the same solution is necessary for blkdev_issue_zeroout()
and blkdev_issue_secure_erase(), because both of them have user
controlled lengths...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
