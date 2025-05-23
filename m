Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48813225784
	for <linux-xfs@vger.kernel.org>; Fri, 23 May 2025 05:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747978313; cv=none; b=hmMk6U3H3bVuhT5q+cx2Qk4hSME1RQXFzfZmFcaTOSMJ34aM3jpV2LyPSuYIghWmSjahGbsLSMkjDLk2oa7rHt3BAOAMJFloIVaoJg2h/Hetb5+PNQDOTt+ghHaPkHeePlym6i29WMUrRq7Ibl1pyWOIKKY6FPX93Awi+FXdkFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747978313; c=relaxed/simple;
	bh=GXY5g+uqpFPHkLOZepns088SujfE6jlaDXytA6QARbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCja9LvKx/DVvo4INCzEPPCYEdhZr72XmJxuHo8mq4zQIXppx+ocB/nKJZDkYzzqJq8qcsYSpWW2R0fVTtroIPi2zm0CYLbf7bFhS4bSO1ahM1aY3i+14hM5B2rYUNvdCxyZShvoAPkJfmM4ygqpE/KzXUTXe3lPTeUzjC4FMME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DYFSyq8A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DYFSyq8A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0/bKAsnxark9NhmLw8gDwrAJ/8RE5sTgmMnKd7/lCWA=; b=DYFSyq8AfeqBLOpPhvXILOhXjl
	ELjanUzX1U/QEm/xoYikhJXNM9mmPXhMlrfm1QQvnQfCI+T46AsxKjJDAoyMV52yX6XPmydf1suB/
	7u82b35AZF/O/oYCu3rYF46dFdRIkQSC2MQ64CM2y11FdHsQ3URPiQ4YbxRc+G/ZVMOKyrdz2SmlZ
	nED08u7qO6ud0D//AmCGQewrQvjkZ7+y/z6IDNSjIvrNKcK6bGrguQovT0r2uc6FmcQl1Aqdxy23G
	uAoTw5XtgzmGV7VGpG37OCc+Mf+FCL0DyyJpfKjAQuawh9KIGDoE+bGpJtrCi1qWZNmoTpBJucXqO
	MaXkyHJw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uIL0Y-0000000304r-3Bjr;
	Fri, 23 May 2025 05:31:50 +0000
Date: Thu, 22 May 2025 22:31:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, djwong@kernel.org, hch@infradead.org
Subject: Re: [PATCH v10 1/1] proto: add ability to populate a filesystem from
 a directory
Message-ID: <aDAIRh275zS5HL_G@infradead.org>
References: <20250522211003.85919-1-luca.dimaio1@gmail.com>
 <20250522211003.85919-2-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522211003.85919-2-luca.dimaio1@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Luca,

thanks again for this work.

Some mostly cosmetic nitpicking below, I'll leave the real review to
Darrick as he knows the code much better than me.

> +will populate the root file system with the contents of the given directory.
> +Content, timestamps (atime, mtime), attributes and extended attributes are preserved

Please keep lines under 80 characters also for the man page.

> +static void populate_from_dir(struct xfs_mount *mp,
> +				struct fsxattr *fsxp, char *source_dir);
> +static void walk_dir(struct xfs_mount *mp, struct xfs_inode *pip,
> +				struct fsxattr *fsxp, char *path_buf);

Is there any easy way to place these new helpers so that no
forward declaration is needed?  If we really have to keep them, the
standard formatting would be:

static void populate_from_dir(struct xfs_mount *mp, struct fsxattr *fsxp,
		char *source_dir);
static void walk_dir(struct xfs_mount *mp, struct xfs_inode *pip,
		struct fsxattr *fsxp, char *path_buf);

> +	struct proto_source	result = {0};

No need for the 0, {} is a valid all-zeroing array initializer.

> +	struct stat	statbuf;
> +
> +	/*
> +	 * If no prototype path is
> +	 * supplied, use the default protofile
> +	 * which creates only a root
> +	 * directory.
> +	 */

Use up all 80 characters for comments:

	/*
	 * If no prototype path is supplied, use the default protofile which
	 * creates only a root directory.
	 */

Same in a few others places.

> +	if (stat(fname, &statbuf) < 0) {
> +		fail(_("invalid or unreadable source path"), errno);
> +	}

No need for the braces around single line statements.  This also happens
a few more times further down.

> +
> +	/*
> +	 * handle directory inputs
> +	 */

> +	if (S_ISDIR(statbuf.st_mode)) {
> +		result.type = PROTO_SRC_DIR;
> +		result.data = fname;
> +		return result;
> +	}
> +
> +	/*
> +	 * else this is a protofile, let's handle traditionally
> +	 */
>  	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {

Shouldb't we open first, then fstat to avoid races?

>  	ret = flistxattr(fd, namebuf, XATTR_LIST_MAX);
> +	/*
> +	 * in case of filedescriptors with O_PATH, flistxattr() will
> +	 * fail with EBADF. let's try to fallback to llistxattr() using input
> +	 * path.

Btw, comments usually are full sentences, and then start capitalized and
end with a dot.  or are short single-line ramblings that start lower
case end end without a dot.  But a mix of the styles is hard to read.

> +/* Growth strategy for hardlink tracking array */
> +#define HARDLINK_DEFAULT_GROWTH_FACTOR	2	/* Double size for small arrays */
> +#define HARDLINK_LARGE_GROWTH_FACTOR	0.25	/* Grow by 25% for large arrays */
> +#define HARDLINK_THRESHOLD		1024	/* Threshold to switch growth strategies */
> +#define HARDLINK_TRACKER_INITIAL_SIZE	4096	/* Initial allocation size */

If you move the comments above the lines it avoids the long lines
and makes this more readable.

> +	/*
> +	 * save original path length so we can
> +	 * restore the original value at the end
> +	 * of the function
> +	 */
> +	size_t path_save_len = strlen(path_buf);
> +	size_t path_len = path_save_len;
> +	size_t entry_len = strlen(entry->d_name);

Instead of messsing with the path, can we use openat to do relative
opens using openat, which avoids the string handling and also
various races.

> +	/*
> +	 * symlinks and sockets will need to be opened with O_PATH to work,
> +	 * so we handle this special case.
> +	 */
> +	if (S_ISSOCK(file_stat.st_mode) ||
> +			S_ISLNK(file_stat.st_mode) ||
> +			S_ISFIFO(file_stat.st_mode))
> +		open_flags = O_NOFOLLOW | O_PATH;
> +	if ((fd = open(path_buf, open_flags)) < 0) {
> +		fprintf(stderr, _("%s: cannot open %s: %s\n"), progname, path_buf,
> +			strerror(errno));
> +		exit(1);
> +	}

And I guess if we want this non-reacy we'd need to open first
(using O_PATH) and then re-open for regular files where we need
to do I/O.

> +
> +	switch (file_stat.st_mode & S_IFMT) {
> +	case S_IFDIR:

Can you split the code for each file type into a separate helper
to split up the currently huge function and make it a bit more readable?

