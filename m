Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37D214F70
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jul 2024 03:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722395430; cv=none; b=aH5eOs8Z5Q+dg9ZPFA+g3bIUgBgh37hmG4jK7gaAey4vHkDjSO5Hg+Q1+MZVGA1Ede4MqVEgkrZnhmcdtZot8LKD6GKND3f0gIP0KmD470sQDpDxOE92MVbblcmtHgjX2UDh8pZ+xIult5OxsZ9g+yDnVdwgJMSVq2eDfmTXguk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722395430; c=relaxed/simple;
	bh=HVMYpG4jL3hV1cSemQ9kneQB4aIaC0JpqxokbeqtlEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mg091PugObSU7TjZ4xUa19iyfi3S3h+BsutfT29/saeaVMk0Fs/xyctRCjDIRLePS1zUbLXF4BrndigOrl/bvOHRNQd55HjjW7vnfHzPQVZdJhpY+DUdvdG5fIFAl2QoNogLTgYol43c5N1g6YEfwblm1BGPUq30L75b8T0o5No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=AJVftrpL; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="AJVftrpL"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7094641d4e6so1561317a34.3
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 20:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722395428; x=1723000228; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q++LfzPODrhE3/pD+dr5euVYYJHagiaaJhzCaqjbiDA=;
        b=AJVftrpLEv8Eoaoe88qpHBxbtf5nzHJB/MnfwoTr8r8CutZiQWK468a0SFlRU4Wtca
         5qQp3BuXh64mxxy/l6NEWDkybawK2rKtlZdnXV6POc0FW5WDt/kMlpWxZuYe0oCikQQr
         Gb/HOpEwchF8/y5Sb9qY94byHt498sKKCPTLr+TfOhV0ORoLPt26SPMMlzJ0NgY8maW1
         f9tWWgD+r57D4CgMC4z1N9gKcIVC7c4idwXj09o196OwyznKH1LdVGNrCQU12UjBj9yv
         kHp0gWu376GvBsTkB3z3OcFXqGx1TcZ2sDtAzKkYXdgoPhF13qI3h8VrUTfz7ciqalil
         cQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722395428; x=1723000228;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q++LfzPODrhE3/pD+dr5euVYYJHagiaaJhzCaqjbiDA=;
        b=MaTn/egZrh8dF7XQ9QhE6n9iZ1JwUdZOQCENfz7pe77z8Rrpxjdc8y7EccgA55nvhV
         vaY4uRMhMwI1vDfI2eQ6P9tx0X+vBtQwHA1btcYvG8WRNmrMAm8qB5JGnblktbFABshX
         FDNLeC/WTct5KPysIjRVTdSteGABOz8U+5sxLqiBlu4aCv58dU81l5Rd/a/YcY6+LF/o
         PdTN4Zr7u9SBGnvv897OBUiDPSN3+1xmaYCLiFrJ6WlrlfIzus9dPdfw++sU8BKAqI43
         t/xnv7578I2TkBkeIVF4Ln7PcyMXTB7qjlCund+S5QMBA2k9skIp8kIZfBJ6Vg0X3yTB
         G2WA==
X-Gm-Message-State: AOJu0YxwuDWbd51dxnxSwGx12OZ8iAqgT6EIrJOjoYA4tRrJyA/oz7VV
	Cb5r2PVizR0vMQxMmzpHOki6CJaLl7WLfjrE5KN1ekhB/vlYDYE1JLt+wlmECU1oYxE7jUFtw1U
	G
X-Google-Smtp-Source: AGHT+IE1vwveGLyc47mStZEjUnV58yOToX0+Xsde+2KfbyVKNNlCkzKSBMIUGYlfT4YAa/LpuSY3kg==
X-Received: by 2002:a05:6870:9a1f:b0:261:f8e:a37a with SMTP id 586e51a60fabf-267d4d09a11mr15801179fac.14.1722395427799;
        Tue, 30 Jul 2024 20:10:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead8146aesm9060598b3a.131.2024.07.30.20.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 20:10:27 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sYzjN-00HRaA-05;
	Wed, 31 Jul 2024 13:10:25 +1000
Date: Wed, 31 Jul 2024 13:10:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 8/9] spaceman/defrag: readahead for better performance
Message-ID: <ZqmrISscIWQ5Zbl8@dread.disaster.area>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-9-wen.gang.wang@oracle.com>
 <ZpXFLwHyJ4eYgQ0Z@dread.disaster.area>
 <71F0919A-6864-4D78-BED7-8822DF984B92@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71F0919A-6864-4D78-BED7-8822DF984B92@oracle.com>

On Thu, Jul 18, 2024 at 06:40:46PM +0000, Wengang Wang wrote:
> 
> 
> > On Jul 15, 2024, at 5:56 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > On Tue, Jul 09, 2024 at 12:10:27PM -0700, Wengang Wang wrote:
> >> Reading ahead take less lock on file compared to "unshare" the file via ioctl.
> >> Do readahead when defrag sleeps for better defrag performace and thus more
> >> file IO time.
> >> 
> >> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> >> ---
> >> spaceman/defrag.c | 21 ++++++++++++++++++++-
> >> 1 file changed, 20 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/spaceman/defrag.c b/spaceman/defrag.c
> >> index 415fe9c2..ab8508bb 100644
> >> --- a/spaceman/defrag.c
> >> +++ b/spaceman/defrag.c
> >> @@ -331,6 +331,18 @@ defrag_fs_limit_hit(int fd)
> >> }
> >> 
> >> static bool g_enable_first_ext_share = true;
> >> +static bool g_readahead = false;
> >> +
> >> +static void defrag_readahead(int defrag_fd, off64_t offset, size_t count)
> >> +{
> >> + if (!g_readahead || g_idle_time <= 0)
> >> + return;
> >> +
> >> + if (readahead(defrag_fd, offset, count) < 0) {
> >> + fprintf(stderr, "readahead failed: %s, errno=%d\n",
> >> + strerror(errno), errno);
> > 
> > This doesn't do what you think it does. readahead() only queues the
> > first readahead chunk of the range given (a few pages at most). It
> > does not cause readahead on the entire range, wait for page cache
> > population, nor report IO errors that might have occurred during
> > readahead.
> 
> Is it a bug?

No.

> As per the man page it should try to read _count_ bytes:

No it doesn't. It says:

> 
> DESCRIPTION
>        readahead() initiates readahead on a file
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It says it -initiates- readahead. It doesn't mean it waits for
readahead to complete or that it will readahead the whole range.
It just starts readahead.

> > There's almost no value to making this syscall, especially if the
> > app is about to trigger a sequential read for the whole range.
> > Readahead will occur naturally during that read operation (i.e. the
> > UNSHARE copy), and the read will return IO errors unlike
> > readahead().
> > 
> > If you want the page cache pre-populated before the unshare
> > operation is done, then you need to use mmap() and
> > madvise(MADV_POPULATE_READ). This will read the whole region into
> > the page cache as if it was a sequential read, wait for it to
> > complete and return any IO errors that might have occurred during
> > the read.
> 
> As you know in the unshare path, fetching data from disk is done when IO is locked.
> (I am wondering if we can improve that.)

Christoph pointed that out and some potential fixes back in the
original discussion:

https://lore.kernel.org/linux-xfs/ZXvQ0YDfHBuvLXbY@infradead.org/

> The main purpose of using readahead is that I want less (IO) lock time when fetching
> data from disk. Can we achieve that by using mmap and madvise()?

Maybe, but you're still adding complexity to userspace as a work
around for a kernel issue we should be fixing.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
