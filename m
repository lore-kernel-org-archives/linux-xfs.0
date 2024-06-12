Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF9DEBB
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 17:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718213758; cv=none; b=bLbbM3t4Elpk8DCIsXGHWe6IbwllobDk3wa0SH6wKyLm7EVhGXfHvx5Xlb5HtZ7L1qDFkBKALCcfzTh+kiSCZJGCq2mCL83ydII+eOkpMuYWZaR16U6A4NcmQWSvfMQ6EJuFzII9meewK5olyt7QorCYxJL8gxyF3VTWZ5ufXBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718213758; c=relaxed/simple;
	bh=MH66XaqTJyGafg/UGdgoY2jHCBMOps3AGKGxPvqMuv0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PW/5o5FhoD3hXwZcIN3Zbkd+4z7YeqGyTsDDXe+ld9hTUheh2bwbBBrr7LpVtw18NKNwKq6cexU1RcC/O4kDgKAW4Nk3Clewgwx8a78mq3yg593A5SUf8l/zMFeJBqC0kLPvjV1iZHSiJIEd3m6Yv6k3EJhU7Yow8Qba3dF0bwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=OV/BoOHc; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="OV/BoOHc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=rN0GmLURdzc+hXzBrKZwl+oeCsX1TD3T3YQ3Bu6ntwg=; b=OV/BoOHcea7GhEGIKi7K3QeVeP
	lOrasklqIuG3DPw8qWzyvo9i9hpBDQfQup2xCPdGBK/3rSDXD39Ng2m3vPmAi8ofunNCdwE0Nc6T2
	rUMpkoTcM42HUCfOay8vNaebn4aenKbPQ4ABE0+06ussPn9Tv0RhLjZZHmU40q01KyC/nK7K1wRUm
	RNtUDaYgmUJrkrrvpCsjQp1mXSRrBDul8g1uxBI6N6hZI7A0CIDrvBF3lPPMEKImG85L7PbboF/1r
	3VoWxGXdVXYOpI1RYLETrAhngJaO9kWE7DWN5OfyC+Tx5Zkz2wD4m0BcG/gNNUtza0Gj7YBjB8oHl
	T0uFzxQw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1sHRt4-008094-UR; Wed, 12 Jun 2024 17:35:55 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>
Subject: [PATCH 0/1] Forward: Install files into UsrMerged layout
Date: Wed, 12 Jun 2024 19:35:04 +0200
Message-ID: <20240612173551.6510-1-bage@debian.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage

Hi,

I am forwarding a patch by Chris Hofstaedtler that is in the deferred
upload queue and is going to arrive in sid in 5 days.

The patch was sent by Christ in January as attachment so I guess it did
not make it to the list.

As most distributions are now /usr merged it might be a good idea to
include it generally.

Cheers,
Bastian

Chris Hofstaedtler (1):
  Install files into UsrMerged layout

 configure.ac                | 19 ++-----------------
 debian/local/initramfs.hook |  2 +-
 2 files changed, 3 insertions(+), 18 deletions(-)

-- 
2.45.2

