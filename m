Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738BE192D7E;
	Wed, 19 Feb 2025 06:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945213; cv=none; b=E/03BZl0yKfHGjzAfOIyHsTLEf7SUNOtL0tiqw7DwvBLKI56h6ZnCVQR/vOHTKH5ggZxUwGgoH9hVElrzIao0yy8iMBdQL1FKr3a73nJgWEPyv8KrrGyzulKm9RlUE0RulAo1I9DkxBTpYxe73cdEI3qDBTx0gxRlZ7za0r9uV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945213; c=relaxed/simple;
	bh=I4hgUFiE1TLvG8jUuhOSHG2zt9jXIU1ju6tqs6nUvUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hjL2tRpLjWqJ6sF1qz3XGV25ZP+g8a213KeJlevCgjTtNMBxJ/dnkKD2jbhgL+mphsfai57FkpjSUj6az7IwdRYSMcVSJIYR8Ej/7bNV29ZVr3743wOm0vee+nxeuKD3vSNw7ftZ0yLVD8lIAxd7+WukRruuYYER9sovkKbN4zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=v+X2vHh4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v+X2vHh4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IC9/2vlqRM52tC7MntLVDsjTrhPUDBGKlnB9LhRzNZ8=; b=v+X2vHh4CFFzfpAkHZE0EN8i5z
	mcPFnj8BS8P6fCXozz7aVnqoNiKVTyfH14m3fQpa5epp1KKhPsDXRdXaFTD16Wucjs4Ln3g24uZUc
	YHX4Z8itLmFaOuebwf8fbOozHpMqd3sM06tyfzj+X6U7dXfElsBoreffN58mLbIkf6nhDUO6NUO0/
	K3V7V9EfLnDxBszgttKxGTyHhRINeKQOonLQw7VKUQu2zM1RNwu+7LX6O+TibOZEu9WPlhHkzIW0F
	nsseIL+fSXW+iYc0RdzV8/SmoOnB4Gl0sz7hReeSH/2UfnVDqG16McBVXNv51cQd/+al3XmiMwINI
	WiWZpZ2A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdES-0000000Azu8-0Rqq;
	Wed, 19 Feb 2025 06:06:52 +0000
Date: Tue, 18 Feb 2025 22:06:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 10/12] common/populate: label newly created xfs
 filesystems
Message-ID: <Z7V0_OpLi9ExRZUf@infradead.org>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
 <173992588245.4078751.18091181818919832636.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992588245.4078751.18091181818919832636.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 04:56:03PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we're creating fully populated filesystems, add an obviously weird
> label to the filesystem images so that it's obvious that it's a test
> filesystem.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

