Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CB83B995D;
	Wed,  7 Oct 2026 14:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791385130; cv=none; b=LDBzE2AAJhELL7fCjFTLmWU5OuA/qXQ9j0pchkzWPuAcAwqE6i9FvUJ97pLXRH8qhtn7ci/uUZiDluwzDwzZz2MrHswdIrKyvGRNMxKOTVkCHToxaXkpOLrSRS3iz38gvHIuPYJkqZbhWnxn7fmg4DmU3JK2wohMdOSXYcdn0g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791385130; c=relaxed/simple;
	bh=uStzgO6+N2Di9st1CAR5YzpbNalTxSJq/Z89TkWKsoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pIuVdAjVf/diSzlvzEP76eL/9Bw8CwzFaopInT3KvzX2oVcAO71A242MmDFpVLAq/wZvd68z62h4WMSmuRcR5W4/fAjNXJbn3Xl7W1I1J4YxoaA5WUnhtKmUy8DQdDn3wRukmJZ4q6d2Q/0KrpIVyxy/07GX042mmZBePEb4v0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KSCu814k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KSCu814k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCFD1F000FF;
	Wed,  7 Oct 2026 14:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791385125;
	bh=sQh3Xowo6Osf2Gk7H/wzIDFpt8E/0Ak6v6QOluUU4eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSCu814k0iGBzHxK1sFZn6jtgY+yWxfzgzLYD52TeHqGEjmm3a950Itb0lLBllspd
	 fJXnKwKNIbTeNe6IXCHi1HOpgkcaihGhZyqZwuEDVHHEYAR4XfR5UuiPMkLDgfK2BS
	 cZbr3LqmyP3rkJcPSTwk0BurG3x7eb/M7W7/2TdshSbYIWbnaA9IQ1VaKRBM8QDiyY
	 uxoZjb1lIhR1gG81ry8BsdG+BouzdXtjWxNIk2Qoq1uMucvWsHGzHb74w3RCrYSGxO
	 z0Z0qhZQOhLsRIHHxGET6UYxlLa3eFFIAKf2nT6EpnKn99wglxT/BBECZgSDv8Tg+/
	 OnOYZLKgK8yfg==
From: Chuck Lever <cel@kernel.org>
To: Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Daejun Park <daejun7.park@samsung.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfsd: do not return overlapping extents in a block layout
Date: Wed,  7 Oct 2026 10:58:41 -0400
Message-ID: <179138511102.2622843.12611347810514170081.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261007-nfsd-block-trim-v1-1-53370f97047a@samsung.com>
References: <20261007-nfsd-block-trim-v1-1-53370f97047a@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 07 Oct 2026 11:03:01 +0900, Daejun Park wrote:
> Since commit cc6c40e09d7b ("NFSD/blocklayout: Support multiple extents
> per LAYOUTGET"), nfsd4_block_proc_layoutget() calls ->map_blocks once
> per extent of a LAYOUTGET, each time for the range left after the
> previous extent. nfsd4_block_map_extent() takes a mapping that starts at
> the offset asked for or below it, but only the first extent may start
> below it. A later extent that starts below its offset overlaps the
> extents before it, which RFC 5663 section 2.3.1 does not allow. The
> Linux client rejects such a layout (verify_extent() returns -EIO), and
> the I/O that needed it fails. The block and SCSI layouts share this
> code.
> 
> [...]

Applied to nfsd-testing, thanks!

[1/1] nfsd: do not return overlapping extents in a block layout
      commit: 214e388464bf850fcdc5d656fd39909f0a1ee83d

--
Chuck Lever

