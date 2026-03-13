Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FD4389DF0
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 13:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773407582; cv=none; b=ozN5jxz6iFQXnNRMTMAAKQgU/t0k/346kQ274yeEJFIDInfGWjnt/Us2+JtnOWY3QNXhaYLcB2Xfb2oMh1pTm5aHovWAodBr0RN6gwwUeGozJ5A3UjCmxrXAkgm9tMlaIYHJFB380cdq7BdsNVISXjko+RGGZH3D+ZnMJ5tWah0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773407582; c=relaxed/simple;
	bh=33WQ9KYqFSvWnDSNh2w1MmmAU80VJLafAd867ISfwFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R8ygJAcf/Y28U+wvGFzNB2Zlx+bE1ZOzBVv4BDoj3zEgRKnixgN0wWw9UFIT+bvBVRMHcW4R9wT8E5PGacvMCzoUUrwXMAYxDIMl/kiGThIbb5i+UTw7xIez7279qPyCshEuk1PpuVXHCclR8k3hWJnpabJaAWH42oqefyNkBeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OIRRDChT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EOYMTD/B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OIRRDChT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EOYMTD/B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773407578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PfJ/KX9G+4IwIzqH9bOlI0FJJqC8ABUTj7gz7e2V6rM=;
	b=OIRRDChTXqc+REIqSMqFKQVFpNshZypdLLzwEuR8EL6cou68QFi4Bx1JMU+wKWHMaUNiXK
	timheQLWEG77RHRGH60sBelZm6WUyorpj2+ouzSl1ngsQJXuxbeuqlksq0vnfYaQxMemGf
	LESu8SQvfmjr10WQ+yp5JJayZdOfXSk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-fkAl5mhwP5W9te4T_Z_Jzw-1; Fri, 13 Mar 2026 09:12:57 -0400
X-MC-Unique: fkAl5mhwP5W9te4T_Z_Jzw-1
X-Mimecast-MFC-AGG-ID: fkAl5mhwP5W9te4T_Z_Jzw_1773407576
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-439bab2d095so1354416f8f.3
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 06:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773407575; x=1774012375; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PfJ/KX9G+4IwIzqH9bOlI0FJJqC8ABUTj7gz7e2V6rM=;
        b=EOYMTD/B3/BeXNkswHp4PCwwvn0vfs5IcVBc4wiquXOpKVTVPCgCdR9bij99bEcjnY
         X9WKm2ZGscdbnkULNm0pShR12ymY2S4IitCBVfn0F7Ex1f0hWKB6zjlW9IkJNBNuyNIT
         FnL8qzqnmkN16iBQ3hgAYsOs+Uio49NBqQWf0F/EHqtT0QBVHYE2rErrFLRD6Ip7hZcj
         AHOoDg34VGJQnObNp2ER800BJErkESstb6xX/+H/Kqn69QqNXFCJXpWEfOgIzT8cm73w
         itNcxZ/wWK+ngIIB9i8JNXBgY2/v9SVmpxnOh++p35k7yUv24tUo4y2fFQkvvMwOtAA5
         5IvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773407575; x=1774012375;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PfJ/KX9G+4IwIzqH9bOlI0FJJqC8ABUTj7gz7e2V6rM=;
        b=dfUKQiT1zKcGvMDWm0BVVtD4f9ISeEGBOYfkyXtPscaQfcrGf2DThH3mJkj6tmYzUU
         1DVXuiDWDTDnNcPVws4jBICv/NwegQ5zvdt0pYUBT7HY5D7/mfycGAXjxYtRVTtWm5I/
         34zjBcojR7VEGtaYg+EJYl3BfDqVGFWoF+kbBMNrdxl23VgZaEcPoNKu/+oDWEaT8jxh
         fWvrRKwuV2R2dqJRx3O+NVly3lBYgPHf54vyi/EvEj66p92GYL5YbFVpwmMM1qLkw/AL
         a9w5lHsXqOSsKuyEIkml57/IkMJsPN0HJ5x93NTSxaYpQItX4M/HpfZT0XYhRH3qk2Uu
         PjoA==
X-Gm-Message-State: AOJu0YzHFAtFibHlhSjl5brQUDvkAhUb5RFxE0S0jj7rSX6tbmRN2nsm
	SWLin0OiesxIruG7AUFyVIWqdt/7VvusqvshsWf3RGmGVYE/Ukg/VlevER7afG/8iaKZMCXS33B
	dsdAV3m97N95OUE2mg1lJ9TKARvUP2wN3wEey9oshE0/iYOjrm5epOdeaMqDbUQZ4X2XU
