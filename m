Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793285358;
	b=Y0gXqe5CXq29m82a38z2tTJR34zaAaGYlRxN7ah7gNpz4MxN7+UKBRNINiEPucNmjWPI
	 E4p4cSCQ+hhFiTCZ1PJvEiT1HuxmeWCCjLkoYLqeYctWfwp/0WDyeMSqPP2YAkbd6uf/V
	 C/TT+2FHEOws2ZTw7/xBohi3F7eEUnvEr/8j8aicT/58UL2RkZdvQ/0fWEGwDDMvLwucz
	 k8X6AZ6vnlllW5xchBK7pF9wdaen6bV5lpDyG46zoFb4Asyua7tLo9Y9FqMAHR0OovC6P
	 Bo8gfojcrTSO6NJRfMm2lkY+UJvsBaDizUGm+g+hQ7QKfdVesHzX5PKvMQiTxGtjy+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793285358;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4QrEbTQGtnljChX3zPFzp85XMlzPbGmcRo9faCYXuc8=;
	b=Y1tWl7mrF3vsOUzRKdttExst/3GGxECluspIc8lPNzOXTaRbnygkMxHJ/a8Ijv5h/U2r
	 BYr1IbtrDbppBjMYmV0jKzd2mldPZUcARnlSIZpoCoN88ZW6udeOce/rip1WoH4NMIsCN
	 RSvQ2viGlqZrAo+2OF5HIRy2OGOp+g0HmnDZ5sDZMyhwYfRek1r45+F1HMtGXy61teCV6
	 9XeKHivOZv5ptU/dbSrzr+8/arDOFBqu38Ej+C/s8fw8CDi1/kzoXsp2nSaAhPyB8/5Nk
	 9/dfgrj3ncID3fCWRxQDKW6uIElo/ReOL4TCfazA9YkzLKzEW+EOr+xeaOBuKB1MNRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dAXuWCh+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E7F606A31F
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dAXuWCh+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A726B1F031E1;
	Thu, 29 Oct 2026 14:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793285357;
	bh=4QrEbTQGtnljChX3zPFzp85XMlzPbGmcRo9faCYXuc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dAXuWCh+DjAGnBlsJVs6LVcH7QwkPzmKlHnyVk8t44x8iPH73czXAMMUER0dw53Xn
	 qQjzUbxV5EdTSNOWoegf8llKxzEN56QB2PH4jBIcX3/eqPQ1RL7tsx+8zVMUObHL3D
	 WtaVCA3hKAt5ZH9zobQgDqWE8dCXahTpVjtt3ovEvrSMWo5NXB43n9nnWIb0IMl6sV
	 BCJOxy10dVUnIu7fFr3usXYxbClKz1myrzLKqqBhA5IWTQdbsIjozGQXDm7mo/Q8Ii
	 k/q2knAU9ELkqFbWR6Ohxti717nJ+U7OW+yRPSFpoF5ceyYgh6UwcjfrAu+XZG56qo
	 D3wVtQDu5MsPg==
Date: Thu, 29 Oct 2026 15:49:13 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: fix libxfs compiler warnings
Message-ID: <auNc0ydS2tNV5ndL@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261027154237.1997484-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027154237.1997484-1-hch@lst.de>

On 2026-10-27 16:42:14, Christoph Hellwig wrote:
> Hi all,
> 
> this series has a few fixes so that xfsprogs compiles warning free on
> Debian unstable.
> 

The series looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
