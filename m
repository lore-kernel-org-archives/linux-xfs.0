Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14FB174EF6
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 22:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712355741; cv=none; b=ldZgmx5f1BEbtNAxs2dk0vgKVchif8zUc6lyy0uJbLBOfOXw9rUolATKXHa0vMx+MCvdfTxJ/zR7Rr41fiD/Ci2w8I7HI+ITzxBjiXgQ+wLFdEUlqjwzvJ3F5ogUDMKqhadZTkjSp407MxVTgknOiJVv8foTxMiSccI2Um+hcpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712355741; c=relaxed/simple;
	bh=C3c8/EqeUmfqbwGIriYMFtJaO0XaFVxVfL4OfFTtnCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G8lhTocGX7qDONiOFXP2vEpdq2wl7PpV3dWRV8NLFt4EFouYW2xsT88TSXDlXtG6DiDRn5ZKQAa5Hy20P1bJONtZV0ZbyZitYO7lgWBu56RObt9CkE9npxy2z/I90FvEXluJTREtSuPlBz3VSuVZgHLTrtwEnuOgvU9SYf3/ZQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hYQ+iDBP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hYQ+iDBP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712355738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=flb3Hgo6KKlOvZKW6EtqxNKNXHh6F2bGM0rHWpVw7DU=;
	b=hYQ+iDBP0d+eMCVBYyOhqG0WTmlZQtE2ol8u3X5ez1nNPE8G91u8/2pEVYuM7C45OAzbez
	VPgd4ko4YgMU79j4w1AKcd+uRVnxNjJdmalC2q9fjPuaXa51SmotzOq/dJrhjN6w8LqNrO
	9rJ0yInClUTEGogzrcgOKleeJE2bQoo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-sWq7RAjxPBGsH-QKdlujKA-1; Fri, 05 Apr 2024 18:22:15 -0400
X-MC-Unique: sWq7RAjxPBGsH-QKdlujKA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-56c1b105949so2315872a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 05 Apr 2024 15:22:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712355734; x=1712960534;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=flb3Hgo6KKlOvZKW6EtqxNKNXHh6F2bGM0rHWpVw7DU=;
        b=k2Z0oWDIyTg6NEEiO+NkKMJl22Eq/tvlDVf5KB27Tc+zFcTsJbW26sCAX1LbKt0hEe
         3pvfypvXWxxV8dzACCl7NzJ+gf5TrGZsnr3bQ9YGXxNEkKKqH+V0+CiRs9SAF6onHdEm
         EJs6Ifg4iDQt0mxeNj62Q4J1RlyXrcQT6GggXX+FNtdRwH+5/loIEw1lTbCEpSHwW/Tr
         n1v1SGWW7ObVN4vr0K1Y1IHIJSuUheu4B4eIXQYMztTsgNZONkAFrQ5HTbcZlLdYCKZJ
         CbsV2PMGlwsbm/yjFNvq5joK3MtIrfak6lmTQi96kFqBK4Lmbl+BV5THdm/pZQ29eoAA
         Mp6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXYkutf0RuEvmXXQSzJupurViq/7P0+JCcCzEi5EbvJ8XPiSodXV9rfEsUjlOa4NUPqbiC2uglhfjpc7V6b6mWDB68vJxNB09fV
X-Gm-Message-State: AOJu0Yx2Vn4dXZbvnMiC5OKyVdhyOTb1+3ENlmUHwwO1vMkKrrDyFZ5/
	sO5SYgKA79TSvk4nurJGnMel9ZntENSj69UxjgZGsMpwybMtQjfzIjHDxRjrXNo3CH+Bv661Utu
	akYS/yCX4xU/YHcTdzmaBp60g2Qqy/RU4XSe0tpmCvy4mHQAYrb0BqlJI
X-Received: by 2002:a50:9fce:0:b0:56b:a077:2eee with SMTP id c72-20020a509fce000000b0056ba0772eeemr1842410edf.4.1712355734055;
        Fri, 05 Apr 2024 15:22:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCxtMSXOienxC9b8zsqXGQAnGXbeCh9mOE4zI4LHQLZ1567C7uE5CANSZ0EEd9+XkYxChYnA==
