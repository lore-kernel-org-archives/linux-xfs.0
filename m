Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38E3142E7C;
	Tue, 19 Nov 2024 05:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731995312; cv=none; b=B6ZffX99acExnOVvb1ueFfZg7Fx8B8vgqhMuOv5BjGvp85vYgpQam1dRnd22pIxxLmU+r8ZvE9br4P+J3+2uJU/fV/ssbRu7mWcVDSkAJtIW4N9lZD6icPTF0oGBfgf3c9iatn7jKb8oEYNPCbWzECZRaSJFMOTlAVqNHumKIOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731995312; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BemhXeYNyilnkvSjd6++ate2qZYm0Z2+DLJBORQLRWzvg74VbtSqBxEYaAeyfoRMbwtGTPNI8FlfDP9+JNlkha8m802knQzgxtHeZVAQf8/9Kwuh4sF8u4rt+TAiPK9PjEKBHEYxX86S5As2LA0kh2FwrjIblmDI4M5exBXiVYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R5NtGyH2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R5NtGyH2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=R5NtGyH2JJWcBSfqeuHabGOCgF
	q+Nbv8zWz7lispkH3i5ScLRlQ5byp3l+b2Jp7gGy8XKVLsp9tFPf3m9WFJTsXYQAl7saO8Eowkfiy
	gVAmD4lC9eKCI4pZCtlgng/T7M/VqP2cPehwhU/OeapsldFJ+Uw53fdKmMD2XDCxiHv1Yv16KdWzt
	RJ0/60YsIqptmVsEyF2ofSDjyzr+/nFVCnTVgM4OtILy1GnW1UIJnTskFgBW76nOmzcIggcBZLnxB
	28tsIaKwRCUblxqeeZccy5+DxB1EgLwD5e8ZdoivqT3V5B+mjh1DOBct9hj4nZdy0qH+mjoTIl2xW
	INjFqreQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDH6E-0000000BSK5-1siK;
	Tue, 19 Nov 2024 05:48:30 +0000
Date: Mon, 18 Nov 2024 21:48:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: fix null bno_hint handling in
 xfs_rtallocate_rtg
Message-ID: <ZzwmrmcGV8-6ohPY@infradead.org>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
 <173197084566.911325.17606647892449835782.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197084566.911325.17606647892449835782.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

