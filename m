Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EC254759
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 15:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721835385; cv=none; b=NKj+PGjT/BSH45e6fNl0T2sj6zxWi4WFR3+AAjBAtFAzg/GAfIYvsY8mS7y4s62RtIVF3LwKt2ZrhZ/vglofIRNbz+m42v/dsUqQJPVpLfQIambYlC0+RySc3W07HkXLcoS+lNDAbGg7OhHeWLeBmEjwGqiQmoLDKvmZLNnMfhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721835385; c=relaxed/simple;
	bh=HMf9MGgWSlZ4IVyjXB0crt97jxMPf/DkzcWq7/2jfJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdAbJo57igxuDlnUIcpTki+2Xq436/VAy91uaBuv/Fiho7kv6FA/BXw/TYRB/LOt56vtdWSx/I6m2FlUfHZcP0nwXZTbFRvHz9QqGy6n7Xa7TkB1CVldGCtCgew0OmboOeP42a07LZJJo0DhGRpkGWGHV6IGZfHezGjJ8p6irL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U3s4hkeN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U3s4hkeN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HMf9MGgWSlZ4IVyjXB0crt97jxMPf/DkzcWq7/2jfJg=; b=U3s4hkeNizWX8iyhblbt7KJpMN
	9GSg+A5lwxk1tnSZLrfmRL827ZmLcE8RcfS8KuPYgCkt5dR/GqQMuRYijBH8Br4cMqRp3KBlDuJv/
	tErfT2x7Tx1Mvro97QC8uwJqkOPBsTf/9DJ2ILyycPlIOCxzXTWYGHk9LxxZ00kONwlWZkbg8sQ79
	6N9gui34TPzCL1N3cgjO/wjgKdXejLb/aG+m8DYx+JNV9khSufk/wIkPgtUEM+ggACIl+RomhIt+3
	jknksZVAyW8IBIm8T6ldRg7mPvJdDAOD0c/74sJEBkhwR6hbPWt0KDxNO2iKG8NFb5BNghugOFV37
	ofsQVtbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sWe2R-0000000Fn4K-2Q57;
	Wed, 24 Jul 2024 15:36:23 +0000
Date: Wed, 24 Jul 2024 08:36:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix file_path handling in tracepoints
Message-ID: <ZqEfd8hJdKcjaDow@infradead.org>
References: <20240711054353.GM612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240711054353.GM612460@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

As the discussion didn't really conclude to anything too useful,
except for Steven finding other opportunities to improve the xfs
trace events I think we should go ahead with this:

Reviewed-by: Christoph Hellwig <hch@lst.de>

