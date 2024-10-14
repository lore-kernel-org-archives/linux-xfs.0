Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E678C1AF4E2
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 15:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728921469; cv=none; b=sQA/FU586KybKSpuk+E+g2MG50lQqEoBjaipqMSNvrzlUZPSk6WERZJeUhMXxG5PJcwOyKcoti3x8YToy1xCgU+gFBV29N2dOozyi2Ca91xe6cLE2XBxA6PVTJROQHedrWskOEcJ69xHRlQZgp2kBXW1+wfDO/1ZzAa99AZT6oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728921469; c=relaxed/simple;
	bh=+buNy0g+JjO6nwiBeYM0jRkXzzScx/l1b0NrsWUBKB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=orV98l1ZTsxBJZSFBC3td4E2hYQlSMmovHP6aEpZVmuCTHRepNr5cMNFxt7rFBSeSchoiKWXE7ZopZ4XrxmClxVi5mvYSjJkvqwqHseDJ9DFj68MV++pDw1PmVYeZ9lDei4nIRVmXec3nv66oARmA6weKjNsYyI//olAT6mFFY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XcD1DSr6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XcD1DSr6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728921466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pF6h7VhHHBGfGvVXA7QvUSygCzoMMI9fdNXh9FBZTJw=;
	b=XcD1DSr6FDBJUjWhKecwP/nSKEV8YP50icr1qN3/pxjfKkFwdNI2CugXkLEE/Ktj7HWWKK
	tfqgHASfDbREiKIwt90r+CW2ETfMj01dW721lDnSxkCzy5hoWllLss4AiCGrttyH8+qMHL
	sFQdvZaDphytxeDCbjotUgNXEOBs4xU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-124-SqwDTzCJPqi9hleh9Jd4EQ-1; Mon,
 14 Oct 2024 11:57:41 -0400
X-MC-Unique: SqwDTzCJPqi9hleh9Jd4EQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFFF71955EB3;
	Mon, 14 Oct 2024 15:57:39 +0000 (UTC)
Received: from ws.net.home (unknown [10.45.224.59])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6323D19560AA;
	Mon, 14 Oct 2024 15:57:37 +0000 (UTC)
Date: Mon, 14 Oct 2024 17:57:34 +0200
From: Karel Zak <kzak@redhat.com>
To: Alan Huang <mmpgouride@gmail.com>
Cc: util-linux@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hongbo Li <lihongbo22@huawei.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: Libmount bug ?
Message-ID: <iipuwlnf73x3zjj4kgpgqqvu4u5t4iefg3qawqgzvl546rrbz5@w7tvj3jr5h2v>
References: <14ADF290-5B46-44D5-83BC-9AE3732B192C@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <14ADF290-5B46-44D5-83BC-9AE3732B192C@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40


 Hi Alan,

On Sat, Oct 12, 2024 at 04:57:39PM GMT, Alan Huang wrote:
> The bcachefs has the helper called mount.bcachefs.

do you mean the following script?
https://evilpiepirate.org/git/bcachefs-tools.git/tree/mount.bcachefs.sh

I believe that if you call the regular mount(8) from the script, then
it's probably fine to not worry about the options. mount(8) will be
able to ignore them.

> Currently, there are users using fstab with nofail/user fail to mount,
> we would like to know whether other filesystems using similar helper
> properly handle this.

The mount.nfs command uses libmount internally to generate the
mount(2) syscall flags, so it is not affected by any additional
options.

The mount.fuse command has a list of unwanted mount options:
https://github.com/libfuse/libfuse/blob/master/util/mount.fuse.c#L318-L326

Please note that the "EXTERNAL HELPERS" section in the mount(8) man
page describes which options are ignored.

Also, if your mount helper is setuid (like mount.nfs), you still need
to parse fstab to obtain mount options from a safe source. This is
because options from the command line should be ignored as they are
considered unsafe.

> 
> This is like commit 06e05eb0f78566b68c44328c37d7c28d8655e9df 
> (“libmount: don't pass option "defaults" to helper")
> 
> Or would you like something like this? This might be incomplete though (e.g. owner, noowner etc.)
> 
> diff --git a/libmount/src/optmap.c b/libmount/src/optmap.c
> index d7569a0f0..c13b9ba19 100644
> --- a/libmount/src/optmap.c
> +++ b/libmount/src/optmap.c
> @@ -152,11 +152,11 @@ static const struct libmnt_optmap userspace_opts_map[] =
>     { "auto",    MNT_MS_NOAUTO, MNT_NOHLPS | MNT_INVERT | MNT_NOMTAB },  /* Can be mounted using -a */
>     { "noauto",  MNT_MS_NOAUTO, MNT_NOHLPS | MNT_NOMTAB },  /* Can only be mounted explicitly */
> 
> -   { "user[=]", MNT_MS_USER },                             /* Allow ordinary user to mount (mtab) */
> -   { "nouser",  MNT_MS_USER, MNT_INVERT | MNT_NOMTAB },    /* Forbid ordinary user to mount */
> +   { "user[=]", MNT_MS_USER, MNT_NOHLPS},                             /* Allow ordinary user to mount (mtab) */

This may cause issues with certain helpers (e.g. cifs) where "user="
is a standard option. However, this is something that needs to be
addressed in libmount, as it already handles this use-case for cifs.
The use of MNT_NOHLPS may override this.

> +   { "nouser",  MNT_MS_USER, MNT_INVERT | MNT_NOMTAB | MNT_NOHLPS},    /* Forbid ordinary user to mount */
> 
> -   { "users",   MNT_MS_USERS, MNT_NOMTAB },                /* Allow ordinary users to mount */
> -   { "nousers", MNT_MS_USERS, MNT_INVERT | MNT_NOMTAB },   /* Forbid ordinary users to mount */
> +   { "users",   MNT_MS_USERS, MNT_NOMTAB | MNT_NOHLPS},                /* Allow ordinary users to mount */
> +   { "nousers", MNT_MS_USERS, MNT_INVERT | MNT_NOMTAB | MNT_NOHLPS},   /* Forbid ordinary users to mount */
> 
>     { "owner",   MNT_MS_OWNER, MNT_NOMTAB },                /* Let the owner of the device mount */
>     { "noowner", MNT_MS_OWNER, MNT_INVERT | MNT_NOMTAB },   /* Device owner has no special privs */
> @@ -180,7 +180,7 @@ static const struct libmnt_optmap userspace_opts_map[] =
>     { "sizelimit=", MNT_MS_SIZELIMIT, MNT_NOHLPS | MNT_NOMTAB },	   /* loop device size limit */
>     { "encryption=", MNT_MS_ENCRYPTION, MNT_NOHLPS | MNT_NOMTAB },	   /* loop device encryption */
> 
> -   { "nofail",  MNT_MS_NOFAIL, MNT_NOMTAB },               /* Do not fail if ENOENT on dev */
> +   { "nofail",  MNT_MS_NOFAIL, MNT_NOMTAB | MNT_NOHLPS},               /* Do not fail if ENOENT on dev */

Could this option be usable for some helpers?

I believe the best solution is to follow the Fuse way and define a
list of options to ignore in your fs-specific helper.

The ideal solution would be to implement a better libmount (perhaps
libmount2) where the /sbin/mount.<type> helpers are replaced with
dlopen() modules. This way, the library would handle all the details
such as command line and fstab options.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

