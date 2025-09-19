Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97A623C8AA
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 16:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758298554; cv=none; b=bv/Xltwd7G1qv0tzOtvA0UUhP9eOTQwJvsq0rOewKnb/nXacCEaaItnCmmuUPgGrkkbmdjHZMDFRoUBzmCOvEy2ftp6F26yC0vnb11ukduNL1wbXZ3ZLZeSbw5IDcK08KWwfyYNehTiVRSclPJCUqzYrmEv+YSKCSMiyYZ2sWQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758298554; c=relaxed/simple;
	bh=UbyzzNLEu5vgS6d0t615GGiSFcFbfxe0X08OnHD7NVk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uD7DGGri3ub1a6rb4s/27BSWw80p0Pmfg0G6mnzDQWMqFlelgcprLGaJLTsh8bQKy1h/JfeM7isNH7jkRhukyqIzdJbzWQGoP3iR5n0gMATks1TnxoIzHnPKLwscEWcKjGLQpZjWYI6vn7gF1qswlWZaI/gK7bk9tufVuVaRLxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DM+qAneF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DM+qAneF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B643C4CEF0;
	Fri, 19 Sep 2025 16:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758298554;
	bh=UbyzzNLEu5vgS6d0t615GGiSFcFbfxe0X08OnHD7NVk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=DM+qAneFDEyPAdYH5qCaYNpOuJLVCxJJy8V3b3XdS702G81h6FBGjbblb87ZEJTGM
	 sC27V0cVsPNIc8iyc5eMkoz67gs24isKIzTv/LrwDS5em1F2ImOXXd8bLE8cb2GuY8
	 Lb4HoZdmQ2CfNlHBbxOuT0/GRL7V2JcrNOcApWJ8d+AosUcsvFVvrtsjp3al6T+yiz
	 nAnYIvw6CjOLQN7RmSlM5CbD7ywjb89Ww4j3pcqTIoiXQvabcRzVJEJaUd4DKWhRoq
	 XvG78nI87U3Jyfv5A6SlOm6oddtFhJTXAXtDPb1Ckvex8TnpQvE2+fRFi26V8YcCew
	 kRWBofXwQPxgA==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20250915132413.159877-1-hch@lst.de>
References: <20250915132413.159877-1-hch@lst.de>
Subject: Re: [PATCH] xfs: move the XLOG_REG_ constants out of
 xfs_log_format.h
Message-Id: <175829855321.1207654.9507440220968910154.b4-ty@kernel.org>
Date: Fri, 19 Sep 2025 18:15:53 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 15 Sep 2025 06:24:13 -0700, Christoph Hellwig wrote:
> These are purely in-memory values and not used at all in xfsprogs.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: move the XLOG_REG_ constants out of xfs_log_format.h
      commit: 42c21838708c20dd8ba605e4099bf6a7156c3362

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

