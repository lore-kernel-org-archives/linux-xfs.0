Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8876C2B9A2
	for <linux-xfs@vger.kernel.org>; Fri,  1 Mar 2024 14:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709304542; cv=none; b=e282LHP31G6A0ulM6iNYNteoSOS2YmAqMObRpeh50V1+T8jWRtLUNsxob0yiXHwaFO5s5FtbNIPT9iwtdFx5GG3VyiH1ePgpUkMBhGXL0NwOuHaifqO3jYsceQ2NaG0MqF5ZM0i5Nk4mK9t90JG4Y/hcRU6PSk8tN+5NCRcUPIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709304542; c=relaxed/simple;
	bh=1+po7odG5bO1OTc9u2yM6r5z3JVr4zzGx8N6ctoCb1k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JJEQxt0a5Xt97nf1icVyB8HwGinIy8POvBqfGXMWWa71r9AspQN9FR1FxzsDPPRaWYXty1ccMHmPCHKB/FXhqMbG4O6bba/AI/sgegDPCKQsvJWy8UxBO6EQMz1xt74xYsxLpZNqoOPU2nadlBRm/C3AbvhBnvOSJaLyQbE15gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gqcdfvV/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gqcdfvV/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=xNjtCsoJ76cIf9qc7jyUU5Ca9xK3xOP0kZqOq1aN8qw=; b=gqcdfvV/zrenPe0c5Yfr+Udi17
	tWg5Sh+08yrhkjC9Oahgmtshb6oK4lbM3ETnPlXd3ppdIvrG1ukiTx/gJUYnX9sHIqQWLx3JGMPxt
	0OFurrlRhIJU+oZWtMfs3kmgQyEkQ63crI9o8hHpTxx6khHR+utUVHg6XPJ4Y5EVR8H5HHa0NONBU
	GaN3yF+G+M2v6f4wxn6A/66VF9m2HkOmhUSmL9h7rDomTCEpkjESqImfL9fiIjqWiZc/eXJtavgfB
	aPKujhP/Ec3Jj7FtKGZl68vsp0/0DaJecezEQSx2MsgYLFq67outYT81ECFEpKuA4+OUyr3ikQUbJ
	3QU2aU1A==;
Received: from [206.0.71.28] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rg4C2-00000000mrg-1JMz;
	Fri, 01 Mar 2024 14:48:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: don't use O_DIRECT in xfsdump for RT files v2
Date: Fri,  1 Mar 2024 07:48:45 -0700
Message-Id: <20240301144846.1147100-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

for reasons unknown to me xfsdump has been using O_DIRECT for files on
the RT subvolume since day 1.  But on 4k file system this causes writes
to fail due to alignment problem, which shows up in xfstests xfs/060.

This removes the O_DIRET flag and treats RT files like files on the
data device and thus fixes the test failure.

Changes since v1:
 - also remove the dio alignment code and fix xfs/059 in addition to
   xfs/060
