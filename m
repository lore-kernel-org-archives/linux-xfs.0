Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978CF1D9A50
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 09:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737019057; cv=none; b=HcOjU4KrCfYGm94UE2QECo6Ql63w0ica7Gwt78keF0uZG1TBEwZhdWRjuRreKGI3uMJsGXtVaG/tN06xtwv1K0ccgJSbwq4GBOvdmMj1zEbYn8cNMzwI7LOGozZY+yuJ6cU7cd8ONt7JHNE/Z342qzKCpSkiqfRKmU2Qfn3yxOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737019057; c=relaxed/simple;
	bh=KsdCMS3wnD148j5LMN+FHgIDcbri7wF433CzpWNeDEA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tPrwJDbt3GMR08jEak3JMYbxZvOvKXLvz4C7RP9wBUKGY7PhUjSsQUssBNof4CIF3FaFa5UXjiIUB0UXfXBiz2Ice6ql2rSnIPigqu7W0FvQFLVrdEbP4kilbocoskguIERumlcMK7ZO2MPQK0F7sBZCqDUS3o5P3iO0q0q39sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G9NvW80Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G9NvW80Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CFEC4CED6;
	Thu, 16 Jan 2025 09:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737019057;
	bh=KsdCMS3wnD148j5LMN+FHgIDcbri7wF433CzpWNeDEA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=G9NvW80YEG3FrXb+rXAMlS2uLNdowIJqYTTaGdFZSmHQ20wObCFlrn+b59ShC6hZ+
	 VHYCBbh/k4zE+G6thzuS39y7RoJAIuHa3anuXyuavMEXdD2kPiSsdulxMXToRPEGD3
	 5mq/AWbDfFLca/m91gd/EljDzCc5tCu11VfX+8aQ2+3+j+Q8pq4wLgpTFPTzXfic6F
	 rbruhJZQrPGW1Shl8yPHU9CXp1s6SzFHOdDjVLb6gyZ2Prc79ALDz7QaPBf4EMoHOt
	 R+TEe+8nM+ji5ppYk/4GUQ99MZIyrQuEse5vchx3lujsUFF2kI9GKRrR8bUOCZTo1e
	 GY5brSsaI8Pxw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20250113141228.113714-1-hch@lst.de>
References: <20250113141228.113714-1-hch@lst.de>
Subject: Re: buffer cache cleanups v2
Message-Id: <173701905597.373819.596117184604981082.b4-ty@kernel.org>
Date: Thu, 16 Jan 2025 10:17:35 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 13 Jan 2025 15:12:04 +0100, Christoph Hellwig wrote:
> over the holidays I dusted off some old buffer cache cleanup as the bio
> splitting in the zoned code gave me a better idea how to handle
> discontiguous buffer bio submission.  This spiraled a bit into various
> additional minor fixes and cleanups.
> 
> Changes since v1:
>  - make xfs_buf_submit return void
>  - improve a comment
> 
> [...]

Applied to for-next, thanks!

[01/15] xfs: fix a double completion for buffers on in-memory targets
        commit: cbd6883ed8662073031a32f1294cdf53c8ec24a4
[02/15] xfs: remove the incorrect comment above xfs_buf_free_maps
        commit: 83e9c69dcf18bff12ed205423b91e1e1ae316998
[03/15] xfs: remove the incorrect comment about the b_pag field
        commit: 411ff3f7386a93d6170dbc067e3965ad472f11c6
[04/15] xfs: move xfs_buf_iowait out of (__)xfs_buf_submit
        commit: 05b5968f33a9fccabc5cb6672afd3ce2367db99b
[05/15] xfs: simplify xfs_buf_delwri_pushbuf
        commit: eb43b0b5cab885a9a76f5edb57020ad03eaf82b2
[06/15] xfs: remove xfs_buf_delwri_submit_buffers
        commit: 72842dbc2b81c4a43203b47b1d4c1ec2aa508020
[07/15] xfs: move write verification out of _xfs_buf_ioapply
        commit: 0195647abaac92f5dbd2799f64d19f316fd97b7a
[08/15] xfs: move in-memory buftarg handling out of _xfs_buf_ioapply
        commit: 8db65d312b5757fd70591382a800336dcbf091af
[09/15] xfs: simplify buffer I/O submission
        commit: fac69ec8cd743f509129deb5feae9e3f9ebc2cc8
[10/15] xfs: move invalidate_kernel_vmap_range to xfs_buf_ioend
        commit: 5c82a471c2b71357f6319f6ec34d20691969a6ba
[11/15] xfs: remove the extra buffer reference in xfs_buf_submit
        commit: 6dca5abb3d10e27e919e5344ac07e057f443c318
[12/15] xfs: always complete the buffer inline in xfs_buf_submit
        commit: 819f29cc7be6a9d949e017ca3f5ccc772a80daef
[13/15] xfs: simplify xfsaild_resubmit_item
        commit: 46eba93d4f582dce63dfdf506a6f2edf8f1787c8
[14/15] xfs: move b_li_list based retry handling to common code
        commit: 4f1aefd13e94bbf027f87befb2e2206ca73a5e7f
[15/15] xfs: add a b_iodone callback to struct xfs_buf
        commit: 4e35be63c4ad880c3dba12a287a0ea196541258e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

