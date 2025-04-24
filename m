Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2573319E7F9
	for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 16:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745510991; cv=none; b=dEn10MposE9fORIQr2te4MhkHjosaJi643L58CXafUXDmWuCLCtsmZ1P7d21OsysEqXv5k+9aL+2tytmjhVW/+T6tnKqpLIjAsG5pANBaryyUWCvlTAv9zAWqpvxA+8JxC+JUcTOwVwCtl7EYY4OqgN5n3Lchy/v+IDyM3lkr9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745510991; c=relaxed/simple;
	bh=oCcQQE2oZKkBqBYqlxTnOkQAtQM1juvKDbMzPFlS3Ko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R3GC1/ySjlZkLIhNd4Fa3+twljI1lZumIv9M/7BEdzTz7+KdtB30jAHCJQcBNyyZ90LF2dsPnM+sT11ePTXlny6M78ERoXpsZOXgva4cyOY/lqCHixejV1gcURGZlQ3uqv4+OiacqJKzYKe4gJMc4V2z+NNVkBIKvX7knrRj4Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nrHUoEAO; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nrHUoEAO"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5f62d3ed994so2238662a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 09:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745510988; x=1746115788; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TcDr4BbjURz6Wrji0AKrOphR6tIt4RmcHWd1H1qr+Jg=;
        b=nrHUoEAOxQhAlK/j/82Uw3IWje9uMd2izunZQqg38koGRyPCaEyeqHK5GhB4NJjt7J
         PaVK0Eoke/vJsRcnlFxF3NhAP6vLNA2oJFrM2t59qAxcxx2LrzNdABFC9kXcYyfi0FkE
         4yenemd+s83yjTT9BAbxlBI/g+V7HwW2Z+01bxYasLWzGzeKifQrp/GyCJTGhepztYs4
         HmDzIWxx+PY8wyDlW1M2wi6WCp0quffjHaBsJp1MX6bYGDgpUCiNaCmcLkdAnMZ76Pmj
         SERmmIZ3stTzrlNArFYJVGLkN71TA5NJV0hM756F7ZH0VE2hbG+Cgcs8XfoJ8V4kNFCI
         zOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745510988; x=1746115788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TcDr4BbjURz6Wrji0AKrOphR6tIt4RmcHWd1H1qr+Jg=;
        b=wedJcF00HadQ0C5ij2Tr0THih6bSHGE39zRNANzvko0Mk99hwCWHUhoZxj4K5MVhu8
         EAi+KdQYGeMIajwOgVt7SDciuE5KNArzFKHptKe/Ah30MEP15Yt0kZRVDIyZ95bg/IDu
         vO6gulZ9ZbkJO7w6iM2WuHOKOsn1av6BDoY7xbhILHlFPzyg5Xg0tL9ZVb2FltSa7j/O
         YWtWcJ92S925UC4ghKYHwGI5cdGfu3yZ7l5QP1NRasvFyU1vCJWp29O7b5Pe4FzDCr5B
         aqtYvcrTpE4gTKBtRQUK+rRlwHVHRzRPFV9Pim4YHCytha2eWABBeDsiASGtVwYk80MY
         vZng==
X-Gm-Message-State: AOJu0YxcdSkIMoQ/L5dz38N1JLu8ZbjvRTzjG2XkSsHeYW3Mf+fF4TX0
	zQgpnJSA1WlfYJXkv36jdDXrriLem6qLvhuczzsEiNOMvCyCo5RY
X-Gm-Gg: ASbGncuV/JfXjSA6wQ8zHD+bYe8CreIkeA7xVaIRdw9Xe+3Vqb6NbGc5j7aX+WZP92j
	D610G2VMEvv+QhZW6FmvMxnUR6/dJPsq7Xwpma8Aqo6VVV3LwmiSUMFse38eZ1Gk44jZZKwXWWs
	XFQjCqQalTVRUA3RYoYp+fZPcC7He9CG210zxgBUvbZj4U8N7jyFqLAaF3U3kUKyAvbwTPkkwuQ
	PzYIGxOXxZVaoqMPHpW0pWSJlCrSHnJA/hYRD11Rt3mdFm4QrwsMld82pSpVJMgK/u7+pPnt0J3
	af9fPg==
X-Google-Smtp-Source: AGHT+IEBZR8fkKWOf1c1RUzMOEAGFyDHFhs2lT712xHmhMqzMFAw7rFqJ0rup3ELa7OJ4dYdkNSCOA==
X-Received: by 2002:a05:6402:210d:b0:5f6:c5e3:faab with SMTP id 4fb4d7f45d1cf-5f6ddb0c5f5mr2732555a12.1.1745510988006;
        Thu, 24 Apr 2025 09:09:48 -0700 (PDT)
Received: from framework13 ([151.43.14.62])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f6ed9dfa8fsm1327782a12.72.2025.04.24.09.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 09:09:47 -0700 (PDT)
Date: Thu, 24 Apr 2025 18:09:45 +0200
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v6 2/4] populate: add ability to populate a filesystem
 from a directory
Message-ID: <vmiujkqli3d4c7ohgegpxvwacowl2tdaps6m4wyvwh6dcfado7@csca7fs5y7ss>
References: <20250423160319.810025-1-luca.dimaio1@gmail.com>
 <20250423160319.810025-3-luca.dimaio1@gmail.com>
 <20250423202358.GI25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423202358.GI25675@frogsfrogsfrogs>

