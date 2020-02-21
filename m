Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C957C35656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 13:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C8F9208C4
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 13:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YN3/b0q6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgBUNnO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 08:43:14 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41898 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727053AbgBUNnO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 08:43:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582292593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y9BNANhEy4c+1esbB9J/yf/xmLZ2jQzY8NSIFrPEJSc=;
        b=YN3/b0q6V+NBe7nk92V6PqCujTjZkAH0a4l4grvxDW5k6AY4hvI3OtlG+HF29i5ZtyopUd
        y/XdfeNN5sr7LF1ZmqkNPlK7B/T+rQGyfqQ8AeVjmuQOkF4g0KwZtnoc9a8akHBFtdJ45I
        QObuekie3I1Casc6n3XrX/nyeU5uLng=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-Xm1LPeLcO8WD4ldhzrpbpQ-1; Fri, 21 Feb 2020 08:43:09 -0500
X-MC-Unique: Xm1LPeLcO8WD4ldhzrpbpQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6903A13E5;
        Fri, 21 Feb 2020 13:43:08 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D24485D9C5;
        Fri, 21 Feb 2020 13:43:07 +0000 (UTC)
Date:   Fri, 21 Feb 2020 21:53:32 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 2/3] t_mmap_collision: fix hard-coded page size
Message-ID: <20200221135332.GK14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Jeff Moyer <jmoyer@redhat.com>, fstests@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20200220200632.14075-1-jmoyer@redhat.com>
 <20200220200632.14075-3-jmoyer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220200632.14075-3-jmoyer@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 03:06:31PM -0500, Jeff Moyer wrote:
> Fix the test to run on non-4k page size systems.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---

This patch looks good to me, and it's really helpful.

Thanks,
Zorro

Before patched:

FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/aarch64
MKFS_OPTIONS  -- -f -b size=65536 -m crc=1,finobt=1,reflink=1,rmapbt=1 -i sparse=1 /dev/sda5
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sda5 /mnt/xfstests/mnt2

