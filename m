Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D4C2D6E5F
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 17:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754935153; cv=none; b=qM0l3v4cRiQ7YD8s72j/83qC22qcLVAT7jAD0kt97bL7odzPtt9qPL+7YZW4sSNlquDBZcVDug56BS67t4DaY0SJayGBPnXv9l9StjP70LlFielSrZIdT9hXQ4H+JmTVjfQoTGXh5AZE2OjT2xYP8rQqBPISj7dzWgu87iOM8NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754935153; c=relaxed/simple;
	bh=ef0lHlV8whRhwcKFAPcJboYQ2/ttMtt8/9vQeKgW1zA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XTpKbtRatenkn0JE7nBd4O7VVvFeRD68Bpq3/riAIrErloQbBZnZnqG0v+fWlLm9HcYOpNmz9PaNzbsCUSYK608YF7bB1V94Ny3vHv2GnGhDzbUIITvdvSrB+TDW6XZMAfRxrEbX6ySjKzTFeY3pcK+gnue5VZcqwDCJTJt+EpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HyfUCPlq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HyfUCPlq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754935151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+M89Chwaj/xYrETNJmbtBCPqSQalO6L7Aetkbd+RPKg=;
	b=HyfUCPlqDYrCwJwHX0korH7QbpjOyLVdMCndSafPL8evHPaXVp8AqzcQPsCsIUBtUfJXNi
	vG8kJeL0U0Lx+ZGOLPNDLSbSu7hkquYnZfL4hw/9JKniW3DI0IotcpuNzN+RZnkfTwKYUG
	uofMrHZiG++ULgxTr1sRDPE5Iwx7Pqg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-T4nPmx3qNfS4R9XoQgxQ7A-1; Mon, 11 Aug 2025 13:59:09 -0400
X-MC-Unique: T4nPmx3qNfS4R9XoQgxQ7A-1
X-Mimecast-MFC-AGG-ID: T4nPmx3qNfS4R9XoQgxQ7A_1754935148
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-458f710f364so30971885e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 10:59:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754935148; x=1755539948;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+M89Chwaj/xYrETNJmbtBCPqSQalO6L7Aetkbd+RPKg=;
        b=scKKomat78VVIsePwoqNQ0zq4N5rAuhbIo5mK5RGoN+TjhjHgamVRnyL6SsRDn1CPA
         cyDPbYhK1MjuG1Ev6i9NBxZv+w2lyxBDShGQx1FQu7Y90S0flkB8wVLufrz156GCM8lH
         AzMRL4gw6s6DHZrWztmK3ximHU6gXaJN1nSpKciV/pEvKendPyOfk8MyB0CK5NsffJd/
         zmKXe/DcVqLFG9hByrJr0ZtE/x+iTcNV4hlKtqIE52uzVziFtiN9IPDI6IBF42lITnP4
         2soZtOaqu0gKMOyD+nTnMN5xn6YfQAndyqQXri4cGd4Q8afEf2sE1nbN2o+C590pQDdH
         Ge0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVQPlxVeerpoBzZ2h+rDl8g4VSPTsZf87BW7Ciw7u8U9E09pr0ZlgnrVSDJqBy6yUW1XDLQm6gzRNs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKsBxzZaz63pM2CFk42O0veNjI5AyeHOfnHWw425n8cKVyT2Qu
	5Q1PH9+yI47cFx1T4CMRxcy32Sx1HNqp+MAAksZsG4DiywmjCeZTrsm3RsuG8JJGf/70NWKadZP
	hJMdA5B0cbI3mrvu/DJNjh0RAhFDQxetHX4uyKxRPER9Ytl+bL7jwioLtLQ2G
X-Gm-Gg: ASbGncv8Z4iAQ/q8CEFh0ZSUoFv1SScWymLqhY+lzZUiOc2FpQzd6KYQJCkLAAD3gdF
	OA/e/NwPUtMRfJ6ny8uvuW2qcSDx+8E/bSyxZxJs/LyEGhqEBqu/8M5GbsLmyq/dGhFECE/GQTB
	O0MhUvoLPX3pIUUc/kzrB9ZYHwePUO7InJNqi1YYorGXnF6uWmrRmuyi9pnh/riRhb6h4vWoccn
	+3ccCepqX1i9MJpgxJobhR2upfTI1I1QqhMccxe4kL4+gHHPLgryfYRXcz++Q7dPChFuAgEpReX
	ZscCIXb3bXJDmV5Pq848DO37Jnb462tjPjDKoipPePusUrkkYDTSPQFbOaA=
