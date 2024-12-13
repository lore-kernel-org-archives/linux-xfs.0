Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9088813DDAA
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734071319; cv=none; b=LCgcTj4mmxJ2Uw9sZhp/+cF3xqRgTuMI8E1FqzVDqeoLSAQMAIwnYbJNSNmWV86q1auS18HqYTypmQjHUInyYY7oF4mBI0rcxjlAHS8bssQUfFEgUQVwCbIG57EAxKdfXuMSIj3TTQQUQk2LVA3hJOvFC8R05QsJMr8fk3P0IYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734071319; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RTpwRFe+n3JuHk8UVVtIcEx9gehLABx6zZDo1mfRiRn6cBV5YkZhA2v8DAkmqumYy6pYoPpEw+MHdb+rKDvamSHlOuTzawoVEJJqSpph+SF6rnnshvo1GK/YXSbiuujs9jgsWlyenHxuwCXYZxi79cxBDs0ER8sokOsXz5kYFXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G069H+Uy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G069H+Uy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=G069H+UyzdqJ7UrPUvPwvl3jbG
	U1IzMTJ+mw9DygfH8hf+TxxKQ6BPxtCfsmhzZ4MqehcLAwfcq/xTtneHtB6ZF9B2GGROGVQIMZ4UC
	/eUV4mqyv3ch2DOoMUOMThIoVMz/hj0o4YX/2CGk32BzpyBJTrS0VeL8wLglSPrN6yyXRjQ9Ad1Rt
	ZLdO332iWbZHIGoC6FdQeZ/uUN9ojIT8XUbO4tVjcPPCHTYTRsuv1lu7Va2r/A86cAS12/9SopV7W
	x7ciX0nuMVxtAYJx4SeSUsHqNuH9Uzmeq/Vxc7B0ZVoaPyZxSW1VLnwZtJ3K69l+e3+x7pN69Os0V
	9d33E6xw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzAD-00000002rt7-0px5;
	Fri, 13 Dec 2024 06:28:37 +0000
Date: Thu, 12 Dec 2024 22:28:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/37] xfs: support recovering rmap intent items
 targetting realtime extents
Message-ID: <Z1vUFYJm7KEJfg89@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123469.1181370.12989413207120120911.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123469.1181370.12989413207120120911.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

