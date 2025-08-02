Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486791E502
	for <linux-xfs@vger.kernel.org>; Sat,  2 Aug 2025 13:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754142431; cv=none; b=FpDrXs00ufRi6deRTB9bxDE10LZlNVoF2yjfFo+mh2V7+FIQaHq8/4ccqIWCU2SDBwmubpoZMgzuoKzMxobAZUAouiPU4i5NLCzVY0Q+MumLYXYpO0vLU9xRlVi2YHjZ0IXPKwGi3WaEHAlo1hUPe12MH2l5aKKzEQrWuVgVz1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754142431; c=relaxed/simple;
	bh=5W1UMp9g72pw9RPEvfzCxPIKYaFpk6jFq1tK1OHHrdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RXgHr8Mfo+A/pdfEYKBNgnUyPb1euY4BLV9beoB8COWhldDCbELZ/HMxKEEV01j7/18peCiCxq4+F86Bb4cC/+qgl1xl/YrzWmMT+RJTV4LGBkULW+AJf2UPKka7yjnwmaF0Lpnf0W4VjPAxlN+O7fqxPB2x96Ym2F5ZzWODfjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Km2JPvKW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Km2JPvKW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754142428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KCPzhhRIiZOBK75Gntdckoh4PTRzWtWZ6zcvlf0GwqQ=;
	b=Km2JPvKWEgZVAdQApb0KG0MfezdXMBg2fxihSwgZwtfkMgbvz++C09f+TV4SZACxD8wmyk
	cse0bILmBZEUvEqHWlAgumKdYXmealx6BF11tvaPRu0+jBClOFyrSkFQmCA1wWMIq9SRAp
	GQ0jYp52zqOBQ07TRlA6b9Vhg22NwcI=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-tCKDcseCNgKPZn43i4jFxQ-1; Sat, 02 Aug 2025 09:47:06 -0400
X-MC-Unique: tCKDcseCNgKPZn43i4jFxQ-1
X-Mimecast-MFC-AGG-ID: tCKDcseCNgKPZn43i4jFxQ_1754142425
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b3bde4d4d5cso1369661a12.2
        for <linux-xfs@vger.kernel.org>; Sat, 02 Aug 2025 06:47:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754142425; x=1754747225;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KCPzhhRIiZOBK75Gntdckoh4PTRzWtWZ6zcvlf0GwqQ=;
        b=A51jVl6g/ASHIU4k3eDCU4neE9M4mAbqwObQ+KoGJZEBHHFEVA/W0X1QErLfJUiSzX
         htWCWRz8lLReqiNamfw+hOtymJDjbpsnLaTEAa/c9xaDxmUewc+8eHVefQY49nsCotQc
         T9r1K7UR4DipQeWmMSPzmtdgvscaolML1ONmNrtLJMULYcRfMtFiBJ7jPpBCRxCJTcS0
         IyJdzfU8a5EH5+u6ysOR33kAD0OTGOJo5kT/+XbI725z3/Nd1qNtuA/HfBzBYM+BeGdQ
         u8kw9nJIKAWgMvWX8p6kEeSVKI4OGXZQ7GjWCH5JVKd6QoqVLg6MDSpBK5cZVh6/o13d
         buiA==
X-Forwarded-Encrypted: i=1; AJvYcCWJorazdLDol9rPX8GyGElc4zKjq+BP6HKkePSF6FN+sPAND+Urfx4AECpUbyU6k1zbdzM8SRYDvJs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsdVtvRCl2dJDSTv1fMtSzp1KBenIM8mZ6Kgig0R8ToUS3mlAU
	Wa/Nyx1VRuOgMoUrf7/g6XR9fnTXbTgE6riwY0Joo9zXleFBQvnpNlR1xvNh2tR13jGiEPnsaYI
	GCAqRvN/eAJaUmY2Iabm7bbyLNTM9YpKGmZNpvU3TRXXq8nhdLkvpzHdlcBd5rQ==
X-Gm-Gg: ASbGncuSiAka6DY0h1gEG0hsVfLdylJSRvGIWwqNpQBHIei1Kh0jfvXl1PnsPZficCX
	SOlSH8ptxGoiogjoiAuNVaAVKWuVRKmQ8xFOyuhDWD3nNR2Voob3BdCzLACZgl1BwIV2eKlgxdx
	QZrK0fnYDxpI1fU84P/Ekmy9qP5jYPYLo/rrj9rdaqAWdvOSg+/QszIjvIRVOUn8cmoCgdbEFMU
	T93UsONn5WO1C9EuAhSWud+sIQJ88Uk+/AjUhIorw3TaoB53X0w0GdCufcHVOC1jfkoy8mHFDyF
	O6MiW6vomTbuIvlksOTvHnpRJfeQjugxyqxo7P0S1dM0HI2j8aLa3lmHPpyNV/JPBufC7todT3h
	C7m+R
X-Received: by 2002:a05:6a20:7d86:b0:233:c703:d4bf with SMTP id adf61e73a8af0-23df8fd290cmr4709660637.19.1754142425449;
        Sat, 02 Aug 2025 06:47:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGP5eOgAqRjUOjwxsaNNr36B04elCmmGnD7lGj7JhewdjfOMgaQ2Fvz/dX0pJuJV3Cm7jYtCw==
