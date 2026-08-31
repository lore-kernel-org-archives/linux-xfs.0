Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF642DA768;
	Mon, 31 Aug 2026 08:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788163565; cv=none; b=Sir32tcmN28IrY4VjzJLs6sRIMO2wvRdX4UoESoBa6pUhgxuUJgGaj1hv6x+M290XvEXTojLJMZTPlS8T2ai1Gg0LsH/WHojEFsOvYJ3X5R9HJ9+VXdbTy16KKUVy4QesYw3ROH8uGx7qWDGjJ1RsJ+B4maY9Jke7K7rbp72nnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788163565; c=relaxed/simple;
	bh=/vyfIpuyozcVWZhMsXhvdOtCX7acdCxC7D7R6kRYp80=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nFQnyPariNuEuxexHNhiC39kXfTytqi4E+mQCfrajwaiSN6te9cWT8vSSUFsOLtuagKIfRi00cy5XZgTTtO/3/jxu8uk+OYVLncOC2CEJJ5xQw96yStx2UMIwBdrFdj8IjesWXm+SwmdkVfaIDS88xP5CFqQx8ptbA3A5YuOQq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FQ4KPu9j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQ4KPu9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEC41F000E9;
	Mon, 31 Aug 2026 08:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788163564;
	bh=1zBgDL1pWVQ/GHbFfDNHCmrOuVh6nlfFlm1bJTojAJA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=FQ4KPu9j2FWTh0KWG2bqm4xDGSDzl3weUfZ444jkzRhTu7yZcIlkt+Jpbz449GzGj
	 BjdXUn6UfZ0TAWm/WkznCDe5oQ+RG6V8cvBq+wmoDMUjdoidcNe3FXczmSW9VLzFZV
	 B7zsStiFfq8U8yZfatOrFFIXje3/V0fRg8SbJLtxt1abLJk+U7RXvJP8p1OHaYFFQH
	 vBa0DvLlm6tLMvA70c0c4FJ9Ca0G7r+DuRK7uhWZRfNgvry5OplVQ9Xg1Oj3LhXyUN
	 h73cRyiD24DkhHqq8I6L6HqZNxyJkYeqwHkIBhxrq+B576IJczLvnL7F+vsF3CPnwz
	 7EKaqMrair2Qg==
From: Christian Brauner <brauner@kernel.org>
To: "Darrick J . Wong" <djwong@kernel.org>, 
 Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 gost.dev@samsung.com, linux-xfs@vger.kernel.org, pankaj.raghav@linux.dev, 
 ojaswin@linux.ibm.com
In-Reply-To: <20260819084858.778285-1-p.raghav@samsung.com>
References: <20260819084858.778285-1-p.raghav@samsung.com>
Subject: Re: [PATCH] iomap: remove the unused ifs parameter from
 ifs_find_dirty_range
Message-Id: <20260831-schaukeln-nulltarif-locken-150eb31299c2@brauner>
Date: Mon, 31 Aug 2026 10:05:57 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=917; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/vyfIpuyozcVWZhMsXhvdOtCX7acdCxC7D7R6kRYp80=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNNX3V/+Nfiud0pRf3siZ61Mk8fnBJKeRu5JV7wiKTO
 yZ1Pjih31HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRSC9GhhemF77nSSxfW3so
 gSk5fdWllvAlV5g2K7x3Lfo1R7AtP5KRocdN5KFJxA/ZvN9L33BM0/K6Ib9q9eqpDy3fbdvQ6f9
 ChwsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Wed, 19 Aug 2026 10:48:58 +0200, Pankaj Raghav wrote:
> iomap: remove the unused ifs parameter from ifs_find_dirty_range

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

[1/1] iomap: remove the unused ifs parameter from ifs_find_dirty_range
      https://git.kernel.org/vfs/vfs/c/1aea0c4a34c7

