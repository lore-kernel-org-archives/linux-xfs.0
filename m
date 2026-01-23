Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D6430ACEE;
	Fri, 23 Jan 2026 12:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769170354; cv=none; b=XgjnEmvBpBrd+LCwoRQY8lFA3g3YyOayNuvfMfJWrAw3XO+BrXGb97vDtCVnNl7Q+jmmp+LMngQORw5SnMOpOnP5hXw/mywTEAhJioHvGtEXJtsAaZ6mKP5bzpRjRFLy7FcJdexgDPt4h2zowUG0g6Naf1WszuRgLdgHIzGVGs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769170354; c=relaxed/simple;
	bh=2PkYR9UHdcM082D5EGL+eh8dNzXnIjYg4vaNcq5QCmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xhhq8EnoJYim8GcrefHHPj/QstW0gMkAr5UuSK7bJZp2YbWazqnRhx/0x/gnDwCsAi6AVn0vfJHhBAxWLZMvhURQCHz/WAm5XPqZvPO9bs0ofi4axiFSZmiyLUpLaYp/252nyH3TjBwrboLsobV0k0DnLSCE2e12Vl/5q70rAUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qTHL4Pou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qTHL4Pou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173F8C19422;
	Fri, 23 Jan 2026 12:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769170353;
	bh=2PkYR9UHdcM082D5EGL+eh8dNzXnIjYg4vaNcq5QCmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qTHL4Poufr50hv0ZoquiVLbCF40danNymQHUU56GSwl2XLv+LALmZ/HXYvFpocKv4
	 k1h4Wlp9MnueK54p2CHrnc64EepZsrZ6nq5UI4NyQitG4zl8UJTbvfZxZqNs8nnH+l
	 8KDuh+ARtJZcGD4F+rC2sZN9yXrf5B99Da0A+JDeYSgC09c0A6zoLDC8rr2CrtA1qn
	 lwrLypBFq9b02SFhuBoWdQioaLqdVDKNzienquQWNEEXkX+8zBNoa7YfiZzgx7qUR5
	 Ktyf5wFqAMNda4SN5LdIy/sjiYeJ3if0pbo4cjELzzF6sow0yQjN6buJ3ckypJ9FZt
	 JqMMdi+HBlLjg==
Date: Fri, 23 Jan 2026 13:12:24 +0100
From: Christian Brauner <brauner@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, hirofumi@mail.parknet.co.jp, linkinjeon@kernel.org, 
	sj1557.seo@samsung.com, yuezhang.mo@sony.com, almaz.alexandrovich@paragon-software.com, 
	slava@dubeyko.com, glaubitz@physik.fu-berlin.de, frank.li@vivo.com, tytso@mit.edu, 
	adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, trondmy@kernel.org, anna@kernel.org, 
	jaegeuk@kernel.org, chao@kernel.org, hansg@kernel.org, senozhatsky@chromium.org, 
	Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH v6 00/16] Exposing case folding behavior
Message-ID: <20260123-zwirn-verfassen-c93175b7a1ee@brauner>
References: <20260120142439.1821554-1-cel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260120142439.1821554-1-cel@kernel.org>

> Series based on v6.19-rc5.

We're starting to cut it close even with the announced -rc8.
So my current preference would be to wait for the 7.1 merge window.
