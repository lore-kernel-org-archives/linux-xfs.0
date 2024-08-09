Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9502D16C6BD
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 23:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723244746; cv=none; b=W/9wlxShiTC560gHurYEpw4y1YCuxfQXpQO+he4QsuFYpBzWkOBbyPZggP6hhDX4VlTgX6qeVXQgeyHwYuS02Mg2lfSTzoLhO+FHSMNyNfNM3oqzEBcfui9yZxEv9Xa1V9P5cDhVapL2QEo8npsZ0I7e7Y4rr5WkjkxnXTgaPGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723244746; c=relaxed/simple;
	bh=kip/j2N4MU6D8qAnWjrKI+qx/Op9j8h8o+o5qlLzWHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qfReOI/qk6CSiGqzC4lXav7LSOMUgSkuicOP84eEBxpoU4iyw9m6MpwKO4/K2KhSSaRj7bCyNOLVjcHuxz30XvM/ZbXwVuGzLNwR8SzKPZzDq9E1lsr83rFOvsvNxKsTfxfZdCVSvLqMVXUZa2Yve8si32NoMRUA5MELUWgKn7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=3F0Tb9rN; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="3F0Tb9rN"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-70d18d4b94cso1957549b3a.2
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 16:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723244744; x=1723849544; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nTDcrQgyeVMDCz81y0q/ZpfGE+ROsNi+zfVoOYVwgYs=;
        b=3F0Tb9rNq80rq+VF0zWpz8JkUKY6UcGOxJpVQha1CnLGe70gSrGzFa0nSJj1DOlagP
         5VYOoSK5Uuy6mbmrFP6ySfybI4hsHQhw0u9OYlJ6W1BYQ0rYxnztqx0HZKUyw/efk91o
         WRAY5v8bd0VSMmd1N2fP0MuovZa/DtJhVnYwRCJm0OG81waDANDDKnl4M+Ozm0BG7Tex
         fzfs1gEXbpi2Y/nLzcl0vPn7pMS9QnKWE69kOfIvLiG4C1VnCgGGGXRlBW/pTICD/7kF
         A13ec9IwI6Icv2/bUEpNTvtFXW2cj9W8KBJth5ICTY1XIuIgAVUum/EzGp/SCnu8qTvN
         q2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723244744; x=1723849544;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nTDcrQgyeVMDCz81y0q/ZpfGE+ROsNi+zfVoOYVwgYs=;
        b=fQg1JFqr2v589jjWVxySRwbcHtjO3SSlbYPXN5/sWjnEcKh6/jzzcwfsoiE9db9ptU
         lcFuWlixiPtp78R/XwafdhKWxdPwNlExLdKxZnSs/2FVwnNXBqNYDPB3e8RFZoyhD8to
         q8a4ptpmWuUaNv044kdtCWLxYwmmWp4VVTkpJSBI+o+3hak4AlDWYGyc/3DmBbXxqJwj
         v16sqLpEdPLpWiz8Id29Xr+mr83Bn0+IbRVWxi6BVAbAN4CvaduudwuQkcK0QSZ3E5Fo
         XVTRhXb7qAQhKtgs38pC1VMc7qqzkfukFzUxLTNOjIOi0Z5ebnlJHHPGt6XcKhyEr3lQ
         YUvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbJZrZAltbKmVNM0pvUdbhl+rf8+KXk95M8gP9n9y10Fv5XcZravxZEL+tyypOs/qsQuLfMT6KahCgTuvZkqyN0zdSSi1CDVQt
X-Gm-Message-State: AOJu0YyiCqHs8/rleI/rT1cZhe7VPJDopvW6zEMMEABqEVK8ZQLNS0rd
	a6hP/+PmlkC0herQrXnznSjvB0rTrYW0qhFKc+DLpkO2nllCOnrYyY5IZPBq5lo=
