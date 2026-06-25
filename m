Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956613C4547;
	Thu, 25 Jun 2026 07:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782373138; cv=none; b=O5dzzGLWFCZ5jH4fRisN2POPLGd5KeoOa//Epk2r0xFYPeWxKfa/Z5d0P2DmBsGqWtP+ytoP4ut4G1CHVreHGn5JJ7NKvJDx/RVIRi3WEjaJ9N7K3RCz8ZwEb8RmEUaAddyuYEsdB3TDogp8VM6L7sr44Ikpin8jwwiog3Df4dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782373138; c=relaxed/simple;
	bh=8nL97t/5OjmQXRAmFvJSs9g5VJVz1seCf5+vq3ov3qs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Ih7fAVvyanPQMpa9QEiBTz00IBFvvz6jdAWpoz6Zn08Qi0xGkIxZlga1zzdEcjFwa44z0PV9Hz4htJFGdE4lJ7asfSAYymD9nMH8ggeabJksphq2xCBXmXoYePZ+n1Y6GO66LRKK+FNDXp5KBa3KrqjKaXmJEUFS9RHAajhfrFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXNYKfx5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXNYKfx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F171F000E9;
	Thu, 25 Jun 2026 07:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782373135;
	bh=s/yctM5cvNxDIzVGX4IzplMohkr8CH4gDLWqSKtdBU0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=fXNYKfx5l7NGvlubEIrVwS/lhY0yN7/oPPUIaCEf+jCy72eWTWPpVsyQW1r4V8wLD
	 7jgotJJ82kiL1V7J8nnPVAIpr0GYZoQntSRihAqFnX5/2UPCl9V9vAzZsisKDfA50i
	 Fr86szoAr2GDQukRcdsaGh2FR/dRsp8cQm/VllrchXEC8ohzvlkUO96MxpKp5Nwaxp
	 f3RL0mT7YGF9zSnl7evrLBaNupwtjDI8h/XF5PRB4FZvtUvSDMwVXWpXNzwLgSdR9s
	 w5t39IHdeHmzDCvDlQkSpNVGFK9QUEjdY8AR0LVd+zxj9s5seYbGGvBKw8TfKZo8D4
	 B+YHoBUbSJhgQ==
From: Christian Brauner <brauner@kernel.org>
To: hch@infradead.org, Morduan Zang <zhangdandan@uniontech.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 djwong@kernel.org, Christoph Hellwig <hch@lst.de>
In-Reply-To: <9E38E2659B47DC2A+20260624062622.337469-1-zhangdandan@uniontech.com>
References: <9E38E2659B47DC2A+20260624062622.337469-1-zhangdandan@uniontech.com>
Subject: Re: [PATCH v2] iomap: guard io_size EOF trim against concurrent
 truncate underflow
Message-Id: <20260625-depression-mittragen-zielt-985cc0586b5b@brauner>
Date: Thu, 25 Jun 2026 09:38:37 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-d9d01
X-Developer-Signature: v=1; a=openpgp-sha256; l=922; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8nL97t/5OjmQXRAmFvJSs9g5VJVz1seCf5+vq3ov3qs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTZ3ObN3TDryzWBM0UbrEL79X+XWflHpNff+L4rjOXQ5
 3lm87hSOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZi8J2RYUMP1/Vu/oxFUtcv
 i+1q/L1z3t2yrRemSHltbWG69TsjcwXDP6vCSasuuSyrC5u7U+xDdzvDjQov88bvgjMP2uhWb2M
 t5QAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Wed, 24 Jun 2026 14:26:22 +0800, Morduan Zang wrote:
> iomap: guard io_size EOF trim against concurrent truncate underflow

Applied to the vfs-7.3.iomap branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.iomap branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.iomap

[1/1] iomap: guard io_size EOF trim against concurrent truncate underflow
      https://git.kernel.org/vfs/vfs/c/d5c89a26c8f3

