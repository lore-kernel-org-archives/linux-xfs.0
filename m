Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4D538B7A9
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 11:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768303342; cv=none; b=dUYln+q3R9T1E6QnU5CSvivEOKUIkTFhk5ZEEwRUVH5aV1fJsi4pnDpzO9eSR+T1nhjtOXBCdfETjIQe/OrkuepGWou2taTeWzQHsiXklI9mg4Ldyg9uevh0XrY64iThiqh1uupmJItVexLACldsvmSuIjJT8wu1ygANw4fN9zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768303342; c=relaxed/simple;
	bh=bGU+byuWxoKQcS0Xj3pE6Dx3kVaO+LSqxEQBS0FaCho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oDTZtT+MTvFOAncyf4obPWeQtkNn4TI5sq82wIPBtrYGcz4pcLa249E2xlncIt8CGitIimAmKbu0xDH69ZeNOkxtFyBLD7wG/SCgnmCQroXUug0Ha2+3jrBzebM4Pn9KZnZg2dCYAbieMYQWyo2OI1IZ0aUSzj+1nzX2Wp/F9UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VKqWYD9H; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=luxNOiwl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VKqWYD9H";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="luxNOiwl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768303338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FM5vgtgxBBy+mCIHGqrkC14i392iYSrQOYRpquRMkP0=;
	b=VKqWYD9HF0qJNZijRUmzyV73KrD31Ud6QQMRlAANdINOByVMrAe+8sjF2uZtiDBWmq/6aQ
	09oYD+j1eAXHki1RqTk5RcC8GLDKebCNIULAWtsXyWzVD0z3yMQlq6jj3TU9tLaWLAqLss
	Zzqk410KavHcZ8iCWXx0uTmTQYv2b68=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-1mMJiZvJNj-7C1TjbuFQgA-1; Tue, 13 Jan 2026 06:22:16 -0500
X-MC-Unique: 1mMJiZvJNj-7C1TjbuFQgA-1
X-Mimecast-MFC-AGG-ID: 1mMJiZvJNj-7C1TjbuFQgA_1768303336
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso58073095e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 03:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768303335; x=1768908135; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FM5vgtgxBBy+mCIHGqrkC14i392iYSrQOYRpquRMkP0=;
        b=luxNOiwlIweRGXc+kTLyqp0GNfqOJbmZkKKvFfZA2X81LCrN067pJzfT/kPFHGNJQK
         ohzD3zjMDEgDeN75AGvQLjVvlAI7PR7x8QLgCpLzK/vB1ZXKR/bVGn019eMFJVJrDelE
         WUK0EaqKZDoti/SZh+h1JaXIxekLn0stySE7mybESZPcN+A/SJI9JO0ddjO/Zi4wQgIU
         6PQ7D3s+e3CEZx6GmNfqg47XAXxpjU87QKZUNon8DUNOrlu6s9E0qD2Y9BjyHMI6wx++
         5BnbB/BITmHpFWqOpzNNuG5piGmNyshaaoqce2IyTbzZCuy62P/lPfX3EjpXlNdCZ1ZO
         ShVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768303335; x=1768908135;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FM5vgtgxBBy+mCIHGqrkC14i392iYSrQOYRpquRMkP0=;
        b=QFzsMFeSes6H2dgG7OwyP1J1yDhf0ceqCWdFYFXn70I7cRiiDSIaT88ztgVKUxL0d+
         7ac5Z+wrDmqRIVovm55V14KxuD5FVgfM525ZZ9OJJRtVQ8ghhEUplu7fH6mvxdW/yVvD
         wjVzqb4I1s7RCaASwchxx3rmRsxlXqObxesTpvS6kso+qs1i1sfhBNsCWYGTxdEfB0u3
         VNO1D/Sc+SdSTR8NHNDGZB/T+vd/FzDC/k3ehS2kHoEd5BT8Z7JSgvRpHxX/U+ApQgb2
         Dj1h9lKrMQUVJ74o0d6YgpJQpTwvoVxEOWZDsZOxtfuC4L/WJ0KoTJw/OUcVtzQ/Jy6h
         431g==
