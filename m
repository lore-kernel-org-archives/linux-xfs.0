Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8CA7F479
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 08:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713341636; cv=none; b=aE+nCqPF7h8sr5u6xbQuVPNQknzqNbZNMLIHjQWv7kexGp9ksrjMF1EmKXkbf80J2cbTUf4RdKcgDtsl3LVYuhQECJXATdZikUKiob/OLTJH59KKkHZKZZvsHMsX/JJ4+/LyxkOMHWqDSGzV5T3BvoDAy3rCtd0LtAFJCNkAa54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713341636; c=relaxed/simple;
	bh=YXwtqBhSHptHdyfY9BHiwuXlNXkTFVJ7bnu/haNraKQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IC8GtJDZmqloLic9owzGRVSIXN/prsVZsFiOIQo0d3is21RDVO4wruejzoVeepn8dwlTxyP3X0Gri7kIofWboPHKSEn+WBa3eSHIyUVV9vdAgA66N3nstUPdtzsm5hLZdyh+12eHV3xUS87pyvL64u67gyKB2DEW25+Mrzu+YCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPu0G1uk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPu0G1uk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B993C2BD10
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 08:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713341636;
	bh=YXwtqBhSHptHdyfY9BHiwuXlNXkTFVJ7bnu/haNraKQ=;
	h=Date:From:To:Subject:From;
	b=mPu0G1ukRIs9JjhiuHD1wE3kM45bCqvZwQ+/TM6CbXkwZy3GjYO/apTTURL4ViRo6
	 +p7K3g4dV+CgJA91GBwNL0S5SIpR5q89CVzJGLnPloYapzTi9FVDogpGfD213RWNYX
	 Ni7McWrZ99e5rOUNBpUk4kFaolrwz00hsmwqW/N+OVYtaFpvZjfyjZaJHNoSFEBSwL
	 ZmqsA6Woy6gNp1eIXWgwyv0OxA6QmAD2rYoZdDQaUDItJjTQaT3opMdRL2cxqo7L62
	 kQperGHu+bl/pI0rd985xI2oDDLwQsroPE1Yglo49mPo5Z4Hg5bXnKQHkP/VeUQQAH
	 BIxNsr6Ds1gZQ==
Date: Wed, 17 Apr 2024 10:13:52 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs v6.7.0 released
Message-ID: <fcm36zohx5vbvsd2houwjsmln4kc4grkazbgn6qlsjjglyozep@knvfxshr2bmy>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

09ba6420a1ee2ca4bfc763e498b4ee6be415b131

-- 
Carlos
