Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793895736;
	b=XOkVJ7Fq+htz8NG8hbrX/Pwc0Ist0F5SFuXJDIHn+maU5mIOI2rXHmRvKxX9Rfm/4KJq
	 /zwnzkz2ikPbG26rVQO7V8U9Seb+B2HojYVN/YjbJlznmnniUhnMeF2sU+2k9bqkdBqLK
	 91RZYqvjT5CrRmOM+tmUQVJclNJ28TvWET4w5GsmZIlq8vdU526XJNmR6yTP21fiyT42Y
	 5VLh3VWG85rQOyPVlFNOVHJN1L5E9zErBcDOFb3xydJt6LSvYapn6qV+PdkYyS1XPxW8y
	 d/8LpMQoafURVIotdPMz41ViEzvMiV6k1WPoEuBJv0Q1nJ2n5DXRjTpdrcqy8sjirrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793895736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding;
	bh=VLO291Yw0dXwc3CQ/dxumGJAHuHs+sp8vgidXg8O+ZA=;
	b=H7WWwftkf/hZGP3UHDZUaZxHNs6hi2dq1P7GNMglQzkjAGFquJsb/2wbRuiRAyBnImZf
	 LYtNaIXRXFUqO3/pmB8ZtfD+fhAPgaSgPAOj/E+2Ltmc/6KJn6oVTYqQaMf+NYDObFKT7
	 2oMG6X7pEU/v/xTYlEuX4dfk/Dh9j0ItzE2yqmAh7AF+B4ureaT3767OVOniqp3Dban6y
	 KPp9r8MQ/ycpRgb3IGuVCNMqK0A8PpY+6cFgEX3jquQO0DkGTEQVm3zTPBSHHsjaNDO2I
	 M6euIsFRBjzDuMOsj/WNIh2j3B2NKKG1Sl3ngKpJ+aDpsmIcBLHLHcWMhMOC4ujmQMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h7AbkmxC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD6C606A328;
	Thu,  5 Nov 2026 16:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h7AbkmxC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A30F1F000C1;
	Thu,  5 Nov 2026 16:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793895735;
	bh=VLO291Yw0dXwc3CQ/dxumGJAHuHs+sp8vgidXg8O+ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h7AbkmxClpxZ7zlz7Q/b99c7d0Kf3ZVKzUIkU6QXaBG0a2LdWeSm/0XuLjNegC16+
	 1rNJrvvhf5hIF1Ib399Mj+GewAfK4Y1dLHDEFvKoP8XNV5heIVxj4wvAodVZJ//Mrg
	 TG/W00JwKZGDbv0m6E58eDW2Z2n4ZMBsIzGId6ubSrn1NNhEIDD6V0o/gTq8APwKn5
	 A/qJMBWZLsxinPL0W8f8G52Q1tHIOcbu0dCBVC2qsD0nVHOAKg/fKrdGKNU+Xv15XU
	 fLpAYTY2sP2b7zy6+QQnzlukPm+eRe9TGQO3wiyfwgPrrnoiu476Yy6EfiimX2T15g
	 dvN+7y1MZ8Hkw==
From: Christian Brauner <brauner@kernel.org>
To: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	pliard@google.com,
	akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	phillip@squashfs.org.uk,
	cem@kernel.org,
	linux-xfs@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	Abbott Liu <liuwenliang@huawei.com>
Cc: Christian Brauner <brauner@kernel.org>,
	yangzhuohao1@huawei.com,
	douzhaolei@huawei.com,
	wangbing6@huawei.com,
	nixiaoming@huawei.com,
	liaohua4@huawei.com,
	chenjie6@huawei.com,
	chengzhihao1@huawei.com,
	heyuqiang1@huawei.com
Subject: Re: [PATCH] initrd: flush deferred fput() before mounting root
Date: Thu,  5 Nov 2026 17:21:40 +0100
Message-ID: <20261105-bleifrei-trunk-lehramt-282105689eab@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930084632.2965573-1-liuwenliang@huawei.com>
References: <20260930084632.2965573-1-liuwenliang@huawei.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1409; i=brauner@kernel.org; h=from:subject:message-id; bh=+7yza4/4Lx9dwn0alaXtZbTmU5h8UwEKXNai/D6jlAE=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WaurH7vEbJrHB6cJFlEPfF1L9pTknG9w7xA16LT/J c1Velijo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCKqZQz/g991FwX/ZVomdTXM MjDJ3aTj5jeGnCWNtw8p3Lm34YVeBcP/sDnKvPpvO1zrtllcX79NiKvgZciRhsk3/Px3TTgZOlm XAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Wed, 30 Sep 2026 16:46:32 +0800, Abbott Liu wrote:
> Booting an old-style initrd, i.e. a bare filesystem image rather than a
> cpio archive, with "root=/dev/ram rootfstype=squashfs" can fail to
> mount the root filesystem and panic:
> 
>     RAMDISK: squashfs filesystem found at block 0
>     RAMDISK: Loading 68449KiB [1 disk] into ram disk... done.
>     No filesystem could mount root, tried:
>      squashfs
>     Kernel panic - not syncing: VFS: Unable to mount root fs on
>     "/dev/ram" or unknown-block(1,0)
> 
> [...]

I reworded the commit message and cut the comment in the code down to what's
necessary.

---

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

[1/1] initrd: flush deferred fput() before mounting root
      https://git.kernel.org/vfs/vfs/c/807c1d7125a2
