Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ABE35BDC7;
	Fri, 19 Jun 2026 08:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781856810; cv=none; b=uKdFwQCB+Y2xaXDEwsjL+TlvOdAlPmW/ShFA2gkLVV5ih08mzyPqC9ZHFIYCPA25g9368HN7aAfnrrDXRMvpcPVqWQDrvMH8XmU9k1bMB6dO92QQJkLbq3gpiFP0UhlTnX6bvOREdtpRw1vK+QDcUnKV2cyZSZzdUPWkaqqNX60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781856810; c=relaxed/simple;
	bh=USTIsNUMIvMPl7g/s/q2uIweJKme94PTrp8NsVpU03U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TrEVe4hxl/5VGUVIDpYXN4kO35B7VjkKCNBOE0C3ISdOXliVmKAM/3SSlsXRZ0KV727O9d0kl59oqIlZW41duCmRqoXm48OIVb5JF16mCaO9eqQNypjs7yHftSqbvqivANJ37Fpx9Se7b+6Je+VNV/Dur73TmdAGqZ+h4bT2ZvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLhd9C7e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLhd9C7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546F71F000E9;
	Fri, 19 Jun 2026 08:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781856809;
	bh=NOJ+Rr88HAThqep/zXjz1/FrJiSqscTdZ/HzMyjxsMY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=OLhd9C7e18DMVUGNfJ16kf9NqwKlYBvFuynO3XAqNqY7IDHXC6zHE3V1zgtZqmzQl
	 8HmZOFSMdEAq5KW/IVIcM7BssuF3FZXJon9QW7TPpDEDdhxKIFUESBkTq4aqb0xsCu
	 +gn9nSz5yX96dqzkMPvcNZTcEg4qiYyZjHB6JzD5VQ6X2jg4+WQNdYiBqWQKQj413/
	 l92ZrrlPwkXyiMX7EK9834iJ9PV7JR9njmJwQkeufMI+12GVdZFb622RUaMet77QQt
	 Q0GyZTs+ViBMYCgNVS8QaU8trA3OtlRplQbLHMtKtIqH3/71fBFEqPLriaX7purSD9
	 EkytgcP1dqHaw==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260617114253.635751-1-bfoster@redhat.com>
References: <20260617114253.635751-1-bfoster@redhat.com>
Subject: Re: [PATCH] iomap: always return status from iomap_write_iter
Message-Id: <178185680256.142447.15042938287249585186.b4-ty@b4>
Date: Fri, 19 Jun 2026 10:13:22 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-aeb64
X-Developer-Signature: v=1; a=openpgp-sha256; l=883; i=brauner@kernel.org;
 h=from:subject:message-id; bh=USTIsNUMIvMPl7g/s/q2uIweJKme94PTrp8NsVpU03U=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSZ/FKXy2Deun5ryzGW7ilV6315V6c9/zchV1Hdlclo8
 8TZq4+2dpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExEkY+RYdLbNXL3vPQ0T919
 p9G42/nF6/64L2wlV46oTdsyJW/bw0CGPzx6LZOuLYq5bRq0dG2Fd836rZWzdA4/+MivrrroueP
 0tawA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Wed, 17 Jun 2026 07:42:53 -0400, Brian Foster wrote:
> iomap: always return status from iomap_write_iter

Applied to the vfs-7.3.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.misc

[1/1] iomap: always return status from iomap_write_iter
      https://git.kernel.org/vfs/vfs/c/39987163d6dc

