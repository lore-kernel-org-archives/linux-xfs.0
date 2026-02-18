Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49307318EC8
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 09:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771407969; cv=none; b=d9IepIP9FhZaz7ccOkFmDXMzbYX/uFQACzM1twEanQJpooo9uYpYQAfIVqn8DhiRvmPjqJ8AxQtBtL/1/KR0DI5yx9jOx9IJfzX56g/CMzoExUZMC4om5uCWFPKIRgYHcPPe3xr6krdxywGvgIJBZ/rhzAnpnhaIagTrhii3s/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771407969; c=relaxed/simple;
	bh=+/zonLHVCNiYpF3F1mGEWfBegPViwa5HxidFiTwykE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a1Yap991lFMwNyPEtJkzoeMXy0at104QM9SFqTO0Tqi20vwFR1/4rA8LFbpIchOVmHsKnajig+GzapNrgGWuBHKhZZl/ElQc5cBVSgsdTKcSbg4tQd+LV0tYt54V6iVy+wGTklY1INSGY89Lb3H0pVhWBRbMOrM1t7Uj/IN+Lms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b8Rz7/99; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EMjHM2mZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b8Rz7/99";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EMjHM2mZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771407967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RyJBX+PISSbPZLtLewMjCIqsH1uiQW06yqBd1F+fu9Q=;
	b=b8Rz7/99/k8NSLyn6gIhNMqdyo48jGtwFqkNaAAxcAR/cKIeCI8nmnZ5eDcgTlqV1LNFph
	m48PmmGsgf+o1PK6ZKt5Gv8Ll69hJxQJHcB2Ns2tCAofH1cqqvVfLBAfhsnV2epfvTcnjX
	KT+vo42ySDM9yqe+dphKMTLTS4NXnwY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-nWkVI_hmNCij0MqxeMptIA-1; Wed, 18 Feb 2026 04:46:06 -0500
X-MC-Unique: nWkVI_hmNCij0MqxeMptIA-1
X-Mimecast-MFC-AGG-ID: nWkVI_hmNCij0MqxeMptIA_1771407965
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48379489438so40360625e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 01:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771407965; x=1772012765; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RyJBX+PISSbPZLtLewMjCIqsH1uiQW06yqBd1F+fu9Q=;
        b=EMjHM2mZwQcFbUSpg6ErZ5H5HeecLNZBe+PM24XrTLhuWbO1Jo55TAXC+IRhRTo37r
         Xiod882IG8vbN4JcWlb5fhC7o2AWiNW6bTrMhWt66wsxMSGw7TDU/4l3VOJJUqVBvfg1
         bit5d1ler/sFnhu7uin6FTB6N0Oj8RkzRo7vo/2e9CGT/inzi3Ob/97qtb/HdPrIOQUo
         EpLSW7b4ruueE0eA7KFBrrUY9TVaaCkb97le+oxpJ5ko2qJV2cjKIJ2c1dFIzbYe4Aof
         VGsTUveRvBSYwBT3hgaqNZIh+qzovf/RvRFYfAH8kXq5wDxw8YEIBWvpmRQS2E9tpGkQ
         Gkng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771407965; x=1772012765;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RyJBX+PISSbPZLtLewMjCIqsH1uiQW06yqBd1F+fu9Q=;
        b=RrsD7g+u929sPWpX+0/GQepRs6b1MB6EaF6dXjzhAvYKqYt2pL2f2dNXJ/SIuirxeN
         yBbx1/hJGLurEnAv6Iondk09nyeuPro4NMufCdAjH2LLi6KTdkq+nQf1l/njrFK4OmBV
         apIJtTP4QXTgN/p9t9/hbgn8x/YX7CpVhyqmPZ46Fn/Ox3bftbIHfEmf1ma0SPfXqq7H
         O6zVLWBMVjM4sg2pJL0bQ5q5dyPf+L7PJnNPjlppQ2Ano9d6GNhpOLyyl0D3FOCd6AEy
         vMUkXZbgO4i3fITtN6XVDhdd9Pyn6iCeIAUm4kgfgx8JyW6FlRKcod6IK3ec71G/i93V
         DacA==