X-Google-Smtp-Source: AGHT+IFCLSKyX0YVdtgGjZlbE/P8XJNJvz1WTxeb29RoLQ3QQ2JHQrcHUzNiNqGJfplvUdPb5Eejhw==
X-Received: by 2002:a05:6a00:cd0:b0:70d:ca45:a004 with SMTP id d2e1a72fcca58-710dc760083mr3294863b3a.13.1723244743590;
        Fri, 09 Aug 2024 16:05:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e58735f9sm267932b3a.2.2024.08.09.16.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 16:05:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1scYg0-00BQM9-1s;
	Sat, 10 Aug 2024 09:05:40 +1000
Date: Sat, 10 Aug 2024 09:05:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	amir73il@gmail.com, brauner@kernel.org, linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v3 13/16] fsnotify: generate pre-content permission event
 on page fault
Message-ID: <ZragxG7wkTsD1sdy@dread.disaster.area>
References: <cover.1723228772.git.josef@toxicpanda.com>
 <192b90df727e968ca3a17b6b128c10f3575bf6a3.1723228772.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <192b90df727e968ca3a17b6b128c10f3575bf6a3.1723228772.git.josef@toxicpanda.com>

On Fri, Aug 09, 2024 at 02:44:21PM -0400, Josef Bacik wrote:
> FS_PRE_ACCESS or FS_PRE_MODIFY will be generated on page fault depending
> on the faulting method.
> 
> This pre-content event is meant to be used by hierarchical storage
> managers that want to fill in the file content on first read access.
> 
> Export a simple helper that file systems that have their own ->fault()
> will use, and have a more complicated helper to be do fancy things with
> in filemap_fault.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

....
> +/**
> + * filemap_maybe_emit_fsnotify_event - maybe emit a pre-content event.
> + * @vmf:	struct vm_fault containing details of the fault.
> + *
> + * If we have a pre-content watch on this file we will emit an event for this
> + * range.  If we return anything the fault caller should return immediately, we
> + * will return VM_FAULT_RETRY if we had to emit an event, which will trigger the
> + * fault again and then the fault handler will run the second time through.
> + *
> + * Return: a bitwise-OR of %VM_FAULT_ codes, 0 if nothing happened.
> + */
> +vm_fault_t filemap_maybe_emit_fsnotify_event(struct vm_fault *vmf)
> +{
> +	struct file *fpin = NULL;
> +	vm_fault_t ret;
> +
> +	ret = __filemap_maybe_emit_fsnotify_event(vmf, &fpin);
> +	if (ret) {
> +		if (fpin)
> +			fput(fpin);
> +		return ret;
> +	} else if (fpin) {
> +		fput(fpin);
> +		return VM_FAULT_RETRY;
> +	}

Logic is back to front.  Both paths have to check for fpin,
only one fpin path needs to modify ret:

	ret = __filemap_maybe_emit_fsnotify_event(vmf, &fpin);
	if (fpin) {
		fput(fpin);
		if (!ret)
			ret = VM_FAULT_RETRY;
	}
	return ret;

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(filemap_maybe_emit_fsnotify_event);
> +
>  /**
>   * filemap_fault - read in file data for page fault handling
>   * @vmf:	struct vm_fault containing details of the fault
> @@ -3299,6 +3391,19 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
>  	if (unlikely(index >= max_idx))
>  		return VM_FAULT_SIGBUS;
>  
> +	/*
> +	 * If we have pre-content watchers then we need to generate events on
> +	 * page fault so that we can populate any data before the fault.
> +	 */
> +	ret = __filemap_maybe_emit_fsnotify_event(vmf, &fpin);
> +	if (unlikely(ret)) {
> +		if (fpin) {
> +			fput(fpin);
> +			ret |= VM_FAULT_RETRY;
> +		}
> +		return ret;
> +	}

Why do we or in VM_FAULT_RETRY here where as the previous case we
simply return VM_FAULT_RETRY? Which one of these is wrong? If both
are correct, then a comment explaining this is in order...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
