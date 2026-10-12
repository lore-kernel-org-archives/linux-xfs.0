Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DE248F02A;
	Mon, 12 Oct 2026 14:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791815135; cv=none; b=cJPlpVUKCCjZU5nq0y6L/gaCFCHCs0qrbO9rPJ8rusH7PgaHFNZ0mO7vMlP1c4p/OSj5SX+eMJCWdSuyvEFCWMv7vwSQSnc0yEDMLZ++ei5DZ5QlgBVQdDXgB4HCurUFBYAL144hlTGNSMR5C7EMSPZPaemaFxqNZ+16mMjxIcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791815135; c=relaxed/simple;
	bh=UDRC4k6jtpTAzdj3jNapRGpGuYwQR6PtAri6UYSXh4k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TQhZk7+SMiSaIPfxIj54DiGz3/mSMx/QKt+QltcVxlvtCgqdSqN28aeyuCh59lB3pa/cd2UjoLhPdExJe/LVx9VsinGGot0f3ON2P5Xz68pqqEEmjM8FRCfFscTnvenRycO+NYN0MzXvfjs+bwQkz8iPKeRZ4fOM3m+6i2BMIeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pefmkigp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pefmkigp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC871F0089D;
	Mon, 12 Oct 2026 14:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791815134;
	bh=GymSLpD5tWybWbzvODs1GBKhiva8NA/oeqm8YClEZCE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Pefmkigp0UcoEhgTPopHOuP1kSQn/b1bhb3XGJfOXGeEnYZtybBD9kTP29WrXxfvy
	 BiNJxEJ1yAYk+rb9/B6V9iNi520It04Iz4S0hEXooi4jkbKIsXmvk6oBh5Tl/5v8fX
	 VRpYZ7hP/PKkJGa/yYoO6fzSgGenLqLGIWKDCKkiSyDc0M+lxtJqAdihySalpFQDQP
	 h8RJ6/tRgDEQU26UlLiEjy53BWh6CIaNypMD0i9TrEJ3ZJU1tw/qYfUVkdhfpcXEF1
	 kCfBCOh64ASVUZBhQ5D92ssEMTCnuH1d/awEO5TwBoUv4RCUBBJPhWGPx9CtzWQjUu
	 1IRmHvbUi4zsw==
From: Christian Brauner <brauner@kernel.org>
To: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261006154005.232338-1-ampr.mhd@gmail.com>
References: <20261006154005.232338-1-ampr.mhd@gmail.com>
Subject: Re: [PATCH] fs/iomap: document ret parameter of
 iomap_iter_continue
Message-Id: <20261012-semmel-mineral-nudelsalat-81f8544c3e8b@brauner>
Date: Mon, 12 Oct 2026 16:25:32 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-3d1b8

On Tue, 06 Oct 2026 19:10:05 +0330, Muhammad Mahdi Amirpour wrote:
> Document the ret parameter of iomap_iter_continue to avoid a
> kernel-doc warning.

Applied to the vfs-7.4.iomap branch of the vfs/vfs.git tree.
Patches in the vfs-7.4.iomap branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.4.iomap

[1/1] fs/iomap: document ret parameter of iomap_iter_continue
      https://git.kernel.org/vfs/vfs/c/92e2f4295403

