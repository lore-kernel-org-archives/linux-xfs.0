Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B420318C332;
	Wed, 22 Jul 2026 12:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724582; cv=none; b=Bnoz10XtY9N4cT8I22Y+M3AM1R+cVJca1tEFIOMDfy2U6g0V1O6t7kON3J+7dDC0orNzCeACdZrNR33U9hxwYHK0MkCrpNXhuyoSVsQwGkOPhq4rMejtIHPwbZBZWK6K14BKrBAiIexw24ZBUQQkbJD60KeieNHTMIfci/vi5s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724582; c=relaxed/simple;
	bh=KxuPW6ocnhT9X9KgOpZjKdjfX7pt9TE/ueWXuS7lMFo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dh1/T0/jpwUVipVmT7CdqNIFnBOG0biD/54WdtNwTY5XEDBpQi8bagMfuf206kQkzQeemkNUHfGOuj5giXIPLOd7yES0Np9V/c3mto1k0YpU6aYtBp6NVCqxfrLn4FDno5BiCXuckpagLaY28fIx3/yw3lzPd0rjvAbr3xc6HhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mBZa6Y7q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mBZa6Y7q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=hhnsgT55aSjD2tWAgV6YRYhs1/v8T24nSAFKRkx6zzc=; b=mBZa6Y7qRVbNLlADGzq41sT+yD
	3wCuP7J9TfIHbs84BGyqr1iHBLpAcoiuS4V8GeA0V9bd+B2UpU8v1W21T0ZXxQASVRuwbgJiADiNA
	1YE5WJk8I8sGJC4VzAt8fNKcs+14GNIaQ4grwDUQeP03zgAlgxpZ5W4eoaG2lVX9rDe6FWbByvUg7
	t7DhzV/3AMfSMQztO0p8D8WsRpaPeQe1nk6EO7cdrg1uyStTZZcraSZbsKnxvcHDb41Aic5eM+wk4
	tWiApDAVNIMGk8mh0oWsAsBFuHnrGFXQB9dltmbaV2UJVk8Jw5UC49WDpPGSxoYljLfeo4ho4E/IB
	oJSgALwA==;
Received: from [2001:4bb8:2d6:3a78:eb21:714c:af4c:ee7d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmWOF-0000000Bnbc-2W9j;
	Wed, 22 Jul 2026 12:49:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: changfengnan@bytedance.com,
	Joanne Koong <joannelkoong@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Carlos Maiolino <cem@kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: decouple simple direct I/O reads from iomap_dio_rw
Date: Wed, 22 Jul 2026 14:49:25 +0200
Message-ID: <20260722124931.3159664-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series reworks how the iomap simple dio read fast path is called and
decouples it from the generic iomap_dio_rw and the iomap iter.  This is
to make the iomap_iter_next transition easier and cleaner.  It slots in
after the first patch from Joanne's

[PATCH v3 00/20] iomap: convert to in-iter iomap_next() model

series, and the first patch from that is included as the first patch
here unmodified as reference.  If the approach looks good to everyone,
I'd suggest to include it in the next spin of that series.
