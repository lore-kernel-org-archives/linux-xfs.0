Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BD01C3038
	for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 21:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739222865; cv=none; b=OFet442XRo5J+U2ow/S3Rz3ziExrLonqcqa2xfLo/WCa1OiAUp38nwkVFl0uxaXKDBI5VrnPaQAerGmwBHzoaibZWBZfbrxRsuBXVUA6tP2sDbG3GuBHNIanJQPripBacI8JuiSWfSCnn0ABenl5ba+4W6wekxHwOzoDH+zXP6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739222865; c=relaxed/simple;
	bh=TCGFMO0Kzsl38vGs8KnFrQdwRbWq3ZsAVQzKAWEcFSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XDTnpL5bNNKWmntQJFTkV/oxF5wWUD0oRcobIfPY15gCVWbuyAsFD6aqgFnzHZ9OFEFGSJg2fL1fRbza0NUSnGKbM9OtrErONuqv7qSrkl6OZAKkCMa03ZTt0jHZgoKSQ15htkcNvkFHoK8JsA4k/9wXaHsjSK8ebBFzkBLHjtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=m80CgoDy; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="m80CgoDy"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21f0444b478so69247255ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 13:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1739222862; x=1739827662; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gtOKP/bSIZMX5MzdlHWBebrHFz0TkipWTyjAUPt1uMI=;
        b=m80CgoDymXqcSb71WKtyRjnyOj5/lgIaJ3+8d5w8sJBZYdc36ts2rv49t91qtaaQ6T
         JiD8qtsAxtPh6+kmvd4LMspe5wScvFp67mQVk/Wt26JgL7qziUdXXYO/tM8QekFPaXZv
         9Y9dYgghH+K73QvYgItkmswB/sLLrqXkleWZ5IeQbc8Kx6DdVMBG9ZrTm9b2sjPBhrQx
         yTtBctdeObi0yIwEvFEW4fv6O5j+uMTT78TKkFtVU7gcER+6liKBEoSgdaB7boiIgooY
         EXhSAGas4RHP7+fIs4BZW/rLCsC/8NKtFZWGMX1gpmtBWLJQOpx/mZkxDIKAly3/Ckh6
         dquw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739222862; x=1739827662;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gtOKP/bSIZMX5MzdlHWBebrHFz0TkipWTyjAUPt1uMI=;
        b=g4+8BogePSxxTMlwvUpS2a4Gs2Ng0D8Vznuikhh9vDJ3T6eGAQIM4DjJYovcvgKk/N
         23hROQBGmqoyRVFRQf7617cN/yUlhyNmQtcymBnfmHel40DgTOHzleqei0lg2CsPVUZn
         mQx+WezQMVSx9SOOqshhKWI22CvXsuyii6MjlqAkXvcAH7TZ+bHaI3WKStBzs2ck6kwQ
         ahCNw2Ldi8qdmhvZVDx1SxCBb8JZhPDGeYvh2Lk0+SxdBP9qeBgNKUqKuehubDmuKcQB
         UBr+joRistxir0svcbedBlFEGGJoAPDx0MMaJbGTL8fCKvjRUqKHgEUZQ7YeHi2C24hv
         cK1A==
X-Forwarded-Encrypted: i=1; AJvYcCX/N8441MO0gzxf4+T2/7n02ovyXugEfrfJTN2tXNKanriKa1Z9V+prtuycaE0918EzjGKEBZI5rQM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQnUjCWzR2/SxEoxiBi+WxhDNEZePpTB/TOpwFxT3MXl8ZwRa3
	bNL+ysrKIf/2UQSGh86wVGI8Kx8mhpSCxzgSzZiZ3bKuAt+QB9v+6WndFEhwOXgHkr3IfdwgAyf
	9
X-Gm-Gg: ASbGncurh3hU8SZC9b8roi3lbJT7R1c6O1qVjbp4/8UrQ4c2hYI3cUNsf3hpQzN5JJy
	Kit6fgY/+xK19Iqek8FW7RyjRumtTF4MlR7A/eNAsenaBKohA/8ZWd2MUjfxR7BpuYDlkfbI5Nt
	OGP1EH8jQcCmtIHBczzqTooCCjYaHrzGq3B6WwkvZ/B/OAv84pnx5KyiXRJmpXqnlS2fStkJN2y
	eSBiiRfUrZ0PMNNH3yhqvg8UiO8vMo2eOyDuSL6WAWtDGprNwj1KF7HB8j1XWMNERumkPUREm0P
	7QEmshnc+ot+TA7nYgmrGZe8MCe+cKabawRwLa5XALPzyFWqawTrOYDwYl4s1QUkYwo=
X-Google-Smtp-Source: AGHT+IFr35z0eAENl9HzqdOEk7n54mdmMk8QWjypibe6vwYaIzd14Ua8l2RBxoHpJi316a7c9TtdSA==
X-Received: by 2002:a17:902:e802:b0:21f:35fd:1b76 with SMTP id d9443c01a7336-21f4e777b52mr239809035ad.45.1739222862295;
        Mon, 10 Feb 2025 13:27:42 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f3650e689sm83568755ad.48.2025.02.10.13.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 13:27:41 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1thbJb-0000000HCZS-2H6i;
	Tue, 11 Feb 2025 08:27:39 +1100
Date: Tue, 11 Feb 2025 08:27:39 +1100
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Raphael S. Carvalho" <raphaelsc@scylladb.com>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org, hch@lst.de,
	Avi Kivity <avi@scylladb.com>
Subject: Re: Possible regression with buffered writes + NOWAIT behavior,
 under memory pressure
Message-ID: <Z6pvS6uL7AYLHi9U@dread.disaster.area>
References: <CAKhLTr1UL3ePTpYjXOx2AJfNk8Ku2EdcEfu+CH1sf3Asr=B-Dw@mail.gmail.com>
 <Z6prC2fBbd6UE49r@dread.disaster.area>
 <Z6ptDG96_MrdN07R@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6ptDG96_MrdN07R@casper.infradead.org>

On Mon, Feb 10, 2025 at 09:18:04PM +0000, Matthew Wilcox wrote:
> On Tue, Feb 11, 2025 at 08:09:31AM +1100, Dave Chinner wrote:
> > Better to only do the FGP_NOWAIT check when a failure occurs; that
> > puts it in the slow path rather than having to evaluate it
> > unnecessarily every time through the function/loop. i.e.
> > 
> >  		folio = filemap_alloc_folio(gfp, order);
> > -		if (!folio)
> > -			return ERR_PTR(-ENOMEM);
> > +		if (!folio) {
> > +			if (fgp_flags & FGP_NOWAIT)
> > +				err = -EAGAIN;
> > +			else
> > +				err = -ENOMEM;
> > +			continue;
> > +		}
> 
> Or would we be better off handling ENOMEM the same way we handle EAGAIN?
> eg something like:
> 
> +++ b/io_uring/io_uring.c
> @@ -1842,7 +1842,7 @@ void io_wq_submit_work(struct io_wq_work *work)
> 
>         do {
>                 ret = io_issue_sqe(req, issue_flags);
> -               if (ret != -EAGAIN)
> +               if (ret != -EAGAIN || ret != -ENOMEM)
>                         break;

This still allows -ENOMEM to escape to userspace instead of -EAGAIN
via pwritev2(RWF_NOWAIT) and AIO write interfaces.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
