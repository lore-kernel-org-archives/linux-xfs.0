Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638003E44E4
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 10:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783936879; cv=none; b=FTjuaYHQFN4TwCmezHOpE3VF2NqjSD440+GPkmyiH0EMCaLliW8AgI0pKSRn786q8JFZepxiA0QoxwElIDt35mxBH8yQsdlAqfbj8DQL/Ny9Wzhb3TXBb+8UYHOTHcwD/APmpipSIiyjmgAg+Zm1mEXeW4zP4fDorCaIDZTqz5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783936879; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cwW7AWISkpXeIErTTAQCy+VPJ0UJ9drn1NVRnUbJ6fFGzSCIO1hTMxrK4vyoRUlbitucQhkidf3ESL4g97CK0JnsCPcb1RggberXwUFNtgCt6rDjiK/mQbdGEHbJZ2gFFPrl9hvvN2qpltPeDDGteaY0kG/QolwU+Q+rgPGLz7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5A3FE68BFE; Mon, 13 Jul 2026 12:01:12 +0200 (CEST)
Date: Mon, 13 Jul 2026 12:01:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>, dgc@kernel.org,
	gost.dev@samsung.com, Zhang Yi <yi.zhang@huaweicloud.com>,
	pankaj.raghav@linux.dev, andres@anarazel.de,
	kundan.kumar@samsung.com, hch@lst.de, cem@kernel.org,
	hch@infradead.org
Subject: Re: [PATCH v9 1/2] xfs: add an allocation mode to
 xfs_alloc_file_space()
Message-ID: <20260713100111.GA10795@lst.de>
References: <20260706084117.1455204-1-p.raghav@samsung.com> <20260706084117.1455204-2-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706084117.1455204-2-p.raghav@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

