Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181582B9B9
	for <linux-xfs@vger.kernel.org>; Fri,  3 Oct 2025 13:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498722; cv=none; b=q9F1As1Nv2NiGUgQLBjxBpp2ZyO+cuLwVdykccKlWmPhpvHZcYmvWFHrnfsrtKjphhHyag43jSsjb59WWhK5oUY9lu40DuPLWiBIuCulkemnvhfZtNBZS8g4ZsVv/JrWrmQdTQLOnCmw/8JNtKc/hLKS3zTv/jfXlYNYOvyyFLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498722; c=relaxed/simple;
	bh=HchU8f4EgzCIclHzMtEp4ytQk6iEU1OkJuge3NDZgkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qK+RHz3olVeADc/B4vPr74BePgUOdRkVL4UJBjk2pr9qbsI4FJCLdTc17aIOoeFdZ4Gtjvzl0t7nLjzJ1d787pqzjNjnJ5j2umGZRUPWhQ/v76+OxaenwytYQLsDrCQCeVdtFwf4mYRhka2Jh5pJu60NpZd8kbZdwsNzej4SqkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kkgF/PRP; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kkgF/PRP"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e34bd8eb2so25625675e9.3
        for <linux-xfs@vger.kernel.org>; Fri, 03 Oct 2025 06:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759498719; x=1760103519; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zjd42OOVf+WajS57RrAMPmwuVCYgfRwVOtOJ5YCKMLU=;
        b=kkgF/PRP3WSisCuM7qr1b+G/qaDJIg1Il7bNMY1zINAfSZN+gbRXJMcVir5ZJDXrog
         4t77zDxR0oH5L9z/5Iw5rOn3w4U5qziu3u9FHr1kt1mOtviEOIr8PRUUA6hc6oDRLqNu
         gp+xEDLycpzqD2ELyb1wGekV7PM3b/20mhL7m4wXFvEGUWXcMsJqLd0cEM/O0r6Hhin2
         HrCRwpm0GX9MlTYiFYFfj5z7BsVA7ofJZdlkXZ2F/JuEnuPT7OIhuPzx+ucYmxvoc576
         OlGrsYRPVaWjW2cit/sK8IYaaue3Zc2L5xzqXLe11LIM3JSpL0CXeAnXCYN3+0lKqAR2
         E6hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498719; x=1760103519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zjd42OOVf+WajS57RrAMPmwuVCYgfRwVOtOJ5YCKMLU=;
        b=U7mDqJBDsKTK95TTO0F7dy2fWPxeCIEzd5NAtAZ8Z8NbvwfNX7szdcBMGv6zr256II
         hkY+zkZ1XF7evVju5ybl548uQVPE59wI7I3pfCWOUGEAi97xICnrBO3nC4DIjEsGHhk7
         HJaVfiggdJ7NxAK6ao16JMAxIPVe+t7Vbj21RACMRxQgAo/37b+DNNQ/LkYReXebFsmA
         3jK9U3/uSggGEJWIB2Fvw/KTx/t5qFNdks2fwZDEXZQ8QwboSIg0sR+vmANJQswMzU/U
         eNtukTvcRfFd9PkBr+GcL49tN8CYTje6CvzfeqJtA2YEdiQHb7/qIPr1G7tg2Q9cc5mF
         Oudg==
X-Forwarded-Encrypted: i=1; AJvYcCV8V3RoKDYk563c9Nll+5+Ya5wBHhWStnpve9YptarQyejjAZcRZjXmrBE/7nsUDjNUgAHLY2uoAug=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAQvxMsFW5HJQ9O+rtxn6G28pF43RoTnXWPBkTYWN5spaHfaDf
	Ls+Wg6uAX5pWIDecF/k47SO1kockqMXxzs/HgoRCWtksRPZgQzzF7fSN
X-Gm-Gg: ASbGncu4VBZ6G2hL0AlAPdDsL5kxYz2QmqPuBz1HcrGUGU6gy0+ldPQKiK7HYU8SbPd
	v+UPoMCn5BHwl+U7fz5rL2lht4OSy/nH2tOkQZ5pfh6MgQYZrPV8I1/ogL4CQyj/uSTRJI2h0HV
	Nar0Gle8eOoKDaf8qoO/NCRc+gry0wHC5LLeGQBDVZby6Z3mJnw0wG75DGMjy9fXyeGvkHTcMkB
	Cv2yehRTZxj1q9SxMB+fEfzjSsXRBspMrHowQC5EAoVruZWKbz7ljg3HihPnz9PindL3Cv9d4Nh
	+yIShBi+1itg7MP2CDHmzZ4iWzRQGh3+/nVZyQ2sIfwWrKADyyf2cMW43WNfvDVGZ0fV6F7UHIc
	ANWsAFvLsTJn4V/kRR39KO83IxoOGlbHlUbsL1+F/GZ9yEmee/mEKsT7Qj3zIwSDAoSkbMGhUJQ
	wEC8nLXsy7YdRKsa9o
X-Google-Smtp-Source: AGHT+IE2d2+VTZ/oWXOczMKDIO72TpVL76DePnGYNZ6TZ9XC7xNSiQbSXq1QW7v89ZQFfAk81Twbfw==
X-Received: by 2002:a05:600c:1f8d:b0:46e:436c:2191 with SMTP id 5b1f17b1804b1-46e71145d77mr24764275e9.25.1759498719134;
        Fri, 03 Oct 2025 06:38:39 -0700 (PDT)
Received: from f (cst-prg-21-74.cust.vodafone.cz. [46.135.21.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a020a3sm130655105e9.10.2025.10.03.06.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 06:38:38 -0700 (PDT)
Date: Fri, 3 Oct 2025 15:38:28 +0200
From: Mateusz Guzik <mjguzik@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: kernel test robot <oliver.sang@intel.com>, 
	Dave Chinner <dchinner@redhat.com>, oe-lkp@lists.linux.dev, lkp@intel.com, 
	linux-kernel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-xfs@vger.kernel.org
Subject: Re: [linus:master] [xfs]  c91d38b57f:  stress-ng.chown.ops_per_sec
 70.2% improvement
Message-ID: <nfqwkcdbd5xawykrtb5nrhvmpfimtry6qyuig5p7qmlehc7itl@utic4l437gwn>
References: <202510020917.2ead7cfe-lkp@intel.com>
 <20251003075615.GA13238@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251003075615.GA13238@lst.de>

On Fri, Oct 03, 2025 at 09:56:15AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 02, 2025 at 04:11:29PM +0800, kernel test robot wrote:
> > 
> > 
> > Hello,
> > 
> > kernel test robot noticed a 70.2% improvement of stress-ng.chown.ops_per_sec on:
> 
> I wonder what stress-ng shown is doing, because unless it is mixing fsync
> and ilock-heavy operations on the same node this would be highly
> unexpected.
> 

According to my strace there is no fsync, instead all of the worker
threads are issuing chown, lchown and fchown on the same inode.

As far as *benchmarking* goes this is useless.

Note stress-ng does not claim to be a benchmarking suite, but a stress
test suite which can also report ops/s for whatever it did.

This bit does not look particularly useful for stress testing either tbh.
