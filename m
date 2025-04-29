Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B077E110
	for <linux-xfs@vger.kernel.org>; Tue, 29 Apr 2025 17:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948043; cv=none; b=TfIEt8udPtVKQ+rmbBLBCfJfQPQhdR1QhUfTYBjXSQOPL1xuDqeH/CqlL2dsv7/0EzhYCO7Uof8ipzTwhBa377a6zyrAv40zViQkEUnQxacyXNuQAQd09VtQOr513O28VV+fVg5H/4o1e6vksomJ3fx+TVh0tVl1sv6D5b4TrYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948043; c=relaxed/simple;
	bh=o0lniUUhJVgHB2Cqys5rT83Vt12dHxdeZzMOgj3aud4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nyXL6ni0blTpJlAU2SzN2gg/ALNeieVQCcjBG397uiaGeDagIhSv9rPgA1gT/s2OK7sVWWz7/gcLOg8DQt7rDUkGUFXMjFnfMEOEIterXn2GqSEn1mWjpyk+5BeHdJu4QZV26sL8yXw40dKLGHRp6PVh6bF5TR1dqIDuGJD/bF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gu42OSTN; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gu42OSTN"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5f63ac6ef0fso177669a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 29 Apr 2025 10:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745948039; x=1746552839; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SCmhofSWxxMwq5GmiuWmspZ7pcebd9M4/l36iwrgcZw=;
        b=gu42OSTNaf4SqsOJ55sftKu3ILhq+JxyQ2pg79DOykth6PQpOG4+lmEK4fJBbCJUlo
         5urUMzwtVubHYnkzGspma7OLrfa5W4JCZ9uDPyE8cnUQ1hKVaFx26bpVJgAFptUnOHyF
         Knxgrt/DXlqg/f5iVkqH11jDEvda6+avzXcnU30jomXfK2VrY4RCtRuDhuqz+F4G50N3
         Zefy7D8iEouin8VXdVC8A3sb9Sxx6RGz4ovfDxYRKfi1xCwyb3kxiqnrhq3v+rx+pr/W
         EdlNH1QoGeLnz9A7EbJ6eb9fVJLHPJyZxJiLnZGNKZ/V2SIlRw9gejVgxZtyUqNHFfhk
         enfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745948039; x=1746552839;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SCmhofSWxxMwq5GmiuWmspZ7pcebd9M4/l36iwrgcZw=;
        b=rjkfTKVcZeCWCJkbUwxgr7xXxShlC/4qQRjga/2+ZUJm1UKPwaptBOb7xynLD136zH
         zaSwkWWVUJOCcoMmOfOqqIYm2HouOH2ir8JKNpgwCShtgTgC4BqaxQqzZc94WbHaE+L0
         ZukJNiHdVU3sc7WTOxBPMcNkhPjvKpSXkPpa1kBhGZBVygRapu5rdalQrhaL04TJ8og+
         3VsxtD1rJKU5aibyMwOjnCLceSgZki+9YlKws+kDiebKZc53fmKMx+H4nPzs5G9n1X8S
         b76qR47AvSx4TCOHznGWFtgvJQYYdyTktUFhJHpAYgjrTEj1ZB8d5veeUXMsdhy/QVeU
         OWew==
X-Gm-Message-State: AOJu0YzHE42xsbANOn1bWix8D5SGcgrUzxy1BEfO3U2uEMl90OXyQLTy
	r1gEqJFvXGYYurAVANOR1teMrCtuHEV79euj0tJ2mnV0vRi4rX8H
X-Gm-Gg: ASbGncsH+qloAZvk8D/3F2jTQBJoQKLVircAQr865rvgO5+L4Pauf+u8Sy1ZqcePzLQ
	vMRhprl/liB2yaUD2dRpRFKAJ2cfzyDNP43ZfZhCi02iN7uBb55hySCtdEjC2pB+NHdeEOACJVP
	pJ0oB7qLCE+SFjwba0dS7zk37Ck6R1aSKWsVoPouhU2yraL3I3Og0crNuD1g3MaBBSliLWBxQyi
	GMCHsMOfEL4618EwvFDyNbcZeRK/3t4KJ96SUDoCwUsF+tLn+x0EifHXel5hrNaVf0Oqyr58A4R
	1RH+E96fu1+Hcn54mcOxKY44VnF8AHXf8HIkE4zg+nIy
