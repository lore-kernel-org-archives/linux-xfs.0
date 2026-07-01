Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213C748097B;
	Wed,  1 Jul 2026 12:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782909894; cv=none; b=jT/LJVZRjZqKgH8lxI5Fdx/ngUX64hUJUVZj97ltVvkQCEs+h2yZ3S/sELeT7u2JX695TkrbQmEtizhyp3rRczDVPixe6Nz8g2VbHKPt77lIdd9z8dUFxhWaxU3h5zrtMNBKwUp64yUQC7fQuIxTW3jfKJUFIXNk/jfo25ENhN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782909894; c=relaxed/simple;
	bh=/mi043GlxodWc85mAs/LQBfO935RjZ6oJndQuFhRG3s=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GGvczHIHV4Bl6BFBtgE9Ox1MuHon7aYBTs/YeUmTsmfAS1/syR3xIIsvRvMYoZYI0H78V/wMOLqS0L70DrhMldLizx8nLRiFLHdHImgVEjKDdKPkkDF17RzzByp9lEQLXpQX1T/C5AJyy5azdgDRmk1bgECbeaBm+sOzHjKr1Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UiMnTGb+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UiMnTGb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8481F000E9;
	Wed,  1 Jul 2026 12:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782909892;
	bh=+Hwm5iIojRq+2LD99vX3C2yOpsYLR+FkvNmWjUoqtxU=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=UiMnTGb+l8ebGYuCZjHMjGJ222VIpxCgp0j9N1Ef5AZmjLPTI5MWWhdqEPO53LRar
	 BBUTy8cVYHcqbb9KqSAN81O7GJrngXxwQ2hOiFcCiacHwoI8QVCgL8TJ9MlXaP1Ern
	 93t4UWJPloP6m7QQTVLZmR2X7HOcfSS0Gi1b9Uz3ySX4XtHS7YI6ylYSUOCBdMO5o3
	 GN3PIzQ40+pjA6U+FgtZknl6F5+BYlVi6cwSivuPwM55ODRfXfn9Qh0JFg9+dKANym
	 SgxcHBFcFLihcrnWHiMijma/J4YUS6JOEptK0M1lBwXl+iaS7EcswGsRvGSKDJjpyb
	 /hTksbB4+UipQ==
From: Christian Brauner <brauner@kernel.org>
To: djwong@kernel.org, hch@infradead.org, ojaswin@linux.ibm.com, 
 dgc@kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 lidiangang@bytedance.com, pankaj.raghav@linux.dev, 
 Fengnan Chang <changfengnan@bytedance.com>
In-Reply-To: <20260701033253.46420-1-changfengnan@bytedance.com>
References: <20260701033253.46420-1-changfengnan@bytedance.com>
Subject: Re: [PATCH v6 0/3] iomap: add simple dio path for small direct I/O
Message-Id: <20260701-abnutzung-laugenbrezel-wurzel-c0d111534aed@brauner>
Date: Wed, 01 Jul 2026 14:44:45 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1517; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/mi043GlxodWc85mAs/LQBfO935RjZ6oJndQuFhRG3s=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS5ch9iWP7HWULZ/uj9AoG1WYEz5lhYqNT8bDTwiJ+zK
 yfs9N6lHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhvCxSkAEzmRwPBP5174P0O7Vz8zny5o
 T3O3E2NYqBY1sdZA1cM+PTF2Dk8wwz+VvC9pb9glfdU3btn8TfSf+aGzhz4+jEttlXvIrfd++31
 mAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Wed, 01 Jul 2026 11:32:50 +0800, Fengnan Chang wrote:
> iomap: add simple dio path for small direct I/O
> 
> When running 4K random read workloads on high-performance Gen5 NVMe
> SSDs, the software overhead in the iomap direct I/O path
> (__iomap_dio_rw) becomes a significant bottleneck.
> 
> Using io_uring with poll mode for a 4K randread test on a raw block
> device:
> taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
> -n1 -P1 /dev/nvme10n1
> Result: ~3.2M IOPS
> 
> [...]

Applied to the vfs-7.3.iomap branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.iomap branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.iomap

[1/3] iomap: factor out iomap_dio_alignment helper
      https://git.kernel.org/vfs/vfs/c/acb8815f181f
[2/3] iomap: pass error code to should_report_dio_fserror directly
      https://git.kernel.org/vfs/vfs/c/281e3e52acbf
[3/3] iomap: add simple dio path for small direct I/O
      https://git.kernel.org/vfs/vfs/c/de2f9ebea176