X-Gm-Gg: ATEYQzwUUfxSuKl8Arc4gyrcQuuvWGQYroMA2c4eCN2eyHxWO8kKIvKTA7Zuw/4RCR6
	/zW1QCgfKlmg1QRwspkEhxTN1uymhP0oon0TfCwJd2o4LzfG6iqlNdZFUsBfshoLKjG5qoMV3gS
	e51WPoKQcK8KBw3V22pTrrIV+vo05/4ZkQfuTx92FyFnOS2MLydvEJXBUxbd7ERUUii2wC9GLAM
	zGAZP0jFcX5O8KCIeJK2+et+b7vkidKDzSUma01zZRUSR/i6kN0IviPecbd7UwgeNzkum8d3Hah
	El2cRCL5NDsSkuVlgNO54ypanZGg0vf0rWRxGt1lca1cbKoSpZScFISKpXT4kQxFRKRtBbMe4I4
	ih5pyXJVLyts=
X-Received: by 2002:a05:6000:2903:b0:439:d7e1:fc51 with SMTP id ffacd0b85a97d-43a04dbeec1mr6581513f8f.36.1773407575364;
        Fri, 13 Mar 2026 06:12:55 -0700 (PDT)
X-Received: by 2002:a05:6000:2903:b0:439:d7e1:fc51 with SMTP id ffacd0b85a97d-43a04dbeec1mr6581432f8f.36.1773407574779;
        Fri, 13 Mar 2026 06:12:54 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe19abbasm16034949f8f.6.2026.03.13.06.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 06:12:54 -0700 (PDT)
Date: Fri, 13 Mar 2026 14:12:53 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Donald Douwsma <ddouwsma@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/5] xfsdump, xfsprogs distro builds and DEBUG=
Message-ID: <nxyxi6y5hdpr3jpmr3aehoaklpe53qqdrpkf27ejn4ospx4rin@6oib2fgjv3hm>
References: <20260224071712.1014075-1-ddouwsma@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224071712.1014075-1-ddouwsma@redhat.com>

On 2026-02-24 18:17:07, Donald Douwsma wrote:
> tldr; Fedora builds with -DDEBUG, is that what folk want or expect?
> 
> We see cases from the field where xfsrestore aborts on an assert(3).
> In each case there's a real problem that needs to be fixed, but these
> problems are preventing folk from restoring their data. With the asserts
> suppressed or removed xfsrestore usually does something sane enough, at
> worst leaving restored content in the orphanage where a user can find
> it.
> 
> This was notably seen with the original xfsdump bind mount fix, now
> we're seeing asserts fire during cumulative restores in
> noref_elim_recurse.
> 
>   xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed
> 
> This appears to be caused by a rename to within the tree between restore
> levels, or a combination of modifications during occurring during the
> dump. Fixing it will likely require changes in noref_elim_recurse, or
> tree_post, to ensure elements of the tree are created for these edge
> cases.
> 
> But why are we seeing assert(3) active in Fedora based distro builds?
> 
> xfsprogs and xfsdump m4/package_globals.m4 shows builds should default
> to DEBUG and xfsdump doc/INSTALL talks about how to turn off asserts and
> create an optimized build, but only Debian has its build rules in-tree,
> where they set DEBUG=-DNDEBUG.
> 
> Building locally on Fedora or similar gets varied results with recent
> Fedora versions building as if DEBUG=-DNDEBUG was set within the realm
> of configure or autoconf, which may be misleading people.
> 
> But for Fedora release builds we can see that they're building with
> DEBUG=-DDEBUG resulting in gcc called with -DDEBUG in the build logs.
> 
>   https://src.fedoraproject.org/rpms/xfsdump
>   https://kojipkgs.fedoraproject.org//packages/xfsdump/3.2.0/4.fc44/data/logs/x86_64/build.log
> 
>   https://src.fedoraproject.org/rpms/xfsprogs
>   https://kojipkgs.fedoraproject.org//packages/xfsprogs/6.18.0/2.fc44/data/logs/x86_64/build.log
> 
> I don't think the intention was to have these build as DEBUG, but that
> seems to be the current result. But before I dig into this further can I
> confirm what people think this should do?
> 
> The following series is illustrative of the changes to build xfsdump
> cleanly with DEBUG=-DNDEBUG, or the type of downstream workarounds
> required to help end users hitting problems for the status quo.
> 
> Don
> 
> Donald Douwsma (5):
>   xfsrestore: remove unused variable strctxp
>   annotate variables only used for assert
>   xfsrestore: include TREE_DEBUG all builds

First 3 patches looks good to me to include, not sure about the
rest and the original use of the those asserts.

-- 
- Andrey

