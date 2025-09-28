Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500F728C864
	for <linux-xfs@vger.kernel.org>; Sun, 28 Sep 2025 13:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759065577; cv=none; b=pxWnr4PeHS0thQEf15VqVTj2K0SXpm7s1uubpGWoaOcCoFOlZgE97KgX8vjctGPGMxqaQx6gsriBpKY6rEE5r52ky+I09nXDgsTQP9t6YEZdM9tQuA+Zfik+WY3toUcMhfqVnw95Mf/taBirdGVZgJuCr2xc2uZr6nT7sKudWqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759065577; c=relaxed/simple;
	bh=KczxhiO3rq4LfuMibjOQzQvDn+yuz+agq6FXGFipxHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vFPsr9KGLQrh4LOnU15FRMRPzPSf0jYHTGpPjRxNBqc0fW4GwmkD/imHHuZiKKQPxZjRIawbPIWKMjkX7Q/75MK0JkQ91+1BJTb06DuhzBYWeoAt8NuYaZWbHOHNS75NNhyaTDUu7igh2f/GEEBZQ51tzFUOgiMVliEkDRTN0YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b2Z415+J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b2Z415+J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759065574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=snNrG5EeW/S+hcRKJgw63KoPcdk3l0w22xmJa+ekRf8=;
	b=b2Z415+JX4A7gkQfA0YJbsULAfRkg1fJmszGn7OQnS23Fmx4DgzXy3CGyec4Z/aGv56MGD
	zBTBqxS/o6OD6342Ff+W7+kq1tRB7mRuks/sBnVuEwuANINVmkB3PEh6S6XtaWC09tQxRi
	cdQekP9/uEm4n+qBIdL0xl+Fxiiys4o=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-obQ29k9CPCG5JrSeMZbP7g-1; Sun, 28 Sep 2025 09:19:32 -0400
X-MC-Unique: obQ29k9CPCG5JrSeMZbP7g-1
X-Mimecast-MFC-AGG-ID: obQ29k9CPCG5JrSeMZbP7g_1759065571
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-783604212ebso957816b3a.3
        for <linux-xfs@vger.kernel.org>; Sun, 28 Sep 2025 06:19:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759065571; x=1759670371;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=snNrG5EeW/S+hcRKJgw63KoPcdk3l0w22xmJa+ekRf8=;
        b=enFbLqiIJpZXaJj5nUOgOrlM034lh16zN/L8PzgSrrdG+PQhKTK4a5Ekhph/Y0sPnX
         l7N11QMrLs1MoDju3CQmHTOFi8UoKPYfJ/9NWZ55Ax1QUWIkLOcNVyZIbYZSJbGcuCSJ
         5f6F+b13/rjjujE0SDbhaX2hcFaJjPbM+JuTdeMca6sdlbqUg9e5dp1RwvwFm08Ipo6h
         vfXi/AfaCLsb2bINJbxc2fJvPU2oOoGj7rpGLT0L0mrHRCjltNfhR3uUp2Q9aNGP5Ceb
         nikQyjJC5l7TdJ3FXjo3LOCrUy7FUo+bFcJocGYHc47z3kKwpHbB1tKMP5P2A66p+msP
         Lp2A==
X-Forwarded-Encrypted: i=1; AJvYcCVTap28s3ltZ9vtXT0dxa2N9643KZSBJEbHIpn+t3eemHRd86nlvO1fVL7zF9Y3IrJEWLN0QMyVj5w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3YOxSDI0dZLqoYZdSC38XrgVYlbAJVmWDW1e9UuJhsg4Ca+FT
	MOh6/GM32wzfJO4UaVe3xqS6ojLTLrbNB6ZmlGnpPdHA6SY/LtyWme76upPWhl9Yy2I2Fr4PYu+
	4LVfA7UywaCDkTv4jqyFB/5YeqoHYltVF/KatvSD5Nk+1z9Dy8gdX0HQ9bimAThhojBJlQw==
