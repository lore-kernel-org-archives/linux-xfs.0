Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2806285C74
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 13:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719925495; cv=none; b=hWrEKVbH3jgD3LeVJgSGcg7Z1a7NxCr6ZBBcm+PtJ2GJ8xxTe4lt68FF6E3gNTotf6Vu4DIMLTGuPe9EuF+CnE2S4+39OSLWfXsvC4T0FbqJtlEIbWTzUoFNViUVHKDPB7YdI0XVTxPB9b8UW6QDXk2HjeGd+CQ+zDBYIqkUeBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719925495; c=relaxed/simple;
	bh=2ba5zC4nFi1Ed7n+ilW+b+NppWtTr+8BGra23dw6gPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZhIB6Z/k7SCk7l2IVwjaFa4Q/hRY8PO/4TWe/89r2G8Nq7p+BQ6T+4zV6LvCwFrVr+AG+gaY4WC5222hTbFbwjotZ57lZeOfcvzXrkHdoKV7k89HV7KqUDYscYYe3P9cJAY2FbITZ5GUPhzBupEfC/10zSjVsgyAp/pWqiBhiwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=mbJBlOH6; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="mbJBlOH6"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-706b53ee183so3543908b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jul 2024 06:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719925492; x=1720530292; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mCUKJtxjiVHBrnRFpZSTwe0fkpTf7lz1L5LAQ0jpucY=;
        b=mbJBlOH6JALXKhEKbeuIWMvF8LmVeRZjHjnJAj7ejHMMAz0P0eHpf7RM1ktfOpyPWq
         9ELRU70O5n49qzLCWNVuNa85zXxoVpxjpdxIJL78zfFU6ILjNLULqWiJNF5MgZkXh1A3
         1NIrCNPGkDHatILvQKUydC/7bF+8iehvK1IVbHvXjZS2kGyp/nxXG6Wy/mS+M8+vAC81
         HTJgwPe6eDeaTgQtkkqXt6AMu/E0+iwXtBmzDhe4c9jYe3hp6Sjgh2hIuHcBgiRiJdY8
         37L/fLJMW1XbM88/YD+TKTVCzAwcxYW7mNoyKmUwbIEjP4uSsE5DtxWVq02CSTKgEaq+
         rGAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719925492; x=1720530292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mCUKJtxjiVHBrnRFpZSTwe0fkpTf7lz1L5LAQ0jpucY=;
        b=LRG2Ewtl13sWNafkn3irOFqCrYZ2h5RvOYwBY+V/DSL96Ps7fEEvYKCQvIT96yYbA8
         EDuERySZyBAeZXTI97+EmzGHCo/q9WDJLlRoYYwA7Fz5ogRzb0wCmXFNGAreLrFenN+z
         uFP68WbL2X/biNu3m60cYlxuOJCuNk9DrMoRYKgsuM1Qp6kN8Ka9o5ctHHNFdfHO7uwn
         Sv26fw2mb8MC24S/g5hXj6EmAPcxrBqO942AL+ut8CHG/9UAPGC9DBYx0j8hYm+8umiu
         sPNT35F+o+qFfl4Iov3tU/1To3NsMgo4PEoOQLM+2l79OkklnTg3FgonyMNqrQ/+n2Q7
         rk4w==
X-Forwarded-Encrypted: i=1; AJvYcCXUFQA/h3pAs9T5eaRJnQcvRClz+nZq7wpobxp5ukLZ5km53B7JuxnYjjfPRZGhaJy0iozO9ztkVy3CAZTw1NniccXKP2+Tjda+
X-Gm-Message-State: AOJu0YwqCUrXM6tDF2fvg3aIAyXKu0FQyCkWxqz9/SIazbYosUQffOn7
	GphZNvmjuvTmiVmo4N4cBGbwFe1Vh6yMBtZooLtIju1dolg6Yk4xoULrwAC6z4E=
X-Google-Smtp-Source: AGHT+IHRMG8haob/98+FO+t2UO8ASY0vn12OW1IElLmLKDK4EpZ0lzqW0mh73cVdUSgNn0L5QHWK5A==
X-Received: by 2002:a05:6a20:9711:b0:1b5:cc1f:38d4 with SMTP id adf61e73a8af0-1bee4927f8fmr15938594637.17.1719925492374;
        Tue, 02 Jul 2024 06:04:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6d00b5aasm6614155a12.83.2024.07.02.06.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 06:04:51 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sOdBh-001WSP-0j;
	Tue, 02 Jul 2024 23:04:49 +1000
Date: Tue, 2 Jul 2024 23:04:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: Trond Myklebust <trondmy@hammerspace.com>
Cc: "snitzer@kernel.org" <snitzer@kernel.org>,
	"bfoster@redhat.com" <bfoster@redhat.com>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: enable WQ_MEM_RECLAIM on m_sync_workqueue
Message-ID: <ZoP68e8Ib2wIRLRC@dread.disaster.area>
References: <Zn7icFF_NxqkoOHR@kernel.org>
 <ZoGJRSe98wZFDK36@kernel.org>
 <ZoHuXHMEuMrem73H@dread.disaster.area>
 <ZoK5fEz6HSU5iUSH@kernel.org>
 <f54618f78737bab3388a6bb747e8509311bf8d93.camel@hammerspace.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f54618f78737bab3388a6bb747e8509311bf8d93.camel@hammerspace.com>

On Tue, Jul 02, 2024 at 12:33:53PM +0000, Trond Myklebust wrote:
> On Mon, 2024-07-01 at 10:13 -0400, Mike Snitzer wrote:
> > On Mon, Jul 01, 2024 at 09:46:36AM +1000, Dave Chinner wrote:
> > > IMO, the only sane way to ensure this sort of nested "back-end page
> > > cleaning submits front-end IO filesystem IO" mechanism works is to
> > > do something similar to the loop device. You most definitely don't
> > > want to be doing buffered IO (double caching is almost always bad)
> > > and you want to be doing async direct IO so that the submission
> > > thread is not waiting on completion before the next IO is
> > > submitted.
> > 
> > Yes, follow-on work is for me to revive the directio path for localio
> > that ultimately wasn't pursued (or properly wired up) because it
> > creates DIO alignment requirements on NFS client IO:
> > https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/commit/?h=nfs-localio-for-6.11-testing&id=f6c9f51fca819a8af595a4eb94811c1f90051eab

I don't follow - this is page cache writeback. All the write IO from
the bdi flusher thread should be page aligned, right? So why does DIO
alignment matter here?

> > But underlying filesystems (like XFS) have the appropriate checks, we
> > just need to fail gracefully and disable NFS localio if the IO is
> > misaligned.
> > 
> 
> Just a reminder to everyone that this is replacing a configuration
> which would in any case result in double caching, because without the
> localio change, it would end up being a loopback mount through the NFS
> server.

Sure. That doesn't mean double caching is desirable and it's
something we try should avoid if we trying to design a fast
server bypass mechanism.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
