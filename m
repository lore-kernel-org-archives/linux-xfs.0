Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE1C149C53
	for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2025 14:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737210745; cv=none; b=YEE1alGpLsWlZwpocDQnZSYEXzWUVq10w58jm24YN+YUspRoC6rWDSek7r1gLFPeRG4NcKmRcPTYmph4OfM7DWBlLTrftVc2+BO/8jWSZLRYkeMgSdhmKsSqGK9EgULt0Zp2jCqH2AjnbTSBJFEFDCfb9Ox8jLN0CGWxaqi/POo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737210745; c=relaxed/simple;
	bh=C8KVAQaMXjEuqRivlDHZFfrBDzsRlU3SVRcBlpwLGmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PjM2J8rNFL+kxSMb3Aeb7DxEqDYaSm8ShXgX4LrB0A1Uuhodbize0hnEZ9miUCtBO6QmeL9Ef5YPqlDieMpHmUx+hUHhjKWuo/Ip9iuCfyCGvQ5swbiP2jWaBleSuZ05w6FYp8r+1f891kGTvW1rEwS34Xoyc+9WZKXwlAk0aa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YLhZDoM/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YLhZDoM/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737210742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KQynHqlXEbirZK19RGEZCQ1MvlBxDpmpsDCS7JVP8hI=;
	b=YLhZDoM/TYxkQZEPxfH0NYBBI6AreI6/j1R5+9/52OLnZhP2bBRdUp7yH9HMjZDoenWjed
	Z40+o/yZQLNqpTl+fCecm4BGcfSOYHO0jmz0HEww2jVweRq4e95aWML3yy/6nsAIhtohMT
	jc20Gw1bFWgwxQTrnBUBuhDA2ogqScY=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-32-kRd86PoKONGmp1PzRAMxQw-1; Sat, 18 Jan 2025 09:32:20 -0500
X-MC-Unique: kRd86PoKONGmp1PzRAMxQw-1
X-Mimecast-MFC-AGG-ID: kRd86PoKONGmp1PzRAMxQw
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2ee9f66cb12so5965073a91.1
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2025 06:32:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737210740; x=1737815540;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KQynHqlXEbirZK19RGEZCQ1MvlBxDpmpsDCS7JVP8hI=;
        b=NEMjgFA0oDBi2NyUmO+t13kw84O0hSHWRDQV6mjYeWOnU5Jy/syqklrZtRQlPZIP7o
         aOWmCvXWGRAnFMuNCAoSGYQQVHbXoF6zmDWFipc1KspbilwGgQE5/1zRXOBJTLM529Ls
         cuHVf1eYGr8eqlzy8Jz2F9UYuVoIilX9uJorv+aOsA6y1+WqnHZp6QrhuK1BupQWAAtJ
         RVoCYf7r1sWS6XaepA3g9RbZ0JNJzIjuzQ7dl7wz2Kvjr9J2uV/vplj7etw4jraFgOpB
         e6bDrVGKD6q2jgoUokIId8Lv9md8PlWou4rcv6qSXzSV9C9x3Mi+msouivXkXN+oNdZV
         vZYA==
X-Forwarded-Encrypted: i=1; AJvYcCUgaBdKGEe4Lant/LYyaOA5ptzyF5Gr4f/iGnwLjGQ/lcgNgpf9DZ6y3RofugqxL89EzEwqRJScpAk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSxjlaOq8dpPxpobvkucSvcZsFfI7hUY/E/a09YReQfO5WR2GS
	yF1K1d1p/RFqJkWFIfUpbczQiphOHUs9aNWij4DWc9URsH61/Q62KyLd0XaEmytm1QjrjqiqtT5
	BdbN6auGsBP97O/xEPGoq1VJJ12VVUx522eAxmshY0GBjaYBq/phtE5CQiQ==
