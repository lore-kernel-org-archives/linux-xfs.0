Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EB929A2
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897315; cv=none; b=iv/S/pMI163p12/ItwPoZBiMHNofeHDZhVFuGWviJ5eH2q3Ea+pxyEFzkhKYYd0tx4yloo+QmPRV6CEWfwpWMJbNCXtMgzS0z52lpRziALjdQrcMw4/LvkHssF0UyTofbfCuP+zVUXb+2ig/Eaca7dW/pdOg4Dx9Inj3D8RJ+Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897315; c=relaxed/simple;
	bh=Rr2XZUvCJlVC2eFlzoQdq2Y5Ymops0K7e8+QfURIwCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hSlSfHq+1FB8TxsCPc4mj2WkaVcUw7eWah5XwGJanZz+aAS0/Y03mIqKiNt0DjvFouclzHu00/uoAH35ucdrfHhdDcjfbjI3jZDVWRKj1tRWYfRhXLdK62XpT3irluDsSP8H01FzQOH5IvJfGyFfk8lJMGnXtNnAkSA4lnuvamo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E25DD68B05; Tue,  2 Jul 2024 07:15:10 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:15:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 09/12] xfs_io: create exchangerange command to test
 file range exchange ioctl
Message-ID: <20240702051510.GI22284@lst.de>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs> <171988116847.2006519.4476289388418471452.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988116847.2006519.4476289388418471452.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 01, 2024 at 05:55:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a new xfs_Io command to make raw calls to the

s/xfs_Io/xfs_io/ ?

> +extern void		exchangerange_init(void);

No need for the extern.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
