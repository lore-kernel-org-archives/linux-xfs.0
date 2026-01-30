Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9B03033C6
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 09:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769766724; cv=none; b=Q4f+Qluz3GFG0a/4G1pwk2xmU42pet2rtFXdVlXzf9RiK4SyX9Cq/bccEIVuYyZoVI750vZO9aKhNvREPYlJ5eamvJ9c7d5lvdvab4joQ7cs+QpwK4SiYDgHdHwE+5ZdfFTusvjWAarctLjCLxJILgSydbIrUux9HDZTQ5Rd4EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769766724; c=relaxed/simple;
	bh=4v7ftzdGiFKwbFVMPipp0obThN153Se/AykVsa8uO80=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GymoRMOccrPOkXVI6cfjvxOpk8E5wwhbLEVNKTGZ9lk5pe6kCV7SUjiQbgQuxFcGaOc+QRX60kdNMrSObs+PCa8sj5qbvGkA+4p0upYKPP9+egZFVacuGCuktetlD6forNBu/uRB3QfIpDUV4vGV5oykCpZTX/6ZOg2hhR5FO8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=msaNDslJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="msaNDslJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E381C4CEF7;
	Fri, 30 Jan 2026 09:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769766724;
	bh=4v7ftzdGiFKwbFVMPipp0obThN153Se/AykVsa8uO80=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=msaNDslJjRx6BEJF8PC//YIy21K4YNNMCWufZXUlbx2SbCTeZaRK6N8Do4GUqaaQy
	 Q1U2G2l9/NPqPlM2gVDGl1YxDe3bGa/Gd8SqlIidRvsaFaMNu8tvQKwdvCyXACxe4j
	 7WhYygY9hOl8gILHa1BQbVtSOcyTnmW25dxcqy5W3zK1sBjbyH5HqB9AMXZHhIEixR
	 ixfErbWPAJ2lSDsW/tp5tLI6SF5qzZoi623zKsHj/KcCQZ6ywIyXBPY1CcJAdGZ/MA
	 Jx3h12n+/mHYPZ5bKM8nnfsC86G7faCvyQsva+eatrqKAufOHV5oN75g68/alyJQ36
	 cJ0LVcehsQSwg==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20260130052012.171568-1-hch@lst.de>
References: <20260130052012.171568-1-hch@lst.de>
Subject: Re: stats and error injection for zoned GC v2
Message-Id: <176976672333.101188.14602981994102294118.b4-ty@kernel.org>
Date: Fri, 30 Jan 2026 10:52:03 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 30 Jan 2026 06:19:15 +0100, Christoph Hellwig wrote:
> this series adds error injection for zoned resets and zoned GC stats.
> My initial use is for a test case that verifies zone reset error
> handling, but that stats should also be very useful for monitoring
> tools like PCP and benchmarking.
> 
> As part of the error injection work I've also added a mount option to
> enable error ibjection at mount time so that it can exercise the
> mount code as well and cleaned up various other bits of the error
> injection code.
> 
> [...]

Applied to for-next, thanks!

[01/11] xfs: fix the errno sign for the xfs_errortag_{add,clearall} stubs
        commit: 9a228d141536a91bf9e48a21b37ebb0f8eea8273
[02/11] xfs: allocate m_errortag early
        commit: 394969e2f9d11427ce493e171949958122dc11ee
[03/11] xfs: don't validate error tags in the I/O path
        commit: b8862a09d8256a9037293f1da3b4617b21de26f1
[04/11] xfs: move the guts of XFS_ERRORTAG_DELAY out of line
        commit: e2d62bfd99b6b79d7c5a4c543c2d84049f01f24f
[05/11] xfs: use WRITE_ONCE/READ_ONCE for m_errortag
        commit: 4d8f42466a3ba2342b876822ff0582a49e174c9b
[06/11] xfs: allow setting errortags at mount time
        commit: 2d263debd7f1df2091efb4c06eda02ab04b68562
[07/11] xfs: don't mark all discard issued by zoned GC as sync
        commit: 32ae9b893a1dc341274ffabd3cdcc63134f36060
[08/11] xfs: refactor zone reset handling
        commit: 06873dbd940dea955b30efb0b59212f1c858f6d9
[09/11] xfs: add zone reset error injection
        commit: 41374ae69ec3a910950d3888f444f80678c6f308
[10/11] xfs: give the defer_relog stat a xs_ prefix
        commit: edf6078212c366459d3c70833290579b200128b1
[11/11] xfs: add sysfs stats for zoned GC
        commit: e33839b514a8af27ba03f9f2a414d154aa980320

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

