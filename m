Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDCF79DCA
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 22:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589756; cv=none; b=JTPcvHgtzjgeE92YogbmWbnDmPBMud2vAMgla5iFBk71fHmEKXc6yWfcXcCu7AT1LUlufnMU4LfncZp5rNBTfJn6vcIZDpw2SRkZ+emjBK4uepw3oQoR35s7olGuSmifLbfr2nKcp7h8zLLN9tkKjFgAQPOzbozCPVZdERTSaLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589756; c=relaxed/simple;
	bh=PxgCv1xzZmhxk+5KTIdHqPhvX38K1jPFDD1q6fBjSeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hly+TI/ptl+ggrfEjLydQp8eP73o1RGzNN485o0iBh3Gs5MCjeceG321fsu0Kf6ufC+744E5f4VmROBGwwe+SOh5oSFftMjS0vh2b5QMS8VmeKuwq2rxXM3o44dcSqQjEtcA7Gz79ZdBjmIsOgxYnhxqViE0lG38sC6OmaPzs0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Do90Iayl; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Do90Iayl"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5d8b276979aso3659868a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 14:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709589753; x=1710194553; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UPT7qKYJtYEG14x2vaIsLF4YqSY7OCBjPVkjFmTBKcA=;
        b=Do90Iayl87GoPEWahOTVj8Y1dE3h4eIpO+WzO9RuCdYlzzhrWOtrIzvsr00lXqHKdf
         cnd6UovWA4OKcVIRijG8s00r1uyH8IsCZ9O6OEOqxAiQjHY36FOu4BCym3d3jrTTRFNP
         xjqYBzoKacEr1MgGVI+AoqUhWUKA8vmWLkOAUqbQ52Uw4t8ZL8JcjC52wfyCzDA2l6Yq
         1M1atTJyEnU/bMUZ6qPLJpwNT08lzmVmZCMLcPVVw+L8QqVaLkvDCQQVzmGsGN1lyAAe
         FEHH1nhjruZBYF0jdMmIVQir++ZWCtNUp7bXrSqvkTDRrIluLdp6z6B7seYICeFKjXkx
         Wf2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709589753; x=1710194553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UPT7qKYJtYEG14x2vaIsLF4YqSY7OCBjPVkjFmTBKcA=;
        b=pyjWrkMtAhq0bpOHrfAkqnDZ6pmQNCUstUnLYepxt5r+mhgnf87f857OuGgYFxYtIB
         qwQU1VeS+0z1b9Dj5GWnFLak5cHqGv4eDMWd9dsB8VRboYZC5BZfZXgRG5/BYXvDnnFr
         dbo0eCI8gIFkVOROxAFLKLSndmOBgkYfuLXS3SDIldet8GiXLN7OPeGHRGsokfmV22uS
         M1oN8n01xfvYmVGvMe76PTAEo7EnzOzo8PQqEiJxZrQnXDMUG8tVMf4Edvjs/qPWGomO
         6VaiZ2W2LzpmQEVQ4QV7SdS769ENh7uP2+zisVgypR8p9B9pRADKtamfsvk8+qC5KeR4
         X6IQ==
X-Gm-Message-State: AOJu0YyLC/MgwTCARh4bAkvZWpdaZkDd5h3spIx2ZG/BOpwBeOHPjPYQ
	PyIeOWQBvJt4I37J6xGaT9wysiNbv2Y6KSGyOKaKUt0q9lhv+P6ZkPDHPdGBDWo=
X-Google-Smtp-Source: AGHT+IGDKaW+p6accsX8sBx9qWgSKW+7eoGdeRhzoClzdXXlDHiVc8S03Pq0PKUsaAYZVYzRmItX2Q==
X-Received: by 2002:a17:90a:ca8e:b0:29b:4dfc:7107 with SMTP id y14-20020a17090aca8e00b0029b4dfc7107mr3360884pjt.38.1709589752932;
        Mon, 04 Mar 2024 14:02:32 -0800 (PST)
