Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4398558212
	for <linux-xfs@vger.kernel.org>; Sun,  3 Mar 2024 13:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709473206; cv=none; b=Kajr+vHPm27uOXGBjPg69iKrSFytBYqunZDzhPFLZFWq8FsCpcfDRvaNAIQSdSkmb7MSdhJOE/vcQix+zzqeCHpNry0cZpLpHeVV1nnjOSfMQ6cQsbzrlyI+Ig22ztnf7RJCzBtLGK1ZxB8dB06J2RwFZFxLYoA6wmJEYzAyNAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709473206; c=relaxed/simple;
	bh=ucEPCsnMKchLHbWhNMVD/lHGAReGn2m9fj/ZQWD5Gw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VXsJv04C2ZX+9goTSmpuhJ0fj1qfba8ZIPl1Lihvqx8XtdaJl3a8/lSrZYExI8E/JrsxUtvo2OWdO6SzHk5YXGG9aN9Qz3fij8/bUpR3uSckBdH1sU8I7a/kHY3yQ9gPckZgmV/xARyiixWDHZbW/VNZQiuvkF7oqyb+e0MsZlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MD19mhN0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MD19mhN0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709473204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l6jv2E3xGUErcOdu2WzOZQEd53M/R5mSkaMstgCoBls=;
	b=MD19mhN0caRTQzApvazQsBD/0SrtOrTNqkTu/cHBkDjiXzcBZqpIx0I0Ax/N/8gyoh7zOC
	aBQU0yQDVuX76kMMgbdl2YS4aFf1jNhP8e3RaA0foBOYK0Y1eUr09/QnqVkA519scQxDxp
	EgzCng+OUTdYE3AL4NJHwZysZ09fH6w=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-oLg2MHt4M3SMj8nCWBxfQg-1; Sun, 03 Mar 2024 08:40:02 -0500
X-MC-Unique: oLg2MHt4M3SMj8nCWBxfQg-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-29988382913so2199882a91.1
        for <linux-xfs@vger.kernel.org>; Sun, 03 Mar 2024 05:40:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709472897; x=1710077697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l6jv2E3xGUErcOdu2WzOZQEd53M/R5mSkaMstgCoBls=;
        b=Ie6FRxNnfvJJPHCPVGmhzfXxTe7elOGholpo5hWM21snecOFVkHQVLCULZqwh6BYxB
         VFd0Its5WMt0jaXdAamRjugoCe38MKYCYmZVrZKyN/idGdi6PeMGjWDJSN53IOh9tux8
         K4gQqb1zb0A97jNIcn4ELGieixU2sFVwyhWrvDY+fUaWT+ueeuTWm4x/LDi7fGLWeEZg
         xkYyV1kMLVg9AnKOg/LrAz+TTbn49CaBqy4bUCMpAnvUPEAZZywYY4mlD2Icmi6J1VkW
         PHmtdkTI18zYjQJ637ZxGAeP/MuPv8+uyhCcSsFVXUbtWAWi8MzU5jbRQfJnVnep5fcc
         1v+g==
X-Gm-Message-State: AOJu0YzfJfiIRyTePPKxod/MuhPQwX8OJiiA5D8fSi/REfmFDiokkcgX
	hgaR3zxsaoQvCa5xTez5uMnd7z1685VzRMVkW1GYUPqw391uIWwr11VqKdqNESuIo/MfcXXKya2
	7YXZimtrnOLM47a+OBrOGpYbKra0C0jLrtC3CAihYSVLivs8fR20TryL18A==
X-Received: by 2002:a17:90a:a88b:b0:29b:33eb:1070 with SMTP id h11-20020a17090aa88b00b0029b33eb1070mr1833933pjq.14.1709472897540;
        Sun, 03 Mar 2024 05:34:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHqqxoyPYW/Fl8gltiL9xsIYwkNBztjmh3JxIRmwjef8V0+LIrsEqP5bt4bAkGOBTS26eQqww==
X-Received: by 2002:a17:90a:a88b:b0:29b:33eb:1070 with SMTP id h11-20020a17090aa88b00b0029b33eb1070mr1833928pjq.14.1709472897230;
        Sun, 03 Mar 2024 05:34:57 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ee15-20020a17090afc4f00b0029aef43b860sm8299228pjb.57.2024.03.03.05.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Mar 2024 05:34:56 -0800 (PST)
Date: Sun, 3 Mar 2024 21:34:53 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET] fstests: random fixes for v2024.02.09
Message-ID: <20240303133453.bxsvioauy4jhtkgf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>

On Mon, Feb 26, 2024 at 06:00:41PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Here's the usual odd fixes for fstests.  Most of these are cleanups and
> bug fixes that have been aging in my djwong-wtf branch forever.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
> ---
> Commits in this patchset:
>  * generic/604: try to make race occur reliably
>  * xfs/155: fail the test if xfs_repair hangs for too long
>  * generic/192: fix spurious timeout?
>  * generic/491: increase test timeout
>  * xfs/599: reduce the amount of attrs created here
>  * xfs/122: update test to pick up rtword/suminfo ondisk unions
>  * xfs/43[4-6]: make module reloading optional
>  * xfs: test for premature ENOSPC with large cow delalloc extents

Hi Darrick,

This patchset didn't catch last fstests release. Six of the 8 patches are
acked, I've merge those 6 patches in my local branch. They're in testing.
Now only the patch [6/8] and the [8/8] are waiting for your response.

As this's a random fix patchset, and I've merged 6 of it. If you have more
patches are waiting for reviewing, you can send those 2 patches in another
patchset :)

Thanks,
Zorro

> ---
>  common/module      |   34 ++++++++++++++++++---
>  common/rc          |   14 +++++++++
>  tests/generic/192  |   16 ++++++++--
>  tests/generic/491  |    2 +
>  tests/generic/604  |    7 ++--
>  tests/xfs/122      |    2 +
>  tests/xfs/122.out  |    2 +
>  tests/xfs/155      |    4 ++
>  tests/xfs/1923     |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1923.out |    8 +++++
>  tests/xfs/434      |    3 +-
>  tests/xfs/435      |    3 +-
>  tests/xfs/436      |    3 +-
>  tests/xfs/599      |    9 ++----
>  14 files changed, 168 insertions(+), 24 deletions(-)
>  create mode 100755 tests/xfs/1923
>  create mode 100644 tests/xfs/1923.out
> 

