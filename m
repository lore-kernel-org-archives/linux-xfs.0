Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE16500978;
	Thu,  8 Jan 2026 16:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767889107; cv=none; b=tn964MtWbQfHMBcbxiJB1UppOrKbnWwIp6zJKbCy9YbyHfy0l91tn5q6AsiOU9Iy3HBnbaeXZtI7DtB0+xHaedC8/yhSKQlUuBhNnjbMZP7o5h5xakQ6pxS656972PMnqgK2nOrkpnwOqVle1SxOERlrCXREZfI/4DPibQm+JTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767889107; c=relaxed/simple;
	bh=XLX7xUN0STtbaswLUVy039LSW+Xs+KrNDznhT2Gm/LE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CwXOZzVb7s/TrNZBGHZXOKF92ZqLIUaA0mZpLs88oFt7Qyz+9+WCTBU4Fl6fFQZQxJKNLpV3ZraDHQs3dfAAKFC2buldRojtY+dZ33/s/l/yU+4tGhavYjbb8EMRoD5RUpQhwgxRMTqpxk0VCR5HlmWPrkLH+xZcsxRdQq2/EXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SJriC9jz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SJriC9jz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XLX7xUN0STtbaswLUVy039LSW+Xs+KrNDznhT2Gm/LE=; b=SJriC9jzmAEyoQHXhBAaTIod9v
	Gx9TssvUCmxE/7WjJwNN9doDj3fAoYqK1ulQilPBZ6w5nCZj22FTGsF4d290gDlDp9smu1dM9rttB
	VJgdKO/QbjRBSHnI2v2IXUYtLdgz8KhR9NJzgO9W/nnNNWusp2RgdeQSLGuJ6n61X7qnCaD3LpMlK
	SE5W1LDTl60v1z09qWZzyLc7mo7MXEYP+HEkx1y28KdCufSnrw0QT2tNcBS984n64yQA/xg/n/6KG
	nD93WEtXRCs/3LaMqr+6l9XVqMSd+6fA6ksclBsW3snifSk3qd19CTgTiOvQaFgqlm2y538s+BrGq
	RmZpRBkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdsiL-000000005sP-1Ifs;
	Thu, 08 Jan 2026 16:18:21 +0000
Date: Thu, 8 Jan 2026 08:18:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
	hch@infradead.org, david@fromorbit.com, zlang@redhat.com
Subject: Re: [PATCH v6] xfs: test reproducible builds
Message-ID: <aV_YzYuVGr5iA1nw@infradead.org>
References: <20260108142222.37304-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108142222.37304-1-luca.dimaio1@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Still looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

