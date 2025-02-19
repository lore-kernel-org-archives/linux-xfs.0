Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588A18BF8;
	Wed, 19 Feb 2025 05:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944206; cv=none; b=hnyKNkdqACuy9546mJUj2ZXgfRry6x8m/7LElAUdU7O02u8eKnuvC/IHsJjWuzgz08HYQ6DSu2xs0V/sxY0RZRxuHYe+IXtTTFBYNAO2ilJrLD88DH3XbeASSUQJ3q0a22sqTgRgdJmZJz3WuMJbrFtPQJhVMIpF7Lqe7ZSRZck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944206; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QQcJlEtcq0pnc2tIKdt3yn8JOUZDL0YArhMpUdiIJaIIc8SN3RPLWLUsZwsX0/+lKrMye5bpKxW1DiToERO9xzS0DMKTqXZduHcaRmK6lJ2H0/nE8O6nkexxGSBiaC4eOXaVvsyVU9yL2e/lQ55RyjZpmg2U5iMHvGmz0hXp/fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1zhxrSGC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1zhxrSGC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1zhxrSGCVWeYBqhEbGLuFvNK9k
	foNO3lrqik86k1KhDpF0VxQ0nm2ytcUs4hZdUr5+H6O3l13tWLrVOyXCfQMC5jlOajLfDCYXts5Qu
	vpuxOrLlPczf53oYISLK8seCQEYPzNImX4REN2U9UzLu90M/Bj3zSY/Cxz5935KU6v8vAKo1czgu7
	4A1gtIL7QNMLXvy1ojRi72USJBPREtISEpKdvjfd8Lzw2+FWhWlevgVD2O4KqOa8JQ/ALczuzswI2
	/KI6lfSnQgGDeE2G040l2pTqhNM8CqSXBZ12vhLRYekGSZfkM78R0TSUFxwUjp1O+wXWa8RoYFP6+
	kgO/cRYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkcyB-0000000AxBV-2lsd;
	Wed, 19 Feb 2025 05:50:03 +0000
Date: Tue, 18 Feb 2025 21:50:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] dio-writeback-race: fix missing mode in O_CREAT
Message-ID: <Z7VxCxw227lFm9TE@infradead.org>
References: <173992586604.4077946.15594107181131531344.stgit@frogsfrogsfrogs>
 <173992586628.4077946.5512645303623484204.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992586628.4077946.5512645303623484204.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
