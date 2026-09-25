Received: from mail-244122.protonmail.ch (mail-244122.protonmail.ch [109.224.244.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDE632B102;
	Fri, 25 Sep 2026 19:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790365535; cv=none; b=e4Rz4/9ZtRs1a8OCjGUfhTBdhWADYjcV/L8fJ8S/BQpJ1/xJjmLb4X96QtMIhz4Az2mmifODk4ruE6yZMZClw0gfL3ys56YCINoQPbi+yqngSug+mUf99YvYb9JU35He2UoAhwCCRAU9OIz5wilZNQkpQXS2EB+nJpExb+ScG+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790365535; c=relaxed/simple;
	bh=VXCfN//Ld7RPyd2dz97rwSxk34crvyB9q8V2H5Q7KSo=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=jdECD4fwwRxOzmjNYczgT5vFvJlpigblNddM/1bSiUwiPmMtuCIDP5hczBHD7I2+CnzIuHDjI6wOJHP5+n4eCksyWTqyXrkeuRSZbbYsQCe5S78OoJe6OQg0iVUAvNUjB8PX0vbogzltmvE1kp4GyrHuxozoumzbOenmPGNNQOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=RtSpJHcm; arc=none smtp.client-ip=109.224.244.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="RtSpJHcm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1790365524; x=1790624724;
	bh=VXCfN//Ld7RPyd2dz97rwSxk34crvyB9q8V2H5Q7KSo=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=RtSpJHcmIOhKT6YZXAFBD+nBBq/covnymRAHXgElwTZX2/UkSeIF+bOAgTSvU/mOi
	 P5u+2R6Gfcv4SwsHsxwKzfmYl7D+PLDn52+TIqzVeJ+UJWUGRV5EjaDRcIsGWHUCZd
	 1TZKrA0403CR4xi96wBDlo6V0oL12tdfQ5AVji9GybFUqQdo89wIsluEUcCRk1H8Ve
	 fzL5MyCZ3ygx6gsYWjfsReYx93HXIE5Tr5sW6OS7ZwpqQAckjodvQnp46KdxugItTA
	 g8MRGTD2un8lb1XsTX8GZRWrLHcCFcBQmSVtq9gTshgoHKJfVsqQqH9riwg8nE2Rsz
	 uPurjxlIw2a2A==
Date: Fri, 25 Sep 2026 19:45:18 +0000
To: syzbot+079e16bc964fb91acb4a@syzkaller.appspotmail.com
From: Ethan Stern-Taubman <ethansterntb@proton.me>
Cc: brauner@kernel.org, djwong@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: WARNING in iomap_read_inline_data (2)
Message-ID: <20260925194515.148526-1-ethansterntb@proton.me>
Feedback-ID: 223622164:user:proton
X-Pm-Message-ID: 251bbc098aa1b7f8c74475049a076702bdcb40b5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hey, I was able to reproduce and I'm looking into fixing this.