X-Gm-Gg: ASbGncswOul/geYPSmltbfTnc3l6QkuPY4qpRr99yV1vOjUJG8KIHRttybiyly4SCDh
	1il3gUeDK5OZ8zV5AShVEDOk1JABCaLD4bdW3xZR5JNYCHrNkMZcz7trxIfADAkPBgo+FFyQ4dW
	GMddmU1w4irMaSEqPd6vSTcNXO1xi66hwn0LqEpKMzm+E3JlqGEa6IsJ/4UHUNW1TAJnWb3W3DQ
	b54ijcsAq2u2i2f7oT3pS8F1jfxwSLdilZ6U1oBo06/u304J/xftSYA3HEEogWAl/g+t8ZPd0qj
	ZiS1bEXNnPrys010K2f2ipkSm7/Bjo1EjfU=
X-Received: by 2002:a05:6a20:c87:b0:1eb:3414:5d20 with SMTP id adf61e73a8af0-1eb34146046mr2873572637.25.1737210739770;
        Sat, 18 Jan 2025 06:32:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFE15VqHHb2DN4YrNVN9JdCv+BZW7I/pMv7aUgYfp8J+DXmS+Iu6fLBTlKBHRLukxoPnyrzaQ==
X-Received: by 2002:a05:6a20:c87:b0:1eb:3414:5d20 with SMTP id adf61e73a8af0-1eb34146046mr2873545637.25.1737210739448;
        Sat, 18 Jan 2025 06:32:19 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a9bca47e6fbsm3658235a12.14.2025.01.18.06.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2025 06:32:18 -0800 (PST)
Date: Sat, 18 Jan 2025 22:32:14 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fstests: workaround for gcc-15
Message-ID: <20250118143214.gcrqvwfa4jnkawyj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250117043709.2941857-1-zlang@kernel.org>
 <20250117172736.GG1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250117172736.GG1611770@frogsfrogsfrogs>

On Fri, Jan 17, 2025 at 09:27:36AM -0800, Darrick J. Wong wrote:
> On Fri, Jan 17, 2025 at 12:37:09PM +0800, Zorro Lang wrote:
> > GCC-15 does a big change, it changes the default language version for
> > C compilation from -std=gnu17 to -std=gnu23. That cause lots of "old
> > style" C codes hit build errors. On the other word, current xfstests
> > can't be used with GCC-15. So -std=gnu17 can help that.
> > 
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> > 
> > Hi,
> > 
> > I send this patch just for talking about this issue. The upcoming gcc-15
> > does lots of changes, a big change is using C23 by default:
> > 
> >   https://gcc.gnu.org/gcc-15/porting_to.html
> > 
> > xfstests has many old style C codes, they hard to be built with gcc-15.
> > So we have to either add -std=$old_version (likes this patch), or port
> > the code to C23.
> > 
> > This patch is just a workaround (and a reminder for someone might hit
> > this issue with gcc-15 too). If you have any good suggestions or experience
> > (for this kind of issue) to share, feel free to reply.
> 
> -std=gnu11 to match the kernel and xfsprogs?

So you prefer using a settled "-std=xxx" to changing codes to match "gnu23"?

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> >  include/builddefs.in | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/builddefs.in b/include/builddefs.in
> > index 5b5864278..ef124bb87 100644
> > --- a/include/builddefs.in
> > +++ b/include/builddefs.in
> > @@ -75,7 +75,7 @@ HAVE_RLIMIT_NOFILE = @have_rlimit_nofile@
> >  NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE = @need_internal_xfs_ioc_exchange_range@
> >  HAVE_FICLONE = @have_ficlone@
> >  
> > -GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
> > +GCCFLAGS = -funsigned-char -fno-strict-aliasing -std=gnu17 -Wall
> >  SANITIZER_CFLAGS += @autovar_init_cflags@
> >  
> >  ifeq ($(PKG_PLATFORM),linux)
> > -- 
> > 2.47.1
> > 
> > 
> 

