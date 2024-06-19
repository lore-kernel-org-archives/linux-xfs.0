Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6994A1D;
	Wed, 19 Jun 2024 06:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777649; cv=none; b=JQ7bOkG7h6MApy1HQ5HoNx75n1DGDtRAniHe/3Sc+4bqhi7PjheUeIZrNMdlPljWG2FUHTG2b1/YzpXqy3a9H2lpzkauJuoKCmN14B1LcrrZKGROPdWHGLEqrcqrwrXyIOw28eXyvMY+7RsfBlfkVwHUa8k5kpAeGSFxsT9T0SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777649; c=relaxed/simple;
	bh=tmcmXJLxBN0KqE/Qvcs3xa9fa4WfvF958FTylr68+Eo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ts33stp4+9fm5uSh884x1iaPwS1Xrh5hZ8FUnsvSQuZ+kOwFJFB22qP3rBYka1jGxd6hRlofvctkXO7ee9EBfMbUzQYtSbTS4WDLN53O/7mwXmpp9c9Z6vpxDYezAifbVs4Bfs3OAK9wLmsVimi0GxGwzrK/f47Whkknj61FqUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z+R6nV9L; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z+R6nV9L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kmkPJrn3ddsXHoE7Qh2ZqO3rX5yTnIzU9Efhr97/Thg=; b=Z+R6nV9LA44wBtvVLS+zeFFNzm
	LJlsEncWyDzQYxEu0rAwarGVHhsaz0mCIHsXi4LVQvzrwbc9GtQyOARNxkH7zfKTYH5Bo4VAGOhT2
	bENo5YU99c0hBIOxwlB6k+fhJtItPke1J39XEZ60aj9545ZlxmE6cNA9n4mY+S6bxxpWb45koJkBs
	LyugW/fUd5zYz7gozUjytB3Meg2u314bckobKdzJrHDDt1MbUF8hxHT8r1fw39BRigvs3uZGdAlpd
	ZLMGuCMarRRduuKcB0l7dWs2hh7DkiDSK5zsulwe/rKlsxQ50l2St1zW8Oo817k0UahAklyCnBws6
	MJc5T7GQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoa7-000000001XF-455w;
	Wed, 19 Jun 2024 06:14:07 +0000
Date: Tue, 18 Jun 2024 23:14:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
	catherine.hoang@oracle.com
Subject: Re: [PATCH 04/11] populate: create hardlinks for parent pointers
Message-ID: <ZnJ3L5eEz1iLmACd@infradead.org>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
 <171867145868.793846.6556224145030803204.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145868.793846.6556224145030803204.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 17, 2024 at 05:50:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create some hardlinked files so that we can exercise parent pointers.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/populate |   38 ++++++++++++++++++++++++++++++++++++++
>  src/popdir.pl   |   11 +++++++++++
>  2 files changed, 49 insertions(+)
> 
> 
> diff --git a/common/populate b/common/populate
> index 15f8055c2c..d80e78f386 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -464,6 +464,44 @@ _scratch_xfs_populate() {
> +
> +		# Create a couple of parent pointers
> +		__populate_create_dir "${SCRATCH_MNT}/PPTRS" 1 '' --hardlink --format "two_%d"

> +		__populate_create_dir "${SCRATCH_MNT}/PPTRS" ${nr} '' --hardlink --format "many%04d"

> +		__populate_create_dir "${SCRATCH_MNT}/PPTRS" ${nr} '' --hardlink --format "y%0254d"

> +			ln "${SCRATCH_MNT}/PPTRS/vlength" "${SCRATCH_MNT}/PPTRS/${fname}"

Can you break these lines to make the code a little easier to read?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
