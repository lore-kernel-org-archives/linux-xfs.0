Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B281F196DA2
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 14:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723212952; cv=none; b=QN2Rk5lqJ8vMiBO48caBhnR/IhQuuPjYT2/whqXSy5fHr/MGTS5YlNDchtpHYIDwNq6Fgp3z2EZM15E+TCEXDOOPZF0Sii4TWfcD9mv+Clpjqu5cNih8RTMKyqo6JDSqSAQuovHKdKJUXPbiPk+d8ZXq3oj86uaCSVfoRK1mQWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723212952; c=relaxed/simple;
	bh=LpyRcD+ea3Jdp/nt2MlljsOpqITTF/5WPLQdiyEFQoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c3bEziGcrq0weLBurLhRPnW4bdy68jp+o3Pu8+stdY6j+Bg6OFCis5XQywL/GwYEPI61resXwCSY78auNcMfJBphZ65FDRMan7xqKOkzFl5bCLwnT2xvohGhsl5hvVMQOhh8ZewwqhuM04LVOlG7OWZibBXzZfNR57Ra3Y1iVIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=p2e6ZgVc; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="p2e6ZgVc"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7093abb12edso1448842a34.3
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 07:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723212950; x=1723817750; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qjz2iKWP20OEyPShdLMLvLzhS5bKm3+7Fe0VrhQtc4A=;
        b=p2e6ZgVc8HRvca6+qmNO22eUNW5XLtUUY0ANVyzCXyBAYZe8WaORYSWePoOfQ1/3i9
         O6gMkqL/rIPAFHXiTutd5VyMyaR/TxmApqfgKj3wQRf/R7KJOCLsggGkslCvZLAG3xPf
         EN7GLdsAZR4Z1CE6jyUvtX8ilFEJCWoyRXwLltFGHZ+RW3u/GxJr7g3vHuBhJ8b310uH
         CyIyeFSxXrAymMkANSUmCHPToh0JHEDDVbM6esCKgllNzy0xLP0eRPso8kPVCE7aXBaU
         6TkTyK3IxIRxp1wC89QX7hwFS92BYAF7ubduMjgP6WlNdd0lhacGSYHbAdjR5LOYpLMn
         DwFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723212950; x=1723817750;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qjz2iKWP20OEyPShdLMLvLzhS5bKm3+7Fe0VrhQtc4A=;
        b=fzl8kAACIZqaPqqXUvOpDkKhxWcSLwB3T8gAtKjaYJ+PvMCnLM8g9E7/Q/Mi6ObJtX
         jGeRqFA1sLJHv9GOYpV5zWw6qLmLh1RekSXoG7lotQqgHNrLIkpEG8jkwaldDp/PlUEK
         ofLZrnl6Z2EJ8gyp1zIMAETbs09uTWDfGUPrl3kMt1QHwHUHAItN34pj6cByuM+SPOkq
         xuVKQh0FG5zE3Q63PtqnQiBnFLBSLg9pvfIYhr2yux6bdfPOWRNxoP2+3cfkWDxk/QIb
         JS0djaNaH4cDBcWosg8JUKJiykyd+uwOO4EYdWt/vgQV0BVKAt6/ywNR6BZPVVoyn5yW
         AeYw==
X-Forwarded-Encrypted: i=1; AJvYcCU2kEe9s8/Gq7gq7QyDMMfLwOuaqb9aoCtzbstzkW4Rx1yx11LLratms0HcI6XWN+CiRS8MHJViQXmK5hKX1F6M9ZVIJxT1raOj
X-Gm-Message-State: AOJu0YxinH0E4g6BRPzMGHDUKjKxjqrQaxbDDZ61q8jFGIykS2p/AYoP
	g4MLrmLru0yGl7AobI9mZ6S9dMcJQSkENSgwbLOeGoQQP7tOXYmFkKDT26sD2lc=
X-Google-Smtp-Source: AGHT+IGEYKuTYzX7n9Q4WkJAqsc2BKy4Op03cbPrmVLdwnUtrw0LcKrosgOY3AEQ0Vv59SDfcwKgvw==
X-Received: by 2002:a05:6830:611a:b0:703:5c2d:56a7 with SMTP id 46e09a7af769-70b74879a7cmr2362612a34.24.1723212949757;
        Fri, 09 Aug 2024 07:15:49 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a3785e1f93sm265995685a.38.2024.08.09.07.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 07:15:49 -0700 (PDT)
Date: Fri, 9 Aug 2024 10:15:48 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Dave Chinner <david@fromorbit.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	amir73il@gmail.com, brauner@kernel.org, linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 16/16] xfs: add pre-content fsnotify hook for write
 faults
Message-ID: <20240809141548.GB645452@perftesting>
References: <cover.1723144881.git.josef@toxicpanda.com>
 <aa122a96b7fde9bb49176a1b6c26fcb1e0291a37.1723144881.git.josef@toxicpanda.com>
 <ZrVAvQLfP8fNSJwx@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrVAvQLfP8fNSJwx@dread.disaster.area>

On Fri, Aug 09, 2024 at 08:03:41AM +1000, Dave Chinner wrote:
> On Thu, Aug 08, 2024 at 03:27:18PM -0400, Josef Bacik wrote:
> > xfs has it's own handling for write faults, so we need to add the
> > pre-content fsnotify hook for this case.  Reads go through filemap_fault
> > so they're handled properly there.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/xfs/xfs_file.c | 20 +++++++++++++++++---
> >  1 file changed, 17 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 4cdc54dc9686..585a8c2eea0f 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1325,14 +1325,28 @@ __xfs_filemap_fault(
> >  	bool			write_fault)
> >  {
> >  	struct inode		*inode = file_inode(vmf->vma->vm_file);
> > +	struct file		*fpin = NULL;
> > +	vm_fault_t		ret;
> >  
> >  	trace_xfs_filemap_fault(XFS_I(inode), order, write_fault);
> >  
> > -	if (write_fault)
> > -		return xfs_write_fault(vmf, order);
> >  	if (IS_DAX(inode))
> >  		return xfs_dax_read_fault(vmf, order);
> > -	return filemap_fault(vmf);
> > +
> > +	if (!write_fault)
> > +		return filemap_fault(vmf);
> 
> Doesn't this break DAX read faults? i.e. they have to go through
> xfs_dax_read_fault(), not filemap_fault().

Oops my bad, I had it right before then decided to make it cleaner and forgot
what the original code was doing, I'll fix it up, thanks!

Josef
