Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FFD4A1D;
	Wed, 19 Jun 2024 06:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777564; cv=none; b=tOgq9lxwWjLWPQio0Gm+Dr9Crg42UADJe4sB4G2lVyFMlbQYCbMs8OkLir7cpksmywlpU7CQtSuZIaNx+fSwRxpnpijzT3PNlliUZVKM5lsRxBs3Ae1ABgZYzPemRq+NDJ7nCJojIC7KPBkq055BBupt/xY6zlLuFMYDtEOrsZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777564; c=relaxed/simple;
	bh=tMLwK0QFoMMprPjfdAaIZnu0I39nFB+Iw/pxNXCY2WQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F7G2av9GwdaNX+sLH7yF5aHSLqfjxk71jrdVYK31U4rwXvb36GYdlGQKiHD0dTx7QQtkH6k06zB+m1A292bbfPEXHoyqzIKj8+x7zmuApxN0CoMoMTEuP7Rh9WqDEO9VZITYP7W6F16RmHziHL7BvcX/bdJsiJqKexTN6H/Zpgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZTG4r0fq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZTG4r0fq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tMLwK0QFoMMprPjfdAaIZnu0I39nFB+Iw/pxNXCY2WQ=; b=ZTG4r0fqEO+dIIzQp3E4UuIiMF
	LvfMRetkXlfwghk/yeAsaO44ztBLZszfrG2APz+XL4gPxMaowim8oh754ehgKdatd3XB9M4nSnuX8
	ealQUl49T1cAnIg5EFpw8WObXyhfZvFTF0UyRmbAuNSdSn1dtoIKiH1yn3/eaofRQ7PoF8kiBfbII
	S3maYnm6EkznTEhqnY6C+jRWThicbkdn0xB0w3GyQKEolW7xb40V17XNAeoX0MRL7ysCm3F4hERn5
	fL2ArdGG4JNNAu9TM/WtxA67g1QJJKs2Fs3V/RUXq5yS+O0uTh0M+chkuHFyni4OI2tSABU9ML9be
	H9UNyeAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoYj-000000001PY-1lDZ;
	Wed, 19 Jun 2024 06:12:42 +0000
Date: Tue, 18 Jun 2024 23:12:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
	catherine.hoang@oracle.com
Subject: Re: [PATCH 02/11] xfs/206: filter out the parent= status from mkfs
Message-ID: <ZnJ22dOMic_HywRS@infradead.org>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
 <171867145837.793846.12125891588945951991.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145837.793846.12125891588945951991.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
