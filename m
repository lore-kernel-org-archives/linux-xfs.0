Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3477C2D0B1
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 04:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88EDF206CC
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 04:47:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mwh7MVcO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgBFErn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 23:47:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25693 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727572AbgBFErm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 23:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580964460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bUD68NMIFbqFuLQpd0nv6/CUVqlfJwTVfurvbAzBZ9E=;
        b=Mwh7MVcOO+FUXpJ2qD3Hf2pZbBj2M0aEd1b++LfPXzw3xukyFtVU07vvwA2A7su6JdpJJB
        zN8bkWc9mG/XslDN4nypiqEWTTOhQd0+UZb4fmmaJm3SM+27R0gYHvODhVjDNH9WXBk2yP
        4mVXBCiJwG/reox+VzYylIVi2fesMpQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-XUxZdK5UMQenI9K_NEuu3Q-1; Wed, 05 Feb 2020 23:47:36 -0500
X-MC-Unique: XUxZdK5UMQenI9K_NEuu3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1057800D5F;
        Thu,  6 Feb 2020 04:47:35 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21E12166BE;
        Thu,  6 Feb 2020 04:47:34 +0000 (UTC)
Date:   Thu, 6 Feb 2020 12:57:28 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 5/5] fsx: support 64-bit operation counts
Message-ID: <20200206045728.GS14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <158086090225.1989378.6869317139530865842.stgit@magnolia>
 <158086093318.1989378.1186256375919220733.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086093318.1989378.1186256375919220733.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:02:13PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Support 64-bit operation counts so that we can run long-soak tests for
> more than 2 billion fsxops.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  ltp/fsx.c |   54 ++++++++++++++++++++++++++++--------------------------
>  1 file changed, 28 insertions(+), 26 deletions(-)
> 
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 120f4374..02403720 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -135,12 +135,12 @@ int	fd;				/* fd for our test file */
>  blksize_t	block_size = 0;
>  off_t		file_size = 0;
>  off_t		biggest = 0;
> -unsigned long	testcalls = 0;		/* calls to function "test" */
> +long long	testcalls = 0;		/* calls to function "test" */

Although the fsx still run passed for me, should we try to keep the sign of
a variable type? That's fine to extend the size of the variable, but should we
explain more about why we need to change the type from unsigned to signed?

Thanks,
Zorro

