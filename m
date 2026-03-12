Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909CF375F71
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 08:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773304656; cv=none; b=LDna+jLwcoqSi4qdHqZQr4Jr8qgbUk0waMpgTwWXxxTJYtnc/L+4VSOIWiCBDhbLzbcDv4bDwPX5PmyQAIEqRm5/N8RnFoi5XXi8R1+TJ5phWnp6kAfa+xs32mUC8l5iUb8eIe+tpgu2kR48S88wBKR2FdAESrDFfw464CdOihM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773304656; c=relaxed/simple;
	bh=n22GzCZFdUtGbp91fkPXqX0Y4tqqGSONNXogP3PTSPo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GsqL4ZwmOM9lCE+q5G72va7LMDCvlzCBI5Z/HIhVHdHQyocKLPPIPbQEdgPjtt+XWaOvidZcyalIVXUqczvhZWFglATjS7SBMGB0u2nHSPPUH4Cx4BO1ucEF/sNtH79kB6Nte+pACmv01v+Mn92xShbjysaO9/ZLd8/86wOLOqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KyD3gFjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KyD3gFjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13680C4CEF7;
	Thu, 12 Mar 2026 08:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773304656;
	bh=n22GzCZFdUtGbp91fkPXqX0Y4tqqGSONNXogP3PTSPo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=KyD3gFjD3Y2LHrjBosmYHVANiidiVV74Fc/frtTMGb0K02OHms7QP+lj4DPAUnVoA
	 OwBdAVqLzoCR88XCD2zCrbYDCcf9gAsUUu8WrEdWoS26aZmem8FJV0AluDQKM3PXvp
	 jgprRmxi87Ff4LoU8iD8aN9oqMoA3bVrtR3YbOX2QBLVJWhHFOFVb1kF19285j4Pgb
	 v1fDSiK1w6Pu3HiXHv86keViKowfS98LfKAS6VD44UzbyIGTovozGLK5+MBEfSvtM1
	 yM+TI3jmC8gb0s9ssLQSIem+adbmyccxlM6dIseo/vaEW75UTS+U2Bxi2KpBgNF+dI
	 FWTYvIygwdjdg==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, cem@kernel.org
Cc: hch@lst.de, dlemoal@kernel.org
In-Reply-To: <20260310173709.457047-1-cem@kernel.org>
References: <20260310173709.457047-1-cem@kernel.org>
Subject: Re: [PATCH v2 0/4] Zoned device cleanups
Message-Id: <177330465478.21069.13072964600496902678.b4-ty@kernel.org>
Date: Thu, 12 Mar 2026 09:37:34 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 10 Mar 2026 18:36:45 +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> This is the V2 of this series, which implement changes suggested by
> Damien and Christoph on the V1.
> 
> Only changes are on patches 1 and 2.
> 
> [...]

Applied to for-next, thanks!

[1/4] xfs: factor out isize updates from xfs_dio_write_end_io
      commit: db8367f63b301bbdff6eb00c2e09fad4f2ae75e9
[2/4] xfs: factor out xfs_dio_write_zoned_end_io
      commit: 02a5d8993b09fe9a6754e57d0e25399baffe9a06
[3/4] xfs: factor out xfs_zone_inc_written
      commit: 3bdc20b005c20ce1bf9b098d1ee2caa1d994141e
[4/4] xfs: opencode xfs_zone_record_blocks
      commit: 54514abb9891eb35033608e0fb51809f5a4c07ff

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