X-Forwarded-Encrypted: i=1; AJvYcCUckiI/3wx1m+fcA0xYwBBR2767oZfw/YM2yW/8vZ43s38A1BnfjpteN+JUbyqX3gH++PJGR7wnshI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyS+gpw4Mds3VJkaPqPtKea74f8BYYGoTwoKsnMktbHu6zzJp9s
	SYKAuUEhuQuHu7+CWE1PlYrDammH+1BHY/1XQkNYw9TvBaM+paORtXEeS1vOBB5o7B5RAGktqXx
	tgvhBSHvoG2IONIBkh3pTlRW4Dhr7LsgB9F12pXlMO8vsqZ3FyQG2/WzeEwMCr2B9lI5b
X-Gm-Gg: AY/fxX4r96nmc8arQoeRRZRESBdekcmvKrsSkZZ4eiCBEEQPDFFOxevQKQrBFspmUGU
	/a8WX50QuwYXfeVufTNIedkzY4G9chvqVD/x8/kWFwGtFcIWkPZiolRnA4MXSoYKyArMOcJBTLH
	ugWiYSqT2UrJvLmrCWb/rrYhEt7tOXttRoi/B16Q1q3gq9qNsPOTnVZPh2aE5dqkw/V043qLI7C
	7Og9ZyIFjCUJyDOm8SPokQ46IzDK0s70tmKLn4vcu0n6Kux8cRrPMJ+WudyHPc3MjkLj4GLHbNK
	NXJ4825obOva21Itq/1+bcplikb1+OLfW/xgSybI9wcouH3icKY9KMZlD2/Fb4NtnrGdEp1UOTg
	=
X-Received: by 2002:a05:600c:45d3:b0:47a:7fdd:2906 with SMTP id 5b1f17b1804b1-47d84b21188mr256772235e9.12.1768303335132;
        Tue, 13 Jan 2026 03:22:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGECcWxkFiiho9xlJ0D1CGOKm8pe8jEYN9Y3nhBbyrWbiKdDM0WvmxiXd/9pHeU2AaRVbQriA==
X-Received: by 2002:a05:600c:45d3:b0:47a:7fdd:2906 with SMTP id 5b1f17b1804b1-47d84b21188mr256771605e9.12.1768303334401;
        Tue, 13 Jan 2026 03:22:14 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47eda0e59cesm12968085e9.8.2026.01.13.03.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 03:22:14 -0800 (PST)
Date: Tue, 13 Jan 2026 12:22:13 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v2 10/22] xfs: disable direct read path for fs-verity
 files
Message-ID: <5pr72dlwyxeel5tfi55wbe4ill2bjltbqih7kypt6mg3lpzcgj@36h6uwaa4fyj>
References: <cover.1768229271.patch-series@thinky>
 <6rsqoybslyv6cguyk4usq5k2noetozrj3k67ygv5ko5fc57lvn@zv67vcnds7ts>
 <20260113082039.GE30809@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113082039.GE30809@lst.de>

On 2026-01-13 09:20:39, Christoph Hellwig wrote:
> On Mon, Jan 12, 2026 at 03:51:03PM +0100, Andrey Albershteyn wrote:
> >  	if (IS_DAX(inode))
> >  		ret = xfs_file_dax_read(iocb, to);
> > -	else if (iocb->ki_flags & IOCB_DIRECT)
> > +	else if ((iocb->ki_flags & IOCB_DIRECT) && !fsverity_active(inode))
> >  		ret = xfs_file_dio_read(iocb, to);
> > -	else
> > +	else {
> > +		/*
> > +		 * In case fs-verity is enabled, we also fallback to the
> > +		 * buffered read from the direct read path. Therefore,
> > +		 * IOCB_DIRECT is set and need to be cleared (see
> > +		 * generic_file_read_iter())
> > +		 */
> > +		iocb->ki_flags &= ~IOCB_DIRECT;
> >  		ret = xfs_file_buffered_read(iocb, to);
> > +	}
> 
> I think this might actuall be easier as:
> 
> 	if (fsverity_active(inode))
> 		iocb->ki_flags &= ~IOCB_DIRECT;
> 
> 	...
> 	<existing if/else>
> 

sure, thanks!

-- 
- Andrey

