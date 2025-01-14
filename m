Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547A1229612
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 10:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736850630; cv=none; b=hEs62UyUQii5d8wVShxivrnJm6/1QskOJBtkQszFFlp9+l/bjjXB+R00XGTbL764JoI93EZxLNn1TpWIYMYOwuaTmsU0G0pd+NTIBUSE+Nu/O9/WqDy7BTDLj1M3F7CHqxalHExfP9ZItjDv7PE9ZRqD6M/UEOix0OA0NMFDGSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736850630; c=relaxed/simple;
	bh=zoBfskAiQ6Odg8pXDnsxlAzVnT9KVy3/QmXWV2xoiMM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VGJHMGc8gCka+CpHfjQ9oWb8P9DDCOc4jkk/FNVqwYr1irC1tATP3npDhloC9rAAerc5VSTxzJ6hwV5TVty3ttC16dfQ2CBLMLtQ2VJiEM7TvTgrB+Mx5pNV55fCO/+WynGmD7bOXfuYmyZorkX1SXKNjQlyp3eIg3CYAaqOpQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mZBKMb/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mZBKMb/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41E5C4CEDD;
	Tue, 14 Jan 2025 10:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736850629;
	bh=zoBfskAiQ6Odg8pXDnsxlAzVnT9KVy3/QmXWV2xoiMM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=mZBKMb/ofKGlZQ/NEMJgehPXLwwGlNqGnAF/vA3r8deFY8s492lXoa8jtY5JuxxOn
	 aVUPuUvnrcQeFvuxuUKsyRiyCtjlZOdq+0C27MQYQEE6mrgilHX1wVkthL8nY32QLk
	 8sSxHylITg4CYXnZUBe06NSpttLV3hI4ogAVn+6+lFKlKAMDnI8HUqzsliIzbTpKx4
	 8D9cjCNA26nK4ylZEn+ICgMLNvMGE16iubEMPGn1+YibxYEXWh2JzXqYyCSSkSkPEb
	 Ya6BRBXaa8UBYuiSEqMeEJtlvrCzHWOadA9UztPEDmnC/rZe6JK8jH+Kq+7s/4W6Tb
	 rM1Q5VdwdXMsw==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
In-Reply-To: <173499429082.2382820.13008491658242175877.stg-ugh@frogsfrogsfrogs>
References: <20241223224906.GS6174@frogsfrogsfrogs>
 <173499429082.2382820.13008491658242175877.stg-ugh@frogsfrogsfrogs>
Subject: Re: [GIT PULL 5/5] xfs: reflink on the realtime device
Message-Id: <173685062861.121209.6176491564309210623.b4-ty@kernel.org>
Date: Tue, 14 Jan 2025 11:30:28 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Mon, 23 Dec 2024 15:18:47 -0800, Darrick J. Wong wrote:
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

merge commit: 156d1c389c543c4620dd86ad8636ecb224be0376

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

