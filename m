Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AC3358A7
	for <linux-xfs@vger.kernel.org>; Sat, 27 Apr 2024 05:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714194250; cv=none; b=H4AdtgSC2cWXCWsET7CjimlCrS0slNJ3yISzRjatyjiMQAhZnO2qlW6dJhZcZxjF1l0idKt5Ma/15Mhp+vdMQGPkm00LWWwOeubGFu9y8wdfvYOz4TX/xCOJdw2kswE5EXxQj4Wq6A2HfTYODV1BQvKUK86tBHDgaZjI7Q2PdMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714194250; c=relaxed/simple;
	bh=XhNqmqbR3OJ5b1rZhTCB1WRDuXDl0I+cd8UytoSyAOo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aKipyFHbt6rSoDtxPwdZ4vevdsvbkkKme9V1X1J4rGRPxBuGn3It5qGmdEgff2cbuptFdRJ2s5hwIHlgnxBqYR0A22ViOrwNi7YIRoe/UkB15JLns/+jNjSW7fAJwsjpyekW2HO4CBAjLdM21NUweS35+6f9fZdwEFX6HPhC71A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MKfVzfHb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MKfVzfHb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=nZ5waDSyWE7qMvkP++qVMTJL1cLtEUbDJWl7kyhg6hw=; b=MKfVzfHb3DZ+9mC8+IOlu29DM3
	E4IsBLLoNPIPXuFjM/a9EOSn/cylR4fV5op32ys7uq859My8CNiOniairo+/9RsF/tODYXjEvG77C
	4z+ynaPbxNvvUOhHvCjREKUWsy+luCi/60vB7dnggXizNnbF0cIgA8XTzDWNLVl7e4z/865pUJhFR
	wRKm/3olFArFhu6VB8FEVEXRPDdb+sIpKwvIbMyffPqQE+UU/NGIjcoSBXFfqQQimBjS9nBVG4Pel
	h3H7j5YGrBE0BzzRgjJw0FkEXkpjh8/ndwxyQqUVA67uH1ojlhwI1Zs8kMFMT9gWfPFwiUHx+iskC
	8nYG2Vtw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s0aEG-0000000EqBJ-1F6Q;
	Sat, 27 Apr 2024 05:04:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: add higher level directory operations helpers v2
Date: Sat, 27 Apr 2024 07:03:55 +0200
Message-Id: <20240427050400.1126656-1-hch@lst.de>
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

with the scrub and online repair code we now duplicate the switching
between the directory format for directory operations in at least two
places for each operation, with the metadir code adding even more for
some of these operations.

This series adds _args helpers to consolidate this code, and then
refactors the checking for the directory format into a single well-defined
helper.

This is now based against the for-next branch in the xfs tree.

Changes since v1:
 - removed two stray whitespaces in the last patch

Diffstat:
 libxfs/xfs_dir2.c     |  274 +++++++++++++++++++++++---------------------------
 libxfs/xfs_dir2.h     |   17 ++-
 libxfs/xfs_exchmaps.c |    9 -
 scrub/dir.c           |    3 
 scrub/dir_repair.c    |   58 ----------
 scrub/readdir.c       |   59 +---------
 xfs_dir2_readdir.c    |   19 +--
 7 files changed, 168 insertions(+), 271 deletions(-)