X-Received: by 2002:a05:600c:1d0c:b0:453:2066:4a26 with SMTP id 5b1f17b1804b1-45a10be7d2bmr4990075e9.16.1754935147900;
        Mon, 11 Aug 2025 10:59:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzsgz1alcX9iZ1OGeIMnBeRHC4issJV1QBepTpHigMvpYiWbPyRpe1aEDnnFUPg8J84MI5HA==
X-Received: by 2002:a05:600c:1d0c:b0:453:2066:4a26 with SMTP id 5b1f17b1804b1-45a10be7d2bmr4989885e9.16.1754935147439;
        Mon, 11 Aug 2025 10:59:07 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458b8aab8c0sm398414305e9.19.2025.08.11.10.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 10:59:07 -0700 (PDT)
Date: Mon, 11 Aug 2025 19:59:06 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_db: use file_setattr to copy attributes on
 special files with rdump
Message-ID: <gi3zx7yt3jhq726vbcs5rpp7cpqp7fu5hkul4fbdxowxypa5kw@ii7tj7ckhyvs>
References: <20250808-xattrat-syscall-v1-0-48567c29e45c@kernel.org>
 <20250808-xattrat-syscall-v1-4-48567c29e45c@kernel.org>
 <20250811151427.GD7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811151427.GD7965@frogsfrogsfrogs>

On 2025-08-11 08:14:27, Darrick J. Wong wrote:
> On Fri, Aug 08, 2025 at 09:30:19PM +0200, Andrey Albershteyn wrote:
> > rdump just skipped file attributes on special files as copying wasn't
> > possible. Let's use new file_getattr/file_setattr syscalls to copy
> > attributes even for special files.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  db/rdump.c | 24 +++++++++++++++++++++---
> >  1 file changed, 21 insertions(+), 3 deletions(-)
> > 
> > diff --git a/db/rdump.c b/db/rdump.c
> > index 9ff833553ccb..5b9458e6bc94 100644
> > --- a/db/rdump.c
> > +++ b/db/rdump.c
> > @@ -17,6 +17,7 @@
> >  #include "field.h"
> >  #include "inode.h"
> >  #include "listxattr.h"
> > +#include "libfrog/file_attr.h"
> >  #include <sys/xattr.h>
> >  #include <linux/xattr.h>
> >  
> > @@ -152,10 +153,17 @@ rdump_fileattrs_path(
> >  	const struct destdir	*destdir,
> >  	const struct pathbuf	*pbuf)
> >  {
> > +	struct file_attr	fa = {
> > +		.fa_extsize	= ip->i_extsize,
> > +		.fa_projid	= ip->i_projid,
> > +		.fa_cowextsize	= ip->i_cowextsize,
> > +		.fa_xflags	= xfs_ip2xflags(ip),
> > +	};
> >  	int			ret;
> > +	int			at_flags = AT_SYMLINK_NOFOLLOW;
> 
> Why does this become a mutable variable?  AFAICT it doesn't change?
> 
> Otherwise things look good here.

ops, leftover from older version, will pass it in place

> 
> --D
> 
> >  
> >  	ret = fchmodat(destdir->fd, pbuf->path, VFS_I(ip)->i_mode & ~S_IFMT,
> > -			AT_SYMLINK_NOFOLLOW);
> > +			at_flags);
> >  	if (ret) {
> >  		/* fchmodat on a symlink is not supported */
> >  		if (errno == EPERM || errno == EOPNOTSUPP)
> > @@ -169,7 +177,7 @@ rdump_fileattrs_path(
> >  	}
> >  
> >  	ret = fchownat(destdir->fd, pbuf->path, i_uid_read(VFS_I(ip)),
> > -			i_gid_read(VFS_I(ip)), AT_SYMLINK_NOFOLLOW);
> > +			i_gid_read(VFS_I(ip)), at_flags);
> >  	if (ret) {
> >  		if (errno == EPERM)
> >  			lost_mask |= LOST_OWNER;
> > @@ -181,7 +189,17 @@ rdump_fileattrs_path(
> >  			return 1;
> >  	}
> >  
> > -	/* Cannot copy fsxattrs until setfsxattrat gets merged */
> > +	ret = file_setattr(destdir->fd, pbuf->path, NULL, &fa, at_flags);
> > +	if (ret) {
> > +		if (errno == EOPNOTSUPP || errno == EPERM || errno == ENOTTY)
> > +			lost_mask |= LOST_FSXATTR;
> > +		else
> > +			dbprintf(_("%s%s%s: file_setattr %s\n"), destdir->path,
> > +					destdir->sep, pbuf->path,
> > +					strerror(errno));
> > +		if (strict_errors)
> > +			return 1;
> > +	}
> >  
> >  	return 0;
> >  }
> > 
> > -- 
> > 2.49.0
> > 
> > 
> 

-- 
- Andrey

