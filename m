Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CAD1D537
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 17:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711472782; cv=none; b=WvwmiT+FtsybnF+hd6T0qHY4ekGPNkDmrPOA6qz8qZKWEdknKrFnJoxlfKMm4IGvKR/VB3DWcvvkF5yCOL9j5uEhKKoA7Wvm4vOKhXsfYMSyGBrGfc9OUSzJj2oafSIPlolJCZGZTZGUNJNmglk/5LlEMl5aXEoJhGUnvz2TCRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711472782; c=relaxed/simple;
	bh=dnM6yEaV4u/Oh9M7M528vTnj3F0XflQMVljrPMdUWE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uzYhFXdiDSxzVwQ41i7fTc5kdRh1Qa9zvTScoQAsx7rBitkm6AtyDUfVHBtklIU68gDRcVoP9ljqNOdUbNf7DS4aetf7IKpMN3kg6SdVpCg2oHOKUa1BsC9ccXc9pKdn6nA5gzbAlwixk7ROHyBKjgcTj2F5zujccyG2NrOPfNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lYJpQAMM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lYJpQAMM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dnM6yEaV4u/Oh9M7M528vTnj3F0XflQMVljrPMdUWE0=; b=lYJpQAMM2FiBGFkKoKl2YxziCj
	pussrn5XnGbvWq0iTJYKO45/lIdliJoTnMfkOw7di11XivKKjVxyMD1Vk6RmyMZN8JMVn+GGI3iic
	RfD4vU+E4icC+X0Ahn0tlYYE1D0dPBD+plmUN7x9ou/QlkD905C96u1glE7eFVtigOCvwxv3klGMZ
	zciiH2Yj6a0LM7o9QGrYQJFDqtTd8OPDqztR4KJPL3XwfRwui/4XYZaiEtCpt3ktJrAsa3wuu0q4Z
	iioD/i5ULEWLq9PLK3H7l9QIzsAprq5swZV0hM8UxgvOuJVSZgI2u9KPsBr4Ft89ZKVDJUzsEpU+r
	sAjADICg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpAFg-00000005dVM-2GRB;
	Tue, 26 Mar 2024 17:06:20 +0000
Date: Tue, 26 Mar 2024 10:06:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 089/110] libxfs: add xfile support
Message-ID: <ZgMAjHZL2xb9aiYq@infradead.org>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
 <171142132661.2215168.16277962138780069112.stgit@frogsfrogsfrogs>
 <ZgJdSnLbTlY4ZW8s@infradead.org>
 <20240326164736.GK6390@frogsfrogsfrogs>
 <ZgL8lq4M7Q7oNJwS@infradead.org>
 <20240326165159.GM6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326165159.GM6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 26, 2024 at 09:51:59AM -0700, Darrick J. Wong wrote:
> <nod> I'll factor that in too:

With that my global rvb applies to this patch as well, thanks.

