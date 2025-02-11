Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC691F03EE
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 08:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739263477; cv=none; b=cS4RDTR7izrMGIUVqqiUL2x16tjsPxok+PnsN3WYYpOF7jjXQcdjPB4tPqidnZJMOmRbxDZMPgiOTMnOVCAEwzOdRR4pHMoJhdMslqryYj+NX1llWLFshdpd/fGS4RS6xSPg/M9BRU7atyzk/dUAMtFMa1fJybtD6X9NPmivB+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739263477; c=relaxed/simple;
	bh=DULCZe2riRLMeAEZLXid5mt2Ws2PaFmQ/9tpEDfOluw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Wy+ejrBPGc4+2TFDuRSuC9Y/EtSub/ovCi9rv5vcOVu9eVQEbSkwsg/CTF9TElJXtWYwsDKTH0MatBjUOYdc3yVOXZSAmOLZwvltNRNhNx3p0AVDU5XzND4BoEQtEJ4jUY0kVcBawmBnkoBPDaS2/UI1gzY+lpgPD5qVPJvhEuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dfQY3daj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dfQY3daj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4825C4CEDD;
	Tue, 11 Feb 2025 08:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739263477;
	bh=DULCZe2riRLMeAEZLXid5mt2Ws2PaFmQ/9tpEDfOluw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=dfQY3daj6xlGxz6fCq+cxokyay+GVUEPg/cpOnGqwbsFuSnI/efWwHhfY7mblapbM
	 aluSxnKBRykSyc/s3fFuLtW+RYx9TYy6OuoelHvEmEUUefq1ujBLSt3mT5+V89Nzkc
	 aoTJXbJGTzsbjpWdszbQSs1bCvEjsf1tYTLQ2ANqn6j1Tpj9EHvic23ivIxIBynNN1
	 +pH8liVVl6XfAdmTttNfd7zbMfFa4dIBuS3bkTBylwfdIE7WwvtWmMOrGY605qGCP0
	 8bnRwuo9bNwuovvl03nJN1qshzCFRI55FpwBIKHnlgN0ereTco90sCeEH0Qvs929zR
	 P6CFobsTMkdVw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, cem@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, dchinner@redhat.com, hch@lst.de
In-Reply-To: <20250203130513.213225-1-cem@kernel.org>
References: <20250203130513.213225-1-cem@kernel.org>
Subject: Re: [PATCH V3] xfs: Do not allow norecovery mount with quotacheck
Message-Id: <173926347551.43797.14508478442986566587.b4-ty@kernel.org>
Date: Tue, 11 Feb 2025 09:44:35 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 03 Feb 2025 14:04:57 +0100, cem@kernel.org wrote:
> Mounting a filesystem that requires quota state changing will generate a
> transaction.
> 
> We already check for a read-only device; we should do that for
> norecovery too.
> 
> A quotacheck on a norecovery mount, and with the right log size, will cause
> the mount process to hang on:
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: Do not allow norecovery mount with quotacheck
      commit: 18df3ca14c34e9fd6e12189a24238a12b064fbac

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

