Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D121A6838;
	Fri, 11 Sep 2026 07:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789111700; cv=none; b=ZSHn0R4eOmztWq7kPg97o2sKjlskKx04MJFXtsJzbZK+aYPOhHmPK3ykVfJ5uJIZJMtlurpN1WaiQlVqkCbyh4HWFFpt0cFI9kIAINWYfz9nhuxCle4k8oJE4dIb1TbdS4bXlbU7om3phE8oiuufDZRlXTM7n8V+0zOfHnIQVlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789111700; c=relaxed/simple;
	bh=im4YJt9/tFyg4A2hOtuhEukgE2LYLWOIe7LJ2pwGswM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GMg0rbxB89KcI/rCsnp6GMo6uy16E6+iLtyvFfhYaDG8CBYEtzsP5zd3p3wpsgG/uiht7uczBAEVm/aSPUyibhvXL0TVpEH5GS6EY2NlcUr06UKTS7IGvncJz8s9+8x1DyyzxtaZ5V+JRD9NKv58TkihOPkJiXJ8CGcSIGhFqk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhxyqPRK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhxyqPRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B5E1F000FF;
	Fri, 11 Sep 2026 07:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789111699;
	bh=qH+vzJvTDcO/4OxAU3B3nLkaxlZTJwINDdDABG2MGNU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=nhxyqPRKfA+FhdQTlBvlZdq7LmnCmMyoVHrVzsH1J/5qP9s/AMHkkUXZ794wZ6rsf
	 yAZAAAc08U/pqcEsiGUFZWrPuHZiNPFLfxl9IA2hvGZnIm1gAwpBm6OIdRK91Fhheg
	 2RdjniBzKwQ7tbxXXS8ZOpn7sOUXb5n7eg+10pPxuKR3UUKYYSOtLb/dHOB+lJ06fZ
	 Tmp5Quic/8o0UUCWrRDmNvCrZU4AH72OLe2pteKkxvwnabuLEuvQ99jH+c+u4RPWpP
	 Nkop6mrkxRh/JCFMcP3dL3N5ul7zJQVBTuPsjjHvkD+755oykkRPpP9FOQACAVaXpt
	 p6px2hn1EIRPQ==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: floss@jetm.me, dgc@kernel.org, stable@vger.kernel.org, 
 linux-xfs@vger.kernel.org
In-Reply-To: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET 2/2] xfs: LLM-inspired bug fixes, part 12
Message-Id: <178911169750.24885.701052452949200916.b4-ty@kernel.org>
Date: Fri, 11 Sep 2026 09:28:17 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 08 Sep 2026 23:02:56 -0700, Darrick J. Wong wrote:
> Here's a twelveth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
> mwa...
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> [...]

Applied to for-next, thanks!

[1/7] xfs: fix under-reservation of blocks when repairing sf directories
      commit: 4d3c07591534517c633945c8d8e6526f10e3fabc
[1/7] xfs: fix under-reservation of blocks when repairing sf directories
      commit: 4d3c07591534517c633945c8d8e6526f10e3fabc
[3/7] xfs: fix rtrmap cross-referencing elision logic
      commit: 3bdbf472a608aeb7e8e4dc70ee86738ad5256356
[4/7] xfs: fix termination logic in xchk_bmap
      commit: d3a6a35a220615c4f4578aedf3b1626b91d3acae
[5/7] xfs: fix replaying dirent removals into the temporary directory
      commit: e854f9a28b1fa08dfa5bf18ee4184fae90106180
[6/7] xfs: reset parent pointer args before each dir tree unlink repair
      commit: 69e10c2b4a51b4ff3c88a70e90f5180ad58c758f
[7/7] xfs: advance the findparent inode scan cursor while holding ILOCK
      commit: ad4497a92caba4630f75c80d49cb947026213280

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

