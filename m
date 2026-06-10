Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239E33FA5E7
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 15:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781105826; cv=none; b=iRlndp3xIZbT5vrKpXEGTEAOpiMOt/8eH7v1yY11d9ZbJRdEx7srVDA5QEChG2eTeYeFYfim7LPudZdmmvs3lSp7xnMqHv21k5ooJ/uQD3EbPj/YV2s1qLI54GGD24LNgnsI8THq60cOzFCoy5zHFQVCkFRdFnjrG0r54CxRHUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781105826; c=relaxed/simple;
	bh=0MvNwuIsJAMtXBs9y5iGe7c98OnJ3VZITed3P71ByY0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pkI21vhQvbdodVX8hRi0B4+NiXn/0cCQJk0Lv+LVEaZwzQ33LMod1kLfp6j9BB2J0xR2nD9Dh1dQI1zMJ64hzgekoc1wJQeZ7V2M2VaCMN5Rjvvk2GnfYsG1r/JKG/SbN/ZISQqS6w8pVJ5kJQb2sz4V+3oSo0IcGM1pSMp5+Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xnkc1bo6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xnkc1bo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976B11F00893;
	Wed, 10 Jun 2026 15:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781105824;
	bh=mjGijsTXEKdWt09cmG6WYphghbe32x6m/SkzKrfSNf4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Xnkc1bo6xeps2F7IiI35TGgMxGVj0HtBLWWjU1TXR+Dq0UJAvSRMIc9TkD5qjZTRX
	 pHaWbttCvuDdbdDP/UxJGiyIpr7aeRfeOkMxl0XobIK/KWpPvajNuOMarqTNvaJ2uf
	 crG5RjVa6Iw9Azu0Oih3xxPVKs73TZfK2Ts3N+ZH2rN0gPhZrERIClL6QiiSAKcOoQ
	 QdrAqS9rfqEDT+IuBlImeyPzTyiPT2xkchozaP1qL/MzUoZGU6NT8VB2b7hegMe6TB
	 tqPvirZFugwEnVsVUpw3Hlyy3lmAwVAG4gYDygoWEMqYy1yHbxLp4BKwfRz/Q1fwwm
	 3E3MIFe61diVg==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
 Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
In-Reply-To: <20260610050731.1906760-1-hch@lst.de>
References: <20260610050731.1906760-1-hch@lst.de>
Subject: Re: zoned growfs fix v2
Message-Id: <178110582328.150581.8383022262140909680.b4-ty@b4>
Date: Wed, 10 Jun 2026 17:37:03 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Wed, 10 Jun 2026 07:07:18 +0200, Christoph Hellwig wrote:
> this series fixes growfs on zoned file systems, which so far has been
> completely broken.  A test to verify it properly will be sent out as
> well.
> 
> Changes since v1:
>  - rename xfs_add_free_zone to xfs_zone_mark_free
>  - use xfs_rtgs_to_rfsbs to avoid overflows
>  - improve a commit message
>  - add a comment explaining the zoned growfs space accounting logic
> 
> [...]

Applied to for-next, thanks!

[1/3] xfs: factor out a xfs_zone_mark_free helper
      commit: 16fc9d358d12e6e9cc553162b4064ad58e7fa869
[2/3] xfs: add newly added RTGs to the free pool in growfs
      commit: ae3692c7f440c1ff577aae1a51202415ec4a794b
[3/3] xfs: only log freed extents for the current RTG in zoned growfs
      commit: 44cccefe65749821d9a13523c8b763bf1262ef73

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

