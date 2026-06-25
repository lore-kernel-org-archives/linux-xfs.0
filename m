Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E9A37C0F6;
	Thu, 25 Jun 2026 07:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782373267; cv=none; b=JQTkqlsVKEQuAvx+/uw2FjxbAPH3R/Gju4azxxQ59vzaDK+zRAHuOvGZ6RFy52usH5LCDaG6HQe+4zC+WSOOY1nzOlMxAPBIuDMtLHwBf+dZXI9eXrIGtG7KpBF6Y+DKUU4it1T/ykcWcBCDDnPa+ydwzQIrfX+rAzxY5AILDrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782373267; c=relaxed/simple;
	bh=aQZCpOa39U+aRpbq7/BqLC+IGI2GpKcB8mpZBwsefew=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=a4fag0UL6j92dZgdFMoRsq6S0aFKwrc7nPb0VFCKmb45oCLrOA5n3MuaTNAVyUeCHSeFxXZXwy4Xs0Lg/n/UUBa5NONDocSIuT9HDEt2Ow15Ei07bGYXAKLo5ZFJ+VPLY2j/QAGScyf0QDhO/MW8RLgWVUOnJ3wnWjlgkPO4a5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MtBNz1/F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MtBNz1/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78271F00A3D;
	Thu, 25 Jun 2026 07:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782373266;
	bh=jGwPbt9xtCQtBq8NtOiKdpCwBI2XrMWlqPzFWEicZYY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=MtBNz1/FgVCcVb4B05HHe6Avu7jRnxtWQRdexGrClzqKVhg5MJ8DcNoG4dNxZJIDL
	 RRUBqyMlZfH+2LsyeihBVrhnwdQZa5qvvTnNL8mGcJ5jc+w7ZpDg+Y9jG9r4R+HQ0y
	 7kNto7qGc5afO+2/JJejqr5aVwwv4YCCHeimF0ToQo1+rP8i0cR+zKTYGPhpi8+flZ
	 a7s4QhYtkNm0a9lhce1k2+rt5U9s4AlZS9sA01PEquPgyLCwcZlNsYPggx+vAU22iv
	 MJt7AY4spVurprh50jidqhFyxMaQvIyGVF4Xp+82UDj8nXmBVEUxVvcjONnkPyl6ek
	 pbkmsFH9OEMUQ==
From: Christian Brauner <brauner@kernel.org>
To: hch@infradead.org, Morduan Zang <zhangdandan@uniontech.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 djwong@kernel.org, Christoph Hellwig <hch@lst.de>
In-Reply-To: <9E38E2659B47DC2A+20260624062622.337469-1-zhangdandan@uniontech.com>
References: <9E38E2659B47DC2A+20260624062622.337469-1-zhangdandan@uniontech.com>
Subject: Re: [PATCH v2] iomap: guard io_size EOF trim against concurrent
 truncate underflow
Message-Id: <20260625-harmonie-gegen-sattbekommen-8eac15addf81@brauner>
Date: Thu, 25 Jun 2026 09:40:45 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-d9d01
X-Developer-Signature: v=1; a=openpgp-sha256; l=963; i=brauner@kernel.org;
 h=from:subject:message-id; bh=aQZCpOa39U+aRpbq7/BqLC+IGI2GpKcB8mpZBwsefew=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTZ3J5QK5+y0aHp/oUiy4B43UxhV9atyhpJd1evuvg9T
 Njub0RBRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwERiNBn+aagtmMPnamvhOF3E
 cK547GeR5u9hLgcWnQyIeCck+Sv5JsM/80vX4tU+z7W4HuvrZWhy4+bHm74/pqz8fDdKnSElNcK
 TFQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Wed, 24 Jun 2026 14:26:22 +0800, Morduan Zang wrote:
> iomap: guard io_size EOF trim against concurrent truncate underflow

This time with the right thank you info...

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

[1/1] iomap: guard io_size EOF trim against concurrent truncate underflow
      https://git.kernel.org/vfs/vfs/c/198790302ba2

