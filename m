Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0D7A48
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 04:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724819688; cv=none; b=TEYeVzmsO2ji07CoFi/OF154MCJZsXCfGl/JNlc4cr6YodBzmlrIORDMJqVlvW0pGldmrRQIQYZqoGGsw9ofEBmn0SgnfqWvf8ceom3gFIwjsxUJdM/SOjRxXa0LCogu95du+OvDtMTXXWzYZCHAUcPLJsnnY05xv9mouvO3HOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724819688; c=relaxed/simple;
	bh=1VEeNHWUb+LXKyhSgHLEox+Sp3USDPQlzSa3poXJDMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hTu0iZmo0v4yj9oTw+LimkQTsBJbS1WrJp7A+h2m6v5pckNXUT2DEPxNE7u+nv11WQFq7RwMCn6bwBcgJjxAD4Ykb2Jp1lbGKzz4Xwm5Ua9WTrEM1cQ8l5aRL2J0rL6qvYvmSkYJ7sS3fTWqhVIikHMmQrWjcf/+FK7aFON35gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DU21ey87; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DU21ey87"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tG4+FKRmAvwNtwPx6jFE8BjqT+YEjNb5B1Q/trdzmyY=; b=DU21ey87dag1KL6pAY2lI9Pm2R
	Rt0HypqWvzyEjebPInFgpRebZE0KiMpVKlfGd23jEzdunnm4ZBFkSJeoX/yjrjBKXLZ7dOgZJ76Jv
	9lygg4XokK3WQ4tev8dJHW/jVG0VBe58q0CfhSQ1whTXBRI4VFR1rRkpv8FiSZbEyZ6JtWqz9lg3y
	G3t0R+nzlEU/o5a7BNDRMe77V4TdPqDd78BY9Xfsq3AmnSJ0K6v4Gd8L0FZ1lnHsutBagFYVKo3t0
	J2WUptaGMjgZ2Ffhx2B6huVUo59vXozvaOMAyvm1J1++Zh8QE44oCSdJTRYVZTra6qzZgthXgSnMz
	3PQ2G7Og==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sjAOM-0000000DoIj-41Mf;
	Wed, 28 Aug 2024 04:34:46 +0000
Date: Tue, 27 Aug 2024 21:34:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
	hch@infradead.org
Subject: Re: [PATCH 1/3] libhandle: Remove libattr dependency
Message-ID: <Zs6o5q_zv1T3wPSw@infradead.org>
References: <20240827115032.406321-1-cem@kernel.org>
 <20240827115032.406321-2-cem@kernel.org>
 <20240827144112.GN865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827144112.GN865349@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 27, 2024 at 07:41:12AM -0700, Darrick J. Wong wrote:
> Hmm.  Here you're changing function signatures for a public library.
> attrlist_cursor and xfs_attrlist_cursor are the same object, but I
> wonder if this is going to cause downstream compilation errors for
> programs that include libattr but not xfs_fs.h?

Oh, I forgot that jdm.h is public.  Yes, this will cause the compiler
to complain, so we can't do that.

