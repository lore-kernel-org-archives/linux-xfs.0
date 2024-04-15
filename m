Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DA53FB96
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 09:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713173085; cv=none; b=A9FfyZw77vZkBhpa1kiIBNi5YJP9Or56V4a+YRFgaNknm/qF5U/Gj+l+kZIC6K5b39/XbkfFlxdAT0yYwR8+L9M1oYY0/kuTcbU/HTHRh3h6DLy505nvEJ1NHI8lrxMS2wgpeO/VWdPHwjFEu28c0Cw8MB+7nChaXgJdHJCEoYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713173085; c=relaxed/simple;
	bh=+nSLXPr8rSD3zmXdT5J4JBlF/RLvFxuxs/HOVVuJ6Rw=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=CeeVCohd2U3uf0u4oY/yD9J+TQWCIRjPqYKgFVHuY9askpop+CgLl3mL00pr0egzCIX2/DcdPm7cxd7Tewl8dMsoaTAixLhbzsKrTA19/ObA29HBoxPK941suQKY8BBJ05PWhDs+VjrBxkdNGFeMhfeTs+Kcfn4gGBryZfO9G28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cBBCUzrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cBBCUzrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344ACC113CC;
	Mon, 15 Apr 2024 09:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713173084;
	bh=+nSLXPr8rSD3zmXdT5J4JBlF/RLvFxuxs/HOVVuJ6Rw=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=cBBCUzrAbyTJP9Rh6+ziCc/XWwuTDBXrX2CGoCCE299TrfkvWrH5AKxdyLuEjFldg
	 81+lGYdPQaTVlqy7Pjg4FnxJ1yFk4Rf+8l+m1aY9Z4K+FU3q9llhixA7HCnlZRMRez
	 71t1GLouq7jSvmBsDsABD5yd1rgFAIsx3dTANNi+JegJQQgfGTm6QoqbQlX3SZgfcx
	 WARUbU+22AHLxzRzhnHA3HGcQLPCsdSwx2MAVaYPRurL32sMM1CBLvA4fWPf18looS
	 Vi987vKPiYO145F/Ivt3ysg67j5KYcrRrZZnqLc9qCVu6llQQa8kzHBha/sN28AiUz
	 40UYovmTNh5iA==
References: <Zgv_B07xhnE-pl6x@infradead.org>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] bring back RT delalloc support
Date: Mon, 15 Apr 2024 14:11:16 +0530
In-reply-to: <Zgv_B07xhnE-pl6x@infradead.org>
Message-ID: <877cgz3rmt.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Apr 02, 2024 at 02:50:15 PM +0200, Christoph Hellwig wrote:
> Hi Chandan,
>
> Please pull this branch with changes for 6.10-rc:
>
> The following changes since commit f2e812c1522dab847912309b00abcc762dd696da:
>
>   xfs: don't use current->journal_info (2024-03-25 10:21:01 +0530)
>
> are available in the Git repository at:
>
>   git://git.infradead.org/users/hch/xfs.git tags/xfs-realtime-delalloc-2024-04-02

Christoph, The tag "xfs-realtime-delalloc-2024-04-02" is missing your
Signed-of-by. Also, could you please rebase your patches on top of v6.9-rc4? I
start applying patches for the next merge window on top of x.y-rc4.

I just checked that your patches indeed apply cleanly on 6.9-rc4.

-- 
Chandan