Received: from dread.disaster.area (pa49-181-192-230.pa.nsw.optusnet.com.au. [49.181.192.230])
        by smtp.gmail.com with ESMTPSA id q14-20020a17090aa00e00b0029b32b85d3dsm4730701pjp.29.2024.03.04.14.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 14:02:32 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rhGOD-00F5Fv-1r;
	Tue, 05 Mar 2024 09:02:29 +1100
Date: Tue, 5 Mar 2024 09:02:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com, djwong@kernel.org
Subject: Re: [PATCH] xfs: allow cross-linking special files without project
 quota
Message-ID: <ZeZE9WtwyQq988yb@dread.disaster.area>
References: <20240304155013.115334-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240304155013.115334-2-aalbersh@redhat.com>

On Mon, Mar 04, 2024 at 04:50:14PM +0100, Andrey Albershteyn wrote:
> There's an issue that if special files is created before quota
> project is enabled, then it's not possible to link this file. This
> works fine for normal files. This happens because xfs_quota skips
> special files (no ioctls to set necessary flags). The check for
> having the same project ID for source and destination then fails as
> source file doesn't have any ID.
> 
> mkfs.xfs -f /dev/sda
> mount -o prjquota /dev/sda /mnt/test
> 
> mkdir /mnt/test/foo
> mkfifo /mnt/test/foo/fifo1
> 
> xfs_quota -xc "project -sp /mnt/test/foo 9" /mnt/test
> > Setting up project 9 (path /mnt/test/foo)...
> > xfs_quota: skipping special file /mnt/test/foo/fifo1
> > Processed 1 (/etc/projects and cmdline) paths for project 9 with recursion depth infinite (-1).
> 
> ln /mnt/test/foo/fifo1 /mnt/test/foo/fifo1_link
> > ln: failed to create hard link '/mnt/test/testdir/fifo1_link' => '/mnt/test/testdir/fifo1': Invalid cross-device link
> 
> mkfifo /mnt/test/foo/fifo2
> ln /mnt/test/foo/fifo2 /mnt/test/foo/fifo2_link
> 
> Fix this by allowing linking of special files to the project quota
> if special files doesn't have any ID set (ID = 0).

Reasonable.

> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 5ca561634164..641270f4d794 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1232,11 +1232,24 @@ xfs_link(
>  	 * the tree quota mechanism could be circumvented.
>  	 */
>  	if (unlikely((tdp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
> +		     !special_file(VFS_I(sip)->i_mode) &&
>  		     tdp->i_projid != sip->i_projid)) {
>  		error = -EXDEV;
>  		goto error_return;
>  	}
>  
> +	/*
> +	 * Don't allow cross-linking of special files. However, allow
> +	 * cross-linking if original file doesn't have any project.
> +	 */

The comment should explain why the code exists, not document what
the code does.

> +	if (unlikely((tdp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
> +				special_file(VFS_I(sip)->i_mode) &&
> +				sip->i_projid != 0 &&
> +				tdp->i_projid != sip->i_projid)) {
> +		error = -EXDEV;
> +		goto error_return;
> +	}

I think this would be better written as:

	/*
         * If we are using project inheritance, we only allow hard link
         * creation in our tree when the project IDs are the same; else
         * the tree quota mechanism could be circumvented.
         */
	if ((tdp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
	    tdp->i_projid != sip->i_projid) {
		/*
		 * Project quota setup skips special files which can
		 * leave inodes in a PROJINHERIT directory without a
		 * project ID set. We need to allow links to be made
		 * to these "project-less" inodes because userspace
		 * expects them to succeed after project ID setup,
		 * but everything else should be rejected.
		 */
		if (!special_file(VFS_I(sip)->i_mode) ||
		    sip->i_projid != 0) {
			error = -EXDEV;
			goto error_return;
		}
	}

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
