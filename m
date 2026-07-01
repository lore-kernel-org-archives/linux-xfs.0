Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10CE1A275;
	Wed,  1 Jul 2026 13:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782912485; cv=none; b=bM8VbOVqzJCOElfebLPsBKvRf6t+0W9Q+MjfFdNmxrP/kBMcVsjnvaVML4biZ2dGjfiWqUmWoKS7a4dZpboBYVvfDXymUidQxKF26qUA1Fo6b/c3RMGWHYXdrgS75d5IOeHWsuYILarL3zagv0gx2N5sKKKPrC99B5fXfYwnoKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782912485; c=relaxed/simple;
	bh=iKscDZQfy0MtN4T97LK36aJevrKA4UAXQeqiSYbMIyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mriY/hXyIuc+k6nE+gG/NmqbVQJO4C0wfVSAGBTK44UPRXC74RuqQVQ/casTKjpb7L0rHFK/iHtW1F5wHP92NCeWAcTdws6Jz+BEu+r/YX3tDYqPbPEHXkZcVmZ7CvUL3E3h21YipxmHYLaffliz/wcQI6Pd6QzZudac11atzL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QBkIcOoi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QBkIcOoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE62B1F000E9;
	Wed,  1 Jul 2026 13:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782912484;
	bh=S/ir4WC1F7FyETK8VqjWLb5Y+h//+o4RHG1aeGMPGPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBkIcOoiSZQuYYK7QffAwCNm8VaK++eXTg9AS9VzPGwSsZmNe721QfD5tLz0b5Ljb
	 ERybIPZ7UuKg70udSUh9Q7eOo7zB8AJYJB13RW0B0gKO+zjDFlqE1pfKCrU+V6INxn
	 TlEjtN0MBdNs7Feqv9TDr/7CiYC0dt+iiVMhTx+dNJQMW8Ld8IphDTJDZjDp7Umn5F
	 M2rvGjzuDP/DBJUpfAARQoQ8IeDuScYB4VkDJwESKSuVGxquOomHKsPgr+z5851UJb
	 FNRZI4ms/t9yiUs2jrV1bdlAXEQSYynE3g4laKriuldFn2wUzcnPKXLr3Prazk95Xv
	 ZeHqosXQ2hpXQ==
From: Christian Brauner <brauner@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] iomap: consolidate bio submission
Date: Wed,  1 Jul 2026 15:27:40 +0200
Message-ID: <20260701-davon-kniegelenk-gedehnt-96476b242a09@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260629121750.3392300-2-hch@lst.de>
References: <20260629121750.3392300-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1819; i=brauner@kernel.org; h=from:subject:message-id; bh=iKscDZQfy0MtN4T97LK36aJevrKA4UAXQeqiSYbMIyY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS5it7RsWDc2sutssqLV0pi/oIv7G6tQj4SdWfS564sN 1S5YvS9o5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCK3IhgZXn05sNjoiK6LmpzZ kcUpV9dIfso4M2nzmZJgzb9SPNb6lgz/9Pi6PGc+u+HOtq8gTdxvdnHqPs1ItmXMtw7+cZHdLbG KGQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Mon, 29 Jun 2026 14:17:38 +0200, Christoph Hellwig wrote:
> Add a iomap_bio_submit_read_endio helper factored out of
> iomap_bio_submit_read to that all ->submit_read implementations for
> iomap_read_ops that use iomap_bio_read_folio_range can shared the
> logic.
> 
> Right now that logic is mostly trivial, but already has a bug for XFS
> because the XFS version is too trivial:  file system integrity validation
> needs a workqueue context and thus can't happen from the default iomap
> bi_end_io I/O handler.  Unfortunately the iomap refactoring just before
> fs integrity landed moved code around here and the call go misplaced,
> meaning it never got called.  The PI information still is verified by
> the block layer, but the offloading is less efficient (and the future
> userspace interface can't get at it).
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/3] iomap: consolidate bio submission
      https://git.kernel.org/vfs/vfs/c/044472d5ee7d
[2/3] fuse: call fuse_send_readpages explicitly from fuse_readahead
      https://git.kernel.org/vfs/vfs/c/3372eb0384b7
[3/3] iomap: submit read bio after each extent
      https://git.kernel.org/vfs/vfs/c/c1fb97d31782
