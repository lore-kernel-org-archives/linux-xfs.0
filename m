Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1929320397
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 16:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758298556; cv=none; b=gB1sPeoSbbCzr/1D15LMqzSgAIm4BiRkvYF9pmRT2Q8Pc4IswHYWZI63mQV9moJL7OeUYfPaMVVR+yKPQj5ntOM4yC2BI4TkAmuPOrhgWscNRmCng4cqO/dFKforVspOkvnP6/0fQNI0RmNNJ3B4HE+Vk0VAmfVbgmzfvirB48Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758298556; c=relaxed/simple;
	bh=cdlTjZ8S1TI2YHcEAp5BGadDHiD9VnH3GOKjGwYIz2s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IhIiAujWBLxxfkJhFHONxffvdeUHoWsGCyB++RbIxHC4Qwl+UfbijevGPvkBckNqKyFOMMZcNqVz6/BSnPGfc6AkksnrPnb7m/EQga1yLnUiWG4uS5PjAosaVnvGkbaObA6pZiKKL3SSZrd/Zaf3qNwraHGIh87OvwDtobvK43w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K6SfDEn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K6SfDEn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47CFC4CEF1;
	Fri, 19 Sep 2025 16:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758298555;
	bh=cdlTjZ8S1TI2YHcEAp5BGadDHiD9VnH3GOKjGwYIz2s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=K6SfDEn0yebNXlEy04EUxY63NHeAlZVonOMOSyE5ZqxlZKamvy10NGXZhHLmmSjPd
	 oYbR0WqfWl2pXtqRpOySXduOhSFHii5MALvyaSFTJqg0KaYN9VJiJSPd2Hylvlxv0i
	 3UBel1rgkGYVIikUBtUluj2+F25iQgNirZnWZWosC6U4ay9q3s8VrdvcFOWZB6WUDM
	 N0qOAErx+Y4Gn+793TTIOopdtkVwSwwGvrHdnuB+jhSLO00FGHu/Ht2YPvwJ7Kgo6l
	 CNQYgoyOkFglaf3KH2ZZq4u4m4GyYC57bngFv38UIBZWflg1KTmwQQFiqkZxdZyc1t
	 r95KT2X+jldFQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20250918143454.447290-1-hch@lst.de>
References: <20250918143454.447290-1-hch@lst.de>
Subject: Re: cleanup error tags v3
Message-Id: <175829855464.1207654.11248308313339579475.b4-ty@kernel.org>
Date: Fri, 19 Sep 2025 18:15:54 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 18 Sep 2025 07:34:32 -0700, Christoph Hellwig wrote:
> while adding error injection to new code I'm writing I got really annoyed
> with all the places error tags had to be added.  This series cleans the
> error tags so that only the definition and one table have to be updated.
> I've also cleaned up a lot of the surroundings while at it.
> 
> Changes since v2:
>  - improve comments in xfs_errortag.h, mostly based on text supplied
>    by Darrick
> Changes since v1:
>  - add a big fat comment and a idef/undef pair for the ERRTAGS magic
> 
> [...]

Applied to for-next, thanks!

[1/5] xfs: remove xfs_errortag_get
      commit: d5409ebf46bb0735ba26c64d7a9c80dde3f94eb6
[2/5] xfs: remove xfs_errortag_set
      commit: 991dcadaddcced38c5d2da656862d94a1fc9e6e5
[3/5] xfs: remove the expr argument to XFS_TEST_ERROR
      commit: 807df3227d7674d7957c576551d552acf15bb96f
[4/5] xfs: remove pointless externs in xfs_error.h
      commit: b55dd72798115015908f4a17a1f8d70e8e974ab4
[5/5] xfs: centralize error tag definitions
      commit: 71fa062196ae3abab790c91f1bdf09dcdc6fb1fe

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

