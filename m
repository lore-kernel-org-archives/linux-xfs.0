Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD8B383984;
	Tue, 29 Sep 2026 05:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790658479; cv=none; b=pKOWwEG1jRtYXkz7OSiKFFwlTm5gCUxbbUgkN1OaRqxJYZrJ+kHov2xZgf1M+znNjjDDlFYg8v/YLnS8m7pnhf6yL5VK9q9GaLyOB/7JlxnS/JK/KSSJyAZB4BBS5RE0GPFiDp7888gQRTLjuU+rLCKbS0dHyoU1+BmlemQwKwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790658479; c=relaxed/simple;
	bh=zVdfo8ZneJrRJ94k14YIO1Y9VXCvy8Lfs7ITB4fmUcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HZ8B9IGRQWtXgrN/vuWVGoO0nrV+6Ybyx27OY4oxs1opuCBTfmEOrj649CwEJfTyj+kzVcsl1ZyzG8XLdqymgB9Z/NTzry2STdJdmsPfjylnq2UEYtk5VxKqURuCcDJ0NWAd95EDWcHf0JayJe3x84+EQRGNCkQKIiEI7+eCkns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Vt8Wl6v9; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Vt8Wl6v9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ql48WTI1DDC42vkQ5aONYMMkjcdFwpalboLPZ35vz1E=; b=Vt8Wl6v9GXqlPdcfnYCxm8QiYp
	IjYDbFvkRSA9EwCbUBHheJvuYZdpImQ8ElWTyxGfzBNWSOW2pO6W+4J4Y1tks26kT+/1ZOyOUbTV2
	LxknNqO7/ieWoGqNfhU/6OiIm+u03J7GX8QRDAzb//I2WHU4oI0/7on5fhJYoFcx/TY3YdWmGFgOj
	4/WzgK4OYYFLnJJZ1H6/D8CD8OvFCYz5m/CT5EO8CcQq6t3LkWaAWZ3HXS+H7Eiz8dY3BcMEfr7b2
	xJxllWNFBc/BuTHZelPBr7MOyE8q5XDulXQDCXIxkADODbw48afqLDdAfkvjLTsbKv4uPDjyQv6ee
	sAjeP0QA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xBQ43-00000002j2z-3GyS;
	Tue, 29 Sep 2026 05:07:40 +0000
Date: Tue, 29 Sep 2026 06:07:39 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: NeilBrown <neil@brown.name>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jan Harkes <jaharkes@cs.cmu.edu>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-um@lists.infradead.org, codalist@coda.cs.cmu.edu,
	coda@cs.cmu.edu, linux-mm@kvack.org, ntfs@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] configfs: remove d_add() calls before
 configfs_attach_group()
Message-ID: <20260929050739.GB3909609@ZenIV>
References: <20260929034158.1455429-1-neilb@ownmail.net>
 <20260929034158.1455429-5-neilb@ownmail.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929034158.1455429-5-neilb@ownmail.net>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Sep 29, 2026 at 01:36:04PM +1000, NeilBrown wrote:
> From: NeilBrown <neil@brown.name>
> 
> These d_add() calls cannot be necessary.  The inode given is NULL so all
> they do is attach the dentry to the hash table.
> 
> If configfs_attach_group() fails, then d_drop() is called so the dentry
> will be detached.
> If configfs_attach_group() succeeds, then
>  configfs_attach_group -> configfs_attach_item ->configfs_create_dir
> must have succeeded, so d_instantiate() will have been called and the
> dentry hashed there.

Neither in mainline, nor in -next...

d_add() _is_ wrong there, but this is not the right solution.  What
we really ought to do is build the subtree first, then either dissolve
it (without any pathname resolution having ever seen it) or move it
in place once we are sure that everything worked.
