Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07B31F03F3
	for <linux-xfs@vger.kernel.org>; Fri,  1 Aug 2025 06:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754029175; cv=none; b=ktRKlNG/gyXL3kkae7Tuw58ViCoahGolojoIp3N8YRVONQSRbG3G1jTHUWJa3JL5/zPR94GAN2a29lpai9GCp6vGKNtxrUgPciwIdOrkRkszze8VgnP62QLiyKWYvS9qWUEEbmzWU9m/PO+HNKr9BKGsOUtazicPd+f0WbB6Jvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754029175; c=relaxed/simple;
	bh=EPHYRAPG3KozJvbw/i4FF6IGHiR0rWYCf+bjKUPbMGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ev6HBkcgoxoGDH3uUBsYZHcs6XiLQOwt7GZvaHb5uG4sCFyUUve2HsxaK/rVSKNfYvITbwoPE0EN43m9WSCEBdGcfFX/gL+6kAgXWZtkXxN4qGAuYK2FaCNboCDWNLy3ypitg24DzHMFzU1XucxrDAyq4JIk7qwsjop7w69iohE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ArHyS9Lp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ArHyS9Lp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754029172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jMYiehdGIQOorTyXunkhNyOrR1xtlljPmOkSUA9k3Uk=;
	b=ArHyS9Lpnzv2G8SRR5SDMcwibaXUBkU8b1LcHeAid+d0dQ7q6ZNJmLv9N7dT82kgV16ypd
	yCth8UJEM8jCKP9T++B7uZy+7WnyBj8l5njuxihgGPBY3wbmKpUqUxZ5ZKuuD/oKNNdb5T
	W7bkZiUG/gJfjwp4jLQzXR7sp1yau2U=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-kS5_I_g_NwaaDoO6xsHtMA-1; Fri, 01 Aug 2025 02:19:31 -0400
X-MC-Unique: kS5_I_g_NwaaDoO6xsHtMA-1
X-Mimecast-MFC-AGG-ID: kS5_I_g_NwaaDoO6xsHtMA_1754029170
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-237f8d64263so20964915ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jul 2025 23:19:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754029170; x=1754633970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jMYiehdGIQOorTyXunkhNyOrR1xtlljPmOkSUA9k3Uk=;
        b=uXM5BDbDOhBgfMV4FJrRaWaMgjmb9r2phR1V+nSiH90hq70v+fXuoNUtNjWIDjR46Q
         o0Hiad70cDLDWhcFt286T8BQ7w7WFpBdg6gbSqDsYZVfMhHshEoD+kag7alp3IZfwjO/
         /unZD+vTFaXjWFf1jh/TuriaWc1lxS4ovE2sXW3lt/WIssoFb7XoYaNHbu9YcL+rM2dy
         qb3jmLLejCqMx6Lt+/0UT6kgMERj5LgwH1CbX3Ewt0AxxnX2t06LfmKLOR0mPhMstPDV
         SWw2nPHxRlEurwh0DT5uwkBr3T48WZBBv7vVjhQBH2B04MIwebhNwM6xDNo0entmJFAR
         gjTw==
X-Forwarded-Encrypted: i=1; AJvYcCVyMV41BgSwAf+eBI2c2fqkmGLyzfxmzEPJTLkifn7f7eRMFQeo1Gx/DcUgQ2BPFATBpfbTanTQnBU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKi7evJEI3JwZeZQkpgZNepyyBKyhbIDLYBy5+leRpD4HAt8C7
	PVoIzdlMYonmjNBff7b82Kvkd3c4/nSJo9nyPdqVSDFFo9ISxtJsoGCxgZuAwMf6sycAacomJ5s
	0XAVubfqKJsYDHgOzRRhy0kyd8pyn2nQRq550kx2Z5I3Ex0OhANE/kiOSyQqa9WmqXKu3lQ==
X-Gm-Gg: ASbGnctD6R3Hq5k77blE+lQDNz8b/4dEkrphQQII9j0mb10QBCwRq8DMOKJj3JNtelW
	rUGbRJNZMMOxoID8Pi6n2pI0b0Ltio5l1U3uvts/ccj7MrRkUfxXYu6LboBd70ucsqicse9eZl7
	nhmniL5MatqaSQVOm4lZoGMfcBFn33ULLK6g45jn/olYCBxwlqVKuPDxPyMM6SDFOWGe4poymfQ
	ihXqC/uMQiDRpVSEGT/HCDYh8z4rp5OC69ucDMObL+WqLAayH8Pso/Sv+A0fXmWIoN8/49iR1fl
	zjtPzxFCb+Y8TwenLwafrYPy+GK46hnEO3gVGebxRWFwKFBAmHC+99xq+KQ+X9/1hVFHWdgAROp
	wKiDd
X-Received: by 2002:a17:902:f2c6:b0:240:981d:a4f5 with SMTP id d9443c01a7336-240981da701mr103511395ad.42.1754029169633;
        Thu, 31 Jul 2025 23:19:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0+kBDdQxrptzUfQkX7oUxk29yF9CB1ceaWnQH3LJBA2mUBpKv/zMXQ5n4S8JBC+lAkH6dqg==
X-Received: by 2002:a17:902:f2c6:b0:240:981d:a4f5 with SMTP id d9443c01a7336-240981da701mr103511075ad.42.1754029169269;
        Thu, 31 Jul 2025 23:19:29 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e89a6ec2sm33954845ad.145.2025.07.31.23.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 23:19:28 -0700 (PDT)
Date: Fri, 1 Aug 2025 14:19:25 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 1/3] fstests: fixes for atomic writes tests
Message-ID: <20250801061925.43z675yfcq7lb3o5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>

On Tue, Jul 29, 2025 at 01:08:28PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Here's a pile of bug fixes for the atomic writes tests.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=atomic-writes
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=atomic-writes
> ---
> Commits in this patchset:
>  * generic/211: don't run on an xfs that can't do inplace writes
>  * generic/427: try to ensure there's some free space before we do the aio test
>  * generic/767: require fallocate support
>  * generic/767: only test the hardware atomic write unit
>  * generic/767: allow on any atomic writes filesystem
>  * xfs/838: actually force usage of the realtime device
>  * common: fix _require_xfs_io_command pwrite -A for various blocksizes
> ---

Do I miss something? I didn't find [PATCH 1/7] in this patch thread :)

>  common/atomicwrites |    6 ++++++
>  common/rc           |   14 +++++++++++---
>  tests/generic/211   |    6 ++++++
>  tests/generic/427   |    5 +++++
>  tests/generic/767   |   19 +++++++++++++++----
>  tests/xfs/838       |    1 +
>  6 files changed, 44 insertions(+), 7 deletions(-)
> 

