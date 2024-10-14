Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EC49474
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728893139; cv=none; b=pEtQJfpHmRFfA2fqLXtV8U9AS8R/JVBU0E7/6FATElVsXooknI9OvKE5zhicpLvf0VzTnt5C4bYlCygbazRa20WB4DCPvIVWMrsU3OsMGftm3ROxsGa4JVAfS9RdE0F96sSRtJpw0DobUpEPqTRKuZAh+uiNxsBuCfClfo4ZdCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728893139; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VW619FaVZh1/wlrQVduW/LVzdYNsdrQ3FvJyF/ab6jClm+i3qXQRVvvhf2z9FRCJ4YmQk9Hu4izaf8Y86YNfS4huJOjLc+X84JbWajZDmLtbNhaCdOXlvGQP6LaWnzNKUnI4Jy0Zet/+jfCAQB/s1q0HfuzNMngRsWIjPOcluwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i0XoGsZq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i0XoGsZq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=i0XoGsZq+cbnBbPMBJUgGYqaI8
	nQqEjKw+iCOr6SMcZjkWs6yrxL/8fHjoAc6AxlbHcXNmq2wDxh1PAzdoIM2QInleBugtnhdeHq/3m
	HG/mSYzm9B7+hTGjw9zla8zAM13Qe0gTrghW1TKVrhJasDjn6NsEljU3JJnWwjBjRPJV+6NDMZDTr
	Nkeb2NhQyeubBz6k++lj5/j/BPifZQlfBRE94PKgjzlN2J3YVjLr12WAYxo6CEWEstGintqMh36Ki
	340IVzeCOG2jzyLjY0FVHHKaF8rP5oqX+cti+iDP5z8K0K7V/vxrMhUzzNKrvN2+geqsc2mEotjvL
	yTu0zjPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0G5B-00000004CG1-26ne;
	Mon, 14 Oct 2024 08:05:37 +0000
Date: Mon, 14 Oct 2024 01:05:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/36] xfs: create helpers to deal with rounding
 xfs_filblks_t to rtx boundaries
Message-ID: <ZwzQ0cegT_QYsB6E@infradead.org>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644724.4178701.12176129713765329444.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860644724.4178701.12176129713765329444.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

