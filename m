Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8B818A6B5
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 20:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734036248; cv=none; b=VHiNGtvrDbHq8FoagQAawWb12Y1hzW9uOQY7bnralqoq/k3hEWL4PpeK1eHgtuCORkfzOY1h0Kge6Ki6O7jSIeOd6ouerKywhxuddERrKO/BNJqQQYakZX6jHpbkLEkOEDcXz255kfCRQMUcWJsmDC4BrL5oSbtU/hzq4A3tuyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734036248; c=relaxed/simple;
	bh=z7dvnp1wJwcgR0OOhWAnXX3y6XFU/RaQbm+Wh5D5GIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OGvPzA/quzpllUXniyuBq47JLBFTcS3iawmi1ovTQIPRImHnZ5jjXANGHCr6OHynpUvxsZ/lYkCavUJy2oeRLD+T1Bp1yxUuab4yekGroDaJRXXAMR6A61ig824Y9TsEVJO1fWptr1C0EpkGJObOL/PdGpktOKz1DSstY4o5VrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=fISalG7f; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="fISalG7f"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-21683192bf9so10592665ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 12:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1734036245; x=1734641045; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gY9QpSeXkRgHpm7Ku8b4o1XavyERhHEQqI9K8o9LNoI=;
        b=fISalG7fFANAr5rVUIbasREP6o7UE4XM7eAJbEGWcnRRR4R2IIsObu/t3TNL9a2Dnn
         SaKXJdhkQI0V0J5LsKzl9yMSFXs6pDTy+pKoV0SjPUkOgS7JcWFVNeaI5I8i33Ff6NVx
         +TQQCvwKyQz6O3A9imOCo1wshh+jOWFTa62apsZ/LO/BIbxBRY5yJWiiVesq1Sa+rjYa
         +mH2CJMDmkywPuFr2F0bfseXEq/D69a+//KLdAg1J1wcGcGj8BjAYrBzzqDbRuT+oE/y
         rubgu4DoL0mufdPFMSOkHlQtYjGl2fTRZta8j6IbnLkCwE0d0RNAVtI3lyqtXhuCeNDN
         +CQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734036245; x=1734641045;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gY9QpSeXkRgHpm7Ku8b4o1XavyERhHEQqI9K8o9LNoI=;
        b=t76CNeZPMonUWGwzThrqdiheIbMKlxYDTCYnhAA9jgBlT2icM2wH5Lq2T8vy5Nt5Nw
         /6tUveKrkTQiJ7seAZ6654tlO6vSSdNycZX2xgMwNjSZrhSSz5q3/9dYkDo0x+pRwhfD
         8Mf/lz0MQLH9ms/hkaXDRjWOmsX+vv/lG0uBqyAKuVBeKpk2iZ6dw6O+pScxTkm8IvHd
         VEqSInp8VMU4KACkmSMm8kGmes6SUg1GQo07pdFq7VAMGzHVABlDigXn2eqcWsvlevm3
         ZcwfvyjME7reBG1rt8CeezrS1KzBbNwWoIE5D0jLU+BVDQIKCo5xlQtDJkPX2yXgo9W7
         uSqw==
X-Forwarded-Encrypted: i=1; AJvYcCW+N+ej8nsKza7AgI7K6JXHpJPwFe5n8LZem3ktcMZjKU3tYLBsBW80YtiMIutIPoQibT7RQxothW8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPC91T81AmIxieWvPtpl+O08SjxNehBWGAf+itIeT99WTsO4nw
	sSRjC7fOx70PopxMnq7i145nCZ0dztP/YsvaCXJBhFAAvntPmnvwPltolnFW2tE=
