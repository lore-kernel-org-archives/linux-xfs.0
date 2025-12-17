Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B043590D7;
	Wed, 17 Dec 2025 10:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966966; cv=none; b=lfAu87/dawDj+Jx1Gve9GCqHb1TI5/PufC4XtleEHBBMPqQkcACyT/HBJch7ZOHmzwTdv10fgR/2kRQitfjeg8UNQ2Ol45sHJcddBgpvZJCSvapriMP1G46DR6IwUWYB6aAwr5BROEHzqe+CJvB8Abn+y1HiOArdB5pE5ylz+AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966966; c=relaxed/simple;
	bh=2S7GwXTbTdXDk52t2DqlWlpY5EWylsBBw1/dJeF1IpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxgJzs7tmUXlGZ2ddqnmmOjts85hqa+ms7bEZhRH26Zqqjw+H6nSPPFDyjI05sdHKbL2xhy12WeQoplynzdBEKYknXh8SYeLUiFwrSvoijdfXI7RXnZlujuF83IL4VuLVAmQe2e+8CAGnmZfriRANWXsecYmZa4X8AE5EqdJxSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A4id2xxg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A4id2xxg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wGqEpqPRPF7cDvkClG0aPFQ9WZwyRMe4EuYdkYsdS6o=; b=A4id2xxg8NePUizjzUCYe2L1b6
	tXk0BHDaWCSxwuMdY3AqgKlwBMbSvJJkSkw48cNp8xFGIOfkQm0LDTvMHbcWbIArazp9LWOfhDqtS
	YgPtbL87Ft8e3Z5Vl56HJnwUnSyG2BVhmGROs47aSt2ix0zZfSpcVYpPQR+oJiNHei4lKtrwQdbo0
	is0tK61oIeY69RnrbJZhAKMns9VLv2dxB/MXDHXCvZiTTs8nOFB8CZVB3OEKsJqrF9vVevxGdl4X6
	RrHVIhwgGOHMX601b/3+CCB8K92R7L05bN8WYBsuJ8g6/5npgdP4RfFumEDFNMWTneixRrmZ07kF/
	rinlvdhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVog7-00000006dN8-03Cb;
	Wed, 17 Dec 2025 10:22:43 +0000
Date: Wed, 17 Dec 2025 02:22:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] common/rc: fix _xfs_is_realtime_file for internal rt
 devices
Message-ID: <aUKEcqYKliEhcAtT@infradead.org>
References: <176590971706.3745129.3551344923809888340.stgit@frogsfrogsfrogs>
 <176590971755.3745129.1885534255261064844.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176590971755.3745129.1885534255261064844.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 16, 2025 at 10:29:41AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we can have internal realtime devices, it's possible to have a
> realtime filesystem without setting USE_EXTERNAL=yes or SCRATCH_RTDEV.
> Use the existing _xfs_has_feature helper to figure out if the given path
> points to a filesystem with an online realtime volume.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

