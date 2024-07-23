Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187AC17E;
	Tue, 23 Jul 2024 00:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721692845; cv=none; b=BanUscUahvj3grspGJGP7mtravtxgpthCUZ3gzSvPh59a/B5AEZA3ELpAVpOrrYnALnnFFvBJv++D6y/Jc86q/EdbwfjW2Ub3f39YiRL74YYUbT6AJ2BS/ljLDKhWFYtaQXISHn2q8XyJwe93cWzDWx/qdT3aw8ZQw3C006gV5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721692845; c=relaxed/simple;
	bh=OWX51z58qgfwnin29Yn7MyfQ5++aw9avHBXiVsXHL7I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DptksvkJ1CruRTe2XSveYCq7y53Iw76rPfd41dJS9XDq/+2R7hBiRh+RwjT3DLVIEtS0WCrX2kVr/GdYm4ItT9UQpBp99qFrptOJ8TVA/blnUVFcgsrPZpDwHaznVv0LB3pxImwOmUO0ow1Y5M5evmnhGwQwAR+5/UMB00iH12Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jdML05t0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jdML05t0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Li5TW48AyPI5gULzcTd/5FHKJ3Z1cLQvXoAp0k6TcPY=; b=jdML05t0x8EULmO8XhBI91h7/y
	zKpJZH+Ldb8rc1yfzYFSZk1hF/RDui/q7SeLZnwLqx8OUYM+HA8Xr0N2GT2U7b1JZf/v5YstBaVGT
	cpJvSQwTHZyDALAeX0v9NG8t11VWO5Uiiu5cyp33b9jdphBkQ+kbNXldsTbj9OawQ0Vf7EGlIa4ZN
	6DHAZbCM3F75LQZe7AHZgjtj/ssz3B0av3SFJKAZzkVv6aOOdpJw4/KwNlklmIY8DmVf9SaUTa0K1
	m+iWZHCu8/kbPXNzKFNZedZHcB1vXiVuMG0HlX+pADbgFqVzLywbG++uC1llNAvHmV4/sQC1YH/6J
	PPzJoBng==;
Received: from [64.141.80.140] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sW2xP-0000000AumW-0L8j;
	Tue, 23 Jul 2024 00:00:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: RFC: don't fail tests when mkfs options collide
Date: Mon, 22 Jul 2024 17:00:31 -0700
Message-ID: <20240723000042.240981-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

I've been running some tests with forced large log sizes, and forced
sector sizes, and get a fair amount of failures because these options
collide with options forced by the tests themselves.  The series here was
my attempt to fix this by not failing the tests in this case but _notrun
them and print the options that caused them to fail.

While writing up this cover letter I realized that the scratch fs options
are much deeper mess than that, so this approach might not be what we
actually want, but I though to send it out for comments anyway.

So what could we do instead?  We might distinguish better between tests
that just want to create a scratch file system with $MKFS_OPTIONS from
the xfstests config, and those (file system specific ones) that want
to force very specific file system configurations.  How do we get
there?

A first step might be to split up _scratch_mkfs into a plain
_scratch_mkfs that never takes any options, and a _scratch_mkfs_opts that
takes options.  The former should never fail as that would be a grave
error rendering all $SCRATCH_DEV based tests useless. The latter can and
should _notrun when the options conflict, or they might be able to do
some limited filtering to reduce the amount of conflict, but I suspect
that is kinda futile.

Last but not least we should probably kill the separate _scratch_mkfs_xfs
(and _scratch_mkfs_ext4) which is used rather inconsistently.
