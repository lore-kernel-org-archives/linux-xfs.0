Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0EA3F8231
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 11:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783424254; cv=none; b=JEBBNvwii29KQeKwg56W6PDByeMLtz7/YwtJu9rXTLD8UqFF+tZECSW51cPG1IyQRh94lRrTuR0N8+BHellr71JrqeK8cMa1aT+Ry2XEBpDf9NolXtCNc9QXGaRa6cpsx6BrQIOcCJ34/vG1iMFWo0Z/d8zc3sI4GL+HhkSsi8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783424254; c=relaxed/simple;
	bh=m4I0aHMYVV/WG7Ui//F+S2vVCTd155BjPV6gi8I8EQ4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bG9RDKt/2erW2VyWZq0lr3A3nco56DxFZZ9g1rFmcf6C+RHY3Rig1Tfbf0JNUsA4ul6N+fX0e2pzbhHgUKDZ4xkxlP0cpZCMkF8+3GsZj2vZ0k1td5QR/S6St2cDpDb1QCnhLQCTGbf1a2F4G1B6zg7BBcH1aiZx8fRJwlkS1pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ja55L/rn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ja55L/rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737271F000E9;
	Tue,  7 Jul 2026 11:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783424252;
	bh=PKH00Ru2l8v6cl3kPzZp0C0g4KAKbJf6OJf4VbONFTI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Ja55L/rnbVlzeCILnMBNrDAG468dCHDj5cvMiRi/xK8nwfV7q2NANIgbTLBP3B3kd
	 ExLqpgxxUEeUOSz15JbMt30Ih+Ek0ONaB5NazjcRNGFsFPZjT0X9iW00mHoUZRTwG4
	 +164qx/KJsJfJPf4fVJ2/KCRfas0iZzIl4W6Lqcv4hPRljd7fDXX5upAZBMTG8k8l1
	 NuHmKFiuGme4KIRqOA4QUahXuFiLDFr17AJ1CKdtwvBpt9o/AD20XbK+KBoXbaMfVV
	 TiIRHHbBAYny+EkEnuL9r281/w4e8u0cET8NL6cdysUkvIU2/gI/amARmnkv5uu68U
	 2y/Zugn80x6Qw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Weiming Shi <bestswngs@gmail.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, 
 Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@infradead.org>, 
 Xiang Mei <xmei5@asu.edu>
In-Reply-To: <20260702162000.3548359-1-bestswngs@gmail.com>
References: <20260702162000.3548359-1-bestswngs@gmail.com>
Subject: Re: [PATCH v3 0/3] xfs: fix NULL deref in log recovery reorder
Message-Id: <178342425117.389943.13021791343607135682.b4-ty@b4>
Date: Tue, 07 Jul 2026 13:37:31 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Thu, 02 Jul 2026 09:19:57 -0700, Weiming Shi wrote:
> A crafted on-disk log can commit a transaction whose only item is a bare
> transaction header (ri_cnt == 0, ri_buf == NULL).
> xlog_recover_reorder_trans() then runs ITEM_TYPE() on it and dereferences
> the NULL ri_buf, faulting the kernel at mount time.
> 
> v3:
>  - patches 1 and 2: picked up the Reviewed-by tags, plus the
>    s/encountered/encounter/ fix in patch 2 that Darrick noted
>  - patch 3: reworked the changelog per Darrick and Christoph. The empty
>    item comes from the len == sizeof(xfs_trans_header) path; the check can
>    only run at commit time because a split header may still get regions
>    from later ops; and the runtime commit path never emits this, so it is
>    only reachable on a crafted log.  It came from an AI-assisted code
>    audit of the parser.  Added Cc: stable # v4.3.
> 
> [...]

Applied to for-next, thanks!

[1/3] xfs: drop ASSERT(0) on unrecognized log item type
      commit: 5b4396e12cb10fa89ca0a272fae2b5408cfeaa91
[2/3] xfs: splice unsorted log items back to the transaction after the loop
      commit: 34dd2253414d228fc9bf8a70b5f9f83107eda3e1

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

