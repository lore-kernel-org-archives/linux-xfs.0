Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD4C376
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 01:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711069231; cv=none; b=hVmpZUaS4dXSYgxBMsT1pqi2Zr35mFw1T0gO9jWAoPHEDrZw4uIDDoSznY7ymDmKKrV9fKTYTCqEIw1aZgdEXbUtYK3pvax5gxDaLqwFGguBMDbrAX9+csLBF7O+hz8INf1qJ1ni7albzIA7hq6iFkvAtSmIM3gALT5kunDc7Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711069231; c=relaxed/simple;
	bh=R/n9TvbmbKIAIifKXoWEDN0Gi0anl3Oy7twO9B1t0BI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bymFQrbihi9hpQhWxRwolUZivWT+FskeZ+k+VFoBwryuocd4qC6W2KWHfxMugwNu/7cdg3QvUIUsSQaA3OyFJLI85PpwcNv+AbgsPwNGQfJhaPm35uCEG0mslgdqmCE2JsymgJSudWMIkMh9uYd3ZLY8B8Sxm0tnTpqn8qRqv2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=2QLpDCL0; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="2QLpDCL0"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5a4a2d99598so826867eaf.2
        for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 18:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711069228; x=1711674028; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=zAF2OQsdd50jyNFznhxA8Yvx5VgWEhwogk7UZowB/ws=;
        b=2QLpDCL0LqupBP2clQL0jCoi6EPHN5BsBaJywjEGC8WE3y/k+pYmNojv6uwSKW1PuQ
         A2P0/24cQ73oqrqZJWfOGYHEKm4nlYMP4iItnUq2FL6iQt3+YAg0kmdGKmgKUHncEYXj
         HMWrXnhDdHflzNL40hAeAXx+EpSOeMHWQ16hM8D/Vguo/GNZ76KOKJmZ9uhUAvfVi3Lt
         CC0g4w8q8AHHUBsX/oOsDsIE6M7/roxj8G4ikZ2aZgP5c/gHM8iGBWFTmZxvoVkXv36X
         LNsRW9vw0viYm7ZnAZn/Z0ny9VBIV9DKLkuwnUdNWUvCOpj8u1uJcGF/GKTCllmjZGkH
         dI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711069228; x=1711674028;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zAF2OQsdd50jyNFznhxA8Yvx5VgWEhwogk7UZowB/ws=;
        b=rpVs1IgQBc4KiDZ/y/AL9PYlwsf/3PN2R9N4d7lXoBXuPjHyunV0j3DLDl/N0Bc1cf
         9TFAj/3elA9IWlBcaoe/5fopKYg36VD2BCZpmfyVYHOcKGmcT/suaUz63cWARBVLzpla
         q/I7Uht/YYiiTXqliwnmYMdvrVN2KM2AOQJ+Tx4yicbYIB8n3BgkNUWrPsA0zx9zo3C2
         46SwnYQ5xyw7sQhROoHzzXXEQNTSHTXwoHwWnrC4xEjyMROgUYEyR5b9d9ueyjQwlNaC
         qcz0AnMukD9VmYGtMBcjkQ8QmMj8SOBKA5q3vWDVnkoTN2tkaIvlhnNGy7Np7ou1hZgB
         lRHQ==
X-Gm-Message-State: AOJu0Yy2tSVrjdHpn04LrOniR+jKmsx+HMP1UY98dpETReaj/MGD+xsc
	4NWDGQxAmWZB9eoHNM3h6OYA4ao/ralt96b2loJ9o7i6/RZbxxiXhm4/f8Jc6IpCsGfdkJEaIY4
	X
X-Google-Smtp-Source: AGHT+IH2TlF6cvXzWBsvo2PtPT+elIkxeUA9i015xlM5tDxT2Xq2O6gAS4q4lr4UWY4T5ZI2CHy0Yg==
X-Received: by 2002:a05:6a20:3ca2:b0:1a1:667c:eece with SMTP id b34-20020a056a203ca200b001a1667ceecemr1476787pzj.2.1711068902033;
        Thu, 21 Mar 2024 17:55:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id fd8-20020a056a002e8800b006e6c3753786sm456014pfb.41.2024.03.21.17.55.01
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 17:55:01 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rnTBT-005TZc-0K
	for linux-xfs@vger.kernel.org;
	Fri, 22 Mar 2024 11:54:59 +1100
Resent-From: Dave Chinner <david@fromorbit.com>
Resent-Date: Fri, 22 Mar 2024 11:54:59 +1100
Resent-Message-ID: <ZfzW40JtJAuVA/Me@dread.disaster.area>
Resent-To: linux-xfs@vger.kernel.org
Date: Wed, 20 Mar 2024 10:59:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: rename bp->b_folio_count
Message-ID: <Zfom3fCEDR7RyMPc@dread.disaster.area>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-10-david@fromorbit.com>
 <ZflApWnBkHDmo4HJ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZflApWnBkHDmo4HJ@infradead.org>

On Tue, Mar 19, 2024 at 12:37:09AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 19, 2024 at 09:46:00AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The count is used purely to allocate the correct number of bvecs for
> > submitting IO. Rename it to b_bvec_count.
> 
> Well, I think we should just kill it as it simplies is the rounded
> up length in PAGE_SIZE units.  The patch below passes a quick xfstests
> run and is on top of this series:

This seems like a reasonable approach - fixing the
mm_account_reclaimed_pages() issues earlier in the patch set meant
I'd already done the xfs_buf_free() changes you made here. :)

That just leaves the vmap wrappers to be fixed up - I think I'll
just replace the b_folio_count rename patch with that cleanup...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
