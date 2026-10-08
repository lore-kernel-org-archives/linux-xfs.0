Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21EC3BB12B;
	Thu,  8 Oct 2026 13:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466364; cv=none; b=Ic/fiK85UOa78vqq7dSaQh95LjUyJ45pjGPJ9Jf9ISj9DaLYPbhxPaDvmiXJZiVc0oKq489FevjhquvjcEdylOkQX8vaUxZ6j7uNs3xOGwYhAdioxyt8nqfGstkESYPwMq7Q10+U5D0A7YhQ+jQ9IXbTfQWdZyQ2KOWJRWRha/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466364; c=relaxed/simple;
	bh=VmDNLm/j8jbe2qk1XdxrfgDo4AErKXGe6l1Kmw1vwpQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Y6SzSKAeEEs1oPP1A9gxLBeva+mjJtGvDwUMF+H6a7Zrz8Db8fNVCYCvYoyZJ1U6VY8vGLokzyNaSNY5VsQr7LfpMWjGs9Wrc6AjShKEuoQ7Z1hfsecR47P+ayEyLbm+00NOEHdryxvhZeP+ztDqDN8tPLdZrxZTxbn0c5zs370=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F6ZEjrPv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F6ZEjrPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59A11F00898;
	Thu,  8 Oct 2026 13:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791466363;
	bh=jJBo3r9KagNzN0xz3qD2A8wApt3doxQW9fYGu1a59Yc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=F6ZEjrPvbywTm65dEl2jfH2Mdx6Y+aoTIxj0vY3+rA02QstJgzXpkVz8164dFoGbf
	 L89eaxwOqKItJ/z8XdTOdRkt6g/VX8mEI8xDI/Sgo6hgeAS90j728dJ6U7Nysryx3g
	 TZL5Q+/bdYNPzyV9LwLudyj1pW5sMoGm8jSs2AJSYQk/t+R+9vUze9uIRaQr/gfIDi
	 cY9KY43BjAQd+FCnB3yNzXaZ4xUPDwooB8OS1MpTRBwGsU4Mdvr42Okdipq8yi1H/B
	 hcYB0qBFvYyz8RnKJSLp6jA6GJWYQ9NwLK8gleCNKHPO+eSFxFCg0JACCQ23o+PCii
	 G50uH082HuOVw==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET] xfs: LLM-inspired bug fixes, part 20
Message-Id: <179146636261.378461.17746297184048857926.b4-ty@kernel.org>
Date: Thu, 08 Oct 2026 15:32:42 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Sun, 04 Oct 2026 22:55:27 -0700, Darrick J. Wong wrote:
> Here's a twentieth batch of xfs fixes resulting from a LLaMma.  Mwa
> mwa mwa...
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> [...]

Applied to for-next, thanks!

[01/12] xfs: flag excessive delalloc rt extents as corruption
        commit: 2b47be015a5e54f4a3d62afa636ba593de9b67f6
[02/12] xfs: zero out di_metatype when removing the metadir file iflag
        commit: f5b4d8c8ce16675f77c25a4ff06caaa9a2739f31
[03/12] xfs: forcibly reset quota timers when upgrading to bigtime during repair
        commit: 780212c8d8105eadb5f56b4c7aafb94937755582
[04/12] xfs: don't pass iget failures up when marking ondisk inodes
        commit: 7f5e8bf335e5e257fb82cf5b3521980ded60e863
[05/12] xfs: always reset incore attr fork buffer when resetting fork
        commit: 71cb13685e72a3c5d118732559c727a0c9090b7f
[06/12] xfs: propagate errors while checking null siblings
        commit: e5bde75a816b3549942f4b09a8bf09006b7ea9de
[07/12] xfs: don't try to scrub self-referential dirent in metapath checker
        commit: 1e7337a3ecebab1bb2ba02187d88b94e5146e4f0
[08/12] xfs: don't allow sm_agno for non-group metadir path checking
        commit: 20c5a56bc4f2329872d21561e4a2d4b8576004c9
[09/12] xfs: init inode number for tracepoint
        commit: e98643f794d0d7a7fde8b29276d74e09fa0d5d19
[10/12] xfs: release ip after unlinked list store failure
        commit: 9a263723d7c9ab0615bab3f5cc145d3d24454a5c
[11/12] xfs: always zero the whole shortform header when zeroing attr fork
        commit: 52aa50cea408e27454d206cccecbe4f694a6c1e1
[12/12] xfs: always forget cached ACLs if the attr fork swap succeeds
        commit: 41ee987f53785b9443388a756912b1a0fe3c9592

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

