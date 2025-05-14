Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA121E492D
	for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 05:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747201017; cv=none; b=RMCXNrN6WvhfJAj+7MpWNbzqUTJ9rko1S04klZJmoX8Ui5zCh3Vtdedzi8hVH0MQ2HkmTr848T0E+3Ydnff7qJy4WhGpl4vK/6PovwUzHhbKfrk2WkgoTrWnjsThHJSkeO5n4Snr85j/AutKnFE+SC8HiaoyTbetsV4g2a1pDg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747201017; c=relaxed/simple;
	bh=5cfTI/aWoZlCOnNpty3N6u09TpujQH8CPhzu9Z7vEJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LmcSkAaa/rdN7Nif4YN08sMctuzbktZFvQrmc7C1G6+v+5nitjwLe3mzOvAKBsyDA406nYRjfKEm9+nHHIQRqirBtNo5BYtg6TMrimJ0Eqk6fd2NGn4/eEdxmShNQmap561eJNYY9EmllhuHlO3pbw7fC9mIJSAL8QwMP0N5Z3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DeEMRc9l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DeEMRc9l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747201013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k7DVWcCawpaeNJq2qKOr5EAfsfYlAClMdZ4LZ2aaJxI=;
	b=DeEMRc9lOWQT5QeT7dVD6hBqG/zUIqNYXmJAEl7UU7/iP1k8u20ZwOKKxPGjVqysKMEA7H
	brgXEi0Wf0hPLNtRG9UHYHJV3tgoh7X/sSLGk1pXFCPqhwf+661zAw1KdI7fQh7IXb/2Bb
	swsFmZvlQvXlwz7AdljE8bYxyffsSmI=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-mqr_10ckMfa0_IcW3gXPsA-1; Wed, 14 May 2025 01:36:51 -0400
X-MC-Unique: mqr_10ckMfa0_IcW3gXPsA-1
X-Mimecast-MFC-AGG-ID: mqr_10ckMfa0_IcW3gXPsA_1747201011
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b2518fbaaabso4988528a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 22:36:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747201011; x=1747805811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k7DVWcCawpaeNJq2qKOr5EAfsfYlAClMdZ4LZ2aaJxI=;
        b=LWWA7AdRQ1C2nfDj6e3QDfwWpaXIJndEHaDJ6SDRazinaUXu9+qr+FYm6JSe+2EjJ7
         XrKXtPRCQkZ4nYOGgz0mphkMiDZVnc7jQmVhBjriXCafopCWcHNS0C9YV7KJTdAaGduw
         UhQ91hAdtLbZqu7c5d1O4ShBj5n141a9F5hZqboQww+Y9X0BQNaqUYSuwxiwLTfb9tZV
         iJOfJ8BMQVXooHGOavKBnU55XkqT/YCy6t62OlvGVo/HrnFXmp6gMYDauN7BXifneRzR
         KyLEePYsk+ocD9BNRkJmPIBDw95W+0XYXihw421b8qFzwclZIQjsBoTo68GrOJ3gIvT2
         ifpw==
X-Forwarded-Encrypted: i=1; AJvYcCXp/cx2b0mGjplazHtlhKTNn7UvdIDepXV6YsIdYHfTN4LsSUiy6rpDpE7Kx+y2F3+MvTsqfULopTc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoKE0l/acBV26xxY7UXKBLw156qix3IgrOsGszcYahrMaVQBvU
	pYsteB8lkfp1If9nvX52Xm1siVwVEuNwtBUJQTMgP1yXsb0HtP8VB1PMUQZrVVDRlietcfe90eK
	OkYIivtW2zUUtTFfJ0yqmaxh42fOYmiw09JDuldhauIGRcipT8ZcLhXYvuA==
