Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2747647A88C;
	Mon, 14 Sep 2026 13:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789393987; cv=none; b=TpJs+UzsST2YipnWB7SqsfBCF6JIszkc46UENmKd7zB+P2E98VxbMACO1DyyoyidMLemSnXInH9kFyr4eACB5mjY9zx9m9+bOOViU/4SDH7zpAAnRHbTUKlcu9lzMTZzUNxO/m7VHAUl4ASjfL//c4/P3OnriQJqUIpSAhpvZkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789393987; c=relaxed/simple;
	bh=mlUfEIFV9BaRgiX9mO66IzROChje335W/BiQA2GTbVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KgAqGJlEW5MSCOHtXW/lRuU6M+LNgyVw+s1GX6wA95gwSrSrVsdVKZKG6UwGuTnN62FzcCAEIS62I0EH3AM2pIrAP2QLpthvhRezU8dKH9T18KhxLaGWr7whbmVVkjpRS9zEXnTCSdUR9pH7/Xj5+D7DcPU7xJctU0DdblgDTkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FeR2gWYH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FeR2gWYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7411F008A6;
	Mon, 14 Sep 2026 13:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789393980;
	bh=/SYe9Unw6oYBV280W7G2r7SKUU5ZsVcjnBx/IJ+taGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FeR2gWYH2doCt/XQ+7nwX9eFl4C5EtBE/49Z9o/3dj2X/alfYxFIx+MdmA7j6KAQl
	 VXW4qgCwQEItXzSW4NWs0UK3KZ0wVLUQWOZp/d+Xukp7BFPm7HdmjjOH3CYjE6zo3T
	 VEDy/tBxeiLTCwg/lAg4AtLHq7kQTepJHdxl2E4JOIBnIMaaG3bH7GRgsak3ouMHfW
	 naRij2M6tcst8O4c+nHE9hkEwMnpqgRaUwVxu9Zk/AWfqu/9mLSnuHjSLtqVIfci1I
	 N4NMjbxPwK4XJ4nx6FvQL7Q/guN3WkMarQVJfw3CzDBCmpLEJwsmvfTMI2Tsv1dIcD
	 c5IMfflTnLc3w==
Date: Mon, 14 Sep 2026 15:52:56 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	djwong@kernel.org
Subject: Re: [PATCH v3] man/man2: introduce man page for
 file_getattr/file_setattr syscalls
Message-ID: <aqf6qS4_CvLhg1o3@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260914111107.1735564-1-aalbersh@kernel.org>
 <aqfeV11OEqtb6nkt@devuan>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqfeV11OEqtb6nkt@devuan>

Hi Alejandro,

On 2026-09-14 14:43:36, Alejandro Colomar wrote:
> Hi Andrey,
> 
> > Date: 2026-09-14 13:11:05+0200
> > From: Andrey Albershteyn <aalbersh@kernel.org>
> >
> > Add manual pages for file_getattr() and file_setattr() syscalls and
> > struct file_attr used as input/output argument.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > Link: https://lore.kernel.org/all/20250630-xattrat-syscall-v6-0-c4e3bc35227b@kernel.org/
> > 
> > ---
> > Changes from v2:
> > - a few grammar fixes
> > - styling fixes
> > - sashiko.dev fixes (wrong AT_FDCWD combined with AT_EMPTY_PATH
> >   description, unused "dfd")
> 
> I'd appreciate if you didn't use sashiko for manual pages.
> <https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/CONTRIBUTING.d/ai>
> 
> > - dropped requirement to zero fattr before using file_setattr()
> > - Pathname -> path
> > - Dropped description of why FS_IOC_ aren't usable with special files
> > - Fixed backslashes in the code examples
> 
> It'd be very useful to see the range-diff too.
> <https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/CONTRIBUTING.d/patches/range-diff>
> 
> And it'd also be good to get the new versions of patches as replies to
> the first mail in v1.  That would allow one to find the entire
> discussion in one thread, with one subthread.
> <https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/CONTRIBUTING.d/patches/sendmail>

ok sure

[...]
> > +If
> > +.I size
> > +is larger than the kernel's structure size,
> > +the extra bytes are zeroed.
> 
> Hmmm, this seems to contradict the explanation from above.  I'll quote:
> 
> 	Userspace applications should zero-initialize
> 	.I struct file_attr
> 	before calling
> 	.BR file_getattr ()
> 	to ensure that fields not filled in by older kernels
> 	will have predictable values.
> 
> So, if old kernels zero any bytes between the (small) size supported by
> the kernel and the (large) size used by the user, why would the user
> need to zero them?  Isn't the kernel doing exactly that?

that's right, I removed this in file_setattr() but probably
forgot to remove it here.

[...]
> > +.SH DESCRIPTION
> > +The
> > +.BR file_setattr ()
> > +system call sets filesystem file attributes
> > +on the file.
> > +.P
> > +As with
> > +.BR openat (2),
> > +if
> > +.I path
> > +is relative,
> > +then it is interpreted relative to the directory
> > +referred to by the file descriptor
> > +.I dirfd
> > +(or the current working directory of the calling process,
> > +if
> > +.I dirfd
> > +is the special value
> > +.BR AT_FDCWD ).
> > +If
> > +.I path
> > +is absolute,
> > +then
> > +.I dirfd
> > +is ignored.
> 
> How about saying that the parameters 'dirfd', 'path', and 'flags' are
> interpreted like in file_getattr(2), and we save some paragraphs?
> 
> We'd also save the user from checking whether there's a tiny detail that
> differs, or if they are identical.
> 
> I have a long term plan of removing a lot of paragraphs in manual pages,
> by saying that some syscalls or functions behave exactly like others, at
> least for some parameters.

Sounds good, I will reference file_getattr then

[...]
> > +error.
> > +.SH VERSIONS
> > +.SS Structure size
> > +The structure size is defined by
> > +.B FILE_ATTR_SIZE_VER*
> > +which is also a version of the structure being used.
> 
> Why do those macros exist?  I expect users should just use sizeof(),
> right?  In fact, the example program doesn't show its use at all.
> Should we remove that macro entirely?

You're right, this is not necessary, the sizeof() is enough.

> 
> > +The
> > +.I size
> > +parameter passed to
> > +.BR file_getattr (2)
> > +and
> > +.BR file_setattr (2)
> > +indicates the version of
> > +.I struct file_attr\fP.
> > +.SS FILE_ATTR_SIZE_VER0
> > +Size is 24 bytes.
> 
> This implementation detail seems unnecessary for programmers.
> '24' is something programmers shouldn't know, IMO.

Yes, I will remove mentions of FILE_ATTR_SIZE_VER0

-- 
- Andrey
