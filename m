Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673781B4F0E
	for <linux-xfs@vger.kernel.org>; Fri,  1 Aug 2025 18:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754074405; cv=none; b=elUggpuigTf3J01AYVe2lKgmo+zKpig5zha6XPnzvBD5yWLWfUXZTh/4st3CX7NIjRRIKSsxUFO6QmDAumI/hp9jC5nDJPv5jQJzLmAn81QbitB8MPfdaO6vbTIFBnOlHKdNzWZ4qvNCVeOpAdaB3/BOB29HTCwuWCkeheiFdkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754074405; c=relaxed/simple;
	bh=BlOWmP6b0ngQyzTUDyYd5gM8MDYZNPL8SItlOoTrUlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KbauqUksyjVl5KfpprKUL8FIAG0lTRcTOGIbOLdtXqTQd/Ak2WGWMd2D0yWGK185537gPcyYaY512LTD5DAvnENnSRQo3/olTlGOQQLcNxhyRFPOppqsLtC7qQ4Udb6MJvxyZSOErjyq70x5SeXNs4ioom9De5krahIcfW80OmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ChintfTR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ChintfTR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754074402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7y/JAVOPDtnhJGGllW7ByUv7onWM1J6uxLUWmUw+0qw=;
	b=ChintfTRyIY4B+1qghde/4i1PHCfeSW7oVE3VrYSVj9Qko4k9rGgjFv2BNzmp7+6r9MXPN
	jejX0mUSofCszBjHbCoDEBrDcTUqU2JnBI4oYJLd+n1MX16ZvZ7PGKH0Edlvu3CyWYGuTP
	QVqrpeDysTcUGTJbnAvf/vP2UP2JVkM=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-1cubPo7SNX6ie6AJiTmATQ-1; Fri, 01 Aug 2025 14:53:21 -0400
X-MC-Unique: 1cubPo7SNX6ie6AJiTmATQ-1
X-Mimecast-MFC-AGG-ID: 1cubPo7SNX6ie6AJiTmATQ_1754074400
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2403c86ff97so16455655ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 01 Aug 2025 11:53:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754074400; x=1754679200;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7y/JAVOPDtnhJGGllW7ByUv7onWM1J6uxLUWmUw+0qw=;
        b=CibM1BD6HEDzZbGNab7vIl1nzgnXdk1YOzbPErVY44IRSZjPvNC5VZ/vye09SNYAuB
         3ClUF1DyZo2tHo00Mpz9W7V/9TCbYQX57OYCXrckPrKVif5qFwmSTtY++OljMmtunzea
         3H8Rd0hu/uT28wpTmJEPvQzyhRCitrVqVpadasiauuD4n0yfiSyCAse4Qk42fsDN3ws2
         wB9Kq2U0hsWY/A0831BY4dp7ry7yBkeeVn8Q8vJd6C6Sqs2d1vOqzuN20WDR4KKHaqEA
         f4Vq02oJU6mfpTMv0jv1vuOlamZxD112/M4Mj9gJpTeMbFJ3b0X2X010c6u93MNKWuHT
         fDRg==
X-Forwarded-Encrypted: i=1; AJvYcCU5LHzUsFFxtxH6T4KE3ni8RfCQHfuZTqyQUsvM0sHEpr/DnS6Mf5Y5RvO+hUH52Dwb7/AH7rq2Hzc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUduHTVOIUtHoVItFF5bPdk6jAwh1rq5BYssqoJUP4nJ6El2aF
	pwfMxJiDocAVYhooFPc6++GucpUI8q9SVyVv+M/jcjN+H8irwtUI3xua+V7W/PdK3vh3tW1xPTL
	55F+lR1vuXI5s6HSc7PVz7XMGTrIILKlPpeGOfNXPgdaMZl7Tl+KQzO7OeEStwg==
