Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C19229604
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 10:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736850701; cv=none; b=RuTBQEfiMorEYiR9avyiDaY8yZN2ATN5evLSmi7rRSyfnmfzTvQ4d0FREWgGDXFpefM6LjRjimUCxbkzGQ7XKmf24YjH4igiJMvv6VxJYSrYZRtkSGYujQYjl7neNj+/dRiPbi77yYQFYzF3VA4yLGl2yNXS02GOo+ilduETX8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736850701; c=relaxed/simple;
	bh=gMPuQpvD9Bo2FKBJoWq3CWQaRIeIRhpmC2JiL7AZ4Ic=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=U2k+gTOfCotdMwCC9H7kTVPbP3MzxM0C+nWm5dEe5OiKp7z/6xNYCUFt19M2rHwpfSbSgc1X7p/23qBIRi2tulqRRoJvEiSidXWwB3Vdli3dnTFgwtBEhj9WD40cWL93ktORDlv3SBV/KVtOb87+3Np2udPqbK7oJorzPT2LD3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b2K3P52F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b2K3P52F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A22C4CEDD;
	Tue, 14 Jan 2025 10:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736850701;
	bh=gMPuQpvD9Bo2FKBJoWq3CWQaRIeIRhpmC2JiL7AZ4Ic=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=b2K3P52FJLfieUUIFXsmzy64mTnp3o8XjBd9HuJC/AY32VaPvZlfMDEctAfh5Vv5W
	 mHvFyZT29q7qKx1QWedxeQRJf6SfSFLQajqYd2Io1vpR0PVcm7joR4TAy8LZHug+7Z
	 0jI8Ze0wWB0t4C4n7eT+HpQ7pa++wId0aNv5kR+5Ehpsf3QAvGtTEMB7m7k2HTbocc
	 w/P7Uo+CPxJNSFh54x4tcrwAffcpMeELBLIw1eiQMIygjy1F8k+tD9vfCKnaZfP2oI
	 NdpehgK4r87RYOOuBImECl4Rqq4skp5AxhxinOHtilNhW4kTM2OFGrz5R2Nny2AhB/
	 FazthP6EBtg3A==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
In-Reply-To: <173499428759.2382820.11756798556084282447.stg-ugh@frogsfrogsfrogs>
References: <20241223224906.GS6174@frogsfrogsfrogs>
 <173499428759.2382820.11756798556084282447.stg-ugh@frogsfrogsfrogs>
Subject: Re: [GIT PULL 2/5] xfs: refactor btrees to support records in
 inode root
Message-Id: <173685069981.121426.12089572431841708005.b4-ty@kernel.org>
Date: Tue, 14 Jan 2025 11:31:39 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Mon, 23 Dec 2024 15:18:00 -0800, Darrick J. Wong wrote:
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

