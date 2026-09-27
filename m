Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83AD38398D;
	Sun, 27 Sep 2026 22:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790549336; cv=none; b=ELU787qAiNROeSngsF5xxQzrbQHWxzAvPj8ZYlKGPe3FPsIQnr70QjcNQ3hWK3F0l6wMCqLPGIWoR+KUw3hKsDJcGZLElJ76BpkeK18f2TMFcr0JXAxmGH2ocbuzK/EvLV05nRIR0DVkxI/2eRRgC6oNtHQKvWpo5crO5UuIUQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790549336; c=relaxed/simple;
	bh=3ho1h+KM/VyELl2jCEVMjv2jb6/E2EmXIdmB/NvnTic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E1B4P+3YDHAXIfFs228gK6eFUfiRcBWz07vSqOKxOcKzmDcWKisArHF1obS4y9RPhRMgmNf6MxZtmjnhrM7dg0cw95naTIUZPybtvsN4hyKZnY6IFEmgKLfRlRcCL/JZVWWdtV3PbPEwJ5hOXfmxnErrss67lM2nM3foc+2i318=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B0oarYu8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B0oarYu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A5D1F000FF;
	Sun, 27 Sep 2026 22:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790549335;
	bh=py3FWWgh37ZtpQZJsiyyfNmzFNQ/4HLrvvHaB+jkBw4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=B0oarYu8vL5xt/zkiLN47f7mk3rRJujql71dB1G/3R/ppmZPZpEtphbaK4Xwsv3ax
	 b2OFT9+OePf4DiBRD8kkO1MNJNkMz1iTYOfuqhQAxJzC9hlwkEa/N5dXHpzvOziwFe
	 73bt0NsuZRGw3m4FLLHsx9HskLGvWifui4XAISS7eeUcQAxbFalgmrxiHtWIzT5Otd
	 fPxJA2P9woXkroDvXmqdJvSAh+adg1p9aZGVTadeMIfbvsKD1ufCiHmpTmvpQncgDw
	 lzE2v7owD+5i6UIfco/2l2kU9Ws15MracNV1w7gkmmAD/aNTdn80XiSKVuiCHs24mF
	 RciQwcqGYjLkg==
Message-ID: <da2b1dd1-bb24-4d05-8705-3b5bf7443a5a@kernel.org>
Date: Mon, 28 Sep 2026 06:48:51 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 13/13] fstests: test UUID consistency for clones with
 metadata_uuid
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <905a961a3bb2ec345285f056053e3016ad3bef6e.1784949155.git.asj@kernel.org>
 <apc5PMJFYtrUyG8U@zlang-mailbox>
 <ea5b61d4-0cba-4afc-b5e0-8720d4717872@kernel.org>
 <20260927150618.GZ6253@frogsfrogsfrogs>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <20260927150618.GZ6253@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


>> _require_metdata_uuid()
>> {
>>         case $FSTYP in
>>         xfs)
>>                 _require_command "$XFS_ADMIN_PROG" "xfs_admin"
> 
> The presence of xfs_admin doesn't guarantee metauuid support on xfs;
> the script predates the creation of that feature flag + cli args.
> 
> --D
Do we need to check and guarantee metadata_uuid support on XFS?

Taking hints from xfs/077, which lacks a check for metadata_uuid
support, leading to _notrun()).