X-Received: by 2002:a50:9fce:0:b0:56b:a077:2eee with SMTP id c72-20020a509fce000000b0056ba0772eeemr1842402edf.4.1712355733439;
        Fri, 05 Apr 2024 15:22:13 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id b9-20020aa7cd09000000b0056c0d96e099sm1198887edw.89.2024.04.05.15.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 15:22:13 -0700 (PDT)
Date: Sat, 6 Apr 2024 00:22:12 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: david@fromorbit.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Subject: Re: [PATCH v2] xfs: allow cross-linking special files without
 project quota
Message-ID: <whjaeatubnlc5hrawjmfcksnnth2nse5en4da4bpbfr56lwwrl@53c7v4zlrqrv>
References: <20240314170700.352845-3-aalbersh@redhat.com>
 <20240315024826.GA1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240315024826.GA1927156@frogsfrogsfrogs>

On 2024-03-14 19:48:26, Darrick J. Wong wrote:
> On Thu, Mar 14, 2024 at 06:07:02PM +0100, Andrey Albershteyn wrote:
> > There's an issue that if special files is created before quota
> > project is enabled, then it's not possible to link this file. This
> > works fine for normal files. This happens because xfs_quota skips
> > special files (no ioctls to set necessary flags). The check for
> > having the same project ID for source and destination then fails as
> > source file doesn't have any ID.
> > 
> > mkfs.xfs -f /dev/sda
> > mount -o prjquota /dev/sda /mnt/test
> > 
> > mkdir /mnt/test/foo
> > mkfifo /mnt/test/foo/fifo1
> > 
> > xfs_quota -xc "project -sp /mnt/test/foo 9" /mnt/test
> > > Setting up project 9 (path /mnt/test/foo)...
> > > xfs_quota: skipping special file /mnt/test/foo/fifo1
> > > Processed 1 (/etc/projects and cmdline) paths for project 9 with recursion depth infinite (-1).
> > 
> > ln /mnt/test/foo/fifo1 /mnt/test/foo/fifo1_link
> > > ln: failed to create hard link '/mnt/test/testdir/fifo1_link' => '/mnt/test/testdir/fifo1': Invalid cross-device link
> 
> Aha.  So hardlinking special files within a directory subtree that all
> have the same nonzero project quota ID fails if that special file
> happened to have been created before the subtree was assigned that pqid.
> And there's nothing we can do about that, because there's no way to call
> XFS_IOC_SETFSXATTR on a special file because opening those gets you a
> different inode from the special block/fifo/chardev filesystem...
> 
> > mkfifo /mnt/test/foo/fifo2
> > ln /mnt/test/foo/fifo2 /mnt/test/foo/fifo2_link
> > 
> > Fix this by allowing linking of special files to the project quota
> > if special files doesn't have any ID set (ID = 0).
> 
> ...and that's the workaround for this situation.  The project quota
> accounting here will be weird because there will be (more) files in a
> directory subtree than is reported by xfs_quota, but the subtree was
> already messed up in that manner.
> 
> Question: Should we have a XFS_IOC_SETFSXATTRAT where we can pass in
> relative directory paths and actually query/update special files?

After some more thinking/looking into the code this is probably the
only way to make it work the same for special files. Also, I've
noticed that this workaround can be applied to xfs_rename then.

So, I will start with implementing XFS_IOC_SETFSXATTRAT

-- 
- Andrey

> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> > ---
> >  fs/xfs/xfs_inode.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 1fd94958aa97..b7be19be0132 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1240,8 +1240,19 @@ xfs_link(
> >  	 */
> >  	if (unlikely((tdp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
> >  		     tdp->i_projid != sip->i_projid)) {
> > -		error = -EXDEV;
> > -		goto error_return;
> > +		/*
> > +		 * Project quota setup skips special files which can
> > +		 * leave inodes in a PROJINHERIT directory without a
> > +		 * project ID set. We need to allow links to be made
> > +		 * to these "project-less" inodes because userspace
> > +		 * expects them to succeed after project ID setup,
> > +		 * but everything else should be rejected.
> > +		 */
> > +		if (!special_file(VFS_I(sip)->i_mode) ||
> > +		    sip->i_projid != 0) {
> > +			error = -EXDEV;
> > +			goto error_return;
> > +		}
> >  	}
> >  
> >  	if (!resblks) {
> > -- 
> > 2.42.0
> > 
> > 
> 