>  
> -unsigned long	simulatedopcount = 0;	/* -b flag */
> +long long	simulatedopcount = 0;	/* -b flag */
>  int	closeprob = 0;			/* -c flag */
>  int	debug = 0;			/* -d flag */
> -unsigned long	debugstart = 0;		/* -D flag */
> +long long	debugstart = 0;		/* -D flag */
>  char	filldata = 0;			/* -g flag */
>  int	flush = 0;			/* -f flag */
>  int	do_fsync = 0;			/* -y flag */
> @@ -148,7 +148,7 @@ unsigned long	maxfilelen = 256 * 1024;	/* -l flag */
>  int	sizechecks = 1;			/* -n flag disables them */
>  int	maxoplen = 64 * 1024;		/* -o flag */
>  int	quiet = 0;			/* -q flag */
> -unsigned long progressinterval = 0;	/* -p flag */
> +long long	progressinterval = 0;	/* -p flag */
>  int	readbdy = 1;			/* -r flag */
>  int	style = 0;			/* -s flag */
>  int	prealloc = 0;			/* -x flag */
> @@ -157,7 +157,7 @@ int	writebdy = 1;			/* -w flag */
>  long	monitorstart = -1;		/* -m flag */
>  long	monitorend = -1;		/* -m flag */
>  int	lite = 0;			/* -L flag */
> -long	numops = -1;			/* -N flag */
> +long long numops = -1;			/* -N flag */
>  int	randomoplen = 1;		/* -O flag disables it */
>  int	seed = 1;			/* -S flag */
>  int     mapped_writes = 1;              /* -W flag disables */
> @@ -788,7 +788,7 @@ doread(unsigned offset, unsigned size)
>  		       (monitorstart == -1 ||
>  			(offset + size > monitorstart &&
>  			(monitorend == -1 || offset <= monitorend))))))
> -		prt("%lu read\t0x%x thru\t0x%x\t(0x%x bytes)\n", testcalls,
> +		prt("%lld read\t0x%x thru\t0x%x\t(0x%x bytes)\n", testcalls,
>  		    offset, offset + size - 1, size);
>  	ret = lseek(fd, (off_t)offset, SEEK_SET);
>  	if (ret == (off_t)-1) {
> @@ -925,7 +925,7 @@ domapread(unsigned offset, unsigned size)
>  		       (monitorstart == -1 ||
>  			(offset + size > monitorstart &&
>  			(monitorend == -1 || offset <= monitorend))))))
> -		prt("%lu mapread\t0x%x thru\t0x%x\t(0x%x bytes)\n", testcalls,
> +		prt("%lld mapread\t0x%x thru\t0x%x\t(0x%x bytes)\n", testcalls,
>  		    offset, offset + size - 1, size);
>  
>  	pg_offset = offset & PAGE_MASK;
> @@ -1003,7 +1003,7 @@ dowrite(unsigned offset, unsigned size)
>  		       (monitorstart == -1 ||
>  			(offset + size > monitorstart &&
>  			(monitorend == -1 || offset <= monitorend))))))
> -		prt("%lu write\t0x%x thru\t0x%x\t(0x%x bytes)\n", testcalls,
> +		prt("%lld write\t0x%x thru\t0x%x\t(0x%x bytes)\n", testcalls,
>  		    offset, offset + size - 1, size);
>  	ret = lseek(fd, (off_t)offset, SEEK_SET);
>  	if (ret == (off_t)-1) {
> @@ -1070,7 +1070,7 @@ domapwrite(unsigned offset, unsigned size)
>  		       (monitorstart == -1 ||
>  			(offset + size > monitorstart &&
>  			(monitorend == -1 || offset <= monitorend))))))
> -		prt("%lu mapwrite\t0x%x thru\t0x%x\t(0x%x bytes)\n", testcalls,
> +		prt("%lld mapwrite\t0x%x thru\t0x%x\t(0x%x bytes)\n", testcalls,
>  		    offset, offset + size - 1, size);
>  
>  	if (file_size > cur_filesize) {
> @@ -1123,11 +1123,12 @@ dotruncate(unsigned size)
>  
>  	if (testcalls <= simulatedopcount)
>  		return;
> -	
> +
>  	if ((progressinterval && testcalls % progressinterval == 0) ||
>  	    (debug && (monitorstart == -1 || monitorend == -1 ||
>  		      size <= monitorend)))
> -		prt("%lu trunc\tfrom 0x%x to 0x%x\n", testcalls, oldsize, size);
> +		prt("%lld trunc\tfrom 0x%x to 0x%x\n", testcalls, oldsize,
> +				size);
>  	if (ftruncate(fd, (off_t)size) == -1) {
>  	        prt("ftruncate1: %x\n", size);
>  		prterr("dotruncate: ftruncate");
> @@ -1168,7 +1169,7 @@ do_punch_hole(unsigned offset, unsigned length)
>  	if ((progressinterval && testcalls % progressinterval == 0) ||
>  	    (debug && (monitorstart == -1 || monitorend == -1 ||
>  		      end_offset <= monitorend))) {
> -		prt("%lu punch\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
> +		prt("%lld punch\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
>  			offset, offset+length, length);
>  	}
>  	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
> @@ -1230,7 +1231,7 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
>  	if ((progressinterval && testcalls % progressinterval == 0) ||
>  	    (debug && (monitorstart == -1 || monitorend == -1 ||
>  		      end_offset <= monitorend))) {
> -		prt("%lu zero\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
> +		prt("%lld zero\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
>  			offset, offset+length, length);
>  	}
>  	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
> @@ -1280,8 +1281,8 @@ do_collapse_range(unsigned offset, unsigned length)
>  	if ((progressinterval && testcalls % progressinterval == 0) ||
>  	    (debug && (monitorstart == -1 || monitorend == -1 ||
>  		      end_offset <= monitorend))) {
> -		prt("%lu collapse\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
> -			offset, offset+length, length);
> +		prt("%lld collapse\tfrom 0x%x to 0x%x, (0x%x bytes)\n",
> +				testcalls, offset, offset+length, length);
>  	}
>  	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
>  		prt("collapse range: 0x%x to 0x%x\n", offset, offset + length);
> @@ -1332,7 +1333,7 @@ do_insert_range(unsigned offset, unsigned length)
>  	if ((progressinterval && testcalls % progressinterval == 0) ||
>  	    (debug && (monitorstart == -1 || monitorend == -1 ||
>  		      end_offset <= monitorend))) {
> -		prt("%lu insert\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
> +		prt("%lld insert\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
>  			offset, offset+length, length);
>  	}
>  	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
> @@ -1724,7 +1725,7 @@ do_preallocate(unsigned offset, unsigned length, int keep_size)
>  	if ((progressinterval && testcalls % progressinterval == 0) ||
>  	    (debug && (monitorstart == -1 || monitorend == -1 ||
>  		      end_offset <= monitorend)))
> -		prt("%lu falloc\tfrom 0x%x to 0x%x (0x%x bytes)\n", testcalls,
> +		prt("%lld falloc\tfrom 0x%x to 0x%x (0x%x bytes)\n", testcalls,
>  				offset, offset + length, length);
>  	if (fallocate(fd, keep_size ? FALLOC_FL_KEEP_SIZE : 0, (loff_t)offset, (loff_t)length) == -1) {
>  	        prt("fallocate: 0x%x to 0x%x\n", offset, offset + length);
> @@ -1773,7 +1774,7 @@ docloseopen(void)
>  		return;
>  
>  	if (debug)
> -		prt("%lu close/open\n", testcalls);
> +		prt("%lld close/open\n", testcalls);
>  	if (close(fd)) {
>  		prterr("docloseopen: close");
>  		report_failure(180);
> @@ -1797,7 +1798,7 @@ dofsync(void)
>  	if (testcalls <= simulatedopcount)
>  		return;
>  	if (debug)
> -		prt("%lu fsync\n", testcalls);
> +		prt("%lld fsync\n", testcalls);
>  	log4(OP_FSYNC, 0, 0, 0);
>  	ret = fsync(fd);
>  	if (ret < 0) {
> @@ -1834,7 +1835,7 @@ cleanup(int sig)
>  {
>  	if (sig)
>  		prt("signal %d\n", sig);
> -	prt("testcalls = %lu\n", testcalls);
> +	prt("testcalls = %lld\n", testcalls);
>  	exit(sig);
>  }
>  
> @@ -1942,7 +1943,7 @@ test(void)
>  		debug = 1;
>  
>  	if (!quiet && testcalls < simulatedopcount && testcalls % 100000 == 0)
> -		prt("%lu...\n", testcalls);
> +		prt("%lld...\n", testcalls);
>  
>  	if (replayopsf) {
>  		struct log_entry log_entry;
> @@ -2293,13 +2294,13 @@ usage(void)
>  }
>  
>  
> -int
> +long long
>  getnum(char *s, char **e)
>  {
> -	int ret;
> +	long long ret;
>  
>  	*e = (char *) 0;
> -	ret = strtol(s, e, 0);
> +	ret = strtoll(s, e, 0);
>  	if (*e)
>  		switch (**e) {
>  		case 'b':
> @@ -2487,7 +2488,8 @@ main(int argc, char **argv)
>  		case 'b':
>  			simulatedopcount = getnum(optarg, &endp);
>  			if (!quiet)
> -				prt("Will begin at operation %ld\n", simulatedopcount);
> +				prt("Will begin at operation %lld\n",
> +						simulatedopcount);
>  			if (simulatedopcount == 0)
>  				usage();
>  			simulatedopcount -= 1;
> @@ -2854,7 +2856,7 @@ main(int argc, char **argv)
>  		prterr("close");
>  		report_failure(99);
>  	}
> -	prt("All %lu operations completed A-OK!\n", testcalls);
> +	prt("All %lld operations completed A-OK!\n", testcalls);
>  	if (recordops)
>  		logdump();
>  
> 

