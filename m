Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8AD2746F
	for <linux-xfs@vger.kernel.org>; Thu, 23 May 2024 11:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716463525; cv=none; b=Xp42f7l8ypH/s2txFQe7f07B6h7JLNgn6RLCZtYMNaQcK17xc+rykhB9anl/zuudXP4p3B9z1sQ4m+hGWHq2h+d9PGDP6HNALMwlXiovwsquibUNfAFA1XwT5BNQ6PNSJK+IiJnHVra4a5fLz84cFMxYXHWOzOM4tUUiWl1aCf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716463525; c=relaxed/simple;
	bh=wt5PN/qtjJ2rzw45d1w/1vKkEDgQP106dMP5qeGQdII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UmzKYmfyYrTOGpbL24CFFlLgYU1Jmn7i5BWxXGJPFe6sejArA3duR7YjdfX7jgogLwORpmLYVB3pdhdgwBsBKeuNQoPPH6R3ujWm68X78LXppL9xDdBU7QWJeZaMQr6Bube2OX2eTcfeYZzi3oOyhLcLL7CSSLpFWQrVtPL866w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NmFt4Ohj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NmFt4Ohj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716463523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6zBDO7+ZsvNadbNCW894YSxB3AuxDzS9c+VkJhtMr+U=;
	b=NmFt4OhjbZQOE+WyIUQ0P/SWRjF8hm4sncGptRl2w6qXFXD4Sx75mafGZx3HnLqnq5j7ms
	nzkWmP73Ru6GQq5aCDEjeGCwCYq4mVjIwI8a6c73U22eSfi6BlSNuRFK2Miz9FXHFcm6/5
	7kSyBFkBq42YroyVt9fULEW2y0cwLCk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-I-tbQ6J_PiubsiyYshCLbg-1; Thu, 23 May 2024 07:25:21 -0400
X-MC-Unique: I-tbQ6J_PiubsiyYshCLbg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-355031d0e82so4599f8f.3
        for <linux-xfs@vger.kernel.org>; Thu, 23 May 2024 04:25:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716463521; x=1717068321;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6zBDO7+ZsvNadbNCW894YSxB3AuxDzS9c+VkJhtMr+U=;
        b=XoxnaZYemR+c8uU8Kjv4r139me0vuM6N1MxOGGd2Iwb876jcG8y/QevwCPf1x2te11
         WakVhKdd+AvucYLe8lRlLzAiiI1kpczg9yGZwSVJPPDH1MmbppBOekAOfHBS8yA0taXM
         9X7s6Ef9Hxzfch+jiLB61+ooGRSAguI5gX2KzsmUdsDNEFdYqaalmsmBFkoMwzEVPe+P
         eOXia32g2ZIUXeh/OvQDZ1+UrDBdCrgKBiYOU63SMiFkmgIJ3ohaLKM1G4jTmI7NfAVO
         b5JWnn78IjCZqA8eP33zhHEj7vGKFsAyicZNhp7yU03Ux3uPT4qOZQ00GNdq/Mjkrifo
         HURQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyqrNmA3ZOMlyASMPOsqXfVL8c81xLTuonA+J3jJJJqs/ZaDtPwosweQMBO0w3Q6qkXoVLmIryFQzEMxwpxRALFuMG6ej20USw
X-Gm-Message-State: AOJu0YwyFeR0vsPWUfX0A1mYndotl8fcd8pepic6YyJxx939LH0zYR+0
	CGrzgGFnUzeEwzcY8lmo2G+8URia71aZzqSVJrGODaWX042lsiNpW/zi2G3iPabl+3JUmLuhHLF
	y583ImduxYFvo5LgO8ZRDR8UxpQa4AzFdSPwixDzVwP+WnAdfsnJfANzR
X-Received: by 2002:a05:600c:1c95:b0:41f:e87b:45c2 with SMTP id 5b1f17b1804b1-420fd225b5amr45149095e9.0.1716463520571;
        Thu, 23 May 2024 04:25:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFf/0WS7wUZcK2TlJzARg3ViRqgIdeYsEi8F/byytPfMSORAmrYwNtxoWRNoW6XrfebxrVYQ==
X-Received: by 2002:a05:600c:1c95:b0:41f:e87b:45c2 with SMTP id 5b1f17b1804b1-420fd225b5amr45148895e9.0.1716463520080;
        Thu, 23 May 2024 04:25:20 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3502b79bc0asm36726213f8f.1.2024.05.23.04.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 04:25:19 -0700 (PDT)
Date: Thu, 23 May 2024 13:25:18 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 2/4] fs: add FS_IOC_FSSETXATTRAT and
 FS_IOC_FSGETXATTRAT
Message-ID: <upfj7ycpdowfsss5nslt4objo4el6xv3chwj2psmvycjjrpnrb@ide7wa5bzvib>
References: <20240520164624.665269-2-aalbersh@redhat.com>
 <20240520164624.665269-4-aalbersh@redhat.com>
 <CAOQ4uxikMjmAkXwGk3d9897622JfkeE8LXaT9PBrtTiR5y3=Rg@mail.gmail.com>
 <z6ctkxtwhwioc5a5kzisjxffkde6xpchstrr3zlflh4bsz4mpd@5z2s2d7lbje5>
 <CAOQ4uxjaLbrmSDk_a_M6YDT5tQoHO=dXTDsHVOSYcMxeQnpP1w@mail.gmail.com>
 <3b7opex4hgm3ed6v24m7k4oagp2gnsjms45yq223u2nnrbvicx@bgoqeylzxelj>
 <20240522162853.GW25518@frogsfrogsfrogs>
 <20240522163856.GA1789@sol.localdomain>
 <CAOQ4uxjkHyRvV1VVAa+Agdgb8TOHJv1QOJvNbgmG-PY=G1L+DQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjkHyRvV1VVAa+Agdgb8TOHJv1QOJvNbgmG-PY=G1L+DQ@mail.gmail.com>

On 2024-05-22 22:03:55, Amir Goldstein wrote:
> On Wed, May 22, 2024 at 7:38 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Wed, May 22, 2024 at 09:28:53AM -0700, Darrick J. Wong wrote:
> > >
> > > Do the other *at() syscalls prohibit dfd + path pointing to a different
> > > filesystem?  It seems odd to have this restriction that the rest don't,
> > > but perhaps documenting this in the ioctl_xfs_fsgetxattrat manpage is ok.
> >
> > No, but they are arbitrary syscalls so they can do that.  ioctls traditionally
> > operate on the specific filesystem of the fd.
> 
> To emphasize the absurdity
> think opening /dev/random and doing ioctl to set projid on some xfs file.
> It is ridiculous.
> 
> >
> > It feels like these should be syscalls, not ioctls.
> >
> 
> I bet whatever name you choose for syscalls it is going to be too
> close lexicographically to [gs]etxattrat(2) [1]. It is really crowded
> in the area of getattr/getfattr/fgetxattr/getxattr/getfileattr/getfsxattr...
> I think I would vote for [gs]etfsxattrat(2) following the uapi struct fsxattr.
> I guess we have officially spiralled.
> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-fsdevel/20240426162042.191916-1-cgoettsche@seltendoof.de/
> 

Thanks for the link, will convert to syscalls in next version.

-- 
- Andrey

