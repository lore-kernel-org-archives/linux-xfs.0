Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DF1390C8B;
	Mon, 23 Mar 2026 10:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774262841; cv=none; b=YK1Erd3SrXwFbFBXS0jmFMwG5zDpuPmcrfd7asljQqgvB7SdwNC1ZfoFWHJcuL0i4PL1RgnLhmQa43UokFUzgHgrx/OMCUTCxq4z/XEaesGb2qtiVvWLfnkF3MNYC24Vc3J2i2P1LNKx2t6a6SQWZSSBlxHMc9oC/BJi+W8WdoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774262841; c=relaxed/simple;
	bh=ToVYtzpds99XCK4HU2wIm72dTCT83YjWAahi4Wzyo/E=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YIQFIxew2vpavUVMfpH/5k0gYevBy3PIKe4Dnd+jAO/lwQA4Np+25VsOtBHoPGNdvyneh0k6pdSEeSlQQcvvtpVsWk2kMRgv1MJcQG7WzHSEHT+sMxTOunTp3fr38bQWsOY1WG44nx58os4lVKfpkIm55y12yDJ+SumAemP/MY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vw469Pl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vw469Pl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5B7C2BC9E;
	Mon, 23 Mar 2026 10:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774262840;
	bh=ToVYtzpds99XCK4HU2wIm72dTCT83YjWAahi4Wzyo/E=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=Vw469Pl82RPSvD/4FW9wIfQ0TfV7MGcjHfUD+NgS1nS/yjIfELhaNsgYYHkONd6Bw
	 bmdrg8Fi1av7hlFPf5U4FrIcE1zv/v8wZZCFeURJ0f1j39ix+fUJy72EaWthXMTHG0
	 cH5lDdubIJzb7gbvPvzw3zuyODHODnR0ttLIGNLR1EXcI62UyMTsEpIH6nxN1vsBFg
	 8BWQ5VdjLzS/FKAEUXfL8e6RRlnYncNGpNwHFSNAPU8JGSTfflAN3rwIIPxhZMaRgR
	 tzhae8yXcBBbzVC5y7NwMT5gbpXR8VLHjOHN18Atv4hOZHLPKtU/ji2KmUEgT/Ekg6
	 cM1XhRIDkFlMA==
From: Carlos Maiolino <cem@kernel.org>
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 Brian Foster <bfoster@redhat.com>
In-Reply-To: <20260311162502.192375-1-bfoster@redhat.com>
References: <20260311162502.192375-1-bfoster@redhat.com>
Subject: Re: [PATCH v4 0/8] iomap, xfs: improve zero range flushing and
 lookup
Message-Id: <177426283968.254917.17482470861788791651.b4-ty@kernel.org>
Date: Mon, 23 Mar 2026 11:47:19 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 11 Mar 2026 12:24:54 -0400, Brian Foster wrote:
> No significant changes in v4. A few whitespace fixes throughout and I've
> added some R-b tags from v3 review. Thanks.
> 
> Brian
> 
> v4:
> - Minor whitespace cleanups.
> v3: https://lore.kernel.org/linux-fsdevel/20260309134506.167663-1-bfoster@redhat.com/
> - Inserted new patches 1-2 to fix up zoned mode zeroing.
> - Appended patch 8 to correctly report COW mappings backed by data fork
>   holes.
> - Various minor fixups to logic, whitespace, comments.
> v2: https://lore.kernel.org/linux-fsdevel/20260129155028.141110-1-bfoster@redhat.com/
> - Patch 1 from v1 merged separately.
> - Fixed up iomap_fill_dirty_folios() call in patch 5.
> v1: https://lore.kernel.org/linux-fsdevel/20251016190303.53881-1-bfoster@redhat.com/
> 
> [...]

Applied to for-next, thanks!

[1/8] xfs: fix iomap hole map reporting for zoned zero range
      commit: 92e9dff9ca5026805798b13b967760f8058794e8
[2/8] xfs: flush dirty pagecache over hole in zoned mode zero range
      commit: 2f46c239fce617ac26cc40d9520b1c0cf05cd34f
[3/8] iomap, xfs: lift zero range hole mapping flush into xfs
      commit: a35bb0dec9552aa2bc69a24e3126c68c257bf55e
[4/8] xfs: flush eof folio before insert range size update
      commit: c35a3e273e86e89f73abc4e75e33648fac20eec9
[5/8] xfs: look up cow fork extent earlier for buffered iomap_begin
      commit: a8eb41376df987887b33dbf7078d5b13c85f3e0c
[6/8] xfs: only flush when COW fork blocks overlap data fork holes
      commit: c770f997a4227b6fc5f62275b2337622213e35af
[7/8] xfs: replace zero range flush with folio batch
      commit: ce9d27ca8b2eafdd2457a15aafdab74218843138
[8/8] xfs: report cow mappings with dirty pagecache for iomap zero range
      commit: 388bb26b3d33de3c53a492824a4c5804151a0014

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

