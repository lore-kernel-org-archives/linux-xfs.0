Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739BB747F
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 00:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738716658; cv=none; b=LazesQWtHX+y25mV8lXxePqHlJaoKOVHafhfq5X47CU91WvFdSJhpXJJiPFd0HlcuMPc4vXXHIw27MQXt+q6jiCJJ30Ox6E4GhngpVGLToXepZ3Rmm6JcYvJlcmU1wEnNK81oWVnUbxIAENTgjh0eQSCLMUNPv8M7RIDwhiEAiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738716658; c=relaxed/simple;
	bh=cc1ya+JqHRjR6Yd8BvuLTxB3mF5z69Uh/ICe+TNYFtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=incfu0ncj2MXiGj6SUj+tiseQW9B03oRWyJehav8DIYIXLGc3xeDTKQCY70Fdu4C7ewJCitiu9IPGyWkmigRHeMRDwMhZl3VqNDHyeNu5AkzBAm+ahFK7F+6u354AiHs+KrnYnYoTzILKqZhUGiQNK/ud+w/NlpA99zhr1Qgtwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=RcJAS7SK; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="RcJAS7SK"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-21ddab8800bso88619175ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 16:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738716656; x=1739321456; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x+f5ut8aHtaaUOEA0SL9/VL3SCKIsv78snAXNCivK40=;
        b=RcJAS7SKYWyiqHPZR8a1GKkM/roWENv3tS690LDRhLmuyHjtGbPi35Vd89xpqVPKr3
         s95ksVNacPqNMLhk8A5wP7Qul6OocJCmykUL1JFGfuOhSzOeAwWOqj1NQOBcMKn58NgY
         3oo1yRTa7s/GNmMuA4zzwnUFavBSPZRZnY9rqxT75x3e3g2bnf2h7E5J5RNdsxB7pOhf
         TlT2iZbl1596/KvaGTw4zLGLQeXSa75n4dtd274y55ZKzjOFFltdHGNa0wxKxtNHaqYZ
         D1MAOXhSwcoXh/mMN4a2Dp9cHIbaUcfeR5vbay+zIGLGMoFfyF6Z3gmL/9btSOpM5KcZ
         E3NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738716656; x=1739321456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x+f5ut8aHtaaUOEA0SL9/VL3SCKIsv78snAXNCivK40=;
        b=WfVX3aI3Ny6dTon+6Fqh+gsyQ2NCKU48pF5ga0joL2eLpM0aBWk4aoEnHiBlEPZWzD
         4lXUQDUw97Aqt4ycTjPicKiEQ8UeOc1i7SQGVxmSUfE7sDkMRL8EFl/ZGvTI65n9mMOY
         dd7F0DUS03CbY8ViVqsA7MLUD3z3PlgnAaBLDpFvweP3fbHQT4JC8yN9YRqFQBHtmW1k
         rPgZesay7c7gdJThmBcgHmTXXwquEUqbRt9ne6Jq9Uss6EQWQQdKfoEwlGPyPJ6XLAdJ
         nqoS6AHpDU7O8macoOWzmeDth6XgMpuTbPzjxD/JZBqwKHoEDb5p0t4BKdGO+XBduFQg
         Xacg==
X-Forwarded-Encrypted: i=1; AJvYcCVc3ZawIR72Vp7XoBh4YxnB0DPDSG2XiL42wdJbK+yG+crvhvWjEpi3IjKJS9+0CW9s2OHdQhUy7I8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6TqYYvgvqwLDC6sGnF4SNeX4/Qbgbm6SSnqGYvyH4CLwNy72e
	tcjVoELT8fBup/6ruTwfbvNV6zPeeVyUCztFb1jezGFNoc5hzGv59cbIyvdGaW8=
X-Gm-Gg: ASbGnctUo55oHAm3FqrkNlj9X+oVvPQj02sQ6HN60zbF9vqEEBugODtj/scHV1hnn/z
	XZBiQyjPtmDzVmEFsQfJJbxd2axSCKzf4M0/u8Rh+WFSyVyKV8/MeHmI9eT6W1cpnYL6G8Nt4C6
	LJ1p/fubVfjafibYGnrOf0ENR9NdIltx43lIngxhMApfwWpr8qMBOCe/x3m7kxoJMb9O2yfGUNs
	ENrLJN4pRWODys7lihxijRevnqwhS1exMjBnxq0WwgWyYnRPhYe1yqNTRB6eZTOYsJg1YuSOp2E
	ZeEXC8R1+2tGDND84qczdzpTpjgHm5hN4BadfA6zrHNFRXcRuOzKH97x
X-Google-Smtp-Source: AGHT+IEFF8diM7izccRmRM0P6rk++fEognlyJxR98HocO7nILywRorgG547wh9OlTJsSJGRO4V7ASg==
X-Received: by 2002:a17:903:252:b0:21c:fb6:7c52 with SMTP id d9443c01a7336-21f17f02051mr11770265ad.45.1738716656729;
        Tue, 04 Feb 2025 16:50:56 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f1668800fsm3615135ad.158.2025.02.04.16.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 16:50:56 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfTcy-0000000EjSa-3q5w;
	Wed, 05 Feb 2025 11:50:52 +1100
Date: Wed, 5 Feb 2025 11:50:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/34] fuzzy: port fsx and fsstress loop to use --duration
Message-ID: <Z6K17JRSyAy4_RQI@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406519.546134.6155766711303511656.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406519.546134.6155766711303511656.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:29:20PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Quite a while ago, I added --duration= arguments to fsx and fsstress,
> and apparently I forgot to update the scrub stress loops to use them.
> Replace the usage of timeout(1) for the remount_period versions of the
> loop to clean up that code; and convert the non-remount loop so that
> they don't run over time.

....

> @@ -1115,7 +1124,8 @@ __stress_scrub_fsstress_loop() {
>  			# anything.
>  			test "$mode" = "rw" && __stress_scrub_clean_scratch && continue
>  
> -			_run_fsstress_bg $args $rw_arg >> $seqres.full
> +			duration=$(___stress_scrub_duration "$end" "$remount_period")
> +			_run_fsstress_bg $duration $args $rw_arg >> $seqres.full
>  			sleep $remount_period
>  			_kill_fsstress

Why does this need to run fsstress in the background any more? If it
is only going to run for $remount_period, then run it in the
foreground and get rid of the sleep/kill that stopped it after
$remount_period. i.e. doesn't this:

-			_run_fsstress_bg $args $rw_arg >> $seqres.full
+			duration=$(___stress_scrub_duration "$end" "$remount_period")
+			_run_fsstress $duration $args $rw_arg >> $seqres.full
-			sleep $remount_period
-			_kill_fsstress

do the same thing, only cleaner?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