X-Forwarded-Encrypted: i=1; AJvYcCWgflx8fUpsp3Toq7O7Gusfs006YJjc31atBSqeLe982VQK5NFBJDkAa8yuDpM7pBoPI8Mb7QbiFQ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZYKoFfdI2uK5j4Vz1ZIQ4nmwzHVwkv1PZ9/iBrz8mp8TpCuKG
	TUG+Nw/Pk+2Dn6rRduqLhMX7qmejgS+FYF5Y6Sma0o/BYApuWLDNlClA6KVLIBWVJNG+4q9zE/V
	ziF/19YjFsaCUC7CInCTI4bPJB66RZQixPWus8d2apIrSNXjZ3yIDF/Min5cB
X-Gm-Gg: AZuq6aJHeHTbSaP44GeVDe4nEzL+A2p8gRoZ4Zw5u693Rd6fHxlg161lkNwBH/NpEDu
	9E9d7ViR0fatHHwOvbawwZMjvVKicphKQja6uCUhEPEaS3sGFx71/ohivcduGNclypm1qFMWJWA
	biquN8vCWeWCpn1E7e9P9ZnCv9T8D6rxWeCT1Dk3YNl6Ujcx6mTvmcfmsMdWjmnv6Lxv1QF5yM7
	e0S8Vr1wMCEcT5jT12hJeQXluVb/AD9ae3ivwv9DRx81wbGFT9ad8eogQNfTKgHDEzEyTHGTT2U
	Pndy162steXY+Dgue6Nfuw/FsENapOr2FeA7azvUzu/KAyW7CEO949WBlgbyplr6pE5Wn5d15iI
	mu4Qc3DFWjG0=
X-Received: by 2002:a05:600c:4f92:b0:482:eec4:76d with SMTP id 5b1f17b1804b1-48398b5e0d0mr23667685e9.17.1771407964661;
        Wed, 18 Feb 2026 01:46:04 -0800 (PST)
X-Received: by 2002:a05:600c:4f92:b0:482:eec4:76d with SMTP id 5b1f17b1804b1-48398b5e0d0mr23667385e9.17.1771407964108;
        Wed, 18 Feb 2026 01:46:04 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48387ab1974sm196913305e9.3.2026.02.18.01.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 01:46:03 -0800 (PST)
Date: Wed, 18 Feb 2026 10:46:02 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	djwong@kernel.org
Subject: Re: [PATCH v3 23/35] xfs: add helper to check that inode data need
 fsverity verification
Message-ID: <7c2kegonzbfrdv3thcrorgadyuejyknb3uipxlbxkpa4gfgu3t@zpowelexa6zu>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-24-aalbersh@kernel.org>
 <20260218063827.GA8768@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218063827.GA8768@lst.de>

On 2026-02-18 07:38:27, Christoph Hellwig wrote:
> On Wed, Feb 18, 2026 at 12:19:23AM +0100, Andrey Albershteyn wrote:
> > +	       (offset < fsverity_metadata_offset(inode));
> 
> No need for the braces.
> 
> > +}
> > +
> > diff --git a/fs/xfs/xfs_fsverity.h b/fs/xfs/xfs_fsverity.h
> > new file mode 100644
> > index 000000000000..5fc55f42b317
> > --- /dev/null
> > +++ b/fs/xfs/xfs_fsverity.h
> > @@ -0,0 +1,22 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) 2026 Red Hat, Inc.
> > + */
> > +#ifndef __XFS_FSVERITY_H__
> > +#define __XFS_FSVERITY_H__
> > +
> > +#include "xfs.h"
> > +
> > +#ifdef CONFIG_FS_VERITY
> > +bool xfs_fsverity_sealed_data(const struct xfs_inode *ip,
> > +		loff_t offset);
> > +#else
> > +static inline loff_t xfs_fsverity_offset_to_disk(struct xfs_inode *ip,
> > +						 loff_t pos)
> > +{
> > +	WARN_ON_ONCE(1);
> > +	return ULLONG_MAX;
> > +}
> > +#endif	/* CONFIG_FS_VERITY */
> 
> It looks like this got messed up a bit when splitting the patches and
> you want an xfs_fsverity_sealed_data stub here?

oh, right, haven't noticed that, will fix this

> 
> Also I'm not sure introducing the "sealed" terminology just for this
> function make much sense.  Just say xfs_is_fsverity_data maybe?
> 

sure, xfs_fsverity_is_data/_is_file_data maybe? to keep consistent
xfs_fsverity_ prefix

-- 
- Andrey

