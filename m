Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C6317D36B
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 19:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717185485; cv=none; b=jfA+/h1o6+e4YUc+hX/lcsASRtPsMNQ4CN2qWEKTt6Y7iHWUIUfcLcflOcPL+ATZ5z31TcVQNoZTqq/BK7BspQ0rWrQdaP/lCWdQ9ANimTbAlUrFaSKwPHZOn+4MLgTM6xFDR6lWfpDmnilvQOnziQUEA7e5bh+KqyEsJyb/CtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717185485; c=relaxed/simple;
	bh=sZPIitI2iD7C01hOhWPTgrJ+WptLFztIMtqiS3w/00s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rNF5t1VnqjXb0KP6VmNmqdlE+ypH4KNK5ZYv5NnxSZC4XRUM9W7efeCGrb3vfDgRtLniCAkZvE/4iq7T1p2ixNUtaHoXwPHvvgEK8fYKHWAQsWRVbWEI0bdDu9F3zKBPuT2dflHCvZOVFSC19zeVtKuUuxs2Yh2ddPFht2f+KA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=jzXfjXZk; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="jzXfjXZk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=GKSMvtqfdtCfWC6M/NuofqkSyTIjZQmDvQLrIXGpLWs=; b=jzXfjXZkcjwceyfYaNmE9nsrG4
	s0DwP0GdGdBd5FJgafWF+5QLSOGeEuEOk9zbs4i5UficfjfV1oY3apJGonq9zA/J91mfzHM05AoHZ
	RKGKnNfkEYsdxzUWoqkkm0lNWwNh3eWQsxgP5PskAnbNOfoTarvntdPWjXK8ZM6smRnPS34BazQfy
	vdY90cq8AdsW6NkurP8AcOPrTuOkyJf7mqzeQVAjqeUM0Zm+i3566OR5VrcuwrfW3CV3eP9YDm2fE
	JVh6Odsrzbur1RNI84DvMANPZqoUu9bX+e6vt1t45ExSpHWoyNNLWqgP0PdShwq3AL5ZHmGpJm57R
	45zDJl6g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1sD8Nw-004FIk-7Q; Fri, 31 May 2024 19:57:56 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>
Subject: [PATCH v3 0/1] xfs_io: make MADV_SOFT_OFFLINE conditional
Date: Fri, 31 May 2024 21:57:50 +0200
Message-ID: <20240531195751.15302-1-bage@debian.org>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage

v2:
Suppress -o on the help message

v3:
Address Christoph Hellwig's comment that I should add a comment
that this is because of the missing definition on mips.

Bastian Germann (1):
  xfs_io: make MADV_SOFT_OFFLINE conditional

 io/madvise.c | 5 +++++
 1 file changed, 5 insertions(+)

-- 
2.45.1

