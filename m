Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284FD3515DC
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 09:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784885940; cv=none; b=lryMYXBxetlGVJm/39IMBDLCJrOm2doARBCWU89Mw0ci3BNk0yl/RutFKXU8dsLydGBzMTwSa4zten7juyGDsWHizf/AvwMhUSngD7hXBNChkvBfhJlKPfAy7izNZoqDCZc9Mhgmk2lklA7HzRffaLskBxathb3FshR9ZhNC+O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784885940; c=relaxed/simple;
	bh=5bygh+KDkyq5VnIRNVHRHMpV3wSyJVNSh4zxi7M408o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ND2XwzKAZBtBWHgT/Ze76oydYnsGl2HVsS+R6f8u+MWfuLNAj3Rsiv7obzC1cnXMOZoP6kDa4an6FU0ybXWpHpBbYHSaS/8ggFkbU8dupM4l+u7HogS+fRZt8AzEs+7Q0Qubz8XWHdBRcWr+z+fsKkjJ1XqtOwUz1CDVHM6wkoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JdAvZv9D; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=f3n9hsD9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JdAvZv9D";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="f3n9hsD9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784885938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0krbbzEdB1cnlzq7dONjoMYcCneykIRlk0aXIE/WO08=;
	b=JdAvZv9D8icmDbEp5q5WSZuEQkWG9qCflWHTT9XXQ8iplRsQDPta+C3ezYxBE5j6f26/p0
	LZG7CjZdUmGQcd9HhRJSV3JTYVQy6R59ENJJlSG4Z+2E0PKsgUY3x+hlFLSOcm409MKRN/
	Tu3kiW+H5RfEREed6mlhgZlqaTbEZPs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-ZIYzfQs0PSqyCIv6ZZPzyQ-1; Fri, 24 Jul 2026 05:38:56 -0400
X-MC-Unique: ZIYzfQs0PSqyCIv6ZZPzyQ-1
X-Mimecast-MFC-AGG-ID: ZIYzfQs0PSqyCIv6ZZPzyQ_1784885936
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4955b84e25eso2002965e9.1
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 02:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784885936; x=1785490736; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0krbbzEdB1cnlzq7dONjoMYcCneykIRlk0aXIE/WO08=;
        b=f3n9hsD9EZrWHliNWPbUXmKNyC3TbEIBqiuOchy848Cw3Ek5CkjwR2Wt898MfQCdJN
         R7YuySscDAoVypS7g5trVGJwDNY05itdHrz+CsA3Bq8Rz0DJRweMmtrvwoiiSl2I4T/x
         JB+C2PJORX5HmZCsp1WfUDbihtqYN6Qo4DY5RSa+/s2CT7dlzurautp5tJoqZydKgXzE
         b2lDTKNvyIBW8XVj7JMPxeU39P1X+h+otnT2YL4d/WT3VLOhRPlzgGAeNOh/QYpbDQNU
         em2ZJWWO5Caz0+NtNVukxLpwcQ3+Aflvmo/9hOnjewuIdFtbcuNtSBHoajhDvUyYXtio
         WPfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784885936; x=1785490736;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0krbbzEdB1cnlzq7dONjoMYcCneykIRlk0aXIE/WO08=;
        b=Bxvd7Ckj9FtCjzSod6oc51OpOedOeOwjWP2nd7F3DBIPOsKGK6TJlAbV/2v5ioRPp6
         mR4GwkpE5SnE9fvXdwzZ26rRme5PD4ieykicT04TtkcZeqEd4iwk9HPYdQlmoNvkH+5d
         8Als9vW1rOlarfQLxSWuNOooBVKNrFtVsIEp4tP1UQp92inRy+z/w1bDgZeA58dOYidv
         szAC7iYoOcx5Tb41YaGN8j7Gkc2qSaCvu8fyO2NQ6v4S9GVk8ZC2/9q5ZAt7JYoYv7wj
         gAsON16MytBaaE+CgPGHvCdSKWEufyjLTr9uxaZ+oBxXP+Cax1lVUwjg2hFHK8NAYZ7U
         0VdQ==
