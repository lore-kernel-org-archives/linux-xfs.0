Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BA2204840;
	Fri,  2 May 2025 08:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746175641; cv=none; b=lSN2bJxH6mCG6DHmjxSDgWgOept/Qs7QN3Fyyy/eTvWE2ADlDrD0pukoELhPCeueQ+sQKmrDSQ6cDis0FD5YzT2/pxvvLL4cAlnsMaY8oGnE66S37j7jpQUZwgRPP5F9qn0pOhEWIXcfGEDLpdnRpBFlkVkYoqYjhjT0x2sqr/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746175641; c=relaxed/simple;
	bh=rz47L1B7+iOlzIBY2QDLXPTa3bmtFpg9h20eFKWI2Bs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KqQGbFC5oXfmU/3OeC4OQuNhEnjXqpajZqa0ql7NaZqOEErf2yTrO6sBKvJkoXECP00Ii703on9UfWtJgmjsyp+i7iUkJ2QpQf5wCbmdV3kDphrbgz/JbPiCGyeVK2s1WTVmluzu1jaaqBOJSvJdynK+k2VGerhyiDBNZHBEHeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SAqSoNsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SAqSoNsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D90FC4CEE4;
	Fri,  2 May 2025 08:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746175640;
	bh=rz47L1B7+iOlzIBY2QDLXPTa3bmtFpg9h20eFKWI2Bs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=SAqSoNswnvxyqHyDjh4fcY08JbD5JtTq7UDKzbiQjE0WGwJCKymbjFUHs5CcxaxVL
	 4OY52zZvLdhSk+3L20Cb+MVztpko4+rAVkDgkbeVROrwAqMh6p+mJxJwQYgebpZRQr
	 TGXGHA+xIxFN5oGrsAnXbrEU9DO88hdYb+9cVT46t6qYX0MenB+ugZswg7t4ObThXc
	 PSutxLwYKiMM3z0GAXzbLZ/0F7uVGiVKdNbb6HFKX3pzNI8yIIKCO297OmJQ7DU5xJ
	 ioESQcFgBGXHG2socKFXU0WK/9m7y5TFiINGl7eedUQDGVbDyOZr1W8T2FXQVDj70e
	 nyKIN9n7T9IPw==
From: Carlos Maiolino <cem@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Dave Chinner <david@fromorbit.com>, 
 "Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>, 
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250430083438.9426-1-hans.holmberg@wdc.com>
References: <20250430083438.9426-1-hans.holmberg@wdc.com>
Subject: Re: [PATCH v2] xfs: allow ro mounts if rtdev or logdev are
 read-only
Message-Id: <174617563872.286454.3698448387151176934.b4-ty@kernel.org>
Date: Fri, 02 May 2025 10:47:18 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 30 Apr 2025 08:35:34 +0000, Hans Holmberg wrote:
> Allow read-only mounts on rtdevs and logdevs that are marked as
> read-only and make sure those mounts can't be remounted read-write.
> 
> Use the sb_open_mode helper to make sure that we don't try to open
> devices with write access enabled for read-only mounts.
> 
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: allow ro mounts if rtdev or logdev are read-only
      commit: bfecc4091e07a47696ac922783216d9e9ea46c97

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