X-Received: by 2002:a05:6a20:7d86:b0:233:c703:d4bf with SMTP id adf61e73a8af0-23df8fd290cmr4709636637.19.1754142425036;
        Sat, 02 Aug 2025 06:47:05 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bccfe9003sm6447391b3a.125.2025.08.02.06.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Aug 2025 06:47:04 -0700 (PDT)
Date: Sat, 2 Aug 2025 21:47:00 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] check: collect core dumps from systemd-coredump
Message-ID: <20250802134700.khtlw7thzqyclfnt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <175381958396.3021194.15630936445319512317.stgit@frogsfrogsfrogs>
 <175381958439.3021194.17530499480231032752.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175381958439.3021194.17530499480231032752.stgit@frogsfrogsfrogs>

On Tue, Jul 29, 2025 at 01:11:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On modern RHEL (>=8) and Debian KDE systems, systemd-coredump can be
> installed to capture core dumps from crashed programs.  If this is the
> case, we would like to capture core dumps from programs that crash
> during the test.  Set up an (admittedly overwrought) pipeline to extract
> dumps created during the test and then capture them the same way that we
> pick up "core" and "core.$pid" files.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  check     |    2 ++
>  common/rc |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 46 insertions(+)
> 
> 
> diff --git a/check b/check
> index ce7eacb7c45d9e..77581e438c46b9 100755
> --- a/check
> +++ b/check
> @@ -924,6 +924,7 @@ function run_section()
>  		     $1 == "'$seqnum'" {lasttime=" " $2 "s ... "; exit} \
>  		     END {printf "%s", lasttime}' "$check.time"
>  		rm -f core $seqres.notrun
> +		_start_coredumpctl_collection
>  
>  		start=`_wallclock`
>  		$timestamp && _timestamp
> @@ -957,6 +958,7 @@ function run_section()
>  		# just "core".  Use globbing to find the most common patterns,
>  		# assuming there are no other coredump capture packages set up.
>  		local cores=0
> +		_finish_coredumpctl_collection
>  		for i in core core.*; do
>  			test -f "$i" || continue
>  			if ((cores++ == 0)); then
> diff --git a/common/rc b/common/rc
> index 04b721b7318a7e..e4c4d05387f44e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -5034,6 +5034,50 @@ _check_kmemleak()
>  	fi
>  }
>  
> +# Current timestamp, in a format that systemd likes
> +_systemd_now() {
> +	timedatectl show --property=TimeUSec --value
> +}
> +
> +# Do what we need to do to capture core dumps from coredumpctl
> +_start_coredumpctl_collection() {
> +	command -v coredumpctl &>/dev/null || return
> +	command -v timedatectl &>/dev/null || return
> +	command -v jq &>/dev/null || return
> +
> +	sysctl kernel.core_pattern | grep -q systemd-coredump || return

# rpm -qf `which coredumpctl`
systemd-udev-252-53.el9.x86_64
# rpm -qf `which timedatectl`
systemd-252-53.el9.x86_64
# rpm -qf `which jq`
jq-1.6-17.el9.x86_64
# rpm -qf /usr/lib/systemd/systemd-coredump 
systemd-udev-252-53.el9.x86_64

So we have 3 optional running dependences, how about metion that in README?

Thanks,
Zorro

> +	COREDUMPCTL_START_TIMESTAMP="$(_systemd_now)"
> +}
> +
> +# Capture core dumps from coredumpctl.
> +#
> +# coredumpctl list only supports json output as a machine-readable format.  The
> +# human-readable format intermingles spaces from the timestamp with actual
> +# column separators, so we cannot parse that sanely.  The json output is an
> +# array of:
> +#        {
> +#                "time" : 1749744847150926,
> +#                "pid" : 2297,
> +#                "uid" : 0,
> +#                "gid" : 0,
> +#                "sig" : 6,
> +#                "corefile" : "present",
> +#                "exe" : "/run/fstests/e2fsprogs/fuse2fs",
> +#                "size" : 47245
> +#        },
> +# So we use jq to filter out lost corefiles, then print the pid and exe
> +# separated by a pipe and hope that nobody ever puts a pipe in an executable
> +# name.
> +_finish_coredumpctl_collection() {
> +	test -n "$COREDUMPCTL_START_TIMESTAMP" || return
> +
> +	coredumpctl list --since="$COREDUMPCTL_START_TIMESTAMP" --json=short 2>/dev/null | \
> +	jq --raw-output 'map(select(.corefile == "present")) | map("\(.pid)|\(.exe)") | .[]' | while IFS='|' read pid exe; do
> +		test -e "core.$pid" || coredumpctl dump --output="core.$pid" "$pid" "$exe" &>> $seqres.full
> +	done
> +	unset COREDUMPCTL_START_TIMESTAMP
> +}
> +
>  # don't check dmesg log after test
>  _disable_dmesg_check()
>  {
> 

