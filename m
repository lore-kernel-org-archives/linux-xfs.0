Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274231D61AA
	for <linux-xfs@vger.kernel.org>; Mon,  7 Jul 2025 12:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751891227; cv=none; b=fD81dKXxJF84somULFP3lS8JFzg47vcRX8P6n9bpeyDbNuM7Ie7lamaV64ZcLKAKAXh81O6R46HDMbXE1Mr3yfNbw5L1w8UHIB4nOIxrhbhLTATT95VcjmkKMC1wVdwFTeohHD1bBq5TWGc22qIuCtRSBaGATBe/DnmLV3Lpx6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751891227; c=relaxed/simple;
	bh=N6aIrao9mvKWLRzYYG6kmQNDgyAReKkf4PPJ58kKg+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovwRE1WGkonIVN2xMim/tfiYEE71X/o7coy3+DTWkoBGZ+t/bcO3pIDmJNWeONxhWK0EkE0YzRo/bepK+mGY5Ij4Z3E4YJCyX/0CszR3WxU/UUBRM4YSxIjoKmzDu3Pa+12aFdAqW9PZdlDpAKKGsXVPgrnecwrKiZicZ94vBJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VWdqClbn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VWdqClbn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751891225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KHTeRzC+GAtalyuC61VSTswPDreUYA10fT25p2FdvD8=;
	b=VWdqClbnL5DTDavf/VC57iQRyvqmO2pg5i3vlePnJpc9nApNQqLQh10DW4t+IVA/voyP/A
	yzzWSuHMgADlmqb+8MEsC2abMSWAZ60RvOmLpTQ3hUzIwWpOhrXDpCaViwV8SLxNvgmTOC
	7Ox+UeoxL87V3z1NImCDxWlSgSmv7O8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-GaPafG3aO2eHLkQkI84BGg-1; Mon, 07 Jul 2025 08:27:03 -0400
X-MC-Unique: GaPafG3aO2eHLkQkI84BGg-1
X-Mimecast-MFC-AGG-ID: GaPafG3aO2eHLkQkI84BGg_1751891223
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ade6db50b98so251200166b.0
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jul 2025 05:27:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751891222; x=1752496022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KHTeRzC+GAtalyuC61VSTswPDreUYA10fT25p2FdvD8=;
        b=l+0CJEQ6RfdxWUayQc1KlpEb9cebNN4sV/J22lWOiPZCD7Hac6hwp6Je2J5ocvEZRt
         a1lqjFydXrO1dat/9ICvShpIYfiMh/zPLFNTUuxNYsprX8QWAKihW+QuWPVyFAxeMAy7
         U4FAYg5AS9RKcbyreTVY8CJeUM6RkRjVPlvrYoHTcABUx+7x/nrSOYV6wOQAv5zMtQbw
         xu7fq58SdXzPODR/p5Fay7eV1YSKQIZ/5Sqfxl82ZE5O3xxped5auTZC+E78B95JHydR
         TQv1UijedsXm4nV19X22DNTqZN3yW80YL7bgD7AsnZcuKIelbB8TdETRSSHSZTKMB/1C
         OWOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrMWksiPKnuDMce8/VNInae2gvSMCjmTHziJGSpBBooIWl7jEJ+cybpsofw4AxwJXwzzzKtVptkng=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ75Q80BJhgDcB7d1q+gAI9VcXET+V4A3lblHVdOAikuE9QhUl
	cBMXYzoz9tam8LdUC2UroU6bVrXZb8vtf4CwNLBQHzvsy3o9iLi2oPjWDlMG9vtXfp+HGmVhtZf
	ZvcvuLgAhKKXSYeShu5LUYhgfhGtcM9/C/BcxURPLxdafZbmSyruI2BtyTqDj
