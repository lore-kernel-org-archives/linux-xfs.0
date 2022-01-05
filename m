Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283F7C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 16:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241895AbiAEQTN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 11:19:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49348 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241894AbiAEQTM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 11:19:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641399552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R57nPR5upCf+llF7MYV/PDGEv/CLCFGVlA6W9s8i/a4=;
        b=ZbAW5euocaThC6jCQ3qYz7zDKtrvasUuhMn34HBuTFLzFbsYqj/RzBfJhRvp57rJi3qRtg
        N8Rf34PTIXxoQjILC3iC0kA/GmbPUrUgh+W74Acki4VbG6DWEBSuX1prZ70411zZNVJ+Ba
        jD51ADPnV/kWH0VvzYlzXyCf+7G/PC8=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-T-TbXlR0Ppi0yzpnwmR7WA-1; Wed, 05 Jan 2022 11:19:10 -0500
X-MC-Unique: T-TbXlR0Ppi0yzpnwmR7WA-1
Received: by mail-pj1-f70.google.com with SMTP id 62-20020a17090a0fc400b001b31e840054so1882904pjz.1
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jan 2022 08:19:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=R57nPR5upCf+llF7MYV/PDGEv/CLCFGVlA6W9s8i/a4=;
        b=li4qTSYFsoURkhRaj6Sd9XDJlZaMeLymqq86wK7R7ONDEyGLDWYMinABuTotZjwBjW
         6RVYxgX8Qx7+my+PNZjOWWRjPg5RCULaJ53RuwhNsVKJDMRxOqnDdGb7GPptIyQknZqq
         yZnWjcW9XMcR8XQsxVkGUPDAbarOZJlxa778MrGM+NUrdvIUQR2cBWolC8PuJw6Zx2Fp
         9jLRvtC6Gw+Mc56rX1ARVH+IdXnpED/b9cg/N1m3wnnAm/G+VJtwbPsurhsvD8lVZEUW
         YrS3Q8xMCBTamRWdcKhEGE+SpRA4g/oFzio+02sJUFFSj3gW1Cle+WCvHi267p0otyy8
         jhOA==
X-Gm-Message-State: AOAM532yplCQvhGPsCpdAzu7a8EuRCkiKJwAd5VKc/tncThrDDGk4Sj9
        xPv0HobfTnNVbmuYjnbrwExEt6L792rqZJtl61vNs6FLZiqfNUpyDVILV5cZu1i0gx8/A861Guh
        YWXYCMAzXRWN+9VYVjfRA
X-Received: by 2002:a17:902:d2d2:b0:148:f7d1:6315 with SMTP id n18-20020a170902d2d200b00148f7d16315mr54714370plc.10.1641399549644;
        Wed, 05 Jan 2022 08:19:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx01CiTilCs9vArJjp6dZhXBX9Fv7h1Hsl3LB64aXN7BSAhl9m+FNC9cKvlxHTmpy3qYICjoQ==
X-Received: by 2002:a17:902:d2d2:b0:148:f7d1:6315 with SMTP id n18-20020a170902d2d200b00148f7d16315mr54714352plc.10.1641399549311;
        Wed, 05 Jan 2022 08:19:09 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c24sm21606687pgm.67.2022.01.05.08.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 08:19:09 -0800 (PST)
Date:   Thu, 6 Jan 2022 00:19:05 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests@vger.kernel.org,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs/014: try a few times to create speculative
 preallocations
Message-ID: <20220105161905.jaobft32wosjy3fv@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        Eryu Guan <guaneryu@gmail.com>, fstests@vger.kernel.org,
        xfs <linux-xfs@vger.kernel.org>
References: <20220104020417.GB31566@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104020417.GB31566@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 03, 2022 at 06:04:17PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test checks that speculative file preallocations are transferred to
> threads writing other files when space is low.  Since we have background
> threads to clear those preallocations, it's possible that the test
> program might not get a speculative preallocation on the first try.
> 
> This problem has become more pronounced since the introduction of
> background inode inactivation since userspace no longer has direct
> control over the timing of file blocks being released from unlinked
> files.  As a result, the author has seen an increase in sporadic
> warnings from this test about speculative preallocations not appearing.
> 
> Therefore, modify the function to try up to five times to create the
> speculative preallocation before emitting warnings that then cause
> golden output failures.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/014 |   41 +++++++++++++++++++++++++----------------
>  1 file changed, 25 insertions(+), 16 deletions(-)
> 
> diff --git a/tests/xfs/014 b/tests/xfs/014
> index a605b359..1f0ebac3 100755
> --- a/tests/xfs/014
> +++ b/tests/xfs/014
> @@ -33,27 +33,36 @@ _cleanup()
>  # failure.
>  _spec_prealloc_file()
>  {
> -	file=$1
> +	local file=$1
> +	local prealloc_size=0
> +	local i=0
>  
> -	rm -f $file
> +	# Now that we have background garbage collection processes that can be
> +	# triggered by low space/quota conditions, it's possible that we won't
> +	# succeed in creating a speculative preallocation on the first try.
> +	for ((tries = 0; tries < 5 && prealloc_size == 0; tries++)); do
> +		rm -f $file
>  
> -	# a few file extending open-write-close cycles should be enough to
> -	# trigger the fs to retain preallocation. write 256k in 32k intervals to
> -	# be sure
> -	for i in $(seq 0 32768 262144); do
> -		$XFS_IO_PROG -f -c "pwrite $i 32k" $file >> $seqres.full
> +		# a few file extending open-write-close cycles should be enough
> +		# to trigger the fs to retain preallocation. write 256k in 32k
> +		# intervals to be sure
> +		for i in $(seq 0 32768 262144); do
> +			$XFS_IO_PROG -f -c "pwrite $i 32k" $file >> $seqres.full
> +		done
> +
> +		# write a 4k aligned amount of data to keep the calculations
> +		# simple
> +		$XFS_IO_PROG -c "pwrite 0 128m" $file >> $seqres.full
> +
> +		size=`_get_filesize $file`
> +		blocks=`stat -c "%b" $file`
> +		blocksize=`stat -c "%B" $file`
> +
> +		prealloc_size=$((blocks * blocksize - size))

So we only try same pwrite operations 5 times, and only check the prealloc_size after 5
times done? Should we break from this loop once prealloc_size > 0?

Thanks,
Zorro

>  	done
>  
> -	# write a 4k aligned amount of data to keep the calculations simple
> -	$XFS_IO_PROG -c "pwrite 0 128m" $file >> $seqres.full
> -
> -	size=`_get_filesize $file`
> -	blocks=`stat -c "%b" $file`
> -	blocksize=`stat -c "%B" $file`
> -
> -	prealloc_size=$((blocks * blocksize - size))
>  	if [ $prealloc_size -eq 0 ]; then
> -		echo "Warning: No speculative preallocation for $file." \
> +		echo "Warning: No speculative preallocation for $file after $tries iterations." \
>  			"Check use of the allocsize= mount option."
>  	fi
>  
> 

