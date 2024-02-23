Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F2A7CF21
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 12:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708692928; cv=none; b=cqIJjbKRY0X5kV+WlJf7P3y8R9e3k8ipgZ/SNmoA8JgxacocCOqiFOVuEqVlg5V9oRn6wJUnuyWIDnsoggEVxwYF7jiTDPv/k2e7jC8qt5FIkJUvKxh5B8ntyc91KEz2bKq4gOZ137GdHWAUlfjfhywn6vz18k/BNlhOamVn4UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708692928; c=relaxed/simple;
	bh=aVFT9EQp7q7JonJdV47KeTLSynCJZvyp7XBYXfrWLoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ir15B04Tc/9/1X6GlrHbGTCPONUNu8Y6pO9gqL3oZAFNF4V/jeliZgFggWjMxbA/Z34WxEUOneEDIj+YoTEvItQ3mmmFKf+zV5GrkmWfnapdcf6m2sk+73lyB63CehFfhRYT3HlL+V7YSZIpkhEeRe9t4Eg+7RNJvkRLWhvwWbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CAn5uSyT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CAn5uSyT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708692925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W+w29RIGjR3n8ArJXrNp/EUd5heRIsgahlaJ2sqHGvU=;
	b=CAn5uSyTB+eJszhSSS7IFDSAAebn/2m9325Dr1cyVBLmrtc6RvTdPS/g6Wjwy+n3NO2o35
	RkbgomplSDLn66mcHdvHQWPDbWQ1u0lUOwcToxnug1xmK4ykTknALgOCzlMbT/0bvUhgCk
	YTzH0wJYI1gzb6U3IzCTZSrpG+aCGZI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-DK9DYNUnMRm7gz75C2dN3w-1; Fri, 23 Feb 2024 07:55:24 -0500
X-MC-Unique: DK9DYNUnMRm7gz75C2dN3w-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33d23c8694dso135900f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 04:55:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708692923; x=1709297723;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W+w29RIGjR3n8ArJXrNp/EUd5heRIsgahlaJ2sqHGvU=;
        b=fNbqBuC71x5KuA4xsi8eqAr4uxvNCglvihdvfHnAjRf1uT5LX1nV92+uAO68C945BR
         F8YCovLzX4Z082WBxkmMsJxpidBuUhN6XbEsfsZEQWf2HqZHF1we2HpUhTbuJJMsfy6n
         TxD8oJnkUM2jN5QHm2RfC2omcTZSjKsGROVpbNX7zWtyWPcv53WdKWp4i7ZxPJxg+kMc
         lf6gLJX5hDIAiBcJJwQNzigTxf23+3mvMGoECGSE7JgXQC+/Nn854uxD6KpVFr+uKgzO
         Wakf/4ElQmIhur9dm/W52tdz/TD1ojcADUXxYYEzlVEEF+NdOgLS6WPCn+CawTAZ2J2l
         yhNg==
X-Forwarded-Encrypted: i=1; AJvYcCUAk573oCV+kPhCS9iRxTixpPvXhBgmjItyvAwwK80iRnITzCQVwi/Zsw4O91IJy/mf8nbbDoAtzOBR+oLrr74j9z/kIR5BemMD
X-Gm-Message-State: AOJu0YyjhLvtp55aGtm0p4MCwvJNDCjVkkcEdt9pLP5GcMrL37gzg1yL
	Sb1SZOCSgEbe0Z/018Hpywjmlye3v+v5iz1Rk8543R1zyY0urAll4s23hH7pudWvxl7OgMhwXJ7
	A2/ycHuqbcY7Xhbd39nNwWIywh1jEN+PG3hRvM1asKbsl1U85apJHu8Im
X-Received: by 2002:adf:f887:0:b0:33d:282c:af48 with SMTP id u7-20020adff887000000b0033d282caf48mr1328741wrp.69.1708692922930;
        Fri, 23 Feb 2024 04:55:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEzOl5wggUxVEAyYw4DG2qkmOXnqF8Ch6/f5lpfvycnx7OLTSTxLLFHYWaS+EMxDphokC898g==
X-Received: by 2002:adf:f887:0:b0:33d:282c:af48 with SMTP id u7-20020adff887000000b0033d282caf48mr1328721wrp.69.1708692922521;
        Fri, 23 Feb 2024 04:55:22 -0800 (PST)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id x3-20020adff643000000b0033b278cf5fesm2674349wrp.102.2024.02.23.04.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 04:55:21 -0800 (PST)
Date: Fri, 23 Feb 2024 13:55:21 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, chandan.babu@oracle.com, djwong@kernel.org
Subject: Re: [PATCH v4 05/25] fs: add FS_XFLAG_VERITY for verity files
Message-ID: <ck7uzvtsfxikgpvdxw5mwvds5gq2errja7qhru7liy5akijcdg@rlodrbskdprz>
References: <20240212165821.1901300-1-aalbersh@redhat.com>
 <20240212165821.1901300-6-aalbersh@redhat.com>
 <20240223042304.GA25631@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223042304.GA25631@sol.localdomain>

On 2024-02-22 20:23:04, Eric Biggers wrote:
> On Mon, Feb 12, 2024 at 05:58:02PM +0100, Andrey Albershteyn wrote:
> > +FS_IOC_FSGETXATTR
> > +-----------------
> > +
> > +Since Linux v6.9, FS_XFLAG_VERITY (0x00020000) file attribute is set for verity
> > +files. The attribute can be observed via lsattr.
> > +
> > +    [root@vm:~]# lsattr /mnt/test/foo
> > +    --------------------V- /mnt/test/foo
> > +
> > +Note that this attribute cannot be set with FS_IOC_FSSETXATTR as enabling verity
> > +requires input parameters. See FS_IOC_ENABLE_VERITY.
> 
> The lsattr example is irrelevant and misleading because lsattr uses
> FS_IOC_GETFLAGS, not FS_IOC_FSGETXATTR.
> 
> Also, I know that you titled the subsection "FS_IOC_FSGETXATTR", but the text
> itself should make it super clear that FS_XFLAG_VERITY is only for
> FS_IOC_FSGETXATTR, not FS_IOC_GETFLAGS.

Sure, I will remove the example. Would something like this be clear
enough?

    FS_IOC_FSGETXATTR
    -----------------

    Since Linux v6.9, FS_XFLAG_VERITY (0x00020000) file attribute is set for verity
    files. This attribute can be checked with FS_IOC_FSGETXATTR ioctl. Note that
    this attribute cannot be set with FS_IOC_FSSETXATTR as enabling verity requires
    input parameters. See FS_IOC_ENABLE_VERITY.

> > diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> > index 48ad69f7722e..6e63ea832d4f 100644
> > --- a/include/uapi/linux/fs.h
> > +++ b/include/uapi/linux/fs.h
> > @@ -140,6 +140,7 @@ struct fsxattr {
> >  #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
> >  #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
> >  #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
> > +#define FS_XFLAG_VERITY		0x00020000	/* fs-verity sealed inode */
> 
> There's currently nowhere in the documentation or code that uses the phrase
> "fs-verity sealed inode".  It's instead called a verity file, or a file that has
> fs-verity enabled.  We should try to avoid inconsistent terminology.

Oops, missed this one. Thanks!

-- 
- Andrey