X-Gm-Gg: ASbGncuY/qosQz3WuX5MCNmZpe/QMY08i3m0atvYa3GX7xqmGmvigwf+gYpU3afLbFC
	fjzcMOEhpVwKlkPk5H45BJ6tTMmtfL7QIBcmYPLq4cENHm6Zz5VzxSUsg2UX6ErPC9OfAtd/okk
	mdrkUZfKZYiUW2K7GNTKXfPe/6gpB1RYk7xGF9p7SVx99gPp8JB9qlj2+5WAaGS8Sd9gehPqKuN
	5MXelckJ6CfyRSylY6epa5oRGl8Xqpx2VIE3g/TuTKh3tIXPh8s6KYHdkAoBFfmMMWCkZkyTEO8
	bBT4a7MFpb84w+ELrUWAhh1YLCqxPDZ6cp+FISssKGCA04sqQSh7
X-Received: by 2002:a05:6a21:33a1:b0:1f5:8fe3:4e29 with SMTP id adf61e73a8af0-215ff08f0d0mr2736423637.3.1747201010719;
        Tue, 13 May 2025 22:36:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5eWBBrJf4d2S34HMSb0MF2dI6lzhWWQaGfh5YOlas66yp91639bve2mCDTBX6wAna3TDIig==
X-Received: by 2002:a05:6a21:33a1:b0:1f5:8fe3:4e29 with SMTP id adf61e73a8af0-215ff08f0d0mr2736391637.3.1747201010402;
        Tue, 13 May 2025 22:36:50 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b236de8839asm8012301a12.40.2025.05.13.22.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 22:36:50 -0700 (PDT)
Date: Wed, 14 May 2025 13:36:44 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH v1 1/3] new: Add a new parameter (name/emailid) in the
 "new" script
Message-ID: <20250514053644.q2yzlhceclxvvffn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1747123422.git.nirjhar.roy.lists@gmail.com>
 <837f220a24b8cbaaaeb2bc91287f2d7db930001a.1747123422.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <837f220a24b8cbaaaeb2bc91287f2d7db930001a.1747123422.git.nirjhar.roy.lists@gmail.com>

On Tue, May 13, 2025 at 08:10:10AM +0000, Nirjhar Roy (IBM) wrote:
> This patch another optional interactive prompt to enter the
> author name and email id for each new test file that is
> created using the "new" file.
> 
> The sample output looks like something like the following:
> 
> ./new selftest
> Next test id is 007
> Append a name to the ID? Test name will be 007-$name. y,[n]:
> Creating test file '007'
> Add to group(s) [auto] (separate by space, ? for list): selftest quick
> Enter <author_name> <email-id>: Nirjhar Roy <nirjhar.roy.lists@gmail.com>
> Creating skeletal script for you to edit ...
>  done.
> 
> ...
> ...
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  new | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/new b/new
> index 6b50ffed..139715bf 100755
> --- a/new
> +++ b/new
> @@ -136,6 +136,9 @@ else
>  	check_groups "${new_groups[@]}" || exit 1
>  fi
>  
> +read -p "Enter <author_name> <email-id>: " -r

I think most of "YOUR NAME HERE" are the name of company, e.g.
"Oracle, Inc", "Red Hat, Inc". Some authors just write their names, e.g.
"Filipe Manana", "Chao Yu"...

So I think the "<email-id>" hint isn't necessary. If someone need that, he
can write it with his name together.

Thanks,
Zorro

> +author_name="${REPLY:=YOUR NAME HERE}"
> +
>  echo -n "Creating skeletal script for you to edit ..."
>  
>  year=`date +%Y`
> @@ -143,7 +146,7 @@ year=`date +%Y`
>  cat <<End-of-File >$tdir/$id
>  #! /bin/bash
>  # SPDX-License-Identifier: GPL-2.0
> -# Copyright (c) $year YOUR NAME HERE.  All Rights Reserved.
> +# Copyright (c) $year $author_name.  All Rights Reserved.
>  #
>  # FS QA Test $id
>  #
> -- 
> 2.34.1
> 
> 

