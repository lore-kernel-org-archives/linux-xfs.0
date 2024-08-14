Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2743F365;
	Wed, 14 Aug 2024 04:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723611156; cv=none; b=TTThf8D2TPAT+Fjomve5xAJHD6xYfO6rlCL+m975z73eBjUizMJNcR+60jUR4WtGRLF4VZJ/AA6N68FA7xA9x61zVXvwqhL2sP8X6DOEkqjFrWLS+KnOZCikxCx+1XcUERTjxlnSQrsSHdiMe3sH1ykQ7foYuv+FBvGMXJzMIrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723611156; c=relaxed/simple;
	bh=/0pt+nXMS5xLTRbiC8M+LNVYsggXXcTezJjYD4VZODI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hsc/omhL+lY5fwOYAbM8lJE0k1A+IwUf0B0Aiz+wEYKRfiToOjP4Scvi/KD+lqU5EZjfOUalCX2WXqSLQcS1kDNoXPgeSUP83n3cMyRS8gFRD2pAnKl23OL58pdiD7mwt/BcdV7QFMsO/G1GtZ6gUG1ytJUOePAUgUMdKOhjbBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Fnxr2ARu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fnxr2ARu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=/0pt+nXMS5xLTRbiC8M+LNVYsggXXcTezJjYD4VZODI=; b=Fnxr2ARuUvyYiUkSkE56CCk2KK
	yWihar5w6LIqS+kwY0gcvOEf6exPspW68Qrpw5jz43LjuBqgoD3Y7KsOCHM6rZoOm/DfJ10dGSIz4
	6i5aZdIMeynuAESjuhoj2leEPf6BzTzI+3oQynN8L3gTuDeHJHLc9Tg0yF9FD9pu0CZ07dqFVnOaI
	i242lSgUnbV4HWXMs4eZk7kMoe/NU8eWmaIftJl+V5nrOcYddiQVczX53KxVb1/eI+JCfVy9fjfmP
	4VPHR5r6Mr6x4GKbN2Pjhv//U3e80W2XhHz2LOKnC/VaTfNOxCucUfittZno4TsVRRt09nJ7MvsD4
	l6fiHOGA==;
Received: from 2a02-8389-2341-5b80-fd16-64b9-63e2-2d30.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:fd16:64b9:63e2:2d30] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1se5zu-00000005jKD-1dEa;
	Wed, 14 Aug 2024 04:52:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: improve minalign handling v2
Date: Wed, 14 Aug 2024 06:52:09 +0200
Message-ID: <20240814045232.21189-1-hch@lst.de>
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

this series improves how xfstests detects minimum direct I/O alignment
by adding a C utility that checks the kernel provided value in statx
before falling back to the existing strategy.

Changes since v1:
 - add a comment about the namespace swizzling in statx.h
 - spell a function name correctly
 - update .gitignore