X-Gm-Gg: ASbGnctymdXxiMaP+7OpzMMco09qe8cX75thjeCtOoWPDmtF7UQGuu/lV3M06DzFEnJ
	rSyzYiqzr6ftojyNca0cbU3rtrWIVzzYXqqOWhsKQfU9hsRPduFYR1LfmfbHmvdv7Qulby5x8P5
	x2EhzSxWeCxffvkBTwQVdtlRwlSkmSBaRP6WhR42pcUO/LW1/VT4YIKP6L3otE203fvF+nmcwaw
	jsaDtHlmC5/EuugJ5En6Zxrq0YExi6RojttqRy8AvB0AHoXa1pNfQbJDhXeuwgkzK0RAG9xWlZP
	72QRtJ/mDuz7SOqL/sKrr9uV5zJ6SuEhdJkymo0UiQ==
X-Received: by 2002:a17:907:1b1c:b0:ae0:d903:2bc1 with SMTP id a640c23a62f3a-ae3fbe32085mr1269372766b.49.1751891222538;
        Mon, 07 Jul 2025 05:27:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+xNnEev9UxKSf7lcc6f2ZhivCo6t8UkYaBDX83sSiieaUIILsbAVwreWk30jTRbKc3uqazw==
X-Received: by 2002:a17:907:1b1c:b0:ae0:d903:2bc1 with SMTP id a640c23a62f3a-ae3fbe32085mr1269369466b.49.1751891222070;
        Mon, 07 Jul 2025 05:27:02 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f66d9263sm700724366b.32.2025.07.07.05.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 05:27:01 -0700 (PDT)
Date: Mon, 7 Jul 2025 14:27:00 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Jan Kara <jack@suse.cz>, 
	Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>, Paul Moore <paul@paul-moore.com>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	selinux@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v6 0/6] fs: introduce file_getattr and file_setattr
 syscalls
Message-ID: <rckjqvax4ciazuasmpiiflk6qgwnkfrcamw6xae4mvtofo3yxk@jj25of6o5ye2>
References: <20250630-xattrat-syscall-v6-0-c4e3bc35227b@kernel.org>
 <20250701-quittung-garnieren-ceaf58dcb762@brauner>
 <uzx3pdg2hz44n7qej5rlxejdmb25jny6tbv43as7dos4dit5nv@fyyvminolae6>
 <20250707-alben-kaffee-da62c14bb5c3@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250707-alben-kaffee-da62c14bb5c3@brauner>

On 2025-07-07 14:19:25, Christian Brauner wrote:
> On Mon, Jul 07, 2025 at 02:05:10PM +0200, Andrey Albershteyn wrote:
> > On 2025-07-01 14:29:42, Christian Brauner wrote:
> > > On Mon, Jun 30, 2025 at 06:20:10PM +0200, Andrey Albershteyn wrote:
> > > > This patchset introduced two new syscalls file_getattr() and
> > > > file_setattr(). These syscalls are similar to FS_IOC_FSSETXATTR ioctl()
> > > > except they use *at() semantics. Therefore, there's no need to open the
> > > > file to get a fd.
> > > > 
> > > > These syscalls allow userspace to set filesystem inode attributes on
> > > > special files. One of the usage examples is XFS quota projects.
> > > > 
> > > > XFS has project quotas which could be attached to a directory. All
> > > > new inodes in these directories inherit project ID set on parent
> > > > directory.
> > > > 
> > > > The project is created from userspace by opening and calling
> > > > FS_IOC_FSSETXATTR on each inode. This is not possible for special
> > > > files such as FIFO, SOCK, BLK etc. Therefore, some inodes are left
> > > > with empty project ID. Those inodes then are not shown in the quota
> > > > accounting but still exist in the directory. This is not critical but in
> > > > the case when special files are created in the directory with already
> > > > existing project quota, these new inodes inherit extended attributes.
> > > > This creates a mix of special files with and without attributes.
> > > > Moreover, special files with attributes don't have a possibility to
> > > > become clear or change the attributes. This, in turn, prevents userspace
> > > > from re-creating quota project on these existing files.
> > > 
> > > Only small nits I'm going to comment on that I can fix myself.
> > > Otherwise looks great.
> > > 
> > 
> > Hi Christian,
> > 
> > Let me know if you would like a new revision with all the comments
> > included (and your patch on file_kattr rename) or you good with
> > applying them while commit
> 
> It's all been in -next for a few days already. :)
> 

Oh sorry, missed that, thanks!

-- 
- Andrey

