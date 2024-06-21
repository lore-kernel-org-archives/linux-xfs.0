Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB1315D1
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 17:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718990443; cv=none; b=BCtIPXBGZByhPtJ1tKWO9okAL7Q7nAiE9FsVcsq0csvl+AmRSH0uxDyAkJbsPOkSIlnsDJV8P7UTAH5CC4S9/hNLn0C5G9BpfaqCdaliTKl0PvhFeY2ZOs+Nj3OHTfRfnfCbwX/yAPLAwGYyADrOmrsUq+2dTiczcXqwF0pQKz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718990443; c=relaxed/simple;
	bh=s76fpLFLMOfLJ1wET/nz6mIX5hz2pLZweUGOogB6bwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fjq3fLsKQ5Dbu207cnVqZwZ91vDdrPueJk5sQBfSJ9UZq8QaOoNYzZ0+/kj9hMiZVpG3Fg0AtTVt1XMpJmKJIKdNXhvDypoZ1oyYV0hYvN0Ddj1NjYxAkmflmMzDu4dgU9ORb9IHXA2aZLjk+boj0tw9yZjUb4vGk2W6+YtDozo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fb8+n6hw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fb8+n6hw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718990441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kc+WxK4RSwvbDVXPwUm+KwbPzHMSQoYdxMjYxRV3o8o=;
	b=Fb8+n6hwjCWi3XxhOJp7XOAeOwzHZ5lCDzfwlP3hC22VZ5ZrlRtt3nxtrjVCMCGS7r5VR6
	JZdPkxKJqnZR5dSIXQvhsKgHt/odit9xISR9CXAP9O3AqtjcY1BZLfWaquxRiinaHnXh0N
	HdWnE50UW8SdQhf65w/U0+Qn06utSrs=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-iK9CRa78PXefUlawNIan4g-1; Fri, 21 Jun 2024 13:20:40 -0400
X-MC-Unique: iK9CRa78PXefUlawNIan4g-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1f70b2475e7so21336895ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 10:20:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718990439; x=1719595239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kc+WxK4RSwvbDVXPwUm+KwbPzHMSQoYdxMjYxRV3o8o=;
        b=EMFAZmrZ8mZWsAPIVRpt8dVmUXH3lC54pUnrTX574uuYrtU+iEXt6xL9l69Rv/NfFg
         QLOvq+TbFIOO/oOx6UTYKH2+M24lDqloN3Imb9WpV4NiYYDkReTzTmBFCstFF/sbxKSf
         06FwIGeVm/WJRPPK/XNtBDWnMl5O/tDmd30pDQCf1IqSnH6oSGZ2hnk/LtRAfaMuYBx0
         Ppv4FsDELAag/2Mas3yeqXI2jEySCzxedJcCNnLQ94LCul6ChWI5qIddWDbTWLeNVZgU
         6Oy+ncLNTAvVHbykd61ZcrNTUc5Vkeb2MyC+NefRq7pGpeMn90FKBtz7Rt/sS0MfT4hA
         FUiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVz45BI6QLwP6IfLSSAkHC1fU3LYShdVeQF4VF/urvw1IyuQdekPkiGzm8Fe/yZ5ux/FCI1qgsF0Dd6m/sdxXbXYXBhDYAiIh1/
X-Gm-Message-State: AOJu0YyPipbiJjtgH+41RL3EhQV+s+e2Pk2ZCuP8WWgVYgTBbl3CyHLe
	e1zS7KpKccvjqgjJLUr5iEmx6vIOMnJdttCWh82ZDQK1+FW4O2l7uZaVYMCQeQshbAMN1yNS1LV
	13iS1aYXXXUv4Bs8H2D3S1106hnBopkuARyN7XmthNtNWvOWpHXF6jJloeg==
X-Received: by 2002:a17:902:e844:b0:1fa:449:1dd6 with SMTP id d9443c01a7336-1fa04492142mr7378535ad.48.1718990438698;
        Fri, 21 Jun 2024 10:20:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgh6rbfZ+cOajX/3iN6CBi2KP2Z5fU8wSFfRO3yhV/EuTGpEcYYCkAvO3EXLnRz6fldt61nQ==
X-Received: by 2002:a17:902:e844:b0:1fa:449:1dd6 with SMTP id d9443c01a7336-1fa04492142mr7378295ad.48.1718990438166;
        Fri, 21 Jun 2024 10:20:38 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb2f0505sm16553745ad.12.2024.06.21.10.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 10:20:37 -0700 (PDT)
Date: Sat, 22 Jun 2024 01:20:34 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCHBOMB] fstests: catch us up to 6.10
Message-ID: <20240621172034.qemkrzrpxif37tot@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240620205017.GC103020@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620205017.GC103020@frogsfrogsfrogs>

On Thu, Jun 20, 2024 at 01:50:17PM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> This patchbomb are all the fixes that xfs needs to bring fstests up to
> date with what's in 6.10-rc.  Except for these two patches:
> 
> [PATCHSET v30.7 2/6] fstests: atomic file updates
> [PATCH 03/11] generic/709,710: rework these for exchangerange vs.
> [PATCH 04/11] generic/711,xfs/537: actually fork these tests for
> 
> everything else in here is fully reviewed and ready for PRs.

Thanks for big updates!

This patchset is big, I've merged and pushed all these patches to
fstests' 'patches-in-queue' branch, feel free to check that.

I need more time to give them more tests, will try to release fstests
at this weekend or middle of next week.

Thanks,
Zorro

> 
> --D
> 

