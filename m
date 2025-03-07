Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5952E219E98
	for <linux-xfs@vger.kernel.org>; Fri,  7 Mar 2025 18:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741372997; cv=none; b=NkbwUcOG0CTyfl+UToNQaRCp2gcmKHr+x4cgZWhI38FtrSdsHdbhdv001Q9A4p0204S+lIQsLBS6ad1ozgR2nl1HlJzQupdwkRPbjQWeplQ4X1bkAo3ij/v3ByoEtoOn257Bm9vDW03bPPLMMoCqAj9yige4C/9iiZ9tZwo4YmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741372997; c=relaxed/simple;
	bh=NN/Qu3CPnQShxCtND9NOjW7QqV4zGDWuCzxNm4T/96k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VI6obwaWADfVNb5K8SZzayjdGLgHwGC7US5GBr+to5rdOJ5GsTWJyI8lGQTYYYpQoc0KDu5d0seJGBBY1/MXHxuxK1SVrOYm2ubczXasJePCJtxH16cOFdTq+e69npwZsMajhkUB0Z9dSoW8m1YgObhAFrUhKpQzS6bMIoMk9cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YKesZMLg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YKesZMLg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741372994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xha3mC4RM8CGcAJZgk81Myst1aIAt6KmyhDLE7ZBOjk=;
	b=YKesZMLgsU4oo30qRuL5fN3DDWSOlbReeQNzhnchoYXJsHdxvJyoNKgkRHmqid+HD2R69P
	KjMxMmXmTWT8wS789wEr2YU/qOy3/OVDiVfVmaKTuPb8X4Z378sB4BOpFL5MSWrMdHvVAl
	gSl+BPnanLeM8QDzllZArz2E7Wh0qpg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-94-06ofkwn4NQ-MF6SkWlD2xw-1; Fri,
 07 Mar 2025 13:43:11 -0500
X-MC-Unique: 06ofkwn4NQ-MF6SkWlD2xw-1
X-Mimecast-MFC-AGG-ID: 06ofkwn4NQ-MF6SkWlD2xw_1741372990
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B37621956087;
	Fri,  7 Mar 2025 18:43:09 +0000 (UTC)
Received: from redhat.com (unknown [10.22.64.191])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD4F2300019E;
	Fri,  7 Mar 2025 18:43:07 +0000 (UTC)
Date: Fri, 7 Mar 2025 12:43:03 -0600
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kjetil Torgrim Homme <kjetilho@ifi.uio.no>, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: [PATCH] xfs_{admin,repair},man5: tell the user to mount with
 nouuid for snapshots
Message-ID: <32rk6ymwr2fvisnvp3zawgwrk7xjedafwszq4k33c2cozcarmm@4ix7lgzlnsx5>
References: <20250307175501.GS2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250307175501.GS2803749@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Mar 07, 2025 at 09:55:01AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Augment the messaging in xfs_admin and xfs_repair to advise the user to
> replay a dirty log on a snapshotted filesystem by mounting with nouuid
> if the origin filesystem is still mounted.  A user accidentally zapped
> the log when trying to mount a backup snapshot because the instructions
> we gave them weren't sufficient.
> 
> Reported-by: Kjetil Torgrim Homme <kjetilho@ifi.uio.no>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  db/sb.c         |    9 +++++----
>  man/man5/xfs.5  |    5 +++++
>  repair/phase2.c |    9 +++++----
>  3 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/db/sb.c b/db/sb.c
> index aa8fce6712e571..52ac48d45d5ae6 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -266,10 +266,11 @@ sb_logcheck(void)
>  		dbprintf(_(
>  "ERROR: The filesystem has valuable metadata changes in a log which needs to\n"
>  "be replayed.  Mount the filesystem to replay the log, and unmount it before\n"
> -"re-running %s.  If you are unable to mount the filesystem, then use\n"
> -"the xfs_repair -L option to destroy the log and attempt a repair.\n"
> -"Note that destroying the log may cause corruption -- please attempt a mount\n"
> -"of the filesystem before doing this.\n"), progname);
> +"re-running %s.  If the filesystem is a snapshot of a mounted filesystem,\n"
> +"you may need to give mount the nouuid option.  If you are unable to mount\n"
> +"the filesystem, then use the xfs_repair -L option to destroy the log and\n"
> +"attempt a repair.  Note that destroying the log may cause corruption --\n"
> +"please attempt a mount of the filesystem before doing this.\n"), progname);
>  		return 0;
>  	}
>  	/* Log is clean */
> diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
> index 0c1edc53e227ce..f9c046d4721a14 100644
> --- a/man/man5/xfs.5
> +++ b/man/man5/xfs.5
> @@ -91,6 +91,11 @@ .SH DESCRIPTION
>  and
>  .BR xfsrestore (8)
>  are recommended for making copies of XFS filesystems.
> +To mount a snapshot of an already-mounted filesystem, you may need to supply
> +the
> +.B nouuid
> +option to
> +.BR mount " (8)."
>  .SH OPERATIONS
>  Some functionality specific to the XFS filesystem is accessible to
>  applications through the
> diff --git a/repair/phase2.c b/repair/phase2.c
> index 29a406f69ca3a1..9a9733749266e5 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -72,10 +72,11 @@ zero_log(
>  				do_warn(_(
>  "ERROR: The filesystem has valuable metadata changes in a log which needs to\n"
>  "be replayed.  Mount the filesystem to replay the log, and unmount it before\n"
> -"re-running xfs_repair.  If you are unable to mount the filesystem, then use\n"
> -"the -L option to destroy the log and attempt a repair.\n"
> -"Note that destroying the log may cause corruption -- please attempt a mount\n"
> -"of the filesystem before doing this.\n"));
> +"re-running xfs_repair.  If the filesystem is a snapshot of a mounted\n"
> +"filesystem, you may need to give mount the nouuid option.If you are unable\n"
> +"to mount the filesystem, then use the -L option to destroy the log and\n"
> +"attempt a repair.  Note that destroying the log may cause corruption --\n"
> +"please attempt a mount of the filesystem before doing this.\n"));
>  				exit(2);
>  			}
>  		}
> 

