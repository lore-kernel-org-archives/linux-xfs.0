Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464D7298CD5
	for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 14:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753886446; cv=none; b=F4idJiCLPDGXgBi9FbmhVBMnqurmx35BtKDdtrzTSQ/6UA+DButgZb7s1uLNpQt9N2LwkBQTzVrDUf3XAbNXtPO7e+Dfo+pgU2ck0P3alKxqd8gJu5V8B+BWZoUlPy+Fy6rImNmtuFWDeGB8LI4yz3o2cgy8kd6zeal5427xvXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753886446; c=relaxed/simple;
	bh=OSwbNK9f56sHYt/29R7Xw/K0opgiQlk/1pX67WwhWK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BCSu2jud8ynyHyJQivJNovG0Tb/85HL3i4WKxCwMlew2lO8NKHlg7pi2TX5ad+14kuowrU/LL0OxGa5VVW4AR3SG5dVdE1sXaxXiq6OAo/SuYiuMzcJwh5Mf3n+NtIS9eeYzWmCJ9icSM6+BJf7DkOpJXhHljWkaAVsAswQw5WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H7FcqT0c; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H7FcqT0c"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-455fdfb5d04so36553455e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 07:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753886442; x=1754491242; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SN7jFmCP+CUsHl17Jgz/sOdn6+dyE6zh5zr7QOxjDzc=;
        b=H7FcqT0cGG1+E2UwocgTGsUu2L1tlIlnDsMjeayefG+u4CJQzmUWcTqo2Prffst8Lm
         GXmuIdoXVZQ8Oty9QKSa1WbCBYrD5Herwd9vXAibAJnNZMaBqB4E3d/PY4Wi06559mYw
         en5+LJDQrW31qshvq6+pk9ed8vGoYlGj/sFuf3lOKINTJNULRm/lS9jVtfVXheXLS5x6
         0FngfCbyM8XIsVlTonzeiy8n2RMXHKJP8vvHsDeKjBHnsrH5ke2s9er87K6z1dBq2pJV
         S/wVUkn9+CJuinRYTws76yfdHqGkgBQYrmwe4AkPyOVQFRzY4Nhalt9ZHr2TFl/hh0ca
         zfDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753886442; x=1754491242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SN7jFmCP+CUsHl17Jgz/sOdn6+dyE6zh5zr7QOxjDzc=;
        b=KOyOIwx+LGIhM7uDO87TWTpwNNluv3BzyuLywfIw9tfm45N2DlJD2oiaje/8yJ+ptB
         uyhURW2KqrbZesyI5+j46e3pEII8r6X0Xktau58nAkAOo10QQ/yRbv8/3KShmVsY882G
         K5Z/8ROl20S93ckLYaI2G55B3SbowV51DvXuR3XyuIsyB0uCQDsxvYSOb7V32p3ItHls
         TbubOaHl2NdrMuRAh5WWZM+jkgriZamohl4Tagv27mhpgxdr9HvyrjoY2ksOM2uky3eK
         LAQudMO49PqOiqI7K9C8x/b0n+H6wR23H4ND69dz8bQiiBriaW598YWIFWlGPkRgNqgc
         +Yjg==
X-Gm-Message-State: AOJu0YxwJpa5iLbWzG4hqPDia0s4ixANhgSDVRzxKLogY7jodmhoalpu
	pQAW3ZtYcivta5uA1UqWzqP9BjBdJEJJecnZz63+vZC9tdcTuNC+zM1E
X-Gm-Gg: ASbGncu089RoUtEvNtH2ia4aclCUsCOAqxszUwRErNpyoeTSuO0S/MEjnEhRkLG4Wc3
	vJGMTyCnXzusVhkYfSrSVvc88/KPVdqQz8oZjdJtjMCKJlwZobn93gYUJ95g3Wz2KJaG1BRAGKD
	SupwiEXyTeh2dCtlacMycMtK5byyvPo6sxYZ/AdoIfU2dhjSfxZmbr7F1hCUjBQludsckLSwgqL
	nhOJVAT4K5TnyXR+ImNqh3iNfdTTyRJiaOC0KJpordYlbjAQjQqeOsNHgELDfNhaMSh/pRPyx58
	wmRS/Xn5HYr4IvSgf7SPwcGuSZbxnQokpB/wsprZ0Ty43p4dShFp1WDYkSL5HnxuI+JffFvZKm8
	b6+qemymlJy/6wDVsYPya53U8xsTYDeTRSIVPqoi021ani5vUVgO3WYV2Oic1I9uzWbZLEg==
X-Google-Smtp-Source: AGHT+IHMiPIhi8e95iEhbjJx3eaH6n7yFM8+8F/KYOYHzJG2+Y31y1YBzwObxe9dfKvCzHmlDetIZQ==
X-Received: by 2002:a05:600c:6287:b0:456:1a69:94fd with SMTP id 5b1f17b1804b1-4589956fda0mr23621405e9.0.1753886442101;
        Wed, 30 Jul 2025 07:40:42 -0700 (PDT)
