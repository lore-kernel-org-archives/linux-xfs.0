Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262CB6D39
	for <linux-xfs@vger.kernel.org>; Sat,  2 Mar 2024 04:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709355361; cv=none; b=DReCzyvYPpvl6PC8RbI/P3NYrKGOIID8qVTw+3HBbnAVHDCx6PDlLGhty/wChUAzdwdrbReyj4j8sUm3/WMYRbOda4G1+nGAL/bDBwRYJhflUMoBSl3D32Jis19pQ8ukWc7LS0R1M2u/qMGBH19A7hEuKoUYuxeWcFxuD5s7Vqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709355361; c=relaxed/simple;
	bh=ELKAZn2jZUtNyzdQvQKmYWmloxvvGBV1ci2VitltL+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uTjDySDnSTdP7YYreHSyhPs7C/zoFLtf5Ntnjgcm9gndcsiarIFcFeIYvxgUVReSOOiWu7ZkOOd9DzfYNsmCAdIFB9ZNQEj/0+qIg2X0JlmcOahqqi/cpsICUCdRxSa3Hw4YNK6o+Nub0vfbJIwkWvQMmBSg3XaZyeZlDfNcBY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D46aT29J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D46aT29J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709355359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3vEEF94P6LHoJobRm9XM8bCTELFJaK1bASos2j2n+m8=;
	b=D46aT29Jqi4GLSyBBj1Z+D8zFXncwai7tIKIm6bXb8J6iuVDXCIjK8WejrK5kGSNL5SL3X
	IxRGpTofw3fmgy2Mmee8X0Og09FDmXurxWygKZ0fA1e1XTkR4dqoLu7tDnqXu1A7UspYnO
	zWjsRqKphufppoiSAfMHecSNuiY0Yk0=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-gNb6jsuaOyqC82F1cB9vqw-1; Fri, 01 Mar 2024 23:55:57 -0500
X-MC-Unique: gNb6jsuaOyqC82F1cB9vqw-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-6e58ad52f50so1749230b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2024 20:55:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709355356; x=1709960156;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3vEEF94P6LHoJobRm9XM8bCTELFJaK1bASos2j2n+m8=;
        b=AabvHqOGngVZdwbmInkPn/iKvAOE7dU7jj9yuPRiQTznJELQ+Z8IfYqrmgrYIJhNar
         J2AltyDIf2peoS8hQoTD1/f0L+rruiryP+bORT8Gip/9RxEAPusxvpBfMaY25qFOB9+X
         aFacCPEXlhwha/MuJJhfMM8ViulZ/EsdOYJYU+3DegIDvXrSxXWlzByf60F/bI/JM0bQ
         ic/4aPz2++X/Qqbe2UT363lVlrfD+TDdarpHPQah8JHFP/n8KMMGyBn4aGl6Hq+Sf8+v
         W1XNd9mt9GxP2pFiaGl1o9O3ueKCBs4cbuEc0Vb17+ulnP9HVPMh93d5Zyog3RD/+Ffu
         85aQ==
X-Gm-Message-State: AOJu0YxK9Fm9V6wPkno/G1Uc0F+KHUSqfyaDyr+8Nfzbkwp6UrM67glP
	sUnKuUS+Up+4QzfJoOJip3sDzURpyljAclAjLiRN3Fg6nQ0G+yP4qui0Q3pViwK8yzW5j1XpEhB
	bexQ+KPHUpaz/ynDm80Us6mSQ8l6HcBK3n9JWOOkqXeszfW14jeABHzArjw==
X-Received: by 2002:a05:6a00:2315:b0:6e4:fa4b:b6e0 with SMTP id h21-20020a056a00231500b006e4fa4bb6e0mr4754016pfh.15.1709355356560;
        Fri, 01 Mar 2024 20:55:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEX+/CUQCoWwE5bwh+2jYPNb5NWU9Xp5nCSNDz0WoaWiXH6v2Ujc2DvTNLtNXWyPA+zspIsRQ==
X-Received: by 2002:a05:6a00:2315:b0:6e4:fa4b:b6e0 with SMTP id h21-20020a056a00231500b006e4fa4bb6e0mr4754005pfh.15.1709355356118;
        Fri, 01 Mar 2024 20:55:56 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id fh8-20020a056a00390800b006e55530067bsm3747721pfb.167.2024.03.01.20.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 20:55:55 -0800 (PST)
Date: Sat, 2 Mar 2024 12:55:52 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs/122: update test to pick up rtword/suminfo
 ondisk unions
Message-ID: <20240302045552.cq4dmvvyrkfm2fmv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915304.896550.17104868811908659798.stgit@frogsfrogsfrogs>
 <Zd33sVBc4GSA5y1I@infradead.org>
 <20240228012704.GU6188@frogsfrogsfrogs>
 <Zd9TsVxjRTXu8sa5@infradead.org>
 <20240229174831.GB1927156@frogsfrogsfrogs>
 <ZeDeD9v9m8C0PsvG@infradead.org>
 <20240301131848.krj2cdt4u6ss74gz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240301175020.GI1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240301175020.GI1927156@frogsfrogsfrogs>

On Fri, Mar 01, 2024 at 09:50:20AM -0800, Darrick J. Wong wrote:
> On Fri, Mar 01, 2024 at 09:18:48PM +0800, Zorro Lang wrote:
> > On Thu, Feb 29, 2024 at 11:42:07AM -0800, Christoph Hellwig wrote:
> > > On Thu, Feb 29, 2024 at 09:48:31AM -0800, Darrick J. Wong wrote:
> > > > It turns out that xfs/122 also captures ioctl structure sizes, and those
> > > > are /not/ captured by xfs_ondisk.h.  I think we should add those before
> > > > we kill xfs/122.
> > > 
> > > Sure, I can look into that.
> > 
> > Hi Darrick,
> > 
> > Do you still want to have this patch?
> > 
> > Half of this patchset got RVB. As it's a random fix patchset, we can choose
> > merging those reviewed patches at first. Or you'd like to have them together
> > in next next release?
> 
> I was about to resend the second to last patch.  If you decide to remove
> xfs/122 then I'll drop this one.

xfs/122 is a xfs specific test case, it's more important for xfs list than me.
As it doesn't break the fstests testing, I respect the decision from xfs folks,
about keeping or removing it :)

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > 
> > 
> > 
> 

