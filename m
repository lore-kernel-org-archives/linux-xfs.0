Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADCC1D5CC4
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 17:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157889; cv=none; b=ChYol8aN0i7rHzILraqegUL7zYGRsFqdccmez08JyTNhFp/1J8ihGpocymr6ku8+yZwHbjsPpZC2Wsn7r7EREkauxe0HrbyFqHSVic8NbLWcY068j0yHeRDwzyIN/QjhFk5mODQLD2Ldsq4/EY05dbNLI7AiMYaeh33pjBQ4Jm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157889; c=relaxed/simple;
	bh=V9qCVkHfBuAxk4ei+3PYlq7A/IIdBzifX312uhHprmU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=d13DNtJeE5Fl/pZK5jUbmvJ2pvkAJKy1Sv5fukI8znlbxuWaL2biu4bUwSEPclUEAnqs702U2Q12ZNtYnsvH+pPkD7nGgM0BB7Hi1zGvjNy6g4jaeh0+tiNf/B5GcF2VVYGdH5lifP47qXfx4qhRAGlvooedmn74+7wHEYuXYkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J10CPqgF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J10CPqgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9A4C4CEE4;
	Tue, 13 May 2025 17:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747157889;
	bh=V9qCVkHfBuAxk4ei+3PYlq7A/IIdBzifX312uhHprmU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=J10CPqgF+v/ImfBtwfIEFs7Zky3lg+s9zgtfEBOgaBCA3C0ChhHZ6xjCHINNOwchD
	 O2ZSuAZQG/Iu7IqjR9LA/xCs1pAFp2fYHn+bfZPGPq9eCimzGLrNPlrTke0on8RErm
	 iyFeuxrcgNcpMnOd92g7/T/VWvlKYNjwZe64NMgOnBYjh2wwIk2Kt49ctTap+3VH4c
	 1Ar3GjSMVfrlxO8kpVKDY2xREX+D2+YLYGbv8tiyx3AA9V2q/+0h1Nr8S4uCep4n+D
	 WJGp2YUeORiniCLyRaTtbHCRnLbz267kxnqgr3sM3YWuIuCBBkQRp+LjXfLCkvzw45
	 Ba5Eqi+nFRprQ==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
In-Reply-To: <20250510155301.GC2701446@frogsfrogsfrogs>
References: <20250510155301.GC2701446@frogsfrogsfrogs>
Subject: Re: [PATCH] xfs: remove some EXPERIMENTAL warnings
Message-Id: <174715788805.709704.13710865404538859491.b4-ty@kernel.org>
Date: Tue, 13 May 2025 19:38:08 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Sat, 10 May 2025 08:53:01 -0700, Darrick J. Wong wrote:
> Online fsck was finished a year ago, in Linux 6.10.  The exchange-range
> syscall and parent pointers were merged in the same cycle.  None of
> these have encountered any serious errors in the year that they've been
> in the kernel (or the many many years they've been under development) so
> let's drop the shouty warnings.
> 
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: remove some EXPERIMENTAL warnings
      (no commit info)

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

