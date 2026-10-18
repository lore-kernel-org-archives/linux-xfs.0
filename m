Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86641388E58
	for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2026 18:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792348969; cv=none; b=u9lCxLh8Qx1T3f2kGAbxevqk8Rpj5bQS2HTUvniDUe7epU3JMYMwzfp5sTCsHe+eBw6JUk/Mb5YOLTz4tk6/7IPj8YwBDt0v9umMpFkaM/KUkusBs0E7vzJIKwUgQk3yGaGuXHAcqaR7aVJ75TvUdv7nfusyj8mSyjtKo8ZRKNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792348969; c=relaxed/simple;
	bh=duSlFJ04CbL9RpkUPdeC3OuYQtGKWzTHho3DtsVK+PY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aOgV0+WT62eWMH/LwMn5XcB479qmW+PkuOd94CL9Pvb7gMFPk8A+MIKGi35dIqvRhASC/rAcrxPpS9RmHJXlXQ/v/2ow736wwtbQFi0z68LYJafj+rfGf1I2OL6ZTKzoTjLJVzw/dePM+vyCHSDAqRDTYlAfGxZy6e6uOzp43js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1tHXGar; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1tHXGar"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 15BDA1F000C4;
	Sun, 18 Oct 2026 18:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792348968;
	bh=BmQhBBw4CUY8q0vQFfn/j1gPwVJWCkAjKj/0vwxLjkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C1tHXGarFMDRIRDwd/sp95rYaofTQ/Eq0Cot9zG7+fPWbS/NLz3/CIUoigG1d1urG
	 3HEnKAIyp0vb/5XXjBMlCook0Iu9YpaAIgSeyE3dltUKLfZmWlS80ePw8butPZhpR/
	 GMXBhPedVbpG795JGl6tZOtKFWT7xds6w4w45Y6Yh4pVOuw0HT05kRwDn+qhR4xxA0
	 q4dYSJHi4ldoS8XhUPlXijLj9wE/VVBkG+zbILSTviDNBNo84AtRcT3EMMOQwUZEkV
	 L0GWFapNmpzJR6iNUGwS3F9745Ns0Z1twJP/dsThcXpflbLZ7XmuK9ACd4hN4zUmAN
	 s8ipjBSBCxNwg==
Date: Sun, 18 Oct 2026 11:42:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chris Thomas <chris.alex.thomas@gmail.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: [PATCH] xfs_db: read a shortform parent pointer's value after
 its name
Message-ID: <20261018184247.GO107986@frogsfrogsfrogs>
References: <CAGhPht=eDTJa45teW7xO_NvdpjybZdK3zFNCgd_YBFa=AxiTJQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGhPht=eDTJa45teW7xO_NvdpjybZdK3zFNCgd_YBFa=AxiTJQ@mail.gmail.com>

On Sat, Oct 17, 2026 at 02:09:57PM +0200, Chris Thomas wrote:
> list_sf_pptrs() passes pptr_emit() the value of each shortform attribute
> entry at sfe->nameval + sfe->valuelen. The value follows the name, so it
> starts at sfe->nameval + sfe->namelen, which is where libxfs reads it
> (xfs_attr_shortform_getvalue) and where xfs_db's own "print a" decoder
> reads it (db/attrshort.c).
> 
> Because a parent pointer's value is always 12 bytes, the record is decoded
> from the right place only when the name is also exactly 12 bytes long. For
> any other name, libxfs_parent_from_attr() rejects the bytes it is given and
> pptr_emit() returns silently, so "parent" lists nothing and exits 0. The
> leaf and node listings are not affected.
> 
> Reproducer, on a filesystem made entirely by mkfs, with xfsprogs built
> from master (7.2.0):
> 
>   cat > proto <<'EOF'
>   /dev/null
>   0 0
>   d--755 0 0
>   a ---644 0 0 /dev/null
>   twelve_chars ---644 0 0 /dev/null
>   thirteen_char ---644 0 0 /dev/null
>   $
>   EOF
>   truncate -s 512M img
>   mkfs.xfs -q -f -n parent=1 -p proto img
>   for n in a twelve_chars thirteen_char; do
>           echo "/$n:"; xfs_db -r -c "path /$n" -c parent img
>   done
>   xfs_repair -n img; echo "xfs_repair -n: $?"
> 
> Each of the three files has one shortform parent pointer to the root
> directory, and xfs_repair -n accepts the filesystem (exit status 0).
> 
> Before this patch only the 12-byte name is listed:
> 
>   /a:
>   /twelve_chars:
>                  128:0x00000000  12 twelve_chars
>   /thirteen_char:
> 
> After it, all three are:
> 
>   /a:
>                  128:0x00000000   1 a
>   /twelve_chars:
>                  128:0x00000000  12 twelve_chars
>   /thirteen_char:
>                  128:0x00000000  13 thirteen_char
> 
> Fixes: 34d3b1079425 ("xfs_db: add a parents command to list the
> parents of a file")
> Signed-off-by: Christopher Thomas <chris.thomas@antimatter-studios.com>
> ---
>  db/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/db/namei.c b/db/namei.c
> index 6e5d0ac..a734705 100644
> --- a/db/namei.c
> +++ b/db/namei.c
> @@ -701,7 +701,7 @@ list_sf_pptrs(
>   sfe = libxfs_attr_sf_firstentry(hdr);
>   for (i = 0; i < hdr->count; i++) {
>   pptr_emit(ip, sfe->flags, sfe->nameval, sfe->namelen,
> - sfe->nameval + sfe->valuelen, sfe->valuelen);
> + sfe->nameval + sfe->namelen, sfe->valuelen);

Patch is severely corrupted by your MUA (gmail?) and probably won't
apply but the code change is correct.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
>   sfe = xfs_attr_sf_nextentry(sfe);
>   }
> 
