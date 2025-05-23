Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96C62248B9
	for <linux-xfs@vger.kernel.org>; Fri, 23 May 2025 13:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748007426; cv=none; b=rpsMRVA8gTgo/L68YMmqRL1PCxX2NiyD9Gan31r+bQKP2+oxd1nbdbT++h84gaBPd5KwE5Ne+7qdkN5d9x5ktrRQFBmiUoU/2YPgyWbr24AcQiMVNO2+ggLqSw66fxLyxkR3mo3nxB/V2R5hYjonsBfMNBEmDT2tCoG9ODSxahU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748007426; c=relaxed/simple;
	bh=RxurU9VH7u1wBYd690W47S66H7qxmMPgFfVb6Z/7Vyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U5EA7GB/TMOLZ3/ylVj57Y9OOaw2F6eExikjbkYPcrAj4PsHErgZb4xHE1FWaVWln+rua8DefGNPiwE9e/o5b+QnQRsUSHrNqLGSKILiMwYN3awvre8/YDeyRnJNOAjt34RF+Ynu3PJzQZnQGTZjEGFdzSRU7MQ3hHjmmKz8f1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AFR0OFwt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AFR0OFwt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748007423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b4RHY5iqN2MaD+kEV0mHsFyeaBl8Tu8APPEOii/iCBs=;
	b=AFR0OFwtVw8XqBo/FoXZHAH983LvAZHIzyhrTUm6j6nIsxEHh4VUUKFikU40ZwaAcT1Dsk
	4jv8i6F5AJ4nsR1Fdyy7GopQd4D+Cl3t2UxZYx4M1C5l47ZHEb5istTWy9ATtZmOoJ2+PX
	7Vx4GSsAkuWRThTuqykrO6wX8xhg/YU=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-ykfxCK_8MyqEoG1s4JgMXg-1; Fri, 23 May 2025 09:37:01 -0400
X-MC-Unique: ykfxCK_8MyqEoG1s4JgMXg-1
X-Mimecast-MFC-AGG-ID: ykfxCK_8MyqEoG1s4JgMXg_1748007420
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b26e0fee53eso5491816a12.1
        for <linux-xfs@vger.kernel.org>; Fri, 23 May 2025 06:37:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748007420; x=1748612220;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b4RHY5iqN2MaD+kEV0mHsFyeaBl8Tu8APPEOii/iCBs=;
        b=kVLCTIlE9ww314U8dMzdTQac/nAY5CI9RIce5///zxogQz+BeaDnpfUlSDA8BHEaLM
         GkhUDzIooXpLyL5EjC00R4A0+c1iGOlm1ntiEype+ZdecPTT00s/UwXmSVB+WerepP/B
         GsMTH0p+VHCjRs2uDoFxsJavF+TTMoT8gCjq/TFq6HycqNvFItFctkPfxDq/6VfeJbFR
         iiGE8ndll9CdITPTkHGl/h4JyUfzVlR21007+Sq0AxfP+xuulbdHYBdLhJ3lE67WLrDa
         uWcJFhJJUVbKMwnTABsQKCmmbibHoFGcnEBmF/ARG8hD3+vJckrVCAE7uxl7Qd1x7gYz
         +OFg==
X-Forwarded-Encrypted: i=1; AJvYcCWTKnMjaPf1TzjfagmDo7Ys6tDzqT1xcHmRdLA05wQR9HNFEuIW5/AT+ClCsCSuTi9zDmb9KzKfnx4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuXqTTwYFAwNCs3zP5ziSXkH3bNrlMZolQA0i1WEdzesoMIjz1
	E71UInJSr2a0ZPAj0mMphs97q1eCsQwGJ8S+sS1dFBAHMPVmP4BZxWPUuDT1Wgx88D+dyWwoksX
	w/JBGsHsDPwsHsLgv3wTQXjjZZMOfwQLDtHGnzxAwfSbsw709P0GFRRgkYf8jeg==
X-Gm-Gg: ASbGncurtu/Ex1dzur0iFLrv0a8v7gp7O5zCUbiuetLBxGr0Fe0/5lFPtxwUk9p6PRV
	aa+bxkML4CnQ30XBHRsVw8ZY30NZMZl5uKNJdc/9O0p3GdF+8ic2SR6eS+4g/NyoYVpzWPlrk8q
	aF8riTjpUKOuqk/tKTlmLvU+Oq2FNBMhrv3NYAdXzM4MuRAqYykHTrRAybldxWDGDDbutYdGJCv
	EBtb3TNm8XxngnMWUUTvOsQn4vTPloWmmoc36Ur8H7RIMh4upUh4aVV5mnU/6QiUW1c2NopI5B2
	kTZ3OuLZNoICJW8KA3QfGY4vw9Ke0swTffRgYNWJPyUdXA7EoER2
X-Received: by 2002:a05:6a21:318c:b0:1f5:9208:3ad6 with SMTP id adf61e73a8af0-2170ce8c04emr41721091637.41.1748007420522;
        Fri, 23 May 2025 06:37:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExolJZr41ZZehMDnfw2H6lN5AfEYxS12dLBplbRK0rq7eGBE+HwDv1wLGKguY4sO01uouzqA==
X-Received: by 2002:a05:6a21:318c:b0:1f5:9208:3ad6 with SMTP id adf61e73a8af0-2170ce8c04emr41721054637.41.1748007420163;
        Fri, 23 May 2025 06:37:00 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a9709534sm12691975b3a.41.2025.05.23.06.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 06:36:59 -0700 (PDT)
Date: Fri, 23 May 2025 21:36:55 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] check: unbreak iam
Message-ID: <20250523133655.bkt7ajt7qwcw6mgf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <174786719678.1398933.16005683028409620583.stgit@frogsfrogsfrogs>
 <174786719750.1398933.11433643731439553632.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174786719750.1398933.11433643731439553632.stgit@frogsfrogsfrogs>

On Wed, May 21, 2025 at 03:42:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I don't know why this change was made:
> 
> iam=check
> 
> to
> 
> iam=check.$$
> 
> The only users of this variable are:
> 
> check:36:iam=check
> check:52:rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out $tmp.report.* $tmp.arglist
> common/btrfs:216:               if [ "$iam" != "check" ]; then
> common/overlay:407:             if [ "$iam" != "check" ]; then
> common/rc:3565: if [ "$iam" != "check" ]; then
> common/xfs:1021:                if [ "$iam" != "check" ]; then
> new:9:iam=new
> 
> None of them were ported to notice the pid.  Consequently,
> _check_generic_filesystem (aka _check_test_fs on an ext4 filesystem)
> failing will cause ./check to exit the entire test suite when the test
> filesystem is corrupt.  That's not what we wanted, particularly since
> Leah added a patch to repair the test filesystem between tests.
> 
> Cc: <fstests@vger.kernel.org> # v2024.12.08
> Fixes: fa0e9712283f0b ("fstests: check-parallel")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

I should revert this line too, when I removed privatens and run_setsid from check.
Thanks for this fixing.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  check |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/check b/check
> index ede54f6987bcc3..826641268f8b52 100755
> --- a/check
> +++ b/check
> @@ -33,7 +33,7 @@ exclude_tests=()
>  _err_msg=""
>  
>  # start the initialisation work now
> -iam=check.$$
> +iam=check
>  
>  # mkfs.xfs uses the presence of both of these variables to enable formerly
>  # supported tiny filesystem configurations that fstests use for fuzz testing
> 
> 

