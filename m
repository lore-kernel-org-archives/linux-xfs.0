Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C3528F95D
	for <linux-xfs@vger.kernel.org>; Fri,  9 May 2025 11:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746791007; cv=none; b=sIiK56xdgAaW2FkvPQ+2Fbc2tSkmv8LkxxDg6HlHTMfASzjjn5GqYpdRuBUGmBzrtcPyJadQ85qfcwGyYADYoC1e6uwtB1soKuNfYagjkYfiTB7CvG7yZXLKBdQbXOWNBf4VB6invss+c6a06Oh8HIjmX62gXD46dsazS1y7bSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746791007; c=relaxed/simple;
	bh=hN13efC7PjCXBTJ+8TUwbzvhNuSMltlt4JOicVGW+LM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VWnojpX7oU06GQUuxNOkYHZA51ktb7+R4iLeWd/K1Nm0/7xFB5fzLDOJzB7cF4L3GEE3uiylCZ0IqftfgYMrt2s+Xouj7Zm59oUKTKoq+N80vu3RdrYb3MxM5gmB4onSpBx6JO2IoXTb5SPIu2YWa1LyE15gbxsYX1OLGGRMRqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ty6ywI+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ty6ywI+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96300C4CEEB;
	Fri,  9 May 2025 11:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746791006;
	bh=hN13efC7PjCXBTJ+8TUwbzvhNuSMltlt4JOicVGW+LM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=ty6ywI+7OI3sdik90fBvZ9WGFZpsgQriTjDXlivDK0G5uUrlcF9oozAWgbOmL8Piz
	 eHb0spLT8fvTsyZNF2QZG53oErS3SE5oz+lhN922gEUo5TUXyN96nXz8/XmTxhYnaN
	 6deOIEHYUL4H1gA9ZEa+NHw3M4MD0BLiKvW4pPhQcKW+gS1+dA3MyDNi0xarZT82vF
	 Ir5ukKViSnRGNye5b0atC9UjyOt/tAP23QHYjo0mMpBb1GbOBEjrAq90kpSkThhqBu
	 TTu36dIBjAAiDBe4V16bFljB8BTgHjZ8r2HQoVi3Vowe91/rZEFxEI3NzthuNm39uv
	 6tlReZGMXMFRg==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, john.g.garry@oracle.com, linux-xfs@vger.kernel.org
In-Reply-To: <174665351406.2683464.14829425904827876762.stg-ugh@frogsfrogsfrogs>
References: <3c385c09-ef36-4ad0-8bb2-c9beeced9cd7@oracle.com>
 <174665351406.2683464.14829425904827876762.stg-ugh@frogsfrogsfrogs>
Subject: Re: [GIT PULL] large atomic writes for xfs
Message-Id: <174679100532.556944.7138422124823862954.b4-ty@kernel.org>
Date: Fri, 09 May 2025 13:43:25 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Wed, 07 May 2025 14:32:12 -0700, Darrick J. Wong wrote:
> Please pull this branch with changes for xfs for 6.16-rc1.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> --D
> 
> [...]

Merged, thanks!

merge commit: 4abb9052a72bc98d521b0535b5deee243a3bbd12

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

