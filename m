Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BA61DF979
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 09:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745398882; cv=none; b=PwDAVJd/2UuErCvDzkHoyM7PfFX/FKWi5VY1lrNSqr/GFD7Zs0VQl5uNr6ZGO8OUsYmu5xUGEo0c06WnBzv5bQgEZo1CX+xamCnIXzF0GkQqIUoUqjqOADsiMGwOqkM8LjqukpmkEBZbrmHA6KK7EcWK144bYrpZVuUp47XlN78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745398882; c=relaxed/simple;
	bh=z97l22zQKlX2GkgKZ/tF8ubhXh8GhHEIgMC7P/ElZCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kU4woPSzZOsqV/zoNQJ5gewHTWoIxDlNU31Zx9YBbSYFClplpk2dQQCOhujBxVTF7zm1zOeyGKDq72+R4Dy/eJQCk1nkqrKrKmXwKj43iRm0Qe5WhnvtevSpwOqds7L3OyyFQ41D3ES6VKwfdedcE/Tx9tfeM3e2ov5alP3ZbdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jxnf+zSZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jxnf+zSZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y4cx9GriXaPmsA6y3SB1mZBCnNiRz/r7gV/Eow0voSM=; b=jxnf+zSZZfrSZMV+fBVHggb/Dw
	sRoiFeZ/bclq1w1xTdst4rIO/QOUz2/VepyJzsU2zhYkHQrLE2G3qP4kUp8XAGA9a2sC0RKY+Tpkd
	hN4pTUDk7K8qHxQkmVoGLsSR818JWBfJxoNppXJWRjeAmq8pcvCwEnqoNtNKnyKtZatF13UqFYeZ2
	/q+WxMpl8nRVvCqE4/AG4JtUbuUZqg4ZWUDL5ooNzTwVb0O5VB2dJn95tqoW4vY1U5U/YL65prasK
	5688ARrc+BX1xsgMkqnNTU+WoQm93G58YsQInuovYEbn6c3+ik4H5bpQUI45ye1PD+RxScE1jWLhX
	Uc0T9Z3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u7Vyq-00000009rAa-20jo;
	Wed, 23 Apr 2025 09:01:20 +0000
Date: Wed, 23 Apr 2025 02:01:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, djwong@kernel.org
Subject: Re: [PATCH v4 4/4] populate: add ability to populate a filesystem
 from a directory
Message-ID: <aAisYB7CiQ6Lyp-J@infradead.org>
References: <20250423082246.572483-1-luca.dimaio1@gmail.com>
 <20250423082246.572483-5-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423082246.572483-5-luca.dimaio1@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Ah, this is the new code.

Please reorder it to before wiring it up in mkfs, or even better just
merge the two patches as that makes reviewing easier.

> +++ b/mkfs/populate.c
> @@ -0,0 +1,287 @@
> 

Please add the SPDX license identifier and your or your employers
copyright (whoever has the right to it) here.

> +static void fail(char *msg, int i)
> +{
> +	fprintf(stderr, "%s: %s [%d - %s]\n", progname, msg, i, strerror(i));

This needs the _() treatment for localization.

> +static void writetimestamps(struct xfs_inode *ip, struct stat statbuf)
> +{
> +	struct timespec64 ts;
> +
> +	/* Copy timestamps from source file to destination inode.
> +	*  In order to not be influenced by our own access timestamp,

The usual kernel and xfprogs style for multi-line comments is:

	/*
	 * Copy timestamps from source file to destination inode.
	 * ..
	 */`

> +static void create_file(xfs_mount_t *mp, struct xfs_inode *pip,

We're (way too slowly) phasing out the use of typedefs for structs,
so the xfs_mount_t above should be struct xfs_mount.

> +	xfs_inode_t *ip;
> +	xfs_trans_t *tp;
> +	tp = getres(mp, 0);
> +	ppargs = newpptr(mp);

Similar for the xfs_inode_t and xfs_trans_t above and a few more later
in the patch.

Also please keep an empty line between delarations and the actual code
for clarity.


> +	// copy over timestamps

Please use /* */ style comments.

> +	if ((dir = opendir(cur_path)) == NULL) {
> +		fail(_("cannot open input dir"), 1);
> +	}

No need to use braces for single line statements.

> +	while ((entry = readdir(dir)) != NULL) {
> +		char link_target[PATH_MAX];
> +		char path[PATH_MAX];
> +		int error;
> +		int fd = -1;
> +		int flags;
> +		int majdev;
> +		int mindev;
> +		int mode;
> +		off_t len;

Can you factor this quite huge loop body into a helper function?

> index 0000000..e1b8587
> --- /dev/null
> +++ b/mkfs/populate.h
> @@ -0,0 +1,4 @@
> +#ifndef MKFS_POPULATE_H_
> +#define MKFS_POPULATE_H_

This also needs SPDX tag.

As you might have noticed this is really just nitpicking.  The actual
logic looks good to me.

