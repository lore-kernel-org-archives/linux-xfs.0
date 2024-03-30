Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C8C2E3E8
	for <linux-xfs@vger.kernel.org>; Sat, 30 Mar 2024 21:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711833354; cv=none; b=C/vHoZ1osNdzgCuT6bqnks4L1r6hla9jwH5p9LAYiSevBhxOHQv60MJNqk9rys102v9tDegcTi4O8J7S/nG1ea+qKvOuAx3Zva8ynMG8ySxywfAepFYSbe6djf5ON5y0S0bSh6b5Kphpm60WOMIOhChWv51XhRYwGOXOPf6Vmlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711833354; c=relaxed/simple;
	bh=qeTQPr1mVp1xkR0y2bXLLeBp4GXtJ7IdtJIlI28sleM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j3pUmZOv+6/0XPhKO/A8Mw69YxRmnAp3/KCi8+WpjXQM3nTDrCOJMW4vWhE/vQx4/fFfnp4cvvbINQMkQNeJYMOsRw1dwDXuI9uW2joIH6ZdhPQyU82lO3nc9T/a7M22WAmaaltBa2NbkbjKhk+Dlu44Mv+8y6FK/M0ouHjiRzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=W8NxB95q; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="W8NxB95q"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1e24c889618so918095ad.2
        for <linux-xfs@vger.kernel.org>; Sat, 30 Mar 2024 14:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711833352; x=1712438152; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4yeacBGm5sCcD3/hi8/4AIAZ0YgvYCwb/I2RHr/y/AY=;
        b=W8NxB95qrG+RrqLBYpkUReO8APh/6UgjGZ/1+hBRweJIkbGuaaXjXxQdhyKZC2ho3D
         2dyV0paj1EmZ6rROa4YCplZ65VPfTT7VizqRvQWnCsdTmEQuiahRgWy/gNUZkTBjE/Oo
         YI8YCI70uSpQnEPp0stZlm06KBF7O/QY8KGTgNzfYbwf9+kzTCMWogpSOrSdKhbR4Gml
         LNioq7KdF4hko+iNa+M34DeMmvMCET1JGzthRlCTszZonwIJ95uqsp2HTPj4URw/UQci
         lqjaI7aVvYuigrXDzQCMDNvMWdYHkB44RcOjzjvoqIsjb3/GAlD2nw+BU4C3mCHdVLyG
         gXYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711833352; x=1712438152;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4yeacBGm5sCcD3/hi8/4AIAZ0YgvYCwb/I2RHr/y/AY=;
        b=PYGQCq5DI/gCSc+SepM8s67iPMRdTwLVSaX3s+WCE4T72TYOK7cV8/u6KWaM7Y03ip
         DixW6UZwZ5Iwvr8X2uM4RjG9guhSquH9gvFCXC8fj5Vr7p1tHtXis4esLWoVOO5iZlSy
         kYZAvXKda3DT3OHg1x0+B4arX9PtKE7roq+z0OBQfKHFm94dzGtYotIkSNbXqgthp5ln
         FRRiIVZ3+CxTdRFbIlVnNTrPm4BdMYG8qhrQ0oGTZKEBWatU/A02pPl8VEvoCfRvghA0
         mguSC01QmqU6vMKFYu6YlPQtBOAeROXinUDFyUNX+tWbNFyIem370lGwT6uO5AXQ1yG8
         IFLw==
X-Forwarded-Encrypted: i=1; AJvYcCWvNf8ufteUIiPtDVKxN57QSAH1f8D1q96LzOqtVCSZhnjX9GRTIkYobEXOnPhb0W10dppizAzIN8iuCy0prQdiYu4T7U3dPToM
X-Gm-Message-State: AOJu0YziLT8HbwJk/tKe6HazSNga1CZgkNtyl8AVORSwQbORNqDuV9hq
	NB57xF48usm6ken57seAL7gGuIQVT7jwg7QZxF1fDhlVifsT5vcY5RNbtSM4ZZw=
X-Google-Smtp-Source: AGHT+IFvxVOfZS4Vv4KCRfZqdr7aYJat52ZAAoYvwba3vB87eiK7+oRjdOby4A38VgjPsLvrT4Q9Xw==
X-Received: by 2002:a17:903:1c9:b0:1de:fe74:af6b with SMTP id e9-20020a17090301c900b001defe74af6bmr6117034plh.46.1711833352090;
        Sat, 30 Mar 2024 14:15:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id e13-20020a170902784d00b001dd69aca213sm5761290pln.270.2024.03.30.14.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Mar 2024 14:15:51 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rqg3J-00Fr5I-0M;
	Sun, 31 Mar 2024 08:15:49 +1100
Date: Sun, 31 Mar 2024 08:15:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix severe performance problems when fstrimming
 a subset of an AG
Message-ID: <ZgiBBUGqR0hMNAcI@dread.disaster.area>
References: <171150385517.3220448.15319110826705438395.stgit@frogsfrogsfrogs>
 <171150385535.3220448.4852463781154330350.stgit@frogsfrogsfrogs>
 <ZgQEcLACdVZSxJ1_@infradead.org>
 <20240329213520.GQ6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240329213520.GQ6390@frogsfrogsfrogs>

On Fri, Mar 29, 2024 at 02:35:20PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 27, 2024 at 04:35:12AM -0700, Christoph Hellwig wrote:
> > On Tue, Mar 26, 2024 at 07:07:58PM -0700, Darrick J. Wong wrote:
> > > periodically to allow other threads to do work.  This implementation
> > > avoids the worst problems of the original code, though it lacks the
> > > desirable attribute of freeing the biggest chunks first.
> > 
> > Do we really care much about freeing larger area first?  I don't think
> > it really matters for FITRIM at all.
> > 
> > In other words, I suspect we're better off with only the by-bno
> > implementation.
> 
> Welll... you could argue that if the underlying "thin provisioning" is
> actually just an xfs file, that punching tons of tiny holes in that file
> could increase the height of the bmbt.  In that case, you'd want to
> reduce the chances of the punch failing with ENOSPC by punching out
> larger ranges to free up more blocks.

That's true, but it's a consideration for dm-thinp, too. I've always
considered FITRIM as an optimisation for dm-thinp systems (rather
than a hardware device optimisation), and so "large extents first"
make a whole lot more sense from that perspective.

That said, there's another reason for by-size searches being the
default behaviour: FITRIM has a minimum length control parameter.
Hence for fragmented filesystems where there are few extents larger
than the minimum length, we needed to avoid doing an exhaustive
search of the by-bno tree to find extents longer than the minimum
length....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