generic/503 14s ... - output mismatch (see /root/xfstests-dev/results//generic/503.out.bad)
    --- tests/generic/503.out   2020-02-21 05:41:37.992675071 -0500
    +++ /root/xfstests-dev/results//generic/503.out.bad 2020-02-21 08:20:19.736550319 -0500
    @@ -1,2 +1,4 @@
     QA output created by 503
    +collapse_range_fn fallocate 2: Invalid argument
    +collapse_range_fn fallocate 2: Invalid argument
...

After patched:

FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/aarch64
MKFS_OPTIONS  -- -f -b size=65536 -m crc=1,finobt=1,reflink=1,rmapbt=1 -i sparse=1 /dev/sda5
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sda5 /mnt/xfstests/mnt2

generic/503 16s ...  16s
Ran: generic/503
Passed all 1 tests

>  src/t_mmap_collision.c | 40 +++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/src/t_mmap_collision.c b/src/t_mmap_collision.c
> index d547bc05..c872f4e2 100644
> --- a/src/t_mmap_collision.c
> +++ b/src/t_mmap_collision.c
> @@ -25,13 +25,12 @@
>  #include <sys/types.h>
>  #include <unistd.h>
>  
> -#define PAGE(a) ((a)*0x1000)
> -#define FILE_SIZE PAGE(4)
> -
>  void *dax_data;
>  int nodax_fd;
>  int dax_fd;
>  bool done;
> +static int pagesize;
> +static int file_size;
>  
>  #define err_exit(op)                                                          \
>  {                                                                             \
> @@ -49,18 +48,18 @@ void punch_hole_fn(void *ptr)
>  		read = 0;
>  
>  		do {
> -			rc = pread(nodax_fd, dax_data + read, FILE_SIZE - read,
> +			rc = pread(nodax_fd, dax_data + read, file_size - read,
>  					read);
>  			if (rc > 0)
>  				read += rc;
>  		} while (rc > 0);
>  
> -		if (read != FILE_SIZE || rc != 0)
> +		if (read != file_size || rc != 0)
>  			err_exit("pread");
>  
>  		rc = fallocate(dax_fd,
>  				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> -				0, FILE_SIZE);
> +				0, file_size);
>  		if (rc < 0)
>  			err_exit("fallocate");
>  
> @@ -81,18 +80,18 @@ void zero_range_fn(void *ptr)
>  		read = 0;
>  
>  		do {
> -			rc = pread(nodax_fd, dax_data + read, FILE_SIZE - read,
> +			rc = pread(nodax_fd, dax_data + read, file_size - read,
>  					read);
>  			if (rc > 0)
>  				read += rc;
>  		} while (rc > 0);
>  
> -		if (read != FILE_SIZE || rc != 0)
> +		if (read != file_size || rc != 0)
>  			err_exit("pread");
>  
>  		rc = fallocate(dax_fd,
>  				FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
> -				0, FILE_SIZE);
> +				0, file_size);
>  		if (rc < 0)
>  			err_exit("fallocate");
>  
> @@ -113,11 +112,11 @@ void truncate_down_fn(void *ptr)
>  
>  		if (ftruncate(dax_fd, 0) < 0)
>  			err_exit("ftruncate");
> -		if (fallocate(dax_fd, 0, 0, FILE_SIZE) < 0)
> +		if (fallocate(dax_fd, 0, 0, file_size) < 0)
>  			err_exit("fallocate");
>  
>  		do {
> -			rc = pread(nodax_fd, dax_data + read, FILE_SIZE - read,
> +			rc = pread(nodax_fd, dax_data + read, file_size - read,
>  					read);
>  			if (rc > 0)
>  				read += rc;
> @@ -142,15 +141,15 @@ void collapse_range_fn(void *ptr)
>  	while (!done) {
>  		read = 0;
>  
> -		if (fallocate(dax_fd, 0, 0, FILE_SIZE) < 0)
> +		if (fallocate(dax_fd, 0, 0, file_size) < 0)
>  			err_exit("fallocate 1");
> -		if (fallocate(dax_fd, FALLOC_FL_COLLAPSE_RANGE, 0, PAGE(1)) < 0)
> +		if (fallocate(dax_fd, FALLOC_FL_COLLAPSE_RANGE, 0, pagesize) < 0)
>  			err_exit("fallocate 2");
> -		if (fallocate(dax_fd, 0, 0, FILE_SIZE) < 0)
> +		if (fallocate(dax_fd, 0, 0, file_size) < 0)
>  			err_exit("fallocate 3");
>  
>  		do {
> -			rc = pread(nodax_fd, dax_data + read, FILE_SIZE - read,
> +			rc = pread(nodax_fd, dax_data + read, file_size - read,
>  					read);
>  			if (rc > 0)
>  				read += rc;
> @@ -192,6 +191,9 @@ int main(int argc, char *argv[])
>  		exit(0);
>  	}
>  
> +	pagesize = getpagesize();
> +	file_size = 4 * pagesize;
> +
>  	dax_fd = open(argv[1], O_RDWR|O_CREAT, S_IRUSR|S_IWUSR);
>  	if (dax_fd < 0)
>  		err_exit("dax_fd open");
> @@ -202,15 +204,15 @@ int main(int argc, char *argv[])
>  
>  	if (ftruncate(dax_fd, 0) < 0)
>  		err_exit("dax_fd ftruncate");
> -	if (fallocate(dax_fd, 0, 0, FILE_SIZE) < 0)
> +	if (fallocate(dax_fd, 0, 0, file_size) < 0)
>  		err_exit("dax_fd fallocate");
>  
>  	if (ftruncate(nodax_fd, 0) < 0)
>  		err_exit("nodax_fd ftruncate");
> -	if (fallocate(nodax_fd, 0, 0, FILE_SIZE) < 0)
> +	if (fallocate(nodax_fd, 0, 0, file_size) < 0)
>  		err_exit("nodax_fd fallocate");
>  
> -	dax_data = mmap(NULL, FILE_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED,
> +	dax_data = mmap(NULL, file_size, PROT_READ|PROT_WRITE, MAP_SHARED,
>  			dax_fd, 0);
>  	if (dax_data == MAP_FAILED)
>  		err_exit("mmap");
> @@ -220,7 +222,7 @@ int main(int argc, char *argv[])
>  	run_test(&truncate_down_fn);
>  	run_test(&collapse_range_fn);
>  
> -	if (munmap(dax_data, FILE_SIZE) != 0)
> +	if (munmap(dax_data, file_size) != 0)
>  		err_exit("munmap");
>  
>  	err = close(dax_fd);
> -- 
> 2.19.1
> 

