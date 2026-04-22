Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDA93CE4BB;
	Wed, 22 Apr 2026 12:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776862603; cv=none; b=hDNku9unuychpFFmcNDT0a0wu4mIhLqIGqM1scfSxrLIgXpZ1QqdkEU8PkL7qNDhfOANkWLqF4uylyn6eLcMTT0xzdQKFYP7SG4bJcbj10/oSCSQeiwNjoVTwRaBzO7sNx7v4qByYycTP++u8CpDEqDCVY8pbQskeNjOjD8aAy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776862603; c=relaxed/simple;
	bh=86mJktcdeRWSNtY4LehpxJnSKmedlpV1JxUJWEaTNoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AfagVD6MyfAt4xkmsk/Xj15aevAi8e76fsGtxR+jCBvKGOpFHf18V1mMQ3SpYPHyWUwKCzzKNnTxjZ4aE2gGIXvCkyFcAukQ7pwLV+LOgt9PrRjKOUwWbk1skRT0evIF3HFQ20o5Hd4nqlpunHQOJrMybKtM46Ix7Y22fMntalM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j82qdD6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j82qdD6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263BBC19425;
	Wed, 22 Apr 2026 12:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776862603;
	bh=86mJktcdeRWSNtY4LehpxJnSKmedlpV1JxUJWEaTNoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j82qdD6RNuIOKtiO/lDYEsaU76XlfGMghXga5brB0KpANCOdJEON+L7qPCoW6A+o9
	 jCZneXlIwokeRqSFIL6XP6xOcnZeUV/8C+bfr7tJSfoVrkHWGh+1T2IM19WID1yQOM
	 xuTPpHhKJoC7DdzJkmOeA4n+OIic1KtQPvKwrSI4vLrjPkL6tqPTw1UQCGXcPi0YI8
	 Kzxb2tpbswQqHoUeteP7g9fk3O9l+M0fEq2TCYBGF+a3RuLpkyrhT01c7ET8RVs1Rh
	 5DWbSJzIlgwpqzenZhTxyBmGXQtkSjgAt/nAlkTRB0uLrjQJuTaQPJALKH+ExkAAr8
	 RuzB8UdPM3YWw==
From: Christian Brauner <brauner@kernel.org>
To: djwong@kernel.org,
	hch@infradead.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Fengnan Chang <fengnanchang@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	lidiangang@bytedance.com,
	Fengnan Chang <changfengnan@bytedance.com>
Subject: Re: [PATCH v2] iomap: avoid memset iomap when iter is done
Date: Wed, 22 Apr 2026 14:56:23 +0200
Message-ID: <20260422-pflaster-verifizieren-382dd21880d0@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260420061630.62077-1-changfengnan@bytedance.com>
References: <20260420061630.62077-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1367; i=brauner@kernel.org; h=from:subject:message-id; bh=86mJktcdeRWSNtY4LehpxJnSKmedlpV1JxUJWEaTNoA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS+ONr8x+Pa5JWNLk3B80t1LpvGZuxewlZ/+9uWFKOyt +FrJFOMO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZitJGRYaJ2zg/FyUF74hs6 a1MexC3c4XDIKF7sR1L+Ilfe5OSCPQz/HVgm9l7xk/nsPiNE+O772XcS1FXd7+5YG3Azxz/97wY jPgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Mon, 20 Apr 2026 14:16:30 +0800, Fengnan Chang wrote:
> When iomap_iter() finishes its iteration (returns <= 0), it is no longer
> necessary to memset the entire iomap and srcmap structures.
> 
> In high-IOPS scenarios (like 4k randread NVMe polling with io_uring),
> where the majority of I/Os complete in a single extent map, this wasted
> memory write bandwidth, as the caller will just discard the iterator.
> Use this command to test:
> taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
> -n1 -P1 /mnt/testfile
> IOPS improve about 5% on ext4 and XFS.
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
branch: master

[1/1] iomap: avoid memset iomap when iter is done
      https://git.kernel.org/vfs/vfs/c/72fa5c7e5c81
