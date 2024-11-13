Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E649C147
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 00:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731459397; cv=none; b=AxQyWlYTGdUjfy7vXhl24M/DVyHbqGQ3VcQ8+DVPPZjPxM5eI4KyLuCNTzMWZi72TZDOnjsgPJkisH7WpWGfWG7jTu/eUsof+TBtDH+b+IF96wjzqsD56rhi3O3UALhKH0hsP3WkzxWuoFrD/zvN/N8LNEdV3pBEj37K7Akdgp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731459397; c=relaxed/simple;
	bh=RN9jWC/pUGLs7zVAlSsQAIRzTlyo1nG/rgVS+HxQwl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A805GEDT+mwin0BXPOi84R9IW12iuQxD20IzcjoZv+tBBZbdRBuGZgkHK9gilVmFTQ2GfbG9jZWLsxR9ceEmlVwaA0cxOmXZlGLC7cQXBjwMncBs3MwJw912q8hiI8+djux2iETMFYLsOtU60YyF30LhYNCkGH5tSFG173ZsuIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=k1DtuLTm; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="k1DtuLTm"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-20cceb8d8b4so1386505ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 16:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1731459395; x=1732064195; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iYkl9uOkq7OHwPXa4RpGPlaR6fJpu6EGYwCm1dCs0Pw=;
        b=k1DtuLTmMphwMtk9ofYmfe47wIimjIgK2CGml7qoIkJR4Dz82uWUfbOouNPZX1Dqki
         PWIwWjhp8GFAQtUAoMMch3I53OTvX2IemmCUCVt5DNsrnYdhw58IcC9yQZMZr0e45xn7
         37yMC+WbGjAG0yGvQX9eKk2IXc2FPNfXPuudL6xzlY2ADPlISJ50z4UDpSYj3CXpt8XO
         95ovQiuF0MPaTYHmsIMSm48sta9oG7oIQR6ffizvqUS4Kbor6OL7cdLKS+6bpYqJEEPY
         RjD5QZ65PwtBByPYmM18Tp3tiqAqrTXB4U3jEeUujA1xE0kfzznPyoeOtWNXbDdpBwAV
         9RZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731459395; x=1732064195;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iYkl9uOkq7OHwPXa4RpGPlaR6fJpu6EGYwCm1dCs0Pw=;
        b=MJ8sempbuyPExn1lJHMuvvEHF7cMI6TBJMgA3amOp90Q3X3DdoTDK/LGicnqpob40H
         wuGfmX5LZB7hT53D+7kPp8xssnd3xJLJqk0mLrY2ZAxVYUJLuZK6BKXKltjG5ltRAnZd
         gclRfG19su3tE33+Kf8GUWVLyE43mDCyyDNQoKp5SgxDBI5K6CbfRgf1IAa0RUU1Z77X
         y6HHyd9vJvy9JQtoLHUOk7eiHPW/g15lOb2N0PAlH8Ys1yXoCF5nea/pKDyK47m0B3xF
         Yev79At59Bn8Mn5iDbQzuotWJka6KVCFfc6JL7/tCaifajg6Uuc9evDLNjbXLmbcljMV
         ORWg==
X-Gm-Message-State: AOJu0YwGO9IN5htN7CtCId2IapkLFEsbZ7RX27DDbWh4s1aSUtss76Fm
	0MLAZaNiY4BPrfWV5aBKjeteZYQAILU/mZB5B5K5RXBhp2s+9W8VIyIoXWM19M66J8EaVy5MA9Y
	k
X-Google-Smtp-Source: AGHT+IHxVKNZJ5ecTaKrhWWxw7fdo3eFfEOtOLMl4Ez29/yQjvVXWvRJhwDqBym1vdAqJhP4AcPmLg==
X-Received: by 2002:a17:902:f54b:b0:20c:cb6b:3631 with SMTP id d9443c01a7336-211837c10b3mr263317705ad.27.1731459395354;
        Tue, 12 Nov 2024 16:56:35 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177dc826fsm99878495ad.11.2024.11.12.16.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 16:56:34 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1tB1gN-00Ds0H-2K;
	Wed, 13 Nov 2024 11:56:31 +1100
Date: Wed, 13 Nov 2024 11:56:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 3/3] xfs: prevent mount and log shutdown race
Message-ID: <ZzP5P4hNnEC0P1NF@dread.disaster.area>
References: <20241112221920.1105007-1-david@fromorbit.com>
 <20241112221920.1105007-4-david@fromorbit.com>
 <20241112235808.GI9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112235808.GI9438@frogsfrogsfrogs>

On Tue, Nov 12, 2024 at 03:58:08PM -0800, Darrick J. Wong wrote:
> On Wed, Nov 13, 2024 at 09:05:16AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > I recently had an fstests hang where there were two internal tasks
> > stuck like so:
....
> > For the CIL to be doing shutdown processing, the log must be marked
> > with XLOG_IO_ERROR, but that doesn't happen until after the log
> > force is issued. Hence for xfs_do_force_shutdown() to be forcing
> > the log on a shut down log, we must have had a racing
> > xlog_force_shutdown and xfs_force_shutdown like so:
> > 
> > p0			p1			CIL push
> > 
> >    			<holds buffer lock>
> > xlog_force_shutdown
> >   xfs_log_force
> >    test_and_set_bit(XLOG_IO_ERROR)
> >    						xlog_state_release_iclog()
> > 						  sees XLOG_IO_ERROR
> > 						  xlog_state_shutdown_callbacks
> > 						    ....
> > 						    xfs_buf_item_unpin
> > 						    xfs_buf_lock
> > 						    <blocks on buffer p1 holds>
> > 
> >    			xfs_force_shutdown
> > 			  xfs_set_shutdown(mp) wins
> > 			    xlog_force_shutdown
> > 			      xfs_log_force
> > 			        <blocks on CIL push>
> > 
> >   xfs_set_shutdown(mp) fails
> >   <shuts down rest of log>
> 
> Huh.  I wonder, what happens today if there are multiple threads all
> trying to shut down the log?  Same thing?

Yes. Anywhere that a both a log shutdown and a mount shutdown can be
called concurrently and one of them holds a locked buffer that is
also dirty in the CIL can trip over this. When I first saw it I
thought "calling shutdown with a locked buffer is bad", then
realised that we do that -everywhere- and assume it is safe to do
so. That's when I started looking deeper and found this....

> I guess we've never really
> gone Farmer Brown's Bad Day[1] on this part of the fs.

Oh, running ~64 individual fstests concurrently on the same VM does
a good imitation of that.

$ time sudo ./check-parallel /mnt/xfs -s xfs -x dump
Tests run: 1143
Failure count: 11

real    9m12.307s
user    0m0.007s
sys     0m0.013s
$

That's what's finding these little weird timing-related issues. I've got
several other repeating issues that I haven't got to the bottom of
yet, so Farmer Brown's Bad Day is not over yet...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
