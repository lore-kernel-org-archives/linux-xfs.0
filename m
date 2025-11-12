Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5328E2C0F60;
	Wed, 12 Nov 2025 15:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762961287; cv=none; b=E8+b8fzMux2icl9LAFYlz4eiLefkHCDuxB4eHuGgYlTy1ZMlrhcQHDVQ9hrZjaPMo9l3df9mSb3xxYYJU/cV78LNDCeufPuSYYJJ7VgY+KH8mvtHmSqJjBQuC8wxDNDzbOgCU+BMqcrqO+Pa6k2mEV2VjFQoHMmrd+4BTinaCME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762961287; c=relaxed/simple;
	bh=x/rkPQscTbeZ7bfRrWr7/hTnR52cEYMXdzAbOe1ZBJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rFnsQDH/0unmkxvMBgzLVuAEeg/4SOdGa1OH1n1Mr98MDduJ+D0gufFFvW0M7Hf5nRDKz18UFo2qbfE0/fRMC9yUyAFZdc98alL+/FkDiXvey8j4wffmsUJXGCuu/KVRWQf+SwCqYIqbWQO5zpWjtz4QKXHWNKQx2gZu38ZOKm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gP2427/l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gP2427/l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0KO36UCI41HIK5x8+kVYx7A+wVnDeo4ZtL4u1Nmqpx8=; b=gP2427/lmgrWOLEGeSvwn5rJ0M
	HDRCvUqJh2Z/aQPdyO5J1lsLvglcZynb9UR9dmuQO/APXRawCdoxK+meEaihlmazqskEgNHqO0geN
	TAZmB6KmXhTe8uMQ48jaJH9Eahl1vHnOllwuN2+N5e/DqFtiCvvvKRoSz+n+LlCZJyjtwLEW+lHIF
	EnrvwQxVMQ1mlu+kfHF2rk58KOVVMwO23DTMDF8hpMShlAkhZeW80Hl0Jd/fnQiatsL27J9cCz9dj
	7Co9yeIo1XJsxxrNUL7p3oqm2NpGJO0wPCC+6o0MF5w1BXkDbgVovDdbp0wJYADrX3z6lSb3pWSl3
	o2ccyuiQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJClP-000000093tk-1UpV;
	Wed, 12 Nov 2025 15:28:03 +0000
Date: Wed, 12 Nov 2025 07:28:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Cc: cem@kernel.org, djwong@kernel.org, chandanbabu@kernel.org,
	bfoster@redhat.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: ensure log recovery buffer is resized to avoid OOB
Message-ID: <aRSng1I6l1f7l7EB@infradead.org>
References: <20251112141032.2000891-3-rpthibeault@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112141032.2000891-3-rpthibeault@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 12, 2025 at 09:10:34AM -0500, Raphael Pinsonneault-Thibeault wrote:
> Fix by removing the check for xlog_rec_header h_version, since the code
> is already within the if(xfs_has_logv2) path. The CRC checksum will
> reject the bad record anyway, this fix is to ensure we can read the
> entire buffer without an OOB.

Thanks for the fix and the very detailed commit message explaining
the logic.  I think this should work, but I suspect the better fix
would be to just reject the mount for

	h_size > XLOG_HEADER_CYCLE_SIZE && !XLOG_VERSION_2

because the larger h_size can't work for v1 logs, and the log stripe
unit adjustment is also a v2 feature, so it really should not have
been applied even accidentally in mkfs.

> Can xfs_has_logv2() and xlog_rec_header h_version ever disagree?

They should not, but I'm pretty sure if we give syzbot enough time
it'll craft an image doing that :)  So we better add sanity checks
for that now.

