Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E505818EB8
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 23:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721689522; cv=none; b=R0QEtLWIxol+Wc6IRF5yeOCVRmQ+FOgWYcP13VtQlzh4qpAmcfZAo0H15cA9CYrqKEVyKig2MCz1EMfUt74GbEhQI1DxbVMA5jxRav3r7daLLiddX0TpeHBYF+w5KIiSMwe3nxXibi+hbI4sjtValDttvmK9ePEhLCFcPJp41rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721689522; c=relaxed/simple;
	bh=oef0Keg4UguIfqqR/VDsMBztsvwUweTi8Mnkh2ed4+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ACc7DcSj2bdqRMfnKy3PmjG6B8W4LTwi4plBtyVHbley60LaBvcnDxXTTtdMnmeEcQ7u/5FLjVU5TNu3XkkKin6UUilWb0eMK/jRgSwgvVZ8twhn/y2K9sppvJuh30bBnDQgvPZa1JN6EfCNMXsakfB+eJ+OnpvgBtw3ROvnSss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=OqgQbpgq; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="OqgQbpgq"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1fd66cddd07so1370615ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 16:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721689519; x=1722294319; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k0LVNU78Mqy232XBpjdVCQU+kdT/t22PITQu/WomBTM=;
        b=OqgQbpgqloMiFsQkv+oFbn4GIleTtGR1KvnTjHH8/7UTrf8gdaQPYKBXIT6ZAfb5MD
         AU/ffSCJPynLEYelA/UGXP414E7ClPvfeHH/WiKi+rdi4OVtL8MT7t9tnWhgm1oOgU76
         mHUPyggPk3+nfOuJFBBsn9qW+9JHUZ+RSc7kP+M7Tcm/tzOHYn0S8aiMFSGG6CpsuAJT
         j9H2uKR2FT2ohRoWCmvpqRL+6Fdy7+59cG6GXuo8IObze/Cqiw/8JIBeEFCZjdN5rFgb
         6y698vntjsi4NZ0zKHwwIyvu1kURwoAze8FjJ6u9pgxnm0juYRMKaNZCrALGg7VDE+JL
         yvJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721689519; x=1722294319;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k0LVNU78Mqy232XBpjdVCQU+kdT/t22PITQu/WomBTM=;
        b=eH/OO48B5UgWH/vMdka4G3k/wjWLjI67K/Q2TCZjiUWSl4B2TIKL+aD3L7al/5ZQSP
         rNL93dWaj/5gP9XQYyZ4c+Ge0WMXLzQlVVYepufBnozrCYijqN0lyHcuDWNeJw2LrvHW
         PzRphHGlfXXyIL9WMvNBtNJuDucNG4+GZU6oate+qTcsCdY9Nj1Gl3vI6fasuVQQDdw3
         n3j3etmW+Qat6IS269hFOMdxQc2RFsMTnHYR2UBC1Dl0RaQDNsHgWSiHalobKZEIR78L
         ajOfl5wsxp3wSfEAGlAJNrbi0e8LLU7mqOXbKtG4oVdos7wgHpIJSbvz8SqLlj8tmeWC
         cFQQ==
X-Gm-Message-State: AOJu0Yx4rESmvfKJTKPoBdjRWzq8qaZsbdLLOnGWDWUA9o5W+Rbug+yu
	UCJBRXvmez33eQIGDWohysAAkmIe0u4fbuQdwHWGIeBD1rRQcTYNj5tBK4SeBZU=
X-Google-Smtp-Source: AGHT+IFwV9qKfqS2yQWWz3btrmiIpY+A7QVmzRBdVSlB4SpNtZTy4eaPcfs/PSe+kr3qRomA4Br+fQ==
X-Received: by 2002:a17:902:ec83:b0:1fc:2e38:d3de with SMTP id d9443c01a7336-1fdb5eb14a7mr14701055ad.7.1721689519463;
        Mon, 22 Jul 2024 16:05:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f48f3ffsm60446675ad.285.2024.07.22.16.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jul 2024 16:05:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sW25k-007qK2-1d;
	Tue, 23 Jul 2024 09:05:16 +1000
Date: Tue, 23 Jul 2024 09:05:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V2] xfs: allow SECURE namespace xattrs to use reserved
 block pool
Message-ID: <Zp7lrCatH3Ry4PpH@dread.disaster.area>
References: <fa801180-0229-4ea7-b8eb-eb162935d348@redhat.com>
 <7c666cfc-0478-42d0-b179-575ace474db0@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c666cfc-0478-42d0-b179-575ace474db0@redhat.com>

On Mon, Jul 22, 2024 at 02:25:33PM -0500, Eric Sandeen wrote:
> We got a report from the podman folks that selinux relabels that happen
> as part of their process were returning ENOSPC when the filesystem is
> completely full. This is because xattr changes reserve about 15 blocks
> for the worst case, but the common case is for selinux contexts to be
> the sole, in-inode xattr and consume no blocks.
> 
> We already allow reserved space consumption for XFS_ATTR_ROOT for things
> such as ACLs, and selinux / SECURE attributes are not so very different,
> so allow them to use the reserved space as well.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Remove local variable, add comment.
> 
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index ab3d22f662f2..09f004af7672 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -110,7 +110,16 @@ xfs_attr_change(
>  	args->whichfork = XFS_ATTR_FORK;
>  	xfs_attr_sethash(args);
>  
> -	return xfs_attr_set(args, op, args->attr_filter & XFS_ATTR_ROOT);
> +	/*
> +	 * Allow xattrs for ACLs (ROOT namespace) and SELinux contexts

It's not just SELinux - it's security xattrs set by LSMs in general
that use the SECURE namespace. These come through:

xfs_generic_create()
  xfs_inode_init_security()
    security_inode_init_security()
      <LSM>
        xfs_initxattrs()
          xfs_attr_change(XFS_ATTR_SECURE)

> +	 * (SECURE namespace) to use the reserved block pool for these
> +	 * security-related operations. xattrs typically reside in the inode,
> +	 * so in many cases the reserved pool won't actually get consumed,
> +	 * but this will help the worst-case transaction reservations to
> +	 * succeed.
> +	 */

It doesn't explain why we need this - it's got the what and the
expected behaviour, but no why. :)

> +	return xfs_attr_set(args, op,
> +		    args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_SECURE));
>  }

Perhaps it would be better to say something like:

	/*
	 * Some xattrs must be resistent to allocation failure at
	 * ENOSPC. e.g. creating an inode with ACLs or security
	 * attributes requires the allocation of the xattr holding
	 * that information to succeed. Hence we allow xattrs in the
	 * VFS TRUSTED, SYSTEM, POSIX_ACL and SECURITY (LSM xattr)
	 * namespaces to dip into the reserve block pool to allow
	 * manipulation of these xattrs when at ENOSPC. These VFS
	 * xattr namespaces translate to the XFS_ATTR_ROOT and
	 * XFS_ATTR_SECURE on-disk namespaces.
	 *
	 * For most of these cases, these special xattrs will fit in
	 * the inode itself and so consume no extra space or only
	 * require temporary extra space while an overwrite is being
	 * made. Hence the use of the reserved pool is largely to
	 * avoid the worst case reservation from preventing the
	 * xattr from being created at ENOSPC.
	 */

-Dave.
-- 
Dave Chinner
david@fromorbit.com
