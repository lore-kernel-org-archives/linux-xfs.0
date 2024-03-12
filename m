Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DE536AFB
	for <linux-xfs@vger.kernel.org>; Tue, 12 Mar 2024 12:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710247355; cv=none; b=dQVphblGOR2DpGAl9Bp8s5prHtxcjQaEB/vOkEt0v/oDD4LmFFFzB2Vk0hGYh//YxPDUNniNa4SSCbgJ1TgsQzIBLL3d/WL9TlC3qeBQftkejZoVLOBN9Ok/EdpZEdRbzxv4KyJCVZYlHet4e8YG4OxCFihBb+nNhmMJq6bUar4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710247355; c=relaxed/simple;
	bh=WdNiCw9a6QyxEfoXxzqePgCN33RJ0NkeRM5mNDnx5Yo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j12ejyFWf0DJNBLC9FbcbWEEKZyRq2a6R2belJNem3UdDADkIATKXa4m5P7Jm6n4nj5VUu2iSRjmL6E0SpKs6szXHh+G0qgGhMvvNz+K2H6OdHY1M8K5oRdVMBT/nAQ4RAhH4J9uwZcQGGdEtgldbxS1OwrqoeSiZnNnvPW44A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cF4F5tCo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cF4F5tCo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710247352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KVF+T75LwSeiDiQb6FyOLvE1cqevBb5wDY4YhiPNbGQ=;
	b=cF4F5tCoWQGTVtZ1JX5I/kUc1t5uBou3wXFFYWL0NHQCztpiBoDqPTZT3Jhcnsaan2jKNp
	cvTS/GTOtRFWSJTPPV1r42aLaaErGLr2g2TblqbGN/LeItTVvnIe63xoMbbg3MS5F1mz75
	sPHbWupSoCERTcJyh4V1uZrAM2xEfBM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-IOHNlAdyMXmjYjGSV4CQeg-1; Tue, 12 Mar 2024 08:42:31 -0400
X-MC-Unique: IOHNlAdyMXmjYjGSV4CQeg-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-558aafe9bf2so3691272a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Mar 2024 05:42:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710247350; x=1710852150;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KVF+T75LwSeiDiQb6FyOLvE1cqevBb5wDY4YhiPNbGQ=;
        b=iba/Yj/uhAhRZC9e1rIqQo/z35o6wPacYMjY1VTN5nr/VXt5qFtz5mowxzWqlJ3/ga
         WdMaFsYahFMhDYEmPmMzoL48labNNwvRJqSQZnXqas32jqrppWubqBbCs1DMOYcHIFyr
         kUDd3e6JoQmx9+Bz3tCDnseyP4hZmvSDpirxcreuSDZUNj4eM2Nao80g2t7qoWTpX1ZT
         WhVBcOsD2yf8G8LLvuXqOgQ7+GY0L2eEFXXsbYefi70tYdKjEhhCFc7WXIDY/9ldOw5Y
         pvfdmx0XZiUhYu/IIvQRVaGbwaBeaRFws5FA5PnX7PWkvLP/JH+8FGa9AnIVqKt7KvU3
         4Q1A==
X-Forwarded-Encrypted: i=1; AJvYcCWlPKmH7l8ajryVVZgNlsEgBy7RwCXOP9ioG4U4Pb/m43DUGF+baUllnSSdYcMnWYXWV9IFDgbl2g68gNZxmwyb+pJWb/y8XgUl
X-Gm-Message-State: AOJu0YzpD61e5+lGLMT4AWdg6lbjK5jXmCdjBnMZMqKb+WPkiTOm8oCl
	0o84eGAJFz1yKNWtU1SKZjxksXax6SE+nK3aHZ/ppaBhiKrDgzRhRjySVniU7E2MDlFHW6bi9EP
	1ZUmp6xxl5hU3JBJpz0kuXGfdvR9zT+3AvWhmsEB5l6X/jx1aIDr4cwxo
X-Received: by 2002:a17:906:f850:b0:a3f:29c:c8fa with SMTP id ks16-20020a170906f85000b00a3f029cc8famr134637ejb.66.1710247349535;
        Tue, 12 Mar 2024 05:42:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFW3bzo7NZebTVEL0evFaE30La4fanl7fiHQtvMNtFbdkYJaaT0rzJHzdyOHCS50THEn4Dl9w==
X-Received: by 2002:a17:906:f850:b0:a3f:29c:c8fa with SMTP id ks16-20020a170906f85000b00a3f029cc8famr134610ejb.66.1710247349003;
        Tue, 12 Mar 2024 05:42:29 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id l8-20020a170906230800b00a4131367204sm3811243eja.80.2024.03.12.05.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 05:42:28 -0700 (PDT)
Date: Tue, 12 Mar 2024 13:42:27 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, chandan.babu@oracle.com, ebiggers@kernel.org
Subject: Re: [PATCH v5 23/24] xfs: add fs-verity ioctls
Message-ID: <3rovt56zfexku6if3d6rgtyyuu7is735sg4u7aglqxf7dec7rh@declezwqfvpp>
References: <20240304191046.157464-2-aalbersh@redhat.com>
 <20240304191046.157464-25-aalbersh@redhat.com>
 <20240307221445.GY1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307221445.GY1927156@frogsfrogsfrogs>

On 2024-03-07 14:14:45, Darrick J. Wong wrote:
> On Mon, Mar 04, 2024 at 08:10:46PM +0100, Andrey Albershteyn wrote:
> > Add fs-verity ioctls to enable, dump metadata (descriptor and Merkle
> > tree pages) and obtain file's digest.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  fs/xfs/xfs_ioctl.c | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index ab61d7d552fb..4763d20c05ff 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -43,6 +43,7 @@
> >  #include <linux/mount.h>
> >  #include <linux/namei.h>
> >  #include <linux/fileattr.h>
> > +#include <linux/fsverity.h>
> >  
> >  /*
> >   * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
> > @@ -2174,6 +2175,22 @@ xfs_file_ioctl(
> >  		return error;
> >  	}
> >  
> > +	case FS_IOC_ENABLE_VERITY:
> > +		if (!xfs_has_verity(mp))
> > +			return -EOPNOTSUPP;
> > +		return fsverity_ioctl_enable(filp, (const void __user *)arg);
> 
> Isn't @arg already declared as a (void __user *) ?
> 
> --D
> 

Right, will remove that.

-- 
- Andrey

