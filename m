Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA8A192B9D
	for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 10:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731665625; cv=none; b=sGsH15Yz/1i4ZK678+oduc1sSeO02HJU7wzs3s25iSC8qMyvbKuACRz6OUXTw/OdCdNAyur68HO5D3Jc86IJLXCvV9iMZq0rKtshJdlZoKMs/MVFESwhiOKQojsZZ2TxDW2nlhMMZHDHLTEYq0lVNJPiLu65HDSKh1JkmS9KJqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731665625; c=relaxed/simple;
	bh=iilK65+5uAZD9k9cuafhLx55P7KOcaH8dTzWUO+pPAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/vAidx4kCCM7EBiCTcdTKokFuIcCMdE/lZUhfY3fkmlQSBlHKi6ke5cERWnTnGW0hj0wYj0AT2RcjNLIRQEohjYERa1uqNRBQixlzeXHs3Nntl75C100rsMVc7kcYN9PynvGK+7K33AwurImBCHfL3/PbniWEG/yui/cWdhweo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dwY6iN7h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dwY6iN7h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731665622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Y4ySrL+N5mDGiGXdf0mBo2mxUbz7/JQ+mzKyQ+R/hc=;
	b=dwY6iN7hmobUDScLMLJ9ubrthmigrfb5jyX7flCW1VtY/GzeCTBlzgglUXerNNFMQ1sygS
	vIps9+kfQT09hcc03tphv+86t5PP0PLPuzPFut95FD0MMU62hNtz9v5qtcOPF8eLMgKHGJ
	j4B5kRcbVXeNT2zWkTsHUwehUz9cQQU=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-aMX6guNYOt6mX1Bty_DaGw-1; Fri, 15 Nov 2024 05:13:40 -0500
X-MC-Unique: aMX6guNYOt6mX1Bty_DaGw-1
X-Mimecast-MFC-AGG-ID: aMX6guNYOt6mX1Bty_DaGw
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-722531f7806so1851560b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 02:13:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731665619; x=1732270419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Y4ySrL+N5mDGiGXdf0mBo2mxUbz7/JQ+mzKyQ+R/hc=;
        b=K7gt0JZrZSu68c1lc+5HxzEbdxqkXCVOyGnrZD5QBO6f//uHBF9TUXMecL5NiEa/Y/
         6h9Wod2J2poqtM6Qvvc3kBOVcahKmiaHyekVekzkol5JHl/DMMMklvQDLn9/bZpNTGG/
         RWzWEHBURFfSY5LOHULo3ufEvf9nlCkmMTQNMwojxK71iAYkiL0sAHjhqWvAMQCWL4s1
         CA0g28a8AMgQ1S/hnFOiidWzqa8Qmf6lqOMRte1+t2+SYRxyicb3eKBBepiI2gqMeoQA
         NttGoycgCIYQCGeTlDelZAZGRzH5jT/8mQ3s4gspVRCcQ0dumrvUdpm6ybtYdCVXqKiO
         iezQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/rSoiMHr5GvbHxkN6Xm1t6R8wf1bLANlXDvxFu991oDGhh7o9is8vzaKSQFlF/GqLgBj4zwqAPLw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb5lTzEck/0fkCyZ1m0YcpbvQhU7R9BBxP1JTuvqfQr/WP0Uga
	HF4Jfm9pP6XC5v+il3R+D4WArQ1AoUr1zvf3Sq8q81H8cpqvOZlhRYmi9tBjCWS5AEcqCo6JRuB
	m+Qhn71HBOJlCMtSN0aQzxvyUJ6lcb1IqroH3k1Rh38Ovs2HKgI16zlwFZZrKVF1pp9U1
X-Received: by 2002:a05:6a00:1483:b0:71e:452:13dc with SMTP id d2e1a72fcca58-72476bb8a9bmr2248502b3a.13.1731665619044;
        Fri, 15 Nov 2024 02:13:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEfL9O7nII/mXZF+B3NEpmkH++Ja1JLTA5rcp+dXCDJZZEHOS5c/oQXaPK/v5e9/SsiC8g+vQ==
X-Received: by 2002:a05:6a00:1483:b0:71e:452:13dc with SMTP id d2e1a72fcca58-72476bb8a9bmr2248484b3a.13.1731665618604;
        Fri, 15 Nov 2024 02:13:38 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724770ee7d3sm1012917b3a.38.2024.11.15.02.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 02:13:38 -0800 (PST)
Date: Fri, 15 Nov 2024 18:13:34 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs/185: don't fail when rtfile is larger than
 rblocks
Message-ID: <20241115101334.jrxgle4r45cjfxzo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <173146178810.156441.10482148782980062018.stgit@frogsfrogsfrogs>
 <173146178844.156441.16410068994780353980.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173146178844.156441.16410068994780353980.stgit@frogsfrogsfrogs>

On Tue, Nov 12, 2024 at 05:37:14PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test creates a 200MB rt volume on a file-backed loopdev.  However,
> if the size of the loop file is not congruent with the rt extent size
> (e.g.  28k) then the rt volume will not use all 200MB because we cannot
> have partial rt extents.  Because of this rounding, we can end up with
> an fsmap listing that covers fewer sectors than the bmap of the loop
> file.
> 
> Fix the test to allow this case.
> 
> Cc: <fstests@vger.kernel.org> # v2022.05.01
> Fixes: 410a2e3186a1e8 ("xfs: regresion test for fsmap problems with realtime")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Makes sense to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/185 |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/tests/xfs/185 b/tests/xfs/185
> index b14bcb9b791bb8..f3601a5292ef0b 100755
> --- a/tests/xfs/185
> +++ b/tests/xfs/185
> @@ -156,7 +156,9 @@ fsmap() {
>  
>  # Check the fsmap output contains a record for the realtime device at a
>  # physical offset higher than end of the data device and corresponding to the
> -# beginning of the non-punched area.
> +# beginning of the non-punched area.  The "found_end" check uses >= because
> +# rtfile can be larger than the number of rtextents if the size of the rtfile
> +# is not congruent with the rt extent size.
>  fsmap | $AWK_PROG -v dev="$rtmajor:$rtminor" -v offset=$expected_offset -v end=$expected_end '
>  BEGIN {
>  	found_start = 0;
> @@ -165,7 +167,7 @@ BEGIN {
>  {
>  	if ($1 == dev && $2 >= offset) {
>  		found_start = 1;
> -		if ($3 == end) {
> +		if ($3 >= end) {
>  			found_end = 1;
>  		}
>  	}
> 

