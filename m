Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D969307489
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 11:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758022487; cv=none; b=ABErejh59IKLmM7+3a+lCBKqAQJVnzhugoP7936BRVuhxNPdy2zrunUBDlKnHr/tNkIMx9RhPdo3qxQEV7HxjTR0vgtDaxJJ+t+k0hkp1rrYtNUDr8rIh4WgyAHXw+8qUU6zC0XQB3o+V+2XtIeRMCKOUfOQt+TKQG7EFhpNQv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758022487; c=relaxed/simple;
	bh=sGWKZ8rIFEe58tNCs2nNcvP+/TqehZszISngJhzteSA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=S0V+w5sXyg2bj5RvnqAr11wXWY052eiG2AMmr47nGsGlGDG8vM2Tf5UhKRNJ1MnG59cvKwWqkP1nQ4d9f5XdB1TEbqQA04by18rzYBr2mwunX+LTZPbrzMUGLCA5KKBz3qoWRM7pN/lSClGwTU2ZloQNIEfeprv5DxHCSIvNo8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eGB+ldeq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eGB+ldeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431B7C4CEFB;
	Tue, 16 Sep 2025 11:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758022487;
	bh=sGWKZ8rIFEe58tNCs2nNcvP+/TqehZszISngJhzteSA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=eGB+ldeqiV7qiPf4nBMS0+wczX8JF2wL5E32H3NEbfWZQXUeh7tD2FKtGrGy5F2Dk
	 W4H9wqx05SD/fI3z+3B5vJdjnAz0B+XXKItycwp3SFo8giNpPfHFiKQMie+7YgIUs9
	 TD5MVnNMq8n3YW8xQjx44tN3aAntDb3MZAiwtjoVIVwKJIJNQvVQ/6m8YhFcOZdRbv
	 vSyKDHm7XHDef/OCzxd0TKl61iFWKzOP+UKEcY3ULoV72Vx+p4uTVlNDLBIMwePDSe
	 Z3AKe4OWNogZOkazsnk6TlQmrDLRVZ1DyePgr2cElooU/pNO20bEutxlsccsrBofkD
	 0eaPwHEadBjQQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20250915132047.159473-1-hch@lst.de>
References: <20250915132047.159473-1-hch@lst.de>
Subject: Re: fix cross-platform log CRC validation
Message-Id: <175802248590.997282.16087539623369702162.b4-ty@kernel.org>
Date: Tue, 16 Sep 2025 13:34:45 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 15 Sep 2025 06:20:28 -0700, Christoph Hellwig wrote:
> this series fixes recovery of logs written on i386 on other
> architectures or vice versa.
> 
> Diffstat:
>  libxfs/xfs_log_format.h |   30 +++++++++++++++++++++++++++++-
>  libxfs/xfs_ondisk.h     |    2 ++
>  xfs_log.c               |    8 ++++----
>  xfs_log_priv.h          |    4 ++--
>  xfs_log_recover.c       |   34 ++++++++++++++++++++++++----------
>  5 files changed, 61 insertions(+), 17 deletions(-)
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: rename the old_crc variable in xlog_recover_process
      commit: 0b737f4ac1d3ec093347241df74bbf5f54a7e16c
[2/2] xfs: fix log CRC mismatches between i386 and other architectures
      commit: e747883c7d7306acb4d683038d881528fbfbe749

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

