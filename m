Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920A014EC46
	for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 12:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729599240; cv=none; b=gVccGVN5MTaeX+0PDfyDj7zr/vYpLUAs6UcBdnHwKu8EcKPHXNoODCStRD1BLchfTr4aTxQ+IdPd1yjlFU7ShpeiUQ6zS+Ol6oR5jMRoJkw7HOJvy2G0oDwE0hLI42LIXtr0HbDNeA1maNhlZzyThr0AOjkld6N5k0xSPF4bsEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729599240; c=relaxed/simple;
	bh=MekrsH7FxUREyqFJTt5498M+sComXJ6EPXJbXAIvLqc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g/lN2vnyWwS3KOlRyPoTtByNyRGFZxGmto+oMvvBqgXJtRn/cEq7nylqPUsnwv95wUyaBFJ9JflD88CcolpOJoLtszhIaPXf+ODf0M7CQYaAA+hFCVzn1njJyhBo+n9mkrff49SvxnTbKXBYYnI1CxE55KJBkUMLY2ESKlJ16FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BviLAwyJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BviLAwyJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=MekrsH7FxUREyqFJTt5498M+sComXJ6EPXJbXAIvLqc=; b=BviLAwyJJDGRppsZM28d2vEEOp
	6olI7IjXi61Dh7DckDrlT+30Exvjd64C1ayPa3PYqXWM6hhsFI2LFnfMclqeukovPprNVwX6CbMVI
	yeHi2gnxQvI0xebkyS96Opo18nuBX42qQ6WHQDpYd6eLiY+DEL2QBjunqRL31kV3YfJiW+/H7dnMJ
	iNd/UDW4KjOIxuNzF9dKGgxXqUG/Ng4GDW7irSPDtV0TMLg2Na7YDAxGZnOR236had/tdqrGaHUTW
	wo3CywQlSdDdIukcuD1s7cYe6fLClO0UV0u4TcDlHgfudeN54rBb1fuW8rLVj5US0oX3IwqX5RPfx
	F6Xgmm/w==;
Received: from 2a02-8389-2341-5b80-1159-405c-1641-8dd9.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1159:405c:1641:8dd9] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t3Dlt-0000000Ao1I-0UmI;
	Tue, 22 Oct 2024 12:13:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: filestreams syzbot fix
Date: Tue, 22 Oct 2024 14:13:36 +0200
Message-ID: <20241022121355.261836-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series fixes the recently reported crash exposed by syzbot in the
filestreams code.
