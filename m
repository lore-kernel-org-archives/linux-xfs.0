Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACC24048A0;
	Mon, 18 May 2026 12:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779107002; cv=none; b=TFDubynNm2OvNKj2teQr3v8iC1aV1sW5BFcLSps6EBhHgiYRA5dBo3kHLcKoDVicv3yICZV+HphpUsr6YWWGdAPqHepkWG5f3Az9v6A7x/pub4mx/SeNpkaZZ+HHW/Ljg3DC/jjaWms+9GBQCyDvE0RcKQtNq1wjxYwYHmOPNgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779107002; c=relaxed/simple;
	bh=4YZHGD6mPvxv61IPspdP4hnCgcXR/yr3wm8VKWU3BF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h7LZTx+tUt1qElq2jj2LW112Z5hX5jOGB+/n/H6ril+xjozFsHH2ZYXZ4uAJVIYTFp04ew2Zo89t0MjWzFlxrLSAVG74kjXm/X63VPet+qKmw9sjo/zSVZwuyi3QXW2MkbAK3uBSGqJ3gGNgO7BQdcY1MfEHFUYFmQogV8k1ZMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iiyDPSeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iiyDPSeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71A4C2BCB7;
	Mon, 18 May 2026 12:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779107002;
	bh=4YZHGD6mPvxv61IPspdP4hnCgcXR/yr3wm8VKWU3BF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiyDPSeBvF6ySEd0VU5dBHmIIj7NxawTfaNXwPkKMr1vH/3D/iODuLuC5e7OkPVTq
	 R5DbXOIea/ZSimFcmfSPiR/+XsZ/4PMxDtzm777CKFqMi5j2NvJszGkSsACNJyxwI3
	 tRDde/CtIfac1SSQDAnz8oEx+zPSIDkkVOK8cOjOCXoeOdCrdTFMsccg6TeYxEgQrV
	 iP43XR86daeB/LOligc2zBbdGwPbHXSk2NvQAgghZ5m78mWx2BgLAHmP24PlvKhO5j
	 bSLMjgHL12ku7jpRweOlEnjYzycYeJc8FpbM4VwVOuhCu71Bh9HXSEqKcaUUk2G0Ek
	 v+w0luqY50E+Q==
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	djwong@kernel.org,
	axboe@kernel.dk,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH] iomap: don't make REQ_POLLED imply REQ_NOWAIT
Date: Mon, 18 May 2026 14:23:16 +0200
Message-ID: <20260518-tattoo-brannten-c5b64728e6ca@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518062917.506483-1-hch@lst.de>
References: <20260518062917.506483-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1292; i=brauner@kernel.org; h=from:subject:message-id; bh=4YZHGD6mPvxv61IPspdP4hnCgcXR/yr3wm8VKWU3BF8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRxs2yV2sHnm7opQL9sQk/Hh4dLN0pf/JF866eu2cyNB 6U9t9j7dJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkzCJGhmULvHqv7eWqvjDz +rnW2TekNnztX9PZU2FcuETn3Dr708cZGf7nBJTFWupem1E9Q+q9t6zmfv6TU+siGxQ7Jl83SZH dyAMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Mon, 18 May 2026 08:29:13 +0200, Christoph Hellwig wrote:
> As described in commit 2bc057692599 ("block: don't make REQ_POLLED imply
> REQ_NOWAIT"), which fixed the same issue for the block device node, there
> are valid cases to poll for I/O completion without REQ_NOWAIT.
> 
> Additionally, sing REQ_NOWAIT for file system writes is currently not
> supported as file systems writes are not idempotent and would need a
> retry of just the bio and not the entire operation to be fully supported.
> 
> [...]

Applied to the vfs-7.2.iomap branch of the vfs/vfs.git tree.
Patches in the vfs-7.2.iomap branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.2.iomap

[1/1] iomap: don't make REQ_POLLED imply REQ_NOWAIT
      https://git.kernel.org/vfs/vfs/c/47f28b493daf