X-Gm-Gg: ASbGncsW5TowzleAngigEN350WQpibYmd0fs0r61xp6QS2CeunPTOMNCrMmkxuywaiH
	u10YU8dktD6JDk5yf7w1PAZR+zR+CQJgbIYzpkRJ5OvKmxCm+Ueui/miFmLdUXb+8GRSoGQkVpA
	GApKW15aKkbdU6tjuIbitCy2a/gOhMifsOc2rd9IlaU3EHDs2wivvT/YBuzKy6rJd0SSbImdUEL
	lOsF7W12hy9f3SzhnwrWu6F7DZ4PyxWJ4+17oHq5edbHA9tPpFp6vNegiDvyzDGSKNHxi9ZRIoH
	9NPBICZXHagDpfxufp2AhZ5nhEjUNpA+otJ9lKqOYZxIu5mhEyN0n8uwSEcRhJXmGpeRFyAGXZ0
	XS6gT
X-Received: by 2002:a05:6a00:3e27:b0:781:2538:bf95 with SMTP id d2e1a72fcca58-7812538c1afmr5753915b3a.10.1759065571017;
        Sun, 28 Sep 2025 06:19:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoygR7HngElZikzt76IKHuWl2MqmxpbWRCgwmp2pHOfMa3v0CliuV3U0gtlzeqwn7G94AEeQ==
X-Received: by 2002:a05:6a00:3e27:b0:781:2538:bf95 with SMTP id d2e1a72fcca58-7812538c1afmr5753895b3a.10.1759065570588;
        Sun, 28 Sep 2025 06:19:30 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-782e36c803fsm2078160b3a.38.2025.09.28.06.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 06:19:30 -0700 (PDT)
Date: Sun, 28 Sep 2025 21:19:24 +0800
From: Zorro Lang <zlang@redhat.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: fstests@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
	djwong@kernel.org, john.g.garry@oracle.com, tytso@mit.edu,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH v7 04/12] ltp/fsx.c: Add atomic writes support to fsx
Message-ID: <20250928131924.b472fjxwir7vphsr@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1758264169.git.ojaswin@linux.ibm.com>
 <c3a040b249485b02b569b9269b649d02d721d995.1758264169.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3a040b249485b02b569b9269b649d02d721d995.1758264169.git.ojaswin@linux.ibm.com>

On Fri, Sep 19, 2025 at 12:17:57PM +0530, Ojaswin Mujoo wrote:
> Implement atomic write support to help fuzz atomic writes
> with fsx.
> 
> Suggested-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---

Hmm... this patch causes more regular fsx test cases fail on old kernel,
(e.g. g/760, g/617, g/263 ...) except set "FSX_AVOID=-a". Is there a way
to disable "atomic write" automatically if it's not supported by current
system?

Thanks,
Zorro

