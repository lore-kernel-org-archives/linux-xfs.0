Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700146;
	b=mAvp3OIY7e51mgoF0Hovly/qWgL89v5zB1pG3fPwDLt2NuBMNyj1dQxiJ8bojQ6I7cFT
	 Vnb/t6ENLEHNwLlc8sEojdGJetveMNjTAvXuJQr3/vboSHcChj/ouNfNEDHhpkbROmBWm
	 w2BAtssWUMAOn8f4DTohBf/qqOUTkrxNmCKmL09O8cKpglRuoHgmPc1hIxfSfAjsQDoYA
	 upiSKMlShw6h470GsVGmMgHoUdFfDFlc4Ycitg7wRdrIZKEozu6GovhoB712rZRjr5VMT
	 P/TNUlTYsJVfjPLU2GNHTfOhTrsm3nr9pT75+2ZgGRMpWeQE+XsvzE6w94lJcV5IBWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700146;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=KeFzGW9Q/Xz8lfIpeM3P2k5/eCg32XWf7nYiqOX6d+E=;
	b=nSigJbLHrS9A40IBv7KnYcZh5mPd0NeJUwJBPKIjuG0o341tnHeZYqFVx7CatJLXUxwh
	 1HQj4vOTp+aRsXlwL0IC7mEUDOTpx0Kz+zZbT+aWZCBdknZnlJ7C+zwxDFHyh8LJCceqd
	 4YKJa3fdP9dPVEDmh8m9A03RToFAOGzhVTeQalmb2C97Qso+HviqGJUnk1Y06fQHE4XGR
	 8w2ub2iJFrwy4R5Uosmkb8o/Ulvn5MaO5tXhUr/OuIUdoufJgj7ybxiArR43rd1nZjXsr
	 4SQDXdPlml84FxOnJ9OUp7PYPFCxKRlxWO3B3ZaIJdSb+C3girItY9TcDvJHS15g6ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="jzYlI/ar";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28636606A327;
	Tue,  3 Nov 2026 10:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jzYlI/ar
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6421F000C1;
	Tue,  3 Nov 2026 10:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700145;
	bh=KeFzGW9Q/Xz8lfIpeM3P2k5/eCg32XWf7nYiqOX6d+E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=jzYlI/arpb6/9WNRaCW4Imvmj79VwE+YWfBujahEwdxhp+1b+VWyiVe3lwlE1j6Xz
	 QTRoizj9LlRaei8qo/TRKhwFeGo77tlOv1ITgrvABGccJgTIHTBgQmDeWVrYErhx7S
	 vEXMe399KXr+jtSGsYaRVB1YXsTLvGkJaHAgkQd/OG3Y1qXJz0X4VaklGYCyPoj2k9
	 8cSa9yNItNZEVl+opXdHnQJpuPcM0ils0dmgEKiaghBr1cQKFBdl3seqlA4J6HpxGW
	 VS5A1MVAkRE+s9qRTx4fg73Xpczf1iDpg71Zb3wIRhmJwEYmdf9MY2S9nxt9oJnogv
	 J74yHEkzboYLA==
From: Carlos Maiolino <cem@kernel.org>
To: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Cc: djwong@kernel.org, dchinner@redhat.com, stable@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <8104ae683f89ff3415528198c8b4af0089b7f9fa.camel@oracle.com>
References: <20261001145153.308087-1-siddh.raman.pant@oracle.com>
 <as5AloTkTT3bZkyq@nidhogg.toxiclabs.cc>
 <e7feec9bf096ed64f581536aa314a21723cccc63.camel@oracle.com>
 <atirYb9qxRsaRYhs@cronus.toxiclabs.cc>
 <8104ae683f89ff3415528198c8b4af0089b7f9fa.camel@oracle.com>
Subject: Re: [PATCH v2] xfs: Fix duplicate assignment in
 xfs_alloc_read_agf.
Message-Id: <179370014407.413123.9754129627068022997.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 11:02:24 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 21 Oct 2026 12:16:25 +0000, Siddh Raman Pant wrote:
> Probably an (harmless) error in copy-paste.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: Fix duplicate assignment in xfs_alloc_read_agf.
      commit: 13257daacb8f3e1a066f86c8d752b240b296236c

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