X-Google-Smtp-Source: AGHT+IGyTs5EK+DpUx5rcAh1YXp2J8pkIutQ0l9adsjyCafoUpjw/+RoRjJhu59JKu+mP1Aptq/JaQ==
X-Received: by 2002:a05:6402:1e8f:b0:5db:68bd:ab78 with SMTP id 4fb4d7f45d1cf-5f89168850fmr121872a12.10.1745948038894;
        Tue, 29 Apr 2025 10:33:58 -0700 (PDT)
Received: from framework13 ([2a01:e11:3:1ff0:d497:e7e3:a910:a510])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f703834065sm7704306a12.80.2025.04.29.10.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 10:33:58 -0700 (PDT)
Date: Tue, 29 Apr 2025 19:33:56 +0200
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v7 1/2] proto: add ability to populate a filesystem from
 a directory
Message-ID: <47tgriadcj4a6zfrqhpzf3qgz3qfi5rzed4kofpobkrqkvhihn@4okusqlxnfxp>
References: <20250426135535.1904972-1-luca.dimaio1@gmail.com>
 <20250426135535.1904972-2-luca.dimaio1@gmail.com>
 <20250428171606.GS25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250428171606.GS25675@frogsfrogsfrogs>

Thanks again Darrick,

On Mon, Apr 28, 2025 at 10:16:06AM -0700, Darrick J. Wong wrote:
> On Sat, Apr 26, 2025 at 03:55:34PM +0200, Luca Di Maio wrote:
> > +	if ((fd = open(fname, O_DIRECTORY)) > 0) {
>
> 0 is a valid (if unlikely) fd return value for open.  But the bigger
> problem is...
>
> > +		return fname;
>
> ...that now you've reduced the coherence of this function by making it
> return either a buffer containing the contents of a protofile minus the
> first two lines; a default protofile excerpt if there was no filename,
> or ... the path argument, if the path happened to point to a directory.
>
> How does the caller (or parse_proto) figure out what they're supposed to
> do with the protostring?  (More on this below.)
>
> > +	if ((fd = open(*pp,  O_DIRECTORY)) < 0) {
>
> Urrrk, here we just open the protostring returned by setup_proto and
> passed in here as @pp?  Recall that if -p file= pointed to a regular
> file, then protostring contains everything except the first two lines.
>
> So if you pass in a corrupt protofile:
>
> /stand/diskboot
> 4872 110
> /etc/
>
> this line will see /etc, the directory open succeeds, and now we start
> importing /etc.  That isn't the documented behavior of a protofile.
>
> Also, you open the passed-in path twice.  This is a minor point for
> mkfs, but what if the path changes from a directory to a regular file in
> between the two open(..., O_DIRECTORY) calls?

Right, this is confusing, I'll do a more structured return type
for the various cases

> > -		fail(_("error collecting xattr value"), errno);
> > +		/*
> > +		 * in case of filedescriptors with O_PATH, fgetxattr() will
> > +		 * fail. let's try to fallback to lgetxattr() using input
> > +		 * path.
>
> Fail how?  Shouldn't we gate this retry on the specific error code
> returned by fgetxattr on an O_PATH fd?
>
> > +		ret = llistxattr(fname, namebuf, XATTR_LIST_MAX);
>
> Same here.
>

Right, will fix and explain the error

> > +		parseproto(mp, NULL, fsx, pp, NULL);
> > +		return;
> > +	}
> > +
> > +	close(fd);
> > +	populate_from_dir(mp, NULL, fsx, *pp);
>
> I'm not sure why you don't pass in the opened directory here.  I'm also
> not sure why the second parameter exists here; it's always NULL.

Right, will cleanup

> > +static void
> > +writefsxattrs(
> > +		struct fsxattr *fsxp,
> > +		struct xfs_inode *ip)
>
> Strange indenting here, the usual parameter declaration convention in
> xfs is:
>
> 	struct xfs_inode	*ip
>
> ^ one tab               ^ another tab
>
> also we usually put the inode first because this function modifies the
> inode...
>

Ack will fix those

> > +}
> > +
> > +struct hardlink {
> > +	unsigned long i_ino;
>
> ino_t ?  Since that's what stat returns.
>
> also struct field declarations need a tab between the type and the field
> name.

Ack

> > +	struct xfs_inode *existing_ip;
> > +};
> > +
> > +struct hardlinks {
> > +	int count;
>
> This can overflow to negative if there are more than 2^32 hardlinked
> files in the source filesystem.  My guess is that this will be rare, but
> you ought to program against that anyway...
>
> > +	size_t size;
>
> ...since I'm guessing the upper limit on this data structure is whatever
> can be held in size_t.

Right, will upgrate it to size_t

> > +	struct hardlink *entries;
> > +};
> > +
> > +/*
> > + * keep track of source inodes that are from hardlinks
> > + * so we can retrieve them when needed to setup in
> > + * destination.
> > + */
> > +static struct hardlinks *hardlink_tracker = { 0 };
> > +
> > +static void
> > +init_hardlink_tracker(void) {
> > +	hardlink_tracker = malloc(sizeof(struct hardlinks));
> > +	if (!hardlink_tracker)
> > +		fail(_("error allocating hardlinks tracking array"), errno);
> > +	memset(hardlink_tracker, 0, sizeof(struct hardlinks));
> > +
> > +	hardlink_tracker->count = 0;
>
> You just memset the object to zero, this isn't necessary.
>
> (use calloc to elide the memset?)

Yep will switch to calloc, thanks

> > +	hardlink_tracker->size = PATH_MAX;
>
> Wait, why is the size being set to PATH_MAX?  Are we tracking path
> strings somehow?
>

Right, I tought to just reuse a constant already defined, I'll just set
it explicitly to a number, it will be resized most likely anyway.

> > +}
> > +
> > +static struct xfs_inode*
> > +get_hardlink_src_inode(
> > +		unsigned long i_ino)
> > +{
> > +	for (int i = 0; i < hardlink_tracker->count; i++) {
>
> Urk, linear search.  Oh well, I guess we can switch to a hashtable if
> we get complaints about issues.

Yea, if it's a problem I can implement an hashtable, from my local
testing using larger source directories (1.3mln inodes, ~400k hardlinks)
the difference was actually just a few seconds (given that most of the
time is doing i/o)

If we get complains we can come back to this

> > +		if (hardlink_tracker->entries[i].i_ino == i_ino) {
> > +			return hardlink_tracker->entries[i].existing_ip;
>
> /me notes that this pins the hardlinked xfs_inode objects in memory.
> That's a risky thing for an xfsprogs utility to do because there's no
> inode cache like there is in the kernel.  In other words, xfs_iget
> creates a brand new xfs_inode object even for the same inumber.
>
> I /think/ that's not technically an issue in mkfs because it's
> single-threaded and never goes back to an existing inode.  But you might
> consider changing struct hardlink to:
>
> /*
>  * Map an inumber in the source filesystem to an inumber in the new
>  * filesystem
>  */
> struct hardlink {
> 	ino_t		src_ino;
> 	xfs_ino_t	dst_ino;
> };
>
> since xfs_inodes are fairly large objects.

Ack, didn't know about libxfs_iget()
I'll switch to only store src/dst ino_t, thanks

> > +		struct hardlink *resized_array = realloc(
> > +				hardlink_tracker->entries,
> > +				new_size * sizeof(struct hardlink));
>
> At this point, is it safe to use reallocarray?  Or will that cause
> problems with musl?

I don't think it's a problem, reading around I see that modern
versions of musl (since around 2020-2021) do include reallocarray().
I'll switch to that

> > +static int
> > +handle_hardlink(
> > +		struct xfs_mount *mp,
> > +		struct xfs_inode *pip,
> > +		struct fsxattr *fsxp,
> > +		int mode,
> > +		struct cred creds,
> > +		struct xfs_name xname,
> > +		int flags,
> > +		struct stat file_stat,
> > +		xfs_dev_t rdev,
> > +		int fd,
> > +		char *fname,
> > +		char *path)
>
> How many of these parameters are actually needed to create a hardlink?

Will cleanup

> > +		/*
> > +		 * if no error is reported it means the hardlink has
> > +		 * been correctly found and set, so we don't need to
> > +		 * do anything else.
> > +		 */
> > +		if (!error)
> > +			return;
>
> You know, if you inverted the polarity of handle_hardlink's return
> value, you could do:
>
> 	if (file_stat.st_nlink > 1 && handle_hardlink(...)) {
> 		close(fd);
> 		return;
> 	}

Right, that's better, thanks

> > +
> > +	/*
> > +	 * copy over file content, attributes,
> > +	 * extended attributes and timestamps
> > +	 *
> > +	 * hardlinks will be skipped as fd will
> > +	 * be closed before this.
>
> Aren't hardlinks skipped because this function returns if
> handle_hardlink() returns 0?
>
> > +	 */
> > +	if (fd >= 0) {
>
> Do callers actually pass us negative fd numbers?

Hardlink of a FIFO should be fd=-1 as we're going to skip open() for
FIFOs (as you suggested)

> > +
> > +	/*
> > +	 * Create the full path to the original file or directory
> > +	 */
> > +	snprintf(path, sizeof(path), "%s/%s", cur_path, entry->d_name);
>
> Urrk, check the return value here!
>
> /me wonders if you should declare /one/ char path[PATH_MAX] at the top
> of the call chain and modify that as we walk down the directory tree,
> rather than declaring a new (4k) stack variable every time we walk down
> another level.

Yes it's better to have one buffer PATH_MAX long and handle one instance
of that, will modify accordingly

> > +
> > +	if (lstat(path, &file_stat) < 0) {
> > +		fprintf(stderr, _("%s (error accessing)\n"), entry->d_name);
> > +		exit(1);
> > +	}
> > +
> > +	/*
> > +	 * symlinks will need to be opened with O_PATH to work, so we handle this
> > +	 * special case.
> > +	 */
> > +	int open_flags = O_NOFOLLOW | O_RDONLY | O_NOATIME;
> > +	if ((file_stat.st_mode & S_IFMT) == S_IFLNK) {
>
> S_ISLNK() ?

Ack

> > +		open_flags = O_NOFOLLOW | O_PATH;
> > +	}
> > +	if ((fd = open(path, open_flags)) < 0) {
> > +		fprintf(stderr, _("%s: cannot open %s: %s\n"), progname, path,
> > +			strerror(errno));
> > +		exit(1);
> > +	}
>
> Not sure you want to open() on a fifo, those will block until someone
> opens the other end.

Right, will fix

> > +
> > +	memset(&creds, 0, sizeof(creds));
> > +	creds.cr_uid = file_stat.st_uid;
> > +	creds.cr_gid = file_stat.st_gid;
> > +	xname.name = (unsigned char *)entry->d_name;
> > +	xname.len = strlen(entry->d_name);
> > +	xname.type = 0;
> > +	mode = file_stat.st_mode;
>
> Most of these could be moved to the variable declarations:
>
> 	struct cred creds = {
> 		.cr_uid	= file-stat.st_uid,
> 		.cr_gid	= file_stat.st_gid,
> 	};
>
> and now future programmers don't have to be careful about uninitialized
> variables.

Right, thanks

> > +		/*
> > +		 * copy over attributes
> > +		 *
> > +		 * being a symlink we opened the filedescriptor with O_PATH
> > +		 * this will make flistxattr() and fgetxattr() fail, so we
> > +		 * will need to fallback to llistxattr() and lgetxattr(), this
> > +		 * will need the full path to the original file, not just the
> > +		 * entry name.
> > +		 */
> > +		writeattrs(ip, path, fd);
> > +		writefsxattrs(fsxp, ip);
> > +		close(fd);
>
> PS: symlink (really, non-directory) files can be hardlinked too.
>
> $ ln -s moo cow
> $ ls -d cow
> lrwxrwxrwx 1 djwong djwong 3 Apr 28 10:05 cow -> moo
> $ ln cow bar
> $ ls -d cow bar
> lrwxrwxrwx 2 djwong djwong 3 Apr 28 10:05 bar -> moo
> lrwxrwxrwx 2 djwong djwong 3 Apr 28 10:05 cow -> moo

Right, I didn't think of this, will modify accordingly

> > +
> > +	/*
> > +	 * open input directory and iterate over all entries in it.
> > +	 * when another directory is found, we will recursively call
> > +	 * walk_dir.
> > +	 */
> > +	if ((dir = opendir(cur_path)) == NULL)
> > +		fail(_("cannot open input dir"), 1);
>
> Please report *which* directory couldn't be opened.

Ack

Thanks for the review
L.
