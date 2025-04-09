Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D721F7083A
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 00:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744159449; cv=none; b=F+V8NuLNSSQMY/utrTmbhrGqe4NUdy5gtcgAFcTdGSLls1wrunl/NHMCZy/OPslLkZrbZxYworGUoNF2dbq7AUspKTT/2a4IqwW0q5S4+WWexDVlVBYqylq6mnkZeBCVe51ecuMAnKuqOmRoe0jrT3pXIayCaYz+/VfmJa139yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744159449; c=relaxed/simple;
	bh=iHbfk/XWM7ppbOvOvQ6qi64KcVzkWoSVIBABMFcVRjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a3qiS4rAh+fOMyOXnhUUDpbWhrrtYTon7mnbCidwHKeyHLeWPCEkVQplzvF/VvO8Ds9wv/XBKcwnzFeKHNoNqRgkC1zoR5gjpB9nFQ8r0pTx4OjBt47dE7QtVinWmNJIbE8/glgKYWGEmxLlm0oAsSvHYA+3cJrjPdnwJbYApkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=itUSnmxh; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="itUSnmxh"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-739be717eddso4866934b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 08 Apr 2025 17:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1744159446; x=1744764246; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tbxqBhkLvik9isyhyqh8hX9+mqPhV1OKGBEqeSrqBcY=;
        b=itUSnmxhhfoXF514hMPqJ4W8dHno1m2oK+PpUUN5LCThk/km0gEuXpitxa7X21Iw+k
         C4tqbbD7UXm5BsgnnnzkEnbotKZpjsWKFXWO6VlWOJOC50SmCA2t0MfniKilKjnNl6oh
         hc756F2C5pNZprdKWfP/E7PNIVyZl/FppqhYJbMDXgjUpOefkTSV1Im5WMdAPzfJHJKR
         9o51QsJYJrfJx6kcgX5QowBKC/HawOJKIPqKAHXKm2+GBeszUEYL1u/yycDa9681P4OR
         UMyt81+TOYgrHZGp7VzSs9t23zyfqAHMbwJRU1Ib+PxOgp6W38oh9gURdGLO84BO0RCT
         jVxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744159446; x=1744764246;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tbxqBhkLvik9isyhyqh8hX9+mqPhV1OKGBEqeSrqBcY=;
        b=tDDjDK7dOxN1T130+UlTP7e5uHMTXy5R4Z27lB0lc7tI63SiBy47b6D9BfVmv4WFIc
         bMpwR/EfAkRBCn/ATp56qpeEZG3ofnH+KHCYzn9EnuU+tCS9WfbZ9rAQhZNme+vKIU0U
         k9TVrTe8HGZAmw19yKoDWeeEFChsVcYcFVveAGIJfleHkPMbvde+H9V7/70DE8mAJOKi
         D6fsDauMryop76LH3TlO54lI3g1KXrGB2kVJ833xi+y+xzti99gm0o26uKs6r+w+lnoE
         i9wb2ZvndnmUcHwcV7cr7bJe4TgwJOi670AgwMArIwJBW5R6/Xq0Y/IcTRE0jgHMuxMn
         O8Xg==
X-Forwarded-Encrypted: i=1; AJvYcCUcVL6OY9TVFYCfYNxupNPI2xErPmX4tycvk0sXKwF3pHf60L8JD7/130diXGi3HaSkkVs3hPPBy/w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwD8Ik0Lr/KN63pqU+JsJbMJu+FSRFS8Q9slNQ3N9lUDSjtQdjn
	crLdReXZzcVPF5e2K/WbDlAPdY/Vhh3jQxDZ2V4RwqXjE2rS/eG9PS2Do2I9aME=