Received: from framework13 (93-44-110-195.ip96.fastwebnet.it. [93.44.110.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45895386627sm30579835e9.19.2025.07.30.07.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 07:40:41 -0700 (PDT)
Date: Wed, 30 Jul 2025 16:40:39 +0200
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v11 1/1] proto: add ability to populate a filesystem from
 a directory
Message-ID: <bowzj7lobz6tv73swiauishctrryozcwqmqyeqck65o2qjyt5v@vufmu67nwlkc>
References: <20250728152919.654513-2-luca.dimaio1@gmail.com>
 <20250728152919.654513-4-luca.dimaio1@gmail.com>
 <20250729214322.GH2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729214322.GH2672049@frogsfrogsfrogs>

Thanks Darrick for the review!
Sorry again for this indentation mess, I'm going to basically align all
function arguments and all the top-function declarations
I was a bit confused because elsewhere in the code is not like that so
it's a bit difficult to infere

Offtopic: maybe we could also introduce an editorconfig setup? so that
all various editors will be correctly set to see the tabs/spaces as
needed (https://editorconfig.org/)

Back on topic:

On Tue, Jul 29, 2025 at 02:43:22PM -0700, Darrick J. Wong wrote:
> > +will populate the root file system with the contents of the given directory.
>
> "...of the given directory tree."
>
> (It's a subtle hint that it recursively imports the whole tree, not
> one single directory)

Ack.

> > +Content, timestamps (atime, mtime), attributes and extended attributes
> > +are preserved for all file types.
> > +.TP
> > +.BI [file=] protofile
> > +If the optional
> > +.PD
> > +.I prototype
> > +argument is given, and points to a regular file,
> > +.B mkfs.xfs
> > +uses it as a prototype file and takes its directions from that file.
> >  The blocks and inodes specifiers in the
> >  .I protofile
> >  are provided for backwards compatibility, but are otherwise unused.
> > @@ -1136,8 +1145,16 @@ always terminated with the dollar (
> >  .B $
> >  ) token.
> >  .TP
> > +.BI atime= value
> > +If set to 1, when we're populating the root filesystem from a directory (
>
> Who is "we"?
>
> "If set to 1, mkfs will copy in access timestamps from the source
> files.
> Otherwise, access timestamps will be set to the current time."
>

Ack.

> > +	 */
> > +	if (S_ISDIR(statbuf.st_mode)) {
> > +		result.type = PROTO_SRC_DIR;
> > +		result.data = fname;
> > +		return result;
>
> Er... this leaks the fd that you opened above.
>

Ack.

> > +static void
> > +create_inode(
>
> Might want to call this create_nondir_inode to distinguish it from
> create_directory_inode.
>

Ack.

> > +	char		*fname)
>
> Hrmm, is @xname the filename we're creating in pip, and @fname is the
> path to the original file so that we can copy the contents and various
> other attributes?  If so, then maybe s/fname/src_fname/ to make this
> clearer?
>

Ack.

> > +static void
> > +handle_direntry(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_inode	*pip,
> > +	struct fsxattr		*fsxp,
> > +	char			*path_buf,
> > +	struct dirent		*entry)
> > +{
> > +	char		cur_path_buf[PATH_MAX];
>
> Hrmm.  For each level of the source directory tree we allocate another
> PATH_MAX buffer on the stack just to snprintf from @path_buf (which is
> itself a stack buffer).
>
> Even assuming the usual 8M thread stack, that means a directory
> structure more than ~2000 levels deep will overflow the stack and crash
> mkfs.
>
> I really think you ought to consider allocating /one/ buffer at the
> start, passing (path_buf, path_len) down the stack, and then snprinting
> at the end of the buffer:
>
> 	size_t avail = PATH_MAX - path_len;
> 	size_t wrote = snprintf(path_buf + path_len, avail, "/%s", entry->d_name);
>
> 	if (wrote > avail)
> 		fail(path_buf, ENAMETOOLONG);
>
> 	...
>
> 	if (S_ISDIR(...)) {
> 		create_directory_inode(..., path_buf, path_len + strlen(entry->d_name), ...);
>
> 	...
>
> 	path_buf[path_len] = 0;
>
> One buffer, much less memory usage.

Right, It was like this before but I've Inadvertently unoptimized this
in V11 when switched to openat(), will fix in next path, sorry.

> > +	if (!S_ISSOCK(file_stat.st_mode) &&
> > +	    !S_ISLNK(file_stat.st_mode)  &&
> > +	    !S_ISFIFO(file_stat.st_mode)) {
> > +		close(fd);
> > +		fd = openat(pathfd, entry->d_name,
> > +			    O_NOFOLLOW | O_RDONLY | O_NOATIME);
>
> Just out of curiosity, does O_NOATIME not work in the previous openat?

Actually on my test setup (mainly using docker/podman to test), opening
with and without O_NOATIME when using O_PATH, does not change accesstime
checking with `stat`, but also it works if I add it.
As a precautionary measure (not sure if podman/docker is messing with
noatime) I'll add it, as it seems to work correctly.

> > +		 * this will make flistxattr() and fgetxattr() fail wil EBADF,
>
> "fail with EBADF"...
>

Ack.

> > +	/*
> > +	 * Copy over attributes.
> > +	 */
> > +	writeattrs(ip, path_buf, fd);
>
> Nothing closes fd here; does it leak?
>
> --D
>

Ack.

L.
