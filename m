Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8913C13E9;
	Mon, 10 Aug 2026 11:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786362937; cv=none; b=KsfdxV47rNt1rih+hJBus7QNy5jkz7QEqf4YcvBIfYnNpp4RuZ5B4FseN2G3kiz44xNZ6M8tPoAPuEzpCKzigq9iQ7Tg23lO7zTqSCmdsqatvXL0xclWmcTscDq431ic+RJbQaEqBCB3ozZb3KY5/ayMpW3Av85h4WxF8ZkgVQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786362937; c=relaxed/simple;
	bh=+gFVfSo+RJ+FVHqWezGx/TxFOVDOoIslihPQ2Xiwh40=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FzTKd65ChPgbrbsfDWNp2Xqa1AVJfJTlXmIJDhrhurTiBy50TZsCEyHNGf6MG/UdfZF3o8cpI/y5FXuC+C/Q3d/374Vt6ffCKdwG/AWTXREbjYQxqU5gFqB9Ob9tKXSW6phS/v/PR+dbIfsE4gVUVw/+jsYnMlkY0SFvqhKMVPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o3F2t8nY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o3F2t8nY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5614E1F00A3A;
	Mon, 10 Aug 2026 11:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786362936;
	bh=WK41KBFUjetaE92dRdzXkyBuaOgsTdji88WxMHi9YKI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=o3F2t8nYcq9PoJjWgk6cc041gKgJ5u1XgeqH1u1bIsd7HXrSkPZ8fx09xoIhEWeLG
	 OVhwi2COD6hnwQLIxlKWDlp+82M3va5EBmgUZLnzqS0S5FMGqTqiTCFC3ekQkkLRob
	 DuI1WsT0do4s7c1mhQycEt1Npn8i4IRlZoKz7/yq19l3DW7LaKAVe0bZyPSaGk2Oc4
	 YAPLD8XMD/NlTub4CpdE2ERF8BMayvYu0T47yyAjl3RFlTNoWl/binkXEl4gcFbYs9
	 pZsQVPhjH9fb316ceyPar9gjz1OWpitqffWHXG/dkmRvZva3FCkXmFl7j4k8pUdKJM
	 TWgYf9i+Tiiuw==
From: Carlos Maiolino <cem@kernel.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: hch@lst.de, djwong@kernel.org, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260730093002.1034320-1-yun.zhou@windriver.com>
References: <20260730093002.1034320-1-yun.zhou@windriver.com>
Subject: Re: [PATCH v3] xfs: restore nofs context unconditionally in
 xfs_trans_roll
Message-Id: <178636293501.58486.13061127606354356864.b4-ty@kernel.org>
Date: Mon, 10 Aug 2026 13:55:35 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Thu, 30 Jul 2026 17:30:02 +0800, Yun Zhou wrote:
> When __xfs_trans_commit() fails in xfs_trans_roll(), the NOFS context
> is cleared but only restored in the success path.  This leaves the
> error path without nofs protection, causing a circular lock dependency
> between xfs_nondir_ilock_class and fs_reclaim:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&xfs_nondir_ilock_class);
>                                lock(fs_reclaim);
>                                lock(&xfs_nondir_ilock_class);
>   lock(fs_reclaim);
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: restore nofs context unconditionally in xfs_trans_roll
      commit: 0241ea5fb0fe86d2a673163b2f5815111aadc7f7

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

