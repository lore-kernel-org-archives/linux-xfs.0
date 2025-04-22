Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4BD284B51;
	Tue, 22 Apr 2025 14:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745330946; cv=none; b=GvvC2mgHubdqrv8CIjJTOaihgJ3zgpYqh4Qu4C3mR0BzJfzCLKyKmX/LxWCiRdPvUlr2hXcu4tTsZ4JuB9k04IgWtcdN5wXiYkxqRepWJqCpB18z7vf7nHbOA4+IVWYoC/t+blwhGiQH4OMq948ISeeZmBUnsQGSSNuoasT5pJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745330946; c=relaxed/simple;
	bh=6LSksaHulYD5cBt/S7EpsqksvLpBu/U3jl42E+cqNik=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=h4nsholET3FJuM+BSAkQtF7MrhrG86huX3/5xVeb5Xce25njzlVRHYI58cVq1u417LiFfzz2iBlL7pMI4jNuY8cIM5of0U40LvsvKNPYoFyDzRQ28nwe2TYosDtZ3NIcG2Vr+6Rc2qSmZjH87Mi0gznukr5LJUQO9eEV/ux7lPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H7s9n4am; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H7s9n4am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D66CC4CEEC;
	Tue, 22 Apr 2025 14:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745330945;
	bh=6LSksaHulYD5cBt/S7EpsqksvLpBu/U3jl42E+cqNik=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=H7s9n4am8+AMlyiE2judvm9czo3yTVu1lSOZ8pU40B28HBa56K01AnjIo821htm8o
	 DDo0Jrs2Ki9CHBeaIPomHpuFWT40CJuc5Tlh6HAiOh/uF4GK31r/iYx1zd6bhHFZfT
	 /JVAmeqXaAqtj2/rN/2X8hM5NxGeRHnGx4uTdPSNdfOSQiVoIWGYki2v+/2s3osat7
	 dPDO3SAiZJIe1HU8VhekqBifT/tKp1prZyCJZmeqdiuNsslXGG4Ror3/8OsEeLgwdp
	 CO4PztWyWJi1Jm8Yl/PxdaVoPPrPRj05ptZEL+jXcak52n/uqzeuAvSjs+Y0DWbTwO
	 Y7YjfTmipMooQ==
From: Carlos Maiolino <cem@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, 
 "Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>, 
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250422114854.14297-1-hans.holmberg@wdc.com>
References: <20250422114854.14297-1-hans.holmberg@wdc.com>
Subject: Re: [PATCH] xfs: remove duplicate Zoned Filesystems sections in
 admin-guide
Message-Id: <174533094408.1020409.11803214533653570257.b4-ty@kernel.org>
Date: Tue, 22 Apr 2025 16:09:04 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 22 Apr 2025 11:50:07 +0000, Hans Holmberg wrote:
> Remove the duplicated section and while at it, turn spaces into tabs.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: remove duplicate Zoned Filesystems sections in admin-guide
      commit: f0447f80aec83f1699d599c94618bb5c323963e6

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

