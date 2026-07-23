Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759013246EC;
	Thu, 23 Jul 2026 05:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784782939; cv=none; b=ddcbZi1I+T+4qoppPV4GvSN02eZm6R3RHIjiavQEqHMmaa+rvUDmJIen9eLC2LgKReC4DSlaihtbZhyu2dh78oNP0muAG3G+HkLuG3pMCE3g0WvXRzxZsQrJ0MdOOaMAD0yxwtfCcgEnfsdXIzKuyl4w40xpB7Ci03PrHOd3RuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784782939; c=relaxed/simple;
	bh=nWraj0gp/xXb8lEw234FjrN5OAf1a6am1dIKtLsXs40=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cZ2/QzdDEW3h2y15xB+JvqaIRxXFl0IJP7gtVtdLuKEdNtvTzdWdYGHO9Uxk2O0mA+2wZVpgQxfq0S6XhxJ2pNbJvOVDxTFoYIE6e4BEFuOLrRdyfUn72S531xAJUZ4bwjikq8IAgknZosSYfPqfrjKep/nQCYVy0enCJIgVxdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EmO2Xlyk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EmO2Xlyk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=KPMyo6JBv0CwjRZb+gM9rCBwMQZs+JDbptBRNsoPZ10=; b=EmO2XlykQVuTNMVn5docUkd+2P
	fi31j2uv6l+uuHSUUZIFnkw1zqz2LpTipcWeG3yTvhBZJ8fIKkCN4f4YezOYZ5N3rW+ywoDIekdq7
	SsAgSGsvNEb+pc1gh2mwdK/mdenU0kOyYxm2YX4JpZfd/KSGHokMHf/C+HUbAbALMy+2Llz6aPuOy
	vJcE9LbRcyLrDiSD2CqP+/JXelKacZf6tFQAh4hCaTNL9MUpY0jkLCjGlz/WOA+/z/OphJBCzmt1a
	h689OgUgE4F52D2znhpceDITuKl+ux1pGo3NAB2mX20OKeTCTp7yby/E4Kc9YQvQyB+o2114xO7Vw
	NMfrNKdw==;
Received: from 217-76-162-32.static.highway.a1.net ([217.76.162.32] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmlZU-0000000DRWq-0dXl;
	Thu, 23 Jul 2026 05:02:12 +0000
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
Subject: decouple simple direct I/O reads from iomap_dio_rw v2
Date: Thu, 23 Jul 2026 07:01:38 +0200
Message-ID: <20260723050201.3381045-1-hch@lst.de>
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

Changes since v1:
 - fix i_dio_count on synchronous errors
 - use read in the name also for the __-helper