X-Gm-Gg: ASbGncvY91v2KcpSf7pCfAPDbBHavBfDcWxdyWSnpqBEuiwDScGbu5XZS9OHgcGf1ia
	KdscublEv0CsUE1X3SqrI+Cns6cyoLglOYAM1kCLxvGcj4YCRccAosE2p1i+9xJpmVxB9wlEP5B
	6j53BmBuOQyQlizW0mwe6/a1irHjalBOxs99nVxCX6MZqX35wCFpWc2mXhXYmxInM81HZ4xjvTx
	RNp83JAo5OFHbtAWkSvX+6Prt4ih6yJDXrBXICcP6KZl0AGh50SSJoEcRjyNx8ShteKQV/vZHEu
	0n+5vkjrtIoMJ9mK2Im6/x9inSyCT2x1E8OWJlns3wSKA+sKFdt0oRYH3Xnxd2MO1p17IXq4Wmx
	j66j3
X-Received: by 2002:a17:903:110c:b0:235:f078:4746 with SMTP id d9443c01a7336-24247030c77mr6836015ad.42.1754074399981;
        Fri, 01 Aug 2025 11:53:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFR71sgbrUQpth4ns+7RmhQm8UWtY4FP90VahQPpWRdU7WkyumbSH8U8cF7K5bIFI1cVFlHg==
X-Received: by 2002:a17:903:110c:b0:235:f078:4746 with SMTP id d9443c01a7336-24247030c77mr6835775ad.42.1754074399596;
        Fri, 01 Aug 2025 11:53:19 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8976a1csm50075115ad.78.2025.08.01.11.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 11:53:19 -0700 (PDT)
Date: Sat, 2 Aug 2025 02:53:15 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] common: fix _require_xfs_io_command pwrite -A for
 various blocksizes
Message-ID: <20250801185315.2d2mfehoqybtiizb@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381958029.3020742.354788781592227856.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175381958029.3020742.354788781592227856.stgit@frogsfrogsfrogs>

On Tue, Jul 29, 2025 at 01:10:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In this predicate, we should test an atomic write of the minimum
> supported size, not just 4k.  This fixes a problem where none of the
> atomic write tests actually run on a 32k-fsblock xfs because you can't
> do a sub-fsblock atomic write.
> 
> Cc: <fstests@vger.kernel.org> # v2025.04.13
> Fixes: d90ee3b6496346 ("generic: add a test for atomic writes")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/rc |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/common/rc b/common/rc
> index 96578d152dafb9..177e7748f4bb89 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3027,16 +3027,24 @@ _require_xfs_io_command()
>  	"pwrite")
>  		# -N (RWF_NOWAIT) only works with direct vectored I/O writes
>  		local pwrite_opts=" "
> +		local write_size="4k"
>  		if [ "$param" == "-N" ]; then
>  			opts+=" -d"
> -			pwrite_opts+="-V 1 -b 4k"
> +			pwrite_opts+="-V 1 -b $write_size"
>  		fi
>  		if [ "$param" == "-A" ]; then
>  			opts+=" -d"
> -			pwrite_opts+="-V 1 -b 4k"
> +			# try to write the minimum supported atomic write size
> +			write_size="$($XFS_IO_PROG -f -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile 2>/dev/null | \
> +				grep atomic_write_unit_min | \
> +				grep -o '[0-9]\+')"
> +			if [ -z "$write_size" ] || [ "$write_size" = "0" ]; then
> +				write_size="0 --not-supported"
                                              ^^^^^^^^^^^^^^^

What is this "--not-supported" for? If write_size="0 --not-supported", will we get...


> +			fi
> +			pwrite_opts+="-V 1 -b $write_size"
>  		fi
>  		testio=`$XFS_IO_PROG -f $opts -c \
> -		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
> +		        "pwrite $pwrite_opts $param 0 $write_size" $testfile 2>&1`

"pwrite -V 1 -b  0 --not-supported 0 0 --not-supported" at here?

Thanks,
Zorro

>  		param_checked="$pwrite_opts $param"
>  		;;
>  	"scrub"|"repair")
> 