X-Gm-Gg: ASbGncs+WvkpHlEM2CyMp4X+2FxlOJScU8xAfEWPXXi8tw83aVC09nXM8LV6gbrSlP4
	AlUByTin+PcBLdyTBBYnjBWZ3yzJZVur07A5azsoYiPsc/Hj4mj3NCLVtWVBhWjY1g828LVQrI+
	VDQAYnQCxBFWo1oN9tdfvl399LeR8rL8+2V0dXlOXeKjSRQn2H7G2e5KejU7LhzdWkKuC8lzddU
	27ZZQcGLe7VflEJGpHutahBNB0d2iXArT9XVif07jtZVjFYgwBVNsuAfHLD3rKzEmfKdfRGqrcx
	gqYzN+J8k7+UxwZ2aZrgydl5Bq8w3g==
X-Google-Smtp-Source: AGHT+IFikBPMpBDF7pd2lmWNowKlEuQrYWQcmYnDsTJx6agqxEvZabEob6zJiQBYVY3pZ7/94b/Img==
X-Received: by 2002:a17:902:e748:b0:215:577b:ab77 with SMTP id d9443c01a7336-21892a40509mr1511235ad.39.1734036245314;
        Thu, 12 Dec 2024 12:44:05 -0800 (PST)
Received: from dread.disaster.area (pa49-195-9-235.pa.nsw.optusnet.com.au. [49.195.9.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21674098324sm50638695ad.52.2024.12.12.12.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 12:44:04 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tLq2T-00000009wiF-3FPn;
	Fri, 13 Dec 2024 07:44:01 +1100
Date: Fri, 13 Dec 2024 07:44:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [RFC 2/3] xfs_io: Add ext4 support to show FS_IOC_FSGETXATTR
 details
Message-ID: <Z1tLEQmRiZc7alBo@dread.disaster.area>
References: <cover.1733902742.git.ojaswin@linux.ibm.com>
 <3b4b9f091519d2b2085888d296888179da3bdb73.1733902742.git.ojaswin@linux.ibm.com>
 <20241211181706.GB6678@frogsfrogsfrogs>
 <Z1oTOUCui9vTgNoM@dread.disaster.area>
 <20241212161919.GA6657@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212161919.GA6657@frogsfrogsfrogs>

On Thu, Dec 12, 2024 at 08:19:19AM -0800, Darrick J. Wong wrote:
> On Thu, Dec 12, 2024 at 09:33:29AM +1100, Dave Chinner wrote:
> > On Wed, Dec 11, 2024 at 10:17:06AM -0800, Darrick J. Wong wrote:
> > > On Wed, Dec 11, 2024 at 01:24:03PM +0530, Ojaswin Mujoo wrote:
> > > > Currently with stat we only show FS_IOC_FSGETXATTR details
> > > > if the filesystem is XFS. With extsize support also coming
> > > > to ext4 make sure to show these details when -c "stat" or "statx"
> > > > is used.
> > > > 
> > > > No functional changes for filesystems other than ext4.
> > > > 
> > > > Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> > > > ---
> > > >  io/stat.c | 38 +++++++++++++++++++++-----------------
> > > >  1 file changed, 21 insertions(+), 17 deletions(-)
> > > > 
> > > > diff --git a/io/stat.c b/io/stat.c
> > > > index 326f2822e276..d06c2186cde4 100644
> > > > --- a/io/stat.c
> > > > +++ b/io/stat.c
> > > > @@ -97,14 +97,14 @@ print_file_info(void)
> > > >  		file->flags & IO_TMPFILE ? _(",tmpfile") : "");
> > > >  }
> > > >  
> > > > -static void
> > > > -print_xfs_info(int verbose)
> > > > +static void print_extended_info(int verbose)
> > > >  {
> > > > -	struct dioattr	dio;
> > > > -	struct fsxattr	fsx, fsxa;
> > > > +	struct dioattr dio;
> > > > +	struct fsxattr fsx, fsxa;
> > > > +	bool is_xfs_fd = platform_test_xfs_fd(file->fd);
> > > >  
> > > > -	if ((xfsctl(file->name, file->fd, FS_IOC_FSGETXATTR, &fsx)) < 0 ||
> > > > -	    (xfsctl(file->name, file->fd, XFS_IOC_FSGETXATTRA, &fsxa)) < 0) {
> > > > +	if ((ioctl(file->fd, FS_IOC_FSGETXATTR, &fsx)) < 0 ||
> > > > +		(is_xfs_fd && (xfsctl(file->name, file->fd, XFS_IOC_FSGETXATTRA, &fsxa) < 0))) {
> > > 
> > > Urgh... perhaps we should call FS_IOC_FSGETXATTR and if it returns zero
> > > print whatever is returned, no matter what filesystem we think is
> > > feeding us information?
> > 
> > Yes, please. FS_IOC_FSGETXATTR has been generic functionality for
> > some time, we should treat it the same way for all filesystems.
> > 
> > > e.g.
> > > 
> > > 	if (ioctl(file->fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
> > > 		if (is_xfs_fd || (errno != EOPNOTSUPP &&
> > > 				  errno != ENOTTY))
> > > 			perror("FS_IOC_GETXATTR");
> > 
> > Why do we even need "is_xfs_fd" there? XFS will never give a
> > EOPNOTSUPP or ENOTTY error to this or the FS_IOC_GETXATTRA ioctl...
> 
> Yeah, in hindsight I don't think it's needed for FS_IOC_FSGETXATTR, but

*nod*

> it's definitely nice for XFS_IOC_FSGETXATTRA (which is not implemented
> outside xfs) so that you don't get unnecessary error messages on ext4.

I don't think we even need it for FS_IOC_GETXATTRA - if the
filesystem does not support that ioctl, we don't print the fields,
nor do we output an error.

After all, this "extended info" and it's only ever been printed
for XFS, so we can define whatever semantics we want for foreign
filesystem output right now. As long as XFS always prints the same
info as it always has (i.e. all of it), we can do whatever we want
with the foreign filesystem stuff.

Keep in mind that we don't need platform tests for XFS files - that
has already been done when the file was opened and the state stored
in file->flags via the IO_FOREIGN flag. We already use that in the
stat_f() to determine whether we print the "xfs info" or not.

IOWs, I think all we need to do is  move where we check the
IO_FOREIGN flag. i.e.:

print_extented_info(file)
{
	struct dioattr  dio = {};
        struct fsxattr  fsx = {}, fsxa = {};

	if (ioctl(file->fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
		perror("FS_IOC_GETXATTR");
		exitcode = 1;
		return;
	}

	printf(_("fsxattr.xflags = 0x%x "), fsx.fsx_xflags);
	printxattr(fsx.fsx_xflags, verbose, 0, file->name, 1, 1);
	printf(_("fsxattr.projid = %u\n"), fsx.fsx_projid);
	printf(_("fsxattr.extsize = %u\n"), fsx.fsx_extsize);
	printf(_("fsxattr.cowextsize = %u\n"), fsx.fsx_cowextsize);
	printf(_("fsxattr.nextents = %u\n"), fsx.fsx_nextents);

	/* Only XFS supports FS_IOC_FSGETXATTRA and XFS_IOC_DIOINFO */
	if (file->flags & IO_FOREIGN)
		return;

	if (ioctl(file->fd, FS_IOC_FSGETXATTRA, &fsxa)) < 0) {
		perror("FS_IOC_GETXATTRA");
		exitcode = 1;
		return;
	}
	if ((xfsctl(file->name, file->fd, XFS_IOC_DIOINFO, &dio)) < 0) {
		perror("XFS_IOC_DIOINFO");
		exitcode = 1;
		return;
	}

	printf(_("fsxattr.naextents = %u\n"), fsxa.fsx_nextents);
	printf(_("dioattr.mem = 0x%x\n"), dio.d_mem);
	printf(_("dioattr.miniosz = %u\n"), dio.d_miniosz);
	printf(_("dioattr.maxiosz = %u\n"), dio.d_maxiosz);
}

Thoughts?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