On Wed, Apr 23, 2025 at 01:23:58PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 23, 2025 at 06:03:17PM +0200, Luca Di Maio wrote:
> > +static void fail(char *msg, int i)
> > +{
> > +   fprintf(stderr, _("%s: %s [%d - %s]\n"), progname, msg, i, strerror(i));
> > +   exit(1);
> > +}
> > +
> > +static int newregfile(char *fname)
> > +{
> > +   int fd;
> > +   off_t size;
> > +
> > +   if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
> > +           fprintf(stderr, _("%s: cannot open %s: %s\n"), progname, fname,
> > +                   strerror(errno));
> > +           exit(1);
> > +   }
> > +
> > +   return fd;
> > +}
>
> Why is this copy-pasting code from proto.c?  Put the new functions
> there, and then you don't need all this externing.
>

Right, this is because with a separate flag I thought it would have been
better to keep it in a separate file.
With the new behaviour you proposed in the previous mail (one -p flag,
check if file/directory) then I can unify back into proto.c, thus
removing all the exported functions changes.

> > +
> > +static void writetimestamps(struct xfs_inode *ip, struct stat statbuf)
> > +{
> > +   struct timespec64 ts;
> > +
> > +   /*
> > +    * Copy timestamps from source file to destination inode.
> > +    *  In order to not be influenced by our own access timestamp,
> > +    *  we set atime and ctime to mtime of the source file.
> > +    *  Usually reproducible archives will delete or not register
> > +    *  atime and ctime, for example:
> > +    *     https://www.gnu.org/software/tar/manual/html_section/Reproducibility.html
> > +    */
> > +   ts.tv_sec = statbuf.st_mtime;
> > +   ts.tv_nsec = statbuf.st_mtim.tv_nsec;
> > +   inode_set_atime_to_ts(VFS_I(ip), ts);
> > +   inode_set_ctime_to_ts(VFS_I(ip), ts);
> > +   inode_set_mtime_to_ts(VFS_I(ip), ts);
>
> This seems weird to me that you'd set [ac]time to mtime.  Why not open
> the source file O_ATIME and copy atime?  And why would copying ctime not
> result in a reproducible build?
>
> Not sure what you do about crtime.
>

The problem stems from the extraction of the artifact. Usually
reproducible archives will remove [ac]time and only keep mtime, but in
the moment that a file is extracted, any filesystem will assign [ac]time
to the moment of extraction.
This will add randomness not to the filesystem itself, because it will
be reproducible if acting on the same extracted archive, but it will not
be reproducible if acting on a new extraction of the same archive.

Another approach we can do is what mkfs.ext4's populate functionality is
doing: while it preserves mtime, [cr,a,c]time is set to whatever time the
mkfs command is running.

This would make it preserve the important timestamp (mtime) and move the
"problem" of the reproducible/changing timestamp to the environment,
while keeping the behaviour of mkfs.xfs sensible

What do you think?

> > +   /*
> > +    * copy over file content, attributes and
> > +    * timestamps
> > +    */
> > +   if (fd != 0) {
> > +           writefile(ip, fname, fd);
> > +           writeattrs(ip, fname, fd);
>
> Since we're adding features, should this read the fsxattr info from the
> source file, override it with the set fields in *fsxp, and set that on
> the file?  If you're going to slurp up a directory, you might as well
> get all the non-xattr file attributes.
>

Right, I thought creatproto() did that, but now I see that this is done
only for the root inode, I'll add this for others too, thanks.

> > +           libxfs_parent_finish(mp, ppargs);
> > +           tp = NULL;
>
> Shouldn't this copy xattrs and fsxattrs to directories and symlinks too?
>

Right, will add, thanks.

> > +/*
> > + * walk_dir will recursively list files and directories
> > + * and populate the mountpoint *mp with them using handle_direntry().
> > + */
> > +static void walk_dir(struct xfs_mount *mp, struct xfs_inode *pip,
> > +                       struct fsxattr *fsxp, char *cur_path)
> > +{
> > +   DIR *dir;
> > +   struct dirent *entry;
> > +
> > +   /*
> > +    * open input directory and iterate over all entries in it.
> > +    * when another directory is found, we will recursively call
> > +    * populatefromdir.
> > +    */
> > +   if ((dir = opendir(cur_path)) == NULL)
> > +           fail(_("cannot open input dir"), 1);
> > +   while ((entry = readdir(dir)) != NULL) {
> > +           handle_direntry(mp, pip, fsxp, cur_path, entry);
> > +   }
> > +   closedir(dir);
> > +}
>
> nftw() ?  Which has the nice feature of constraining the number of open
> dirs at any given time.
>
> --D
>

The problem with nftw() is that working with callback functions, we will
need to switch to static variables for state, for example to keep track
of each ip's pip, while with the recursive approach we can have some
state and basically walk_dir() behaves similar to parseproto(), making
changes to the rest of the file minimal.
This seems to involve a lot more changes than now where we're basically
just adding a limited number of functions to proto.c.

Thanks again for the review Darrick,
I'll wait for your feedback on the walk_dir() vs nftw() and the [ac]time
approach,
thanks

L.
