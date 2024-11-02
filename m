Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF182B9A4
	for <linux-xfs@vger.kernel.org>; Sat,  2 Nov 2024 07:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730533481; cv=none; b=Q2bMgxF5U0kR/D2C6A3R9GBgaYlFVDHpdco/f7oHJBpBxp2FfmWIS/xt2PnWXqKXK8Zom+lm+SIAp9g2/BCbadcqm6CSXjqXLLuie0fPf5Al4kxYrvJpwBxjahLmLVKUqr37xMNR5R2tmBQgI2YeVCilECnpyj1mF0F19CE9QPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730533481; c=relaxed/simple;
	bh=fM3OPqM6jYuDtQcbB86hjbx7fr1EaVHznb/ZchXSXas=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=g5iL2lajjN1kX4O22S2W1SK4/XBokUBvOHLflbyD0eCqSP6FspIe1YDdiUCepvUwCK/shTCyPGa2pJoAyfEq0gYIwts+R9XJC4+ujHqU84pVw+w5RIGtEy5ejAAfONkkLImWcYJDWtbwmKhi3cM+9CHRroqS05sjxjYOlLpoEfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WopTVu/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WopTVu/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFD8C4CEC3;
	Sat,  2 Nov 2024 07:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730533481;
	bh=fM3OPqM6jYuDtQcbB86hjbx7fr1EaVHznb/ZchXSXas=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=WopTVu/0OHWsn9oC0wGdBHBV2MYERbjSd7GN+EuGP0KQ67oyzK5tUZ1jdEv6YdcDn
	 fv9yn8jvp/6HdsEo0l+LFrmlPitHaNMkqEU0SA51mPpLcXcnSlg1IEQfrD5YQnhDVM
	 wfRXnWZ6KXgUt0RyrQJpuSXfi2MmiU9FZ5T7tInsTh+wE/vd5hqdlqhugnD11/01t/
	 Iv8oZSeS9aV8zXu0Wmy8oBP/cwEaCflrU0GlIbdiGcQioftMQSyw/EkaVfcTSJOOnw
	 0xufmbNWjqve7Du62SjkCtONSyjnwaMn368j4wnF9YOE7AxKt3o5AtPbvYLl0a2pTB
	 ql8CY/kld2C4A==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
 syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
In-Reply-To: <20241023133755.524345-2-hch@lst.de>
References: <20241023133755.524345-1-hch@lst.de>
 <20241023133755.524345-2-hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: fix finding a last resort AG in
 xfs_filestream_pick_ag
Message-Id: <173053347926.1934437.18266444538518873062.b4-ty@kernel.org>
Date: Sat, 02 Nov 2024 08:44:39 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 23 Oct 2024 15:37:22 +0200, Christoph Hellwig wrote:
> When the main loop in xfs_filestream_pick_ag fails to find a suitable
> AG it tries to just pick the online AG.  But the loop for that uses
> args->pag as loop iterator while the later code expects pag to be
> set.  Fix this by reusing the max_pag case for this last resort, and
> also add a check for impossible case of no AG just to make sure that
> the uninitialized pag doesn't even escape in theory.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: fix finding a last resort AG in xfs_filestream_pick_ag
      commit: dc60992ce76fbc2f71c2674f435ff6bde2108028
[2/2] xfs: streamline xfs_filestream_pick_ag
      commit: 81a1e1c32ef474c20ccb9f730afe1ac25b1c62a4

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

