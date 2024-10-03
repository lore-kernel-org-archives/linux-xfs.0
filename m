Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9D5823C3;
	Thu,  3 Oct 2024 14:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727966292; cv=none; b=TI3MgVyAhzSqzaxmppBhbKtUm2Ss6S6MUKfFAAqR7VWucRZcLzkht31hds0wdKrKtdRxvo9ba2+JkMnZDxG7uKEiy42Qh0fAwYZEBTLU/t9mjH0eatxYrOdstnIo0iWegqy1U1w47ihlcfbVDdfcWfAVWyBITzEIINhgI6sckgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727966292; c=relaxed/simple;
	bh=lhWlOBCRfSmBiUjwFkHMxKLLksC/uPH+iVW2o5pThtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LLURmJFJ3xt6F9tIf9yCLlecZIJmy14FoBQPomCmtuWDsXr0ksDhAh5GMMbPfPVL/PM3gdDKQpGnyn3cO6vGRAvVD31InbpVBA1m8SoBoQpJSdZXlYHY+dcEkMhD0u9CYkVpwcGjMYIWc+1Bc+d1Ol4nox6NoBKnKHRt88dCmRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HpVW7PGV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HpVW7PGV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M6eij6ZcJQ8Z2KhU4fdZW/ky5sE/ZHaX8QfqS+fWrgw=; b=HpVW7PGVKjKi1v5LIVI3Qu/vPM
	PcNEHJdJO86tzQqiXf+nanBAYiNyEq4xmwf7VxsZaGvg6qnF1Kdj7bgktunk9aDNz99xIpNpdCgZA
	Elk8iQanrD8+MYhBmgH+zeqKl4jXB8nm6jUMV/VQOY7foKQC1i7aBAYX4iVgFc945992i+XTMi5IT
	bcrLzIxkVtiS3sq3773Npb3yNskSIT5hoJJ284ANDsauu2mcRuPLWagJwgEr81xkN4zVZUyjaGSi4
	AQH5+zZ8fzId+WK4qeliYz3Abr1Oub0y4cUfUVFCZx6JJ5Un+393bbhlbo99Ulxv6Lqn7q6Kur4gK
	VZrT4rpQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1swMy3-00000009Q0H-0EgT;
	Thu, 03 Oct 2024 14:38:11 +0000
Date: Thu, 3 Oct 2024 07:38:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
	linux-kernel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>, dchinner@redhat.com,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: Re: [PATCH] xfs: Check for deallayed allocations before setting
 extsize
Message-ID: <Zv6sU5eF4OCPTzNH@infradead.org>
References: <20241003101207.205083-1-ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241003101207.205083-1-ojaswin@linux.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 03, 2024 at 03:42:07PM +0530, Ojaswin Mujoo wrote:
> Extsize is allowed to be set on files with no data in it. For this,
> we were checking if the files have extents but missed to check if
> delayed extents were present. This patch adds that check.
> 
> **Without the patch (SUCCEEDS)**
> 
> $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'

Can you add a testcase for this to xfstests?

> -	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
> +	if (S_ISREG(VFS_I(ip)->i_mode) &&
> +	    (ip->i_df.if_nextents || ip->i_delayed_blks) &&

We have two other copies of the

	ip->i_df.if_nextents || ip->i_delayed_blks

pattern to check if there is any data on the inode in xfs_inactive and
xfs_ioctl_setattr_xflags.  Maybe facto this into a documented helper?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

