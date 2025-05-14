Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4567118859B
	for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 05:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747199772; cv=none; b=eu9mTeDJOVd+E0zObnnqSb52To1svvAdvHocd+V+jvtyNmX4jJ/0BFJ+7O54AFqe+vPAZ/O+NYdXIzUot92rh9wMxRLyZKdpx1gcCa6PiZH4I+GBPUhAFxyT4jzcQ2d8sR6qdyp6DUCQw7RMOBGMVCnV0AnpQnlttTM8XRaLR1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747199772; c=relaxed/simple;
	bh=ZYWfRoUNdCbMMtF+BzpN03zk/VJ8HtJCHtEmMns4WK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sBFHm3vWeIEt8yxE2z+vvTad1S23GE9GRiz/7gXfC+/ik3ZAvK5wDabZkYyAvtenydlcbC3j3ur5ljK8sIPZw9SgD6Ps1GW/Of5Ieh5sH7l+Fvel2mw0AITQrHqhIeGrU4+qoU3w/TbYEch1HcaRSBDIIsaC1vcuqYVoI/lD1s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E/Pb3eww; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E/Pb3eww"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747199770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GrxAGHg+YeGRcnPC87DHevJMZf8wlrTQXSUswW5GY/o=;
	b=E/Pb3ewwzwuwAdgt0/Dk/deyARgL57piNvADWFAGjiWd9Vrmwc7XogNCXSoIpkRmiVZB6G
	cZjaxnPnS++oGx680BOauJfeDnceUo/ZuLmliSykTYNz/JDVF2jGqskWEl/XcyXg7M1hvv
	xDBix+bKOqbUcrwTaFH0qsO4fQrB3HI=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-M6dxEDOHNyar1OYINjDytQ-1; Wed, 14 May 2025 01:16:08 -0400
X-MC-Unique: M6dxEDOHNyar1OYINjDytQ-1
X-Mimecast-MFC-AGG-ID: M6dxEDOHNyar1OYINjDytQ_1747199767
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-7394772635dso4714010b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 22:16:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747199767; x=1747804567;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GrxAGHg+YeGRcnPC87DHevJMZf8wlrTQXSUswW5GY/o=;
        b=HbKGGkP0fat+GR6k2/oKxlT9X0h3CddKgc7JmxvpK7IkHQWOo0mJHmj1GqArwbskzX
         w0fJQdcM43w4hue0FSvZn8w4uHAEs93G2/KjhgMFCp4a0nBAHBoMdZpD4ogu/6V3IUQY
         e/CcQ0JLhil09gfujaQzg2F1ZZAT2eStnDAn8FrpUDBYxyYXDrgVhHTnsKkOgcj3Jv8Q
         2zLCUiXyGA/VIUsoDgRbogzu/bJpObp8FmRFhqA/caz3GLUOJZlwTRLzjR/SYxClUlYO
         9yvJIWYzrfFyZ8llv16WEvk1WtLQkfPgF7m9UiPdtSNQI1FeJsdLY5zhwim6LsFInktq
         IZHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVs4FqJW4JmvDiQOjuFIAFIv29wIY5XbrntjEIcoDy29Y33WVLblqYVH1qmlHQFBsvsH6KxASyow/g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhdhPZPooMOx/VQVglsS5HDegTd1foMlj/gnn0XUIfdnRuofW9
	L22XwpIPt2BpQnrd+mIU6IAtFw6Dp8a8Tx7f8oSWlS6wMBJ97R7sH/DzoQMnTnOXIqsvEUsQW26
	FvW4Io0vfZOZQFnFKkhbu8mpG3tJXYqIMULhlzEHllifoTSLy5tWgQMl3jA==
X-Gm-Gg: ASbGncv+gpv+1/HDrtP7zZ8xpQa9AMnoSSauSwm6c0cN73jd3qRrDk1LmeOf5nI3048
	kPmy2K1St1qwhokpBzjzufyXG0VPBoSVG7YkgHrXqi3Ybg/KFtgLgyT13usQR1ghEt9aCAHRY71
	scbqT4NLmWHUh1LPdLR0+rxAFwy4y46YQ8kFQnmXK79QfxdjghrIiVaT93Q/j8kz4lxwYvd0MuC
	lOSz32mPEmeiJUvrYxg4IAFo5p+GK8xGAK+I285qRg4RFMp3oWLLSot6nBttPj7TneE5JnLxGRS
	cveqlPDLZGYPFMF9bvmXq10YweumedgROBkoBIEp3iwIo/cVxvZh
X-Received: by 2002:a05:6a20:258c:b0:1f5:7eb5:72dc with SMTP id adf61e73a8af0-215ff088295mr3149753637.3.1747199767319;
        Tue, 13 May 2025 22:16:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpp7Lh1H7QdSXACO08YRZOZ54s4dp4ICWCaeCGfReWKcc3fDzy5gX5ZLHst/pvYxZN431xkA==
X-Received: by 2002:a05:6a20:258c:b0:1f5:7eb5:72dc with SMTP id adf61e73a8af0-215ff088295mr3149727637.3.1747199767021;
        Tue, 13 May 2025 22:16:07 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b234ab540f0sm8077793a12.34.2025.05.13.22.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 22:16:06 -0700 (PDT)
Date: Wed, 14 May 2025 13:16:01 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH v1 3/3] new: Run make after adding a new test file
Message-ID: <20250514051601.xj2lzfcmvruovorm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1747123422.git.nirjhar.roy.lists@gmail.com>
 <cf589731ad93deb067f6dadf0d80604884fb330a.1747123422.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf589731ad93deb067f6dadf0d80604884fb330a.1747123422.git.nirjhar.roy.lists@gmail.com>

On Tue, May 13, 2025 at 08:10:12AM +0000, Nirjhar Roy (IBM) wrote:
> Once a new test file is created, it needs to explicitly
> added to the group.list file in tests/<FSTYPE> directory
> in order for it to get run. Automate
> that by running make by as a part of creation of the new
> test file in the "new" script.

I think it's not necessary to force to do that, the users can do "make -jN"
when they need :)

> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  new | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/new b/new
> index e55830ce..647763c1 100755
> --- a/new
> +++ b/new
> @@ -191,5 +191,13 @@ QA output created by $id
>  Silence is golden
>  End-of-File
>  
> +echo "Adding test $tdir/$id to the test list..."
> +make >> /dev/null 2>&1 || true
> +
> +if ! grep -q $id $tdir/group.list; then
> +	echo "$tdir/$id created but not added to the $tdir/group.list."
> +	echo "Possible reason is make failure. Please ensure a clean build"
> +fi
> +
>  echo " done."
>  exit 0
> -- 
> 2.34.1
> 
> 

