Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6292253E1
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 09:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741600324; cv=none; b=RqXQ3ytLIxjDGUzu0M2wI5OwMPA5gkESqXJYLrNbHpKQbTYj5YMYUkpODCr5TCXmthBSvhbS+4aEBLQxzpNpgFZNM57Q6b9RraVZ8c26wsc3vVNmH1Lti3PQ8kB5I/WQwnl6QqKjXiADyVrbjhDg/IdkFRJCwdeRbQ3a4vQ/gPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741600324; c=relaxed/simple;
	bh=U5pbJ1Tr2tykHGVZ/IJCPiKwHTTEQI3XH69RLS0eq5w=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Rj+azPIcty/ZNTZoPe8GOwpzcJSkNJ9xth93eo3YEBfoXvJiFHrQCpth2FMPAzvbAPPQDR3jF4NGjdjY1KJzF9IyfpgPsDp7KlpZt6C0DTyRIMsAoUtpsxwZitrMhYE/F7fz1ZPGt8UdP71omrq0aq84F+ojecUeq1v8yWsb/Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bGTdV2df; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bGTdV2df"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F27C4CEEC;
	Mon, 10 Mar 2025 09:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741600323;
	bh=U5pbJ1Tr2tykHGVZ/IJCPiKwHTTEQI3XH69RLS0eq5w=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=bGTdV2df4pIrVwC0Hd1IDRG09qepv4W26PHcrNFOZTcH2e9PBMHOctyG6hye0mNhb
	 pPALp4/jsrUFY8zi5xaAjkbhG8prkP9qzPp9QDSFT5BBoCqypMEJe0B+PIfahjMEBh
	 nEN5NW1kXKfvuVToEtQrNFZRbvm2oRI/fNVeld+TP+NdKTcGAgT8sIWjfkTRqnJTFJ
	 3UOxoaBOg9P2d3sIGSuw4EbLiOQzkS3IzzUpxy2ymHIFs1eDJjEJve9IEu1Yas7rcP
	 h+EQ6vVY7L0dMoePt1Ez3bxU0+p10cHM0XmldfpSbUtgQY6QubcCgTNopnbijdCjKL
	 aiB2tQ6UtzF1w==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <Z8XL3ZduUCceA4hJ@infradead.org>
References: <Z8XL3ZduUCceA4hJ@infradead.org>
Subject: Re: [GIT PULL] xfs: add support for zoned devices
Message-Id: <174160032209.193222.10444052897557877825.b4-ty@kernel.org>
Date: Mon, 10 Mar 2025 10:52:02 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Mon, 03 Mar 2025 08:33:49 -0700, Christoph Hellwig wrote:
> The following changes since commit 0a1fd78080c8c9a5582e82100bd91b87ae5ac57c:
> 
>   Merge branch 'vfs-6.15.iomap' of git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs into xfs-6.15-merge (2025-03-03 13:01:06 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.infradead.org/users/hch/xfs.git tags/xfs-zoned-allocator-2025-03-03
> 
> [...]

Merged, thanks!

merge commit: 4c6283ec9284bb72906dba83bc7a809747e6331e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

