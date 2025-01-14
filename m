Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8177229610
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 10:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736850709; cv=none; b=WM9+bdW8dtINlYeW/g6J2jBpyvG0DJWRmgmjZuEybOuNkdi42hVO3FC2zRas0IUfpSH6uGd3BL25kAA0sZMNFEEJQlH8d5fKCkaOfhk0015AvFRxWGejZLIxxgU4dPk41SGTLKZNsJUPn6lbNmt5alASElA+moPQmBgQ1Ul4mns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736850709; c=relaxed/simple;
	bh=yGp1qHFegy69/6N/PdVsFKt1wnxuyr0mJYbOiTMhJyo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NcrE8eVJ1wymmsHwj0Jt+2+JeQoBmuNdF4Gj3JUhYb2V/nUQ30/sN7Ywl2vRnhk/xrVVH+zpALnbIRjW1eBtHfTcrKcFmKY2/d8qHSfVy3nFN222u0IJJU++TLaZcpv57YJPlMRgA1eWKf8AbP4T+OcAkhN0fjYE5Mov2SAG4oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uDnqDvqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uDnqDvqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BF2C4CEDD;
	Tue, 14 Jan 2025 10:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736850708;
	bh=yGp1qHFegy69/6N/PdVsFKt1wnxuyr0mJYbOiTMhJyo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=uDnqDvqqD/35GcvclGUXaIBHtQ1cgTxbtGyYRSRMtRcTj3Si0dQrk2D03ELJGhi/i
	 VfOczUKPqXgVrEyDu58K+wUBJx8S/JGAIZZYnJ9WrXQawfASwjIVjpufOoEOuVDkwL
	 71b08TKN1Kx4eL4lIX1A2EAqSzU3SDingFRP62wZVtcfM01b/0xMSNwqlXE2lZrh5c
	 J5+k8FtnfB+aB6slXntfCYbDoSTzeoUUOWCv0p3dwJiYgpOr+JAJF6cbgkT+dszulO
	 hSltQdZ6u6Uhgo57+u8Z3sHVQYNd0zXcBWKbVfvx6RUM/VVloe4ogpP/5VIVE6rpKo
	 UVmZrvA95+5Og==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
In-Reply-To: <173499428862.2382820.11178785771990555823.stg-ugh@frogsfrogsfrogs>
References: <20241223224906.GS6174@frogsfrogsfrogs>
 <173499428862.2382820.11178785771990555823.stg-ugh@frogsfrogsfrogs>
Subject: Re: [GIT PULL 3/5] xfs: enable in-core block reservation for rt
 metadata
Message-Id: <173685070766.121451.6357558975139072042.b4-ty@kernel.org>
Date: Tue, 14 Jan 2025 11:31:47 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Mon, 23 Dec 2024 15:18:16 -0800, Darrick J. Wong wrote:
> Please pull this branch with changes for xfs.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> --D
> 
> [...]

Merged, thanks!

merge commit: af32541081ed6b6ad49b1ea38b5128cb319841b0

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

