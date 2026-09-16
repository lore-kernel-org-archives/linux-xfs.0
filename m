Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967E637C930;
	Wed, 16 Sep 2026 12:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560413; cv=none; b=Zh/8DgWWbQBlnyl5UoLJZ3EnKxY6Z7ivaomLj0AsNFyTH70rYnmpXw2hKDatjGCXbJnKYNiu+1AbixCWMC9NGzNzW5kyFw7tkk5a8ECiEBTYJIgqn+v4wofh/QAXsl+/JfsJsaE9fhUOepIUp6io57LnxlZvbR/lVStxi0WM0eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560413; c=relaxed/simple;
	bh=V9WmN3pS9RQt3VJdSTU3OsV+czBArpTcxUhzd5C60LA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=QW+IBftviS8OwwQJeOjfOPwfaJKBJBToCT5h+OibrUzLscum4Z3pgO1tP++LtGjz3AWp/8JQHoo8Gq201iT+5aeDlZmYi8TC3SJvA8dg8MzDuvnIAoxLcwyayInpsZhXPPAmhV+RqzH4Dy8d7S2c4CIk3Ze/g2FYKMJ65RgzUKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AgdnOPoX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AgdnOPoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1C61F0089A;
	Wed, 16 Sep 2026 12:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560405;
	bh=3BVXiVmYcM6ZXh0uAhydcd0lKmWtt4lNRNnh97r56I4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=AgdnOPoXxVubyQ8Uc4YeQcA9bm/Y741cELaSbSEqVbtSciP0vZlAHOUPXPWwS+wKm
	 02Qm/vz4zTb2ugjjGZPyZt2qC83uuzScWEFod/jn5Le3TCN3Ry05TCOR0tvyUi6afe
	 GEyXYZYBCIZlVXXdqVbrxcK5jMO/9UR+WAGm7dxIIX9tQ5g9ZgXLkedZVf5kudSDsU
	 JUZDSILEOhUqH5x+LIDWmQ6PXLdBmHV1w8+UaCLAKDD2sJx6Rnp0MIGhBaft//ru1x
	 q2EAmY5Ns8u1cI+pP+t57zj/lPTW6TbHcBXM1K6zJ6PYinEMJwVJpYnGVTiu9YxKSl
	 3hNOUB7VXN/rA==
From: Carlos Maiolino <cem@kernel.org>
To: Jiangshan Yi <yijiangshan@kylinos.cn>
Cc: djwong@kernel.org, ljp1205831794@gmail.com, gaoyingjie@uniontech.com, 
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 13667453960@163.com
In-Reply-To: <20260914082111.195006-1-yijiangshan@kylinos.cn>
References: <20260914082111.195006-1-yijiangshan@kylinos.cn>
Subject: Re: [PATCH] xfs: remove duplicate INO1_WRITTEN check
Message-Id: <178956040379.10466.12341783504062469919.b4-ty@kernel.org>
Date: Wed, 16 Sep 2026 14:06:43 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 14 Sep 2026 16:21:11 +0800, Jiangshan Yi wrote:
> Commit a23eca88448e ("xfs: fix exchange-range reflink flag clearing
> issue with INO1_WRITTEN") duplicated commit b2d5a81dae38 ("xfs: fix
> exchange-range reflink flag clearing issue with INO1_WRITTEN"), so
> xmi_can_exchange_reflink_flags() ended up with two identical
> XFS_EXCHMAPS_INO1_WRITTEN checks.  The second one is dead code,
> since the first one already returned false.  Remove it.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: remove duplicate INO1_WRITTEN check
      commit: ce2b91bebc7bc0495fe3ad5ee47e4977fbb77fc5

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

