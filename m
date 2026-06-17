Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F7B405C54
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 10:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781692504; cv=none; b=pkPc0ETSiEAOv79tiMTwfzZs13XkaL6ZuK2eS/9a5/QC4M8PxWAmKAurwktR9z3jRi4meNQdxSTZROWcjb5aSvh93XmMSdLvkiErZHSqpgxbuXc/hH1PCfteIDXCuo31fKifZqCoYsRe1IqjV1A4ib2u26lTJbgVlWzMCmF2geY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781692504; c=relaxed/simple;
	bh=7LvJBNrCOsdO+Iqg7GxV85IP0uM/07EsbX5Zo/PdvTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MTE47LV1ze2Sv07H+OnDHsiGbSdqck/CufEN9rJWFiTBwaDv16dkZWcMHhH8RS5p7IcQGdrjB2YkRWtvJE3EP+FZn5kqB6BUp9/NVLeWEhJ4vRC4FTu65F/4MaKPXhmG/XrkYDUA3oZb539xHR8pHKgfzp6RjsczmL/66CM/9vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dxpFmEwt; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KpE2CKQr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dxpFmEwt";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KpE2CKQr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781692499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hrtxT73Xq7XoN/8m1K2SzFEraWMChjq663Y9uWGHxXE=;
	b=dxpFmEwtghX3F4r7gdnxsDavJRC0qEynKSlFnDcDFNZMqfzokqnbEb4ZKsPxJTrrMqVFn3
	Y2TnFKGKd+il+ivza5p4ZdMhmDY4b789qScf1LL8uA7APL5eZ0n8uSc9Mcx7ybLcdxjiOG
	CNtuxn82W/n/xP4LfVDH8vom866Z4XA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-3RbPXbEdMeuQLuuv53u8wA-1; Wed, 17 Jun 2026 06:34:57 -0400
X-MC-Unique: 3RbPXbEdMeuQLuuv53u8wA-1
X-Mimecast-MFC-AGG-ID: 3RbPXbEdMeuQLuuv53u8wA_1781692496
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4625e71d3ccso469894f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 03:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1781692496; x=1782297296; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hrtxT73Xq7XoN/8m1K2SzFEraWMChjq663Y9uWGHxXE=;
        b=KpE2CKQrUbkKSk0kl+A7Rg7Wyp2Sl6LatZTT3b0cUcLSxtnoKHWQDaPByNB/xUC/9k
         7BDdTuAQrs6CLVu1LT5JFEcf0fNc++oBxfPB0yGo8F2baODf6Lgo+Z0zEUeT4XMvGwL3
         dzvxUiXAzc5Aal/LFlVXJtPZxjJHbNoWAoDpC52BOpyieNQl4OyMwr95xatNHP0diTJk
         Fl0fbzJYZhxD9Y6ttFPJQscZv+M7efehvQOAthAzfV+ALWATKNwkd2zuKQQhelgkIHuV
         yunELSvIm9DNsODISp2OXT3zBeBGltC4mKK/EjRF5orc+kRRjtRbQmzMgRyCUQxYBsAb
         zXbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781692496; x=1782297296;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hrtxT73Xq7XoN/8m1K2SzFEraWMChjq663Y9uWGHxXE=;
        b=aezd/y/rgz2Xsq09BlUZbREM6b7++684Ta2K1KJXASZs9vkMK88ouYUXUv9bld6Jcf
         ewKOHj2JLOihJOXgVNArKWkubLX3pkoLbZJchca46MwRMR/kb/b9PUD/5SjAZHEGI4/+
         kdZOB2DM/CBmwJitqPZ8af6ZYDcikjvtA/Z+kiXtQfcR+D547Zog63lHKTAYLJIIVZbk
         1SAdxruWEhjF8Gj+X8kis3QkWOQMkCGrJTKEExXfc+YpunboupPlHbV3NLNwrQ1m9bhM
         PVDP3WPU3C+wSm+Va08cXlpsWn1Ta9fRTLg3trq/qzhzDq+iaBoRyCpl1sC+z5Aw/+O1
         gZpA==
X-Forwarded-Encrypted: i=1; AFNElJ/WBL8DX+Ewlh+eletGw1W7dMKFi9zwsZ5VWY9ZYH9yDBS7bdtq1gt4gg/tKdQjP5iPs8hbkTRdTdk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQLUjmPbxC5JXd8AiX/gXlijmWbg+nS9OCWgZvmBqJiRdGyAGV
	FqMZ5h2bERWze6CmrVOuDrkEJOyVreUp5lxQE90dyu+8bIoFUqFiTNKh0x1fvlQUjioH7TMd6co
	hVqr2hysYzkibvoWQaWJlooq8ziS+JQjzAZq7Ivz74dyf+g7mUQp2lyqLTagdWXqQxK/P
X-Gm-Gg: AfdE7cm0OPoUq9VTeG8uM118nPVXNGzAICzM/dowmc/7NG5L6DfjdSjeCXxnZKeFSzd
	eYDrziQmAfT0eF1sA3NeDEfC3uFUTc/eeN9e8vnXHKBBPYg7wXIb8cH7898zE7Z5ViUj9bFxWtE
	yMzHaAguRPyqvejOsUl6sEYxJFc2O73uFYm3yGQpnSIiaKjnmblNZ2+48oZVU3SFeCdRM0hnAiY
	mFgaHuPbMI8giLSThHbx+ZdWNhlUbEcCzkaExh5l7j7/kHTyhqDgJUrtKd5PoO89ZP4Kmf/JI4F
	bX0l83ufKMzwrsDOsdgH2qDfGWHoBzfTWWQFgiKMOADa+svkqMoW2GkeXtQbjWozZ8VqYBpieef
	H7n0JDFUqpDjTKS58FfhTXcxNYblaeGMRCLxKKTqlxShAPQ==
X-Received: by 2002:adf:e846:0:b0:460:2e53:a6f6 with SMTP id ffacd0b85a97d-4626acf77ffmr2746850f8f.12.1781692496418;
        Wed, 17 Jun 2026 03:34:56 -0700 (PDT)
X-Received: by 2002:adf:e846:0:b0:460:2e53:a6f6 with SMTP id ffacd0b85a97d-4626acf77ffmr2746806f8f.12.1781692495853;
        Wed, 17 Jun 2026 03:34:55 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b0d70sm53208390f8f.19.2026.06.17.03.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 03:34:55 -0700 (PDT)
Date: Wed, 17 Jun 2026 12:34:55 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/6] xfs_healer: don't allow aliasing of mon_fd in
 setup_monitor
Message-ID: <ajJ4PwifqmpwaRJN@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
 <178118661279.728615.16193461564655914882.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178118661279.728615.16193461564655914882.stgit@frogsfrogsfrogs>

On 2026-06-11 07:05:21, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> As the comment says, mon_fp consumes ownership of mon_fd.  Therefore, we
> should set mon_fd to -1 so that we can't use it further on.  Codex
> complains about this logic bomb.
> 
> Cc: <linux-xfs@vger.kernel.org> # v7.0.0
> Fixes: b9b03770197d19 ("xfs_healer: create daemon to listen for health events")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