X-Gm-Gg: ASbGncsIEGRY9IIdzaIBJTyY75hRMH7S6ybAt+ElcXk4baNnHiVMKcEIwyUuMGB8eJ6
	IZLQamhZIJ2/RPcpYS1QMCH5iPDbWUa+5vvYzFF+304MsyPDHzaWnpTlMRCcMBhSar8tgdfCOgP
	50xQLu/ghHRcoONzEm2ab6obgmK6SRvltGNQwwvN8zPjpt+LfWc2toAj0lTcXJYKZwP03Z4sdGb
	CRdtF6Ped+Ifda9BWtTt07446WNotMigjD9Re0V0s7MBPgV28yul2GDkgFl1Q7mfZncUZ//QPFG
	nneQGF0+v/ScYykLSgSpPbs+RuId5EEUJCxyLhorWK699lyYN1lyj6Tn8pMDeKheig2lqB8iOZy
	ZA4DHHqI=
X-Google-Smtp-Source: AGHT+IHMeo66q/hGrohL61FKn52NJ0cl6OjqSIj7QkxbgAFmrHfwOv4cZSsuZcNyl4l8ueFDICgAAQ==
X-Received: by 2002:a05:6a00:3a12:b0:736:34ff:be7 with SMTP id d2e1a72fcca58-73bae52a063mr1061739b3a.15.1744159445981;
        Tue, 08 Apr 2025 17:44:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739d9ea0a7csm11673182b3a.91.2025.04.08.17.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 17:44:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1u2JXu-00000006H8B-0w0d;
	Wed, 09 Apr 2025 10:44:02 +1000
Date: Wed, 9 Apr 2025 10:44:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org
Subject: Re: [PATCH v3 5/6] common/config: Introduce _exit wrapper around
 exit command
Message-ID: <Z_XC0sMObxxHOWM5@dread.disaster.area>
References: <cover.1744090313.git.nirjhar.roy.lists@gmail.com>
 <352a430ecbcb4800d31dc5a33b2b4a9f97fc810a.1744090313.git.nirjhar.roy.lists@gmail.com>
 <Z_UJ7XcpmtkPRhTr@dread.disaster.area>
 <37155b56-34ba-4d5d-a023-242abbe525b5@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37155b56-34ba-4d5d-a023-242abbe525b5@gmail.com>

On Tue, Apr 08, 2025 at 10:13:54PM +0530, Nirjhar Roy (IBM) wrote:
> On 4/8/25 17:05, Dave Chinner wrote:
> > On Tue, Apr 08, 2025 at 05:37:21AM +0000, Nirjhar Roy (IBM) wrote:
> > > diff --git a/common/config b/common/config
> > > index 79bec87f..eb6af35a 100644
> > > --- a/common/config
> > > +++ b/common/config
> > > @@ -96,6 +96,14 @@ export LOCAL_CONFIGURE_OPTIONS=${LOCAL_CONFIGURE_OPTIONS:=--enable-readline=yes}
> > >   export RECREATE_TEST_DEV=${RECREATE_TEST_DEV:=false}
> > > +# This functions sets the exit code to status and then exits. Don't use
> > > +# exit directly, as it might not set the value of "status" correctly.
> > > +_exit()
> > > +{
> > > +	status="$1"
> > > +	exit "$status"
> > > +}
> > The only issue with putting this helper in common/config is that
> > calling _exit() requires sourcing common/config from the shell
> > context that calls it.
> > 
> > This means every test must source common/config and re-execute the
> > environment setup, even though we already have all the environment
> > set up because it was exported from check when it sourced
> > common/config.
> > 
> > We have the same problem with _fatal() - it is defined in
> > common/config instead of an independent common file. If we put such
> > functions in their own common file, they can be sourced
> > without dependencies on any other common file being included first.
> > 
> > e.g. we create common/exit and place all the functions that
> > terminate tests in it - _fatal, _notrun, _exit, etc and source that
> > file once per shell context before we source common/config,
> > common/rc, etc. This means we can source and call those termination
> > functions from any context without having to worry about
> > dependencies...
> 
> Yes, I agree to the above. Do you want this refactoring to be done as a part
> of this patch series in the further revisions, or can this be sent as a
> separate series?

Seperate series is fine. You're not making the dependency mess any
worse than it already is with this change...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
