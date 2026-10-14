Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55DB4A5EC6;
	Wed, 14 Oct 2026 08:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791966514; cv=none; b=kNDvLum5efpMzyF01rvVWSpXv4VPZG5tQPQiMKY1zo34Guk/DuPAfXIZ1L/2gpNrRpeJ6NEiCKT4BLgZtXN8NH8fWJoZ56f7dcmeRJ/3VofXIeYhypl8luIihYgQ4dnJB6t8XYf9Id0dYd7gkuQyIdctWGfmIVRMLYAxf7JiWAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791966514; c=relaxed/simple;
	bh=5B+s5XAtpLrp7aNBPuebaYjuzZX+7wRPOvmNro33yDg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=stoZ6sWY0ov4ray4M2aN+UEjVSYhHhRi6faY3ijiCeeEROy52WEDge7WLDe98VqXg0aWvAjEO1+moozcVGIA9c8UDIdcUV3YzZ3LFnglle8gzkriLLHUKFed3VLOIZFtmHP5jQ50lBaoCmd93XBg9efT+qs/slIiMfDDxXt1M/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eaOsd4oW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eaOsd4oW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9129E1F000FF;
	Wed, 14 Oct 2026 08:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791966513;
	bh=0tgLJL4LD7zCdRELlMuMmXIhlo6JFZcu3GAiv5XGnAY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=eaOsd4oW1RANCyUPUEy13GaFMiQ+zrn6BKrUqAJTHZjiuoM3t8pPugaenzjj9U4QR
	 Y+CDh5+vNOdkqgyPqPegoPMkMAUaSHnY7Pl4cFuN5T/G8OSFxJIYp8DOLS/yNMHFWs
	 y+Npqc0sVRj5P5s+AZii49MbWQj3rF8um08etY49z6zKCG7AcPWK/Uh+G26CyVNpIQ
	 PtiLCF6EKY9zNVyhnXiTubKFG9GdpCzPt1P/fO40To7rvoG2gzBU/6Ozzs7tM4RNiU
	 gTEiPPXtIExIcyT+CGAPQvOsWsOkWv0PLwSWmBoiIHgcQWj70qygGH6nJDOnVT24vy
	 LfiZwLJRcFcWw==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
In-Reply-To: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
References: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET v2 2/2] xfs: LLM-inspired bug fixes, part 23
Message-Id: <179196651229.20513.10034700131514474421.b4-ty@kernel.org>
Date: Wed, 14 Oct 2026 10:28:32 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 12 Oct 2026 23:05:22 -0700, Darrick J. Wong wrote:
> Here's a twenty-third batch of xfs fixes resulting from a LLaMma.  Mwa
> mwa mwa... this is the final batch of fixes from me.
> 
> v2: fix issues pointed out by reviewers.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> [...]

Applied to for-next, thanks!

[01/12] xfs: don't set a metadata directory's parent to sb_rootino
        commit: c9f98b0f4f70c8cfd617dc2886bf2fc0a36ab9da
[02/12] xfs: don't rescan ifree and icount when frozen
        commit: 18028768415e3c05ab7edb22d740e2f4dc52836a
[03/12] xfs: rescan the AGs if incore delalloc counter is negative
        commit: 47b1e941bb55f735d82ba2649412260da78b98f8
[04/12] xfs: don't try to repair rtsummary if the summary file isn't computed
        commit: 6e82b7641889ad0198f3bf17a5e4c6fe7aab0850
[05/12] xfs: update quota flags on secondary supers when metadir enabled
        commit: 9d9ea6e6cbc4cb1a36fb79f873d97e1ac2fe1a64
[06/12] xfs: refactor directory data block walking loops in scrub
        commit: 19b5653cc870788df71e7fcf2dd7b6131d8868dc
[07/12] xfs: improve dirent bounds checking in scrub and repair
        commit: 5d470234d04dae6fe2ca2cf4b9ef277b78c7e05a
[08/12] xfs: drop unnecessary sa parameter from the xrep_ag init functions
        commit: a55686b2f50500d0a453b43d45677c9824fb4437
[09/12] xfs: drop unnecessary sr parameter from xrep_rtgroup init functions
        commit: ec72fccbc852fdc30bebb31146374fc99ae0b87d
[10/12] xfs: drop unnecessary sa parameter from xchk_ag init functions
        commit: 49869d5d0356c9468621de24d49bac43b7893782
[11/12] xfs: drop unnecessary sr parameter from xchk_rtgroup init functions
        commit: 02c8e8d78792164df615a8c54411501e91fc7b64
[12/12] xfs: refactor inode forkoff to byte conversions
        commit: ce58cff1077dfb9ec3d0e6f5da1b06a85be035bb

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