>  ltp/fsx.c | 115 +++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 110 insertions(+), 5 deletions(-)
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 163b9453..bdb87ca9 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -40,6 +40,7 @@
>  #include <liburing.h>
>  #endif
>  #include <sys/syscall.h>
> +#include "statx.h"
>  
>  #ifndef MAP_FILE
>  # define MAP_FILE 0
> @@ -49,6 +50,10 @@
>  #define RWF_DONTCACHE	0x80
>  #endif
>  
> +#ifndef RWF_ATOMIC
> +#define RWF_ATOMIC	0x40
> +#endif
> +
>  #define NUMPRINTCOLUMNS 32	/* # columns of data to print on each line */
>  
>  /* Operation flags (bitmask) */
> @@ -110,6 +115,7 @@ enum {
>  	OP_READ_DONTCACHE,
>  	OP_WRITE,
>  	OP_WRITE_DONTCACHE,
> +	OP_WRITE_ATOMIC,
>  	OP_MAPREAD,
>  	OP_MAPWRITE,
>  	OP_MAX_LITE,
> @@ -200,6 +206,11 @@ int	uring = 0;
>  int	mark_nr = 0;
>  int	dontcache_io = 1;
>  int	hugepages = 0;                  /* -h flag */
> +int	do_atomic_writes = 1;		/* -a flag disables */
> +
> +/* User for atomic writes */
> +int awu_min = 0;
> +int awu_max = 0;
>  
>  /* Stores info needed to periodically collapse hugepages */
>  struct hugepages_collapse_info {
> @@ -288,6 +299,7 @@ static const char *op_names[] = {
>  	[OP_READ_DONTCACHE] = "read_dontcache",
>  	[OP_WRITE] = "write",
>  	[OP_WRITE_DONTCACHE] = "write_dontcache",
> +	[OP_WRITE_ATOMIC] = "write_atomic",
>  	[OP_MAPREAD] = "mapread",
>  	[OP_MAPWRITE] = "mapwrite",
>  	[OP_TRUNCATE] = "truncate",
> @@ -422,6 +434,7 @@ logdump(void)
>  				prt("\t***RRRR***");
>  			break;
>  		case OP_WRITE_DONTCACHE:
> +		case OP_WRITE_ATOMIC:
>  		case OP_WRITE:
>  			prt("WRITE    0x%x thru 0x%x\t(0x%x bytes)",
>  			    lp->args[0], lp->args[0] + lp->args[1] - 1,
> @@ -1073,6 +1086,25 @@ update_file_size(unsigned offset, unsigned size)
>  	file_size = offset + size;
>  }
>  
> +static int is_power_of_2(unsigned n) {
> +	return ((n & (n - 1)) == 0);
> +}
> +
> +/*
> + * Round down n to nearest power of 2.
> + * If n is already a power of 2, return n;
> + */
> +static int rounddown_pow_of_2(int n) {
> +	int i = 0;
> +
> +	if (is_power_of_2(n))
> +		return n;
> +
> +	for (; (1 << i) < n; i++);
> +
> +	return 1 << (i - 1);
> +}
> +
>  void
>  dowrite(unsigned offset, unsigned size, int flags)
>  {
> @@ -1081,6 +1113,27 @@ dowrite(unsigned offset, unsigned size, int flags)
>  	offset -= offset % writebdy;
>  	if (o_direct)
>  		size -= size % writebdy;
> +	if (flags & RWF_ATOMIC) {
> +		/* atomic write len must be between awu_min and awu_max */
> +		if (size < awu_min)
> +			size = awu_min;
> +		if (size > awu_max)
> +			size = awu_max;
> +
> +		/* atomic writes need power-of-2 sizes */
> +		size = rounddown_pow_of_2(size);
> +
> +		/* atomic writes need naturally aligned offsets */
> +		offset -= offset % size;
> +
> +		/* Skip the write if we are crossing max filesize */
> +		if ((offset + size) > maxfilelen) {
> +			if (!quiet && testcalls > simulatedopcount)
> +				prt("skipping atomic write past maxfilelen\n");
> +			log4(OP_WRITE_ATOMIC, offset, size, FL_SKIPPED);
> +			return;
> +		}
> +	}
>  	if (size == 0) {
>  		if (!quiet && testcalls > simulatedopcount && !o_direct)
>  			prt("skipping zero size write\n");
> @@ -1088,7 +1141,10 @@ dowrite(unsigned offset, unsigned size, int flags)
>  		return;
>  	}
>  
> -	log4(OP_WRITE, offset, size, FL_NONE);
> +	if (flags & RWF_ATOMIC)
> +		log4(OP_WRITE_ATOMIC, offset, size, FL_NONE);
> +	else
> +		log4(OP_WRITE, offset, size, FL_NONE);
>  
>  	gendata(original_buf, good_buf, offset, size);
>  	if (offset + size > file_size) {
> @@ -1108,8 +1164,9 @@ dowrite(unsigned offset, unsigned size, int flags)
>  		       (monitorstart == -1 ||
>  			(offset + size > monitorstart &&
>  			(monitorend == -1 || offset <= monitorend))))))
> -		prt("%lld write\t0x%x thru\t0x%x\t(0x%x bytes)\tdontcache=%d\n", testcalls,
> -		    offset, offset + size - 1, size, (flags & RWF_DONTCACHE) != 0);
> +		prt("%lld write\t0x%x thru\t0x%x\t(0x%x bytes)\tdontcache=%d atomic_wr=%d\n", testcalls,
> +		    offset, offset + size - 1, size, (flags & RWF_DONTCACHE) != 0,
> +		    (flags & RWF_ATOMIC) != 0);
>  	iret = fsxwrite(fd, good_buf + offset, size, offset, flags);
>  	if (iret != size) {
>  		if (iret == -1)
> @@ -1785,6 +1842,36 @@ do_dedupe_range(unsigned offset, unsigned length, unsigned dest)
>  }
>  #endif
>  
> +int test_atomic_writes(void) {
> +	int ret;
> +	struct statx stx;
> +
> +	if (o_direct != O_DIRECT) {
> +		fprintf(stderr, "main: atomic writes need O_DIRECT (-Z), "
> +				"disabling!\n");
> +		return 0;
> +	}
> +
> +	ret = xfstests_statx(AT_FDCWD, fname, 0, STATX_WRITE_ATOMIC, &stx);
> +	if (ret < 0) {
> +		fprintf(stderr, "main: Statx failed with %d."
> +			" Failed to determine atomic write limits, "
> +			" disabling!\n", ret);
> +		return 0;
> +	}
> +
> +	if (stx.stx_attributes & STATX_ATTR_WRITE_ATOMIC &&
> +	    stx.stx_atomic_write_unit_min > 0) {
> +		awu_min = stx.stx_atomic_write_unit_min;
> +		awu_max = stx.stx_atomic_write_unit_max;
> +		return 1;
> +	}
> +
> +	fprintf(stderr, "main: IO Stack does not support "
> +			"atomic writes, disabling!\n");
> +	return 0;
> +}
> +
>  #ifdef HAVE_COPY_FILE_RANGE
>  int
>  test_copy_range(void)
> @@ -2356,6 +2443,12 @@ have_op:
>  			goto out;
>  		}
>  		break;
> +	case OP_WRITE_ATOMIC:
> +		if (!do_atomic_writes) {
> +			log4(OP_WRITE_ATOMIC, offset, size, FL_SKIPPED);
> +			goto out;
> +		}
> +		break;
>  	}
>  
>  	switch (op) {
> @@ -2385,6 +2478,11 @@ have_op:
>  			dowrite(offset, size, 0);
>  		break;
>  
> +	case OP_WRITE_ATOMIC:
> +		TRIM_OFF_LEN(offset, size, maxfilelen);
> +		dowrite(offset, size, RWF_ATOMIC);
> +		break;
> +
>  	case OP_MAPREAD:
>  		TRIM_OFF_LEN(offset, size, file_size);
>  		domapread(offset, size);
> @@ -2511,13 +2609,14 @@ void
>  usage(void)
>  {
>  	fprintf(stdout, "usage: %s",
> -		"fsx [-dfhknqxyzBEFHIJKLORWXZ0]\n\
> +		"fsx [-adfhknqxyzBEFHIJKLORWXZ0]\n\
>  	   [-b opnum] [-c Prob] [-g filldata] [-i logdev] [-j logid]\n\
>  	   [-l flen] [-m start:end] [-o oplen] [-p progressinterval]\n\
>  	   [-r readbdy] [-s style] [-t truncbdy] [-w writebdy]\n\
>  	   [-A|-U] [-D startingop] [-N numops] [-P dirpath] [-S seed]\n\
>  	   [--replay-ops=opsfile] [--record-ops[=opsfile]] [--duration=seconds]\n\
>  	   ... fname\n\
> +	-a: disable atomic writes\n\
>  	-b opnum: beginning operation number (default 1)\n\
>  	-c P: 1 in P chance of file close+open at each op (default infinity)\n\
>  	-d: debug output for all operations\n\
> @@ -3059,9 +3158,13 @@ main(int argc, char **argv)
>  	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
>  
>  	while ((ch = getopt_long(argc, argv,
> -				 "0b:c:de:fg:hi:j:kl:m:no:p:qr:s:t:uw:xyABD:EFJKHzCILN:OP:RS:UWXZ",
> +				 "0ab:c:de:fg:hi:j:kl:m:no:p:qr:s:t:uw:xyABD:EFJKHzCILN:OP:RS:UWXZ",
>  				 longopts, NULL)) != EOF)
>  		switch (ch) {
> +		case 'a':
> +			prt("main(): Atomic writes disabled\n");
> +			do_atomic_writes = 0;
> +			break;
>  		case 'b':
>  			simulatedopcount = getnum(optarg, &endp);
>  			if (!quiet)
> @@ -3475,6 +3578,8 @@ main(int argc, char **argv)
>  		exchange_range_calls = test_exchange_range();
>  	if (dontcache_io)
>  		dontcache_io = test_dontcache_io();
> +	if (do_atomic_writes)
> +		do_atomic_writes = test_atomic_writes();
>  
>  	while (keep_running())
>  		if (!test())
> -- 
> 2.49.0
> 

