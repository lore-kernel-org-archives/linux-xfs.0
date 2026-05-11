Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554A92C0299
	for <linux-xfs@vger.kernel.org>; Mon, 11 May 2026 11:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778498148; cv=none; b=NJwoSEUHzZPJ7NFgg0JVUfP8gkPQFrT44ix2SUCgjRdvNxGCnxSuVHg7OxFH38Crf2397X5i8d8LW3yjgx9YFEfoDcPcF/iLLw8MAa7wXetcz8Rg+Rq9kShM2pBbbcs782j7qJu8OfB+HdGBd6Bz1wHzJHa4vmokl62fbaDvJ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778498148; c=relaxed/simple;
	bh=RR1NenBgrAYdu1c55iySbUR6WPCvJPcX8MV/1pGj/Aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sxgfBcQDegAGajfwTMxXU1mtvACkrO6nGDByH8NaRa56WspHR9krCxtd5DIUqp00AF9wzXqdZnpHddFvuZxrg/uki7rb6RjqItBSPs8wf6oyzSQa0/PC03dY0eakzbRvHqIqHh4G+d857+40kM9zhFOvrzz+79ZQfsF1L6Y+2ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IlLwuKIt; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JD7RYlZU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IlLwuKIt";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JD7RYlZU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778498146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yQi40JXMVWHDZRjke+rHrQlcRrLFkKa2WRv/wpGjnDg=;
	b=IlLwuKItqCC/e2dJp+CtZBVs4Q42EFIS1Td4DgQltJTZc2ZFmusRFzeWS//BGNWIQU3URQ
	/y4lvWa667bE43QUz1pYA+JS1lw0vl7bDkwlYvjnCw2DuGpvPK1+hr/u+L2kdf7eSEqENT
	jSw1mh0/zVPa+OqEb8HZArCRybrDoRU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-KZ5PDT7yPu2gYzbxCHnsKw-1; Mon, 11 May 2026 07:15:43 -0400
X-MC-Unique: KZ5PDT7yPu2gYzbxCHnsKw-1
X-Mimecast-MFC-AGG-ID: KZ5PDT7yPu2gYzbxCHnsKw_1778498142
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43d7b7bacddso2695784f8f.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2026 04:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778498142; x=1779102942; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yQi40JXMVWHDZRjke+rHrQlcRrLFkKa2WRv/wpGjnDg=;
        b=JD7RYlZU6EskBY0iebQXhrP6fG75D84nXogDPu32FfcEw63rnM1IikbMUF2W/1X4Dt
         vZt+Wq8PziYB+4Hp7ysslCShy8FNO/Ok6TcQ4mFZ6m0CiQTd60l6VyvOfoqewkkfBYYQ
         FkZf3iCfI+5BBlhha7ptXvQZyNtIxwStyV/4KlGARJYEQYkV5SXdLGUxd+I4kXg7z+vB
         r/CeTPBzHD4KfQFNbu0VqhuEplLProVADaEeS+0jmKCpu725WyJezz2C61yDE0sToe9q
         lDw3yxAMwWPWjke4qYIA79uVQLaRPgr0bJBWYyFBaIo/2EAZGrKxl8U4V5UuHvErYF9T
         vgyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778498142; x=1779102942;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yQi40JXMVWHDZRjke+rHrQlcRrLFkKa2WRv/wpGjnDg=;
        b=sFl9ILdWct8+mPC7gHsYL9WRXUL40r6dXDntSPrbFfFm9zR1tVxXrpy3lsnuKG2RcS
         BLwW2xZ7jhGRqv62qKTI5bOHBbwGySD4L8e7intecP6FDaxHykSo3aa7pdy8hFux8hHR
         /6UP8J9P/jBNHXaqaXxu8xk3pGgr6LkW49NEQgFT5jktfBHlgGaRTuxq3RrSuUtjR13+
         5tN5JEzGfsi81ofABHclkd1IUCNJg3whHE40Ok/whjjQn3h2P3NEvC/JfxP7yCwVWvBz
         wIyGmCDBiBQays2QzKpupzimUAOOzIP59QTNFRVnZUKyHjoBJvtzXmyd82YHa4gIebo1
         85rA==
X-Forwarded-Encrypted: i=1; AFNElJ/xCgMx394p8WNjmn0kOdO6nee74TjRy6Dgi6uBe9nzIN2xUaIYhodkCuuAiM1rtZ3SY++4hTi2obA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFhMohF/jnBRwOPkJygIKQXqOPrhrrhNf9Tl7LVtq/wa2nYcE9
	Gl6ft2GLBGsHIh5ZfzR77IWWuHk4SZmaf/lViC0obFjIyDb40fou4istwig+MSvgkID+SDH53gu
	WvVsW2GKlBbBk1h4Oxm3FCnjmQNg31PH6DtljQ2dhbukZI0kfkJaXEZc5XA6k
X-Gm-Gg: Acq92OEmO9j5GlcfokieuO3vxazNDfJ595Ujbs5VMrUbvvLB9FtqAepWf8EF2Xl940Y
	8dmNxz3CoalGMxgB39vEGxco0gMhGVqyJvAdKhg6U/jXP51vtohi9NkTSv0ko/YlxyxXyUSUdRU
	2HT/p2nK/8aS1wchfIboGdddNdEnsO74Xn1yaoSN1SDxXHCms+7PPJo3Hw2feNBGcAdAUcIygC9
	z3diztvBWcRmhPg8Gqj8fWBR3xX5l5KnvhkKb+o8I0gfBoLuH3mNiMyG6E6p0eYA2aUaNA28olR
	c1Sh4uo4onDyGbQpm6HwqJRw7mM+WB4KnUoJhxGnUloAvH9XXM7A8hTLLR06W8Z/zhFqjBRXImc
	9CjPgZtAvSGY=
X-Received: by 2002:a05:600c:1f89:b0:48e:8741:fd4c with SMTP id 5b1f17b1804b1-48e8741ff98mr21083565e9.18.1778498141640;
        Mon, 11 May 2026 04:15:41 -0700 (PDT)
X-Received: by 2002:a05:600c:1f89:b0:48e:8741:fd4c with SMTP id 5b1f17b1804b1-48e8741ff98mr21082605e9.18.1778498140980;
        Mon, 11 May 2026 04:15:40 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e7040a9a9sm309872515e9.9.2026.05.11.04.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 04:15:40 -0700 (PDT)
Date: Mon, 11 May 2026 13:15:39 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org, 
	david@fromorbit.com
Subject: Re: [PATCH v9 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <hnsxzymuydf5evoxw4chao7rkixm4eafolebxfjtsqschgfazh@nll3fdfnsigx>
References: <20260428083332.768693-1-aalbersh@kernel.org>
 <20260507055217.GA19888@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507055217.GA19888@lst.de>

On 2026-05-07 07:52:17, Christoph Hellwig wrote:
> On Tue, Apr 28, 2026 at 10:33:06AM +0200, Andrey Albershteyn wrote:
> > This series based on v7.0 with Christoph's read ioends patchset [1].
> 
> That's not a good baseline.  We'll need it on the -rc that has everything
> from the current merge window at least.  It might also interact with
> the fsverity fix that just went in.

Sure, I will sent v10 with a latest master and that fix soon.

> 
> This might also be time to come up with a merge plan to figure out through
> what tree(s) to merge it as there don't seem to be any maintainer
> objections.
> 
> 

-- 
- Andrey

