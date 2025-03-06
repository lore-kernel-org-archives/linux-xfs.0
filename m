Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBB3B661
	for <linux-xfs@vger.kernel.org>; Thu,  6 Mar 2025 00:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741222655; cv=none; b=JI/mpnxEzXQev6SXdNCuIsSIE8M2WQRUDu+UnRTjM+0SfdUo7iRoNmT0KPPwxL+YOifRZ60hhlY600Xa0+6CaPCLlGVlILGpHnZxsYghRpckl45CCmThgJo9uJf6huvq8/SxgYoPSEEf3SUw7rOrXo52e3+N+RJbpf2dL9QkiAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741222655; c=relaxed/simple;
	bh=/BuYc0IiQ+BLgYmlejL7wsQkzt7ljuiQanBTGiittK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BE6OOhPGooImIumWV9R430OLYgNgTBKXF9yygKPvd1WKpZdL0hEMdjfOgBHoTX5QNJ+nAjr76m5/kmIajQ/KfPP8tSWpnwDT/mwnMEDQCdvzdUqanzPMW8KLOPSSR9IRoTAiQfu93bn4pAq2Y02HVkVqTRITPyi/Qdrv977A+zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=b04gvRiD; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="b04gvRiD"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2239aa5da08so807525ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 05 Mar 2025 16:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741222653; x=1741827453; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AchpGjutQnMq7ioaypF8uU+cDR5ucoX1O8Ctqb03z7Q=;
        b=b04gvRiD3nCTy4QtblP/YZ/QEzO3PViUJiVAfJ2nGdz4Ul5iY5qFDklzX4uWX7i16l
         Gcul+4w9d5Z5poSdL9CyUCSkC3A2rdwR7v1bHWh96oubAVrwADvCYi7LxRrqL/b7dGK8
         3adnwzgFKG9k86qvljg/8TLBU5JlAYaUKNlfPk/sSGRNA3lQRn9ExghphAuodmBQttka
         qzILFLguO/SQRo9b0tfYhrbhsjcwpHdXiHQa/83VGWQ/05pSeUP8abyb28/VjPIByVeC
         AGi/iieWpr56+219ih/e/jdDZn6LhTuM2UAo8LmzZeUYKxrPlsG5A3gScViDtMk5jW4v
         9AiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741222653; x=1741827453;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AchpGjutQnMq7ioaypF8uU+cDR5ucoX1O8Ctqb03z7Q=;
        b=QXMSQjsRPOaOE2knAKZ401RVpVFZK0mbE/Xay1HpLwtpQ0Ua+mo1xro2aGhdla+ueC
         oHfTNnksd4nTusKalHG9UHcFtvEgq65Y01Faw1dvzfSS+G495EOBK4n/A/+p8KFj9AM4
         5ETwLATFXwScXR7LCsnWag7CNEegXvJ0A5bCGyow5je95l4K1r/swMGkwlPmxUQfPNKs
         OHcDk9YlIzfUoDuT0nbAtJVX8ztb7Gx2NQT9ImW2/hxF8Mp1mBCsV041IDoyIsqmWUIM
         2NK9Ek+AaLFxS7U/lmbzRzhi+1ka4Tq9uuN8zDbZIkTE0UlvEoexkAvXEJgSDbih1TNm
         zXNg==
X-Forwarded-Encrypted: i=1; AJvYcCVLt6YIhoGMVNBjyw7gl8ymYzSs09Uoufw/ZV7Tqk3k8JhJ3v6evwDCWAWhgNdbLdP6mzfZkgwGEug=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz28zlZQABmdbZR+wEu2knxQVwyJY+UijaDIiRgBVaWTEdWHdFE
	N3N8k7feCnYkYWGpfMQkLqmxNEBk4v/lWrfKfoIemmkYzUW6IpvuIM16W3SoKO0=
X-Gm-Gg: ASbGncvDjM6cSaDu0VqF0Xyg7HG+rWAS46ea6PNTNjux+2DxPNn2biaXjCGG3MVC8ge
	cyDr3zs5pKkEZEetrfvW0OiXfwVzIgChNvyDwbL0Vz9wv9/V5xLRYfoqdrtd0vGEKzhbRpdZ8Xd
	10A4P9JoutvtuF5Lk7286oz2BwETeduE0k2RlS8+m7Z08E5R9tCmOfEF4wf43/hsLX3KeCUZ+ss
	EZd3ebGTInIJ7Ag4hQ1AFtD3mKSLZDz+abFYNan7/1GkjLE1OV/lroc+E66xMk9ipKRtbSiQtHW
	qopnHoTvjCwSOjzBRe46rzKrlXYP5hJGSx/++xjnvDAKyRtAxWhTMIkxjgLpPRXnx2dlSPcCPtW
	wgq52D62KZVmZ+xuRszX8
X-Google-Smtp-Source: AGHT+IG2YeiuC2ckgB3jymldRwPbytKqhSW7v3CmNxXtf05EfR8uzQwPUQP2FyfNSDdC8DfmENn9dw==
X-Received: by 2002:a17:903:2301:b0:220:e1e6:4457 with SMTP id d9443c01a7336-223f1cfa46bmr81626775ad.26.1741222652932;
        Wed, 05 Mar 2025 16:57:32 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109ddf9asm540475ad.5.2025.03.05.16.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 16:57:32 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tpzYH-00000009OiW-3H8N;
	Thu, 06 Mar 2025 11:57:29 +1100
Date: Thu, 6 Mar 2025 11:57:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: use vmalloc instead of vm_map_area for buffer
 backing memory
Message-ID: <Z8jy-VIjs47EDiow@dread.disaster.area>
References: <20250305140532.158563-1-hch@lst.de>
 <20250305140532.158563-11-hch@lst.de>
 <Z8jACLtp5X98ShBR@dread.disaster.area>
 <20250305233536.GC613@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305233536.GC613@lst.de>

On Thu, Mar 06, 2025 at 12:35:36AM +0100, Christoph Hellwig wrote:
> On Thu, Mar 06, 2025 at 08:20:08AM +1100, Dave Chinner wrote:
> > > +		__bio_add_page(bio, virt_to_page(bp->b_addr),
> > > +				BBTOB(bp->b_length),
> > > +				offset_in_page(bp->b_addr));
> > >  	}
> > 
> > How does offset_in_page() work with a high order folio? It can only
> > return a value between 0 and (PAGE_SIZE - 1).
> 
> Yes.
> 
> > i.e. shouldn't this
> > be:
> > 
> > 		folio = kmem_to_folio(bp->b_addr);
> > 
> > 		bio_add_folio_nofail(bio, folio, BBTOB(bp->b_length),
> > 				offset_in_folio(folio, bp->b_addr));
> > 
> 
> That is also correct, but does a lot more work underneath as the
> bio_vecs work in terms of pages.  In the long run this should use
> a bio_add_virt that hides all that (and the bio_vecs should move to
> store physical addresses).  For now the above is the simplest and
> most efficient version.

Can you add a comment that the code is done this way because
of the mismatch between block layer API and mm object (folio/slab)
handling APIs? Otherwise this code is going to look wrong every time
I look at in future....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