X-Forwarded-Encrypted: i=1; AHgh+RrDxIFCeTEedGZx/C7mJp67V2Ql+stLYFKo650Yt56TVmPjwahvg1EXP23JcRfuzwaYaGkCAqUv6Oo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwM7/dezpkSws3cXgNs7tV9qwPHV3OL7h8gLu7rHLWnn9JfChx/
	QAM4BUjNqL4lNp475PRbfMO3BXUSpA5nXLeuqNSgX3DrnoQx59OHaPa2wgnBC9aD2hhY+ASHdDk
	SxkY0oOLhJnn0EmNK3GYvs9+7V9j5V5e4Iu+vdefhB/CiX3NQT384x87TBJoA
X-Gm-Gg: AR+sD11UMmTnY76ilSLEyCrkmoFHzQvobKy2Db5Xr4ZKAS85chujOigYsQSn2NC8hsS
	tyX31f4kp3O62jgke9VnuwdqAN5JWoAmn0Nj2UIuAAjsyVHxHfrP5NRgEWQl0HIT76KSStOTspW
	lycDQg6nKfBAO7yICNFmiG5BBouYap1dPDOr/ipLrEbwtGaO2bJ5dZjfu/sqEa1SX5wsXGfEOvj
	j8pFlC4n/LSJ9NJQoYHP+WbTzBkSXJd9ZLEl4/FDgQpP52Tau9lgdAMnjoYU4W6ql5u9AH87MLO
	hDnVycExFt30Ko47r0SMX2+OvzS7EYYJ9v5MedLsD9nBrot3+7rrN2UQ1BlsmnRgLSkkBiHO0Fr
	LNIhPPiwiSrznMOIqNWRfh2jflKvEWMG1PSc=
X-Received: by 2002:a05:600c:a21c:b0:495:4811:7998 with SMTP id 5b1f17b1804b1-49573ca982fmr49200975e9.17.1784885935512;
        Fri, 24 Jul 2026 02:38:55 -0700 (PDT)
X-Received: by 2002:a05:600c:a21c:b0:495:4811:7998 with SMTP id 5b1f17b1804b1-49573ca982fmr49200745e9.17.1784885934954;
        Fri, 24 Jul 2026 02:38:54 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957af6ad58sm65616845e9.4.2026.07.24.02.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 02:38:54 -0700 (PDT)
Date: Fri, 24 Jul 2026 11:38:53 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Tal Zussman <tz2294@columbia.edu>, Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 18/22] xfs: use BIO_COMPLETE_IN_TASK for bounce buffered
 read I/Os
Message-ID: <amMvIEtEtRrNE7A_@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260723145000.116419-1-hch@lst.de>
 <20260723145000.116419-19-hch@lst.de>
 <amItES6s54i1QSHw@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <20260724062120.GA4953@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724062120.GA4953@lst.de>

On 2026-07-24 08:21:20, Christoph Hellwig wrote:
> On Thu, Jul 23, 2026 at 05:58:49PM +0200, Andrey Albershteyn wrote:
> > I would probably need something like this for fsverity.
> > 
> > When using integrity checksums with fsverity together, both file data
> > ioends and fsverity metadata ioends get onto the inode queue
> > (without checksums there's no metadata ioends). This way worker could
> > self-deadlock if data ioend processed first in xfs_end_io(). It will
> > call verify_bio to read merkle pages which could be already waiting
> > in queue.
> 
> Yes.  Same as the situation we have (or had as this is changing
> for 7.3) with fsverity and fscrypt.
> 
> > I initially considered changing xfs_end_io, for read ioends, to just
> > schedule them instead of adding to the queue, but decided just sort
> > metadata ioends first in the queue [1] as a bit simpler fix.
> > 
> > The difference is that work won't be scheduled on the high-priority
> > fsverity's workqueue. Not sure how critical this is as with
> > checksums all reads would be the same priority.
> 
> I'll need to go back to your series, but just sorting isn't going
> to fix the problem, as the reading of the verity metadata could
> be kicked off from the completion workqueue and you could be blocking
> the rescuer thread.  So either verity needs it's own WQ, or we'd need
> some way for a currently running I/O completion to exit and get
> restarted.

Oh I see, then, the data reads could be queue further with
fsverity_enqueue_verify_work(ioend). This way bio completion queue
can continue process incoming metadata reads while data ioend is
waiting for verification.

> 
> With BIO_COMPLETE_IN_TASK we could probably do that restart thing.
> Or add a second set of workers for "metadata".
> 

-- 
- Andrey

