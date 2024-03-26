Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FED13C67E
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 15:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711465827; cv=none; b=rDGvY5lW6eois3itTIwKR4ZEtE1ueHoIwTH3431xgXavKz+afrwzR42+Le5Gxi7gP/QfS0AGD3NVMtUbXVAaQJ7nslFQoRICHIkfd8Sel+ku8y9uUplgfr7fsex0e20Vgam1LpCOmZI4FWYFjpKqL0drXyTSWIXw+O5CpcHW3tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711465827; c=relaxed/simple;
	bh=xXOb+BG25Vxf3ovjBUjCL7KjeaTIPO/ZI5N7H7ORD3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n78jVn3poxuCAnMUB+v4WIdZRHfbeprMHVM0oR7dpYj3BlgoGyoiRNboxiqbWz2J5xfMfLrh6nW3t2KnyR0cxjJHxHQAeFA5F4oK6zK6LJOF1y4ZdAGvXuZz7Z6PRBCkQxPlyXGkNXP2Mmy78fWcbBtEhxpEC8LFj0rBSS/zYlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FG1H7JqS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FG1H7JqS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711465824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DxdV7cOquI5Q3fFWTr9Rp0HS+bVOMASvKCj8swk/RK0=;
	b=FG1H7JqSGI9L92L7S1Vw6JbtLZcZeQkuw2DxA3XUNh1fzgreAuBxko+ZEJLJWr5ZCTCIf+
	PYCmVOt2jnPllslmHV4gzlvPWpkFuSsjwXsh+73uq/mokhRPXBV669XUQHOOAHa3WUPUJT
	R1JvsoT4BDQNss/jLJ27gwh1G+Ijs/I=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-KOfZBxDyPU6TW2CtDHzVdA-1; Tue, 26 Mar 2024 11:10:21 -0400
X-MC-Unique: KOfZBxDyPU6TW2CtDHzVdA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a462e4d8c44so261954066b.1
        for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 08:10:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711465820; x=1712070620;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DxdV7cOquI5Q3fFWTr9Rp0HS+bVOMASvKCj8swk/RK0=;
        b=CGhY5QIFmyUeMpX/Sq5bCkrXX17vEXXC8EnjSXmg5qoDPfDgaMSoFjSrjDZXB8sy2W
         H8LRgjx+4pvKggpsbhUH6rlepofGMsqVk8YzgtwtaIwt5KSd+XOIP4yrc5JYQHk0OadA
         s2DJS5ugYGbyZZIaUabbeaxX/UXqvoH4CccR9Xj5FQhDFkThUXIQ0EXv60mLbjFiXUJ+
         zdUF+lzqqdPA+xh1k1L61H/42s3TUnecuMFXoTGDcm/SlaL/O9GqdjJtG9gLuV24ZeIk
         FOzpC7Qk0kOQNTLee6T2acEo9SI2pdHDCYE3ws9y9sDPjtXKS1fv1EqPm0my/RQlHLAe
         GibQ==
X-Forwarded-Encrypted: i=1; AJvYcCWH8HVUpFieJDAmjN4yWMmQ6Jf4IAwIIJ7TQX2efcYVZN9BMV0M1QyYXaT9a0fu9FJizgh2otOigoieU2XDDvEoIvv/5mQV7/sr
X-Gm-Message-State: AOJu0YwBDBt7d0eKKSvhbkYfNVC9Y79oX/ZomnxzqYzgxdtZEivy6qKw
	YIp4B/EwPmEkcT3GEaob77ia6rWR0Q6m7J9n6tG2v0hGsy0g7wz5TSz6plVfPUu2LFraDxNgBS6
	DvQzkjs2NPLuKIhx0Izp0TzgExOXF8zcFZ0x24QywYY6oQd8G+2DmKr1P
X-Received: by 2002:a17:907:f84:b0:a48:7cbd:8b24 with SMTP id kb4-20020a1709070f8400b00a487cbd8b24mr4609922ejc.17.1711465819985;
        Tue, 26 Mar 2024 08:10:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVYr2DynbfCAra0NeiwDGEse4TeSxrOQRUZazVPyl2v3IXwcp4SpWFoy/KtQRMC2IEi/kf7Q==
X-Received: by 2002:a17:907:f84:b0:a48:7cbd:8b24 with SMTP id kb4-20020a1709070f8400b00a487cbd8b24mr4609889ejc.17.1711465819182;
        Tue, 26 Mar 2024 08:10:19 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id u13-20020a17090626cd00b00a45200fe2b5sm4291883ejc.224.2024.03.26.08.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 08:10:18 -0700 (PDT)
Date: Tue, 26 Mar 2024 16:10:18 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: dchinner@redhat.com, djwong@kernel.org, hch@lst.de, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, mark.tinguely@oracle.com
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to f2e812c1522d
Message-ID: <dlmrrqswfhspcjn6ai7jfh54t4mwrgus2ex3b4klpcbszq72zw@cizkdcybodfs>
References: <874jcte2jm.fsf@debian-BULLSEYE-live-builder-AMD64>
 <wdc2qsq3pzo6pxsvjptbmfre7firhgomac7lxu72qe6ard54ax@fmg5qinif62f>
 <s2kxdz3ztpuptn3o2znqpsbskra5yqxqnjhisfjxyc3cqw33ct@k6bvhr2il2sn>
 <87r0fxgmmj.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r0fxgmmj.fsf@debian-BULLSEYE-live-builder-AMD64>

On 2024-03-26 18:42:47, Chandan Babu R wrote:
> On Tue, Mar 26, 2024 at 12:14:07 PM +0100, Andrey Albershteyn wrote:
> > On 2024-03-26 12:10:53, Andrey Albershteyn wrote:
> >> On 2024-03-26 15:28:01, Chandan Babu R wrote:
> >> > Hi folks,
> >> > 
> >> > The for-next branch of the xfs-linux repository at:
> >> > 
> >> > 	https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
> >> > 
> >> > has just been updated.
> >> > 
> >> > Patches often get missed, so please check if your outstanding patches
> >> > were in this update. If they have not been in this update, please
> >> > resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
> >> > the next update.
> >> > 
> >> > The new head of the for-next branch is commit:
> >> > 
> >> > f2e812c1522d xfs: don't use current->journal_info
> >> > 
> >> > 2 new commits:
> >> > 
> >> > Dave Chinner (2):
> >> >       [15922f5dbf51] xfs: allow sunit mount option to repair bad primary sb stripe values
> >> >       [f2e812c1522d] xfs: don't use current->journal_info
> >> > 
> >> > Code Diffstat:
> >> > 
> >> >  fs/xfs/libxfs/xfs_sb.c | 40 +++++++++++++++++++++++++++--------
> >> >  fs/xfs/libxfs/xfs_sb.h |  5 +++--
> >> >  fs/xfs/scrub/common.c  |  4 +---
> >> >  fs/xfs/xfs_aops.c      |  7 ------
> >> >  fs/xfs/xfs_icache.c    |  8 ++++---
> >> >  fs/xfs/xfs_trans.h     |  9 +-------
> >> >  6 files changed, 41 insertions(+), 32 deletions(-)
> >> > 
> >> 
> >> I think [1] is missing
> >> 
> >> [1]: https://lore.kernel.org/linux-xfs/20240314170700.352845-3-aalbersh@redhat.com/
> 
> I am sorry to have missed that patch.
> 
> >
> > Should I resend it?
> 
> You don't have to resend it.
> 
> I will include the above patch in 6.9-rc3 fixes queue.
> 
> -- 
> Chandan
> 

Thanks!

-- 
- Andrey

