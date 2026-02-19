Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42177325728
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771483888; cv=none; b=rJIGfKCyWQaYj3iqgTYugmwtfDM9GqvMv7GzRcbin9/Fbc4na14N2lwdgz4Ed9XVi9nsHOGoXBti+mlSLDS092g5+pXQuc5l6TRp2C8vxl1XqyJtLqSRqc3Glv5m6QE8sQ22p2NkMtVGseD1Tv1sMBZJo2xwkuRALtAToMeWG4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771483888; c=relaxed/simple;
	bh=GKZuZ3xHU7r2Y05OfgYaeQNjNC490bq5i8Duf6RJ7ss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xt6/3ajCJZKYD0BQpr6oEIgDbAZxIlisxvauCD70+4EuaLjPlyuwVWk0dduFxkhMejDsYsv8wFB3tbtK92cRyDr6SVW3tN5D8nMvtgXbrin5noT1X+jk3pAVexOa7BDEZeD+mjZgHvVOp4Wc0kkfjtrH71FyNIPAMDo7RM5v1Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lVMeVIC0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lVMeVIC0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aVym7rjx88Q3KSMZJXKRsf7jQK9f0iE0KJspIUTulIg=; b=lVMeVIC0Xf4LPCvXAk2Iep0Qwc
	A0h1KehCxQ/QBNCV9OXE39EPUsqnc/Dk0YUibgyuz7aJVBtk2iIQjk7k0Kf0OsRkifimEor9uIE1H
	5x0h0lWjL9/dJxZOCdAxvt9C33bg9podgfJlO7H+WOvw1yIxVuAfI0U/5lX85AhLR8Pu1cjJbamdF
	7kI+NVj8VbUI00Xh2s5AHgQ70X3zVXPAnJtFGekZGQtF8XrnmVCOFZqFaN9fuVNHdstPuU0SuaULc
	DsAMFmIK2h+AMrhGK5EwQjP4TPPeVY+3lKxNeySvkrG/ayW592ymFuUtXGPp9MerUAX7ELY4xSi0Y
	/EPbJRIw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsxsf-0000000AzMI-19mf;
	Thu, 19 Feb 2026 06:51:21 +0000
Date: Wed, 18 Feb 2026 22:51:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, djwong@kernel.org,
	cem@kernel.org, linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com
Subject: Re: [PATCH v1 2/4] xfs: Update sb_frextents when lazy count is set
Message-ID: <aZay6Zub8PFPrQq1@infradead.org>
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
 <3621604ea26a7d7b70b637df7ce196e0aa07b3c4.1770904484.git.nirjhar.roy.lists@gmail.com>
 <aZVUEKzVBn5re9JG@infradead.org>
 <91050faaf76fc895bbda97689fd7446ad8d4f278.camel@gmail.com>
 <aZav-QE1L87CKq5L@infradead.org>
 <fd8be071-55ce-484d-872b-aaf5eeab1138@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd8be071-55ce-484d-872b-aaf5eeab1138@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 19, 2026 at 12:16:51PM +0530, Nirjhar Roy (IBM) wrote:
> Okay got it. So what you are saying is that, for rtgroup support, lazy
> counter is ALWAYS enabled and xfs_has_lazysbcount(mp) will always be true -
> so there is no need to keep the updation of sb_frextents inside the if()
> block. Right?

Yes.  And given that it confused you, maybe add a comment about that
for the next round:

	/*
	 * RT groups are only supported on v5 file systems, which always
	 * have lazy SB counters.
	 */

