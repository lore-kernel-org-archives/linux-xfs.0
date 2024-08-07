Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F4A80BF8
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 14:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042759; cv=none; b=UNIucmbrBTBsCO6LUNkEb37XOeA5x3IeOgJACkyZDYHtbIzDJWBJ1eRH4Qqqgp7tqGLcP8s8mlyLgEYC1VwN0STo2WpKviDfFzwlQIgXtIwId2uQaTvQhYvPPs+QoPwNKw7pOqecfL1niq42RVh+fQ45wAkbSp0VZcAwlg8Koww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042759; c=relaxed/simple;
	bh=vsVTfNxrvQMOc8mV55O0i9CaQNgunrBpSZQmDnkSYf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jT3omvAgpLNkTqPU3vWg4MON0Z8drtFWb32z7S+HH2RREwkhFkjQZTRBaEE+LF7kQl920M2ScBI5dBz21XM73cf0hHtY8EbCLQKn7N4tpt0FcO3A7Ev6NToAZGHQ0wVTE6QtidyCqb+1IgsZ1JisvL/qMlE/ZyJQoTx+XQiagFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ayTGy5YX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ayTGy5YX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBBAC32781;
	Wed,  7 Aug 2024 14:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723042759;
	bh=vsVTfNxrvQMOc8mV55O0i9CaQNgunrBpSZQmDnkSYf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ayTGy5YXV0jHg5MeWtkZy8QmMsWbgmdg7EN0rhfVaSxUIPVZlQ6sB96QLl4EzB7u2
	 +jDJaGd6DDSoS60DjJAnhDVqcZ+WqVH2x05PWFzKkHqeptiH54m+BvXC8WnS1udCz3
	 GwLBxM04nXSo9LPS0xkM8Kb66L+/DkyQ1bq18hE14RXhs2iXuSzclcuQ0maRzdPzNf
	 pIe72zpSiZoGYohoFZAf4T4gmV0na+bOaCXkIJSUuTOovqDnGgDWUWBj2dHRJo9dpI
	 6wybpAHrj0br6zOA2W1chY//mvC2MY5PeiObAIKMRQ8B2HC77qpy5dBR5Q3JWjzfCf
	 qeNUC3EAaPcOw==
Date: Wed, 7 Aug 2024 07:59:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: don't bother returning errors from
 xfs_file_release
Message-ID: <20240807145918.GD6051@frogsfrogsfrogs>
References: <20240623053532.857496-1-hch@lst.de>
 <20240623053532.857496-5-hch@lst.de>
 <20240624153951.GH3058325@frogsfrogsfrogs>
 <20240624155124.GB14874@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624155124.GB14874@lst.de>

On Mon, Jun 24, 2024 at 05:51:24PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 24, 2024 at 08:39:51AM -0700, Darrick J. Wong wrote:
> > > +/*
> > > + * Don't bother propagating errors.  We're just doing cleanup, and the caller
> > > + * ignores the return value anyway.
> > 
> > Shouldn't we drop the int return from the function declaration, then?
> > 
> > (Is that also a cleanup that's you're working on?)
> 
> We can't drop it without changing the f_ops->release signature and
> updates to the many instance of it.  That would still be worthwhile
> project, but it's something for someone who is better at scripting
> than me.

Yeahhhhh... at this point it's a giant treewide change that just doesn't
seem worth it.  Maybe save it for someone who wants to make a subtle but
important behavior change and needs a type signature change to stand in
as an idiot light for out of tree modules. :P

Anyway I think this is fine, let's merge this series
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D
