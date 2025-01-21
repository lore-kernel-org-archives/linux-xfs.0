Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D6F3BBE5
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 03:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737430112; cv=none; b=MDP5rYJhcKK25QFv6Rcy6QGr2CWh6s53ArgESG6nq4j/O0ICPu8oDSL06abEKsKyxhdr8GPCh3iPM0RvlhHqVC1qGS0nsC4cTVfhJBgAxpflp8sQfRZXENg6dBiX6sAuOqvs5gc19Oe0iIbksFp8Io9XmqJJnWqFGOi9spEQ19s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737430112; c=relaxed/simple;
	bh=bPEBdK/qWZ0Zn75m/mlOGY2m7zwRIAwGdQr7gKIMeOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GYJOTDSGwvwFwwCSyFWyLHbFGZgPQusBk9J5EdOEXQ08zftv1ISn8ucWuBEWQLwcb52em6HZrV5c5ALGJhIDv5EJUm9XinaL5m8nWyRRZ/U9RKm4+gGOFvfGmY7xbQr/bHR7yanRfk3mhKFbU9y9E63c86D/HWpKLLCylkYSteQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Maah/1OL; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Maah/1OL"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2f441904a42so9210505a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 19:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737430110; x=1738034910; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CcpoeaCBzCSnacTbDCHAQL8cOA6etRubnzzS9sntxMo=;
        b=Maah/1OLOyu7n0Q54jSl/OEyVsV5OWz48Y5pQWZYTpRc3K10OrnbCOnmfG1ntoBfRj
         cCRorhYfh2taamKyn5r8M1OEl01iaVRVridJ9ywyJxUerUPfo0XJnlaHpATm9Otog0f5
         KeJ8LQ0INml3fd2EEId26LjU9guSjkfyaFwOFunK57UIcfXwragjVUspOSlhNO1MZc0D
         8fwKAdRBqWyPtVLvVwZGCIYjQPLn4JaKA2GnhwsAzw4r2tdFlPUjurCRrrVTgpV0GLXf
         z+vv7Ag8sxBOJdhsSG4VD+DFaYog/F7lQIoLwz/KXKT6jQVpcuOz1M6VLDbeObi6h6tP
         NEuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737430110; x=1738034910;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CcpoeaCBzCSnacTbDCHAQL8cOA6etRubnzzS9sntxMo=;
        b=FwI9y4fbpCjQr/rxlkQ71VHyYMngqfh91PyLIvHWFlDn/7dl6ClXFgJoeovIa0VO86
         1EKQdUIZB1qFeYNOYclSYl/TE/wTpI+J5nDtOQT/om9qQzs7wtSI8MOIB2tReifJmvSC
         WKxCAjkxfpFmj8dP6XF87JuVxiA+cMZw/VbkDX/TdPIZlPk8KxOkiY92U7iNk4kZ0Bt1
         gg0xF7zKYmxU5aGuH0EyPbLLvaZbvjITQEhkj+WDupJlcXMYGO7o18fCWO0QC86az36L
         cgXX5wSVXRyjSynhp8v/TJHokbNrd08GdK9YEhbTNnzoRGf9xnqCe0+8C/8Myc1Lp8YQ
         L1Bw==
X-Forwarded-Encrypted: i=1; AJvYcCV4UWYpxBKqol6wLuLqGPyv9/FOlWslormKVfUiGwohssp2icE6rlrrvgi83I8VtE1Rdk0lb8NxlSs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOmHODxT390643JSHULkhmRS0nnR7ZOzczMdcnn2POsq9UpTTf
	/v8b1cK/jWfYAtHOWDIy85FPJ/qArfjNG1wyGuo26tPoaNvFytDGB7TiSzd++Xc=
X-Gm-Gg: ASbGncs4SQpkkFQy3PouerXMStGoSiEnEyJnmB1Lme/VkdJ1sSjIOxew3ww0lLQPdQp
	j/ni56HFG+fmCj6ffO09j0FOSQCallWMlvgZeMU0RcUWpmFIjquSXJvtfvK8ccRXPrEyLyDCOfG
	s5MLTTqHsbPar/5mtLTYv7aRSDwu1wSkxp2ZsMW8wAvqDrfXh0fM4TP5Hu6yBSoqECvXT4IGw9f
	JM8Da9Fgsz37k/oqSQaeH1ydzgbFRyfFMEu9NEMQ2sl53/lymfNEyK1XKUTlGXTZ8flztO3liAN
	Gols4ZQc80wIv2jOosj1nMFKMm19f3a/1JI52F0rKt6c/w==
X-Google-Smtp-Source: AGHT+IHn/SsWz7vbYHKsSQAnJVTxGJS8kgE1CDNukKRbgMYrEK6G8ijmSQ7zgx30xD9eHey2LSBYxA==
X-Received: by 2002:a17:90b:2548:b0:2ee:fdf3:390d with SMTP id 98e67ed59e1d1-2f782d9a164mr22190616a91.31.1737430110296;
        Mon, 20 Jan 2025 19:28:30 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f72c335093sm11698770a91.48.2025.01.20.19.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 19:28:29 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1ta4wE-00000008VZ4-1wIj;
	Tue, 21 Jan 2025 14:28:26 +1100
Date: Tue, 21 Jan 2025 14:28:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/23] common: fix pkill by running test program in a
 separate session
Message-ID: <Z48UWiVlRmaBe3cY@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974197.1927324.9208284704325894988.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173706974197.1927324.9208284704325894988.stgit@frogsfrogsfrogs>

On Thu, Jan 16, 2025 at 03:27:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Run each test program with a separate session id so that we can tell
> pkill to kill all processes of a given name, but only within our own
> session id.  This /should/ suffice to run multiple fstests on the same
> machine without one instance shooting down processes of another
> instance.
> 
> This fixes a general problem with using "pkill --parent" -- if the
> process being targeted is not a direct descendant of the bash script
> calling pkill, then pkill will not do anything.  The scrub stress tests
> make use of multiple background subshells, which is how a ^C in the
> parent process fails to result in fsx/fsstress being killed.

Yeah, 'pkill --parent' was the best I had managed to come up that
mostly worked, not because it perfect. That was something I wanted
feedback on before merge because it still had problems...

> This is necessary to fix SOAK_DURATION runtime constraints for all the
> scrub stress tests.  However, there is a cost -- the test program no
> longer runs with the same controlling tty as ./check, which means that
> ^Z doesn't work and SIGINT/SIGQUIT are set to SIG_IGN.  IOWs, if a test
> wants to kill its subprocesses, it must use another signal such as
> SIGPIPE.  Fortunately, bash doesn't whine about children dying due to
> fatal signals if the children run in a different session id.
> 
> I also explored alternate designs, and this was the least unsatisfying:
> 
> a) Setting the process group didn't work because background subshells
> are assigned a new group id.

Yup, tried that.

> b) Constraining the pkill/pgrep search to a cgroup could work, but we'd
> have to set up a cgroup in which to run the fstest.

thought about that, too, and considered if systemd scopes could do
that, but ...

> 
> c) Putting test subprocesses in a systemd sub-scope and telling systemd
> to kill the sub-scope could work because ./check can already use it to
> ensure that all child processes of a test are killed.  However, this is
> an *optional* feature, which means that we'd have to require systemd.

... requiring systemd was somewhat of a show-stopper for testing
older distros.

> d) Constraining the pkill/pgrep search to a particular mount namespace
> could work, but we already have tests that set up their own mount
> namespaces, which means the constrained pgrep will not find all child
> processes of a test.

*nod*.

> e) Constraining to any other type of namespace (uts, pid, etc) might not
> work because those namespaces might not be enabled.

*nod*

I also tried modifying fsstress to catch and propagate signals and a
couple of other ways of managing processes in the stress code, but
all ended up having significantly worse downsides than using 'pkill
--parent'.

I was aware of session IDs, but I've never used them before and
hadn't gone down the rabbit hole of working out how to use them when
I posted the initial RFC patchset.

> f) Revert check-parallel and go back to one fstests instance per system.
> Zorro already chose not to revert.
> 
> So.  Change _run_seq to create a the ./$seq process with a new session
> id, update _su calls to use the same session as the parent test, update
> all the pkill sites to use a wrapper so that we only target processes
> created by *this* instance of fstests, and update SIGINT to SIGPIPE.

Yeah, that's definitely cleaner.

.....

> @@ -1173,13 +1173,11 @@ _scratch_xfs_stress_scrub_cleanup() {
>  	rm -f "$runningfile"
>  	echo "Cleaning up scrub stress run at $(date)" >> $seqres.full
>  
> -	# Send SIGINT so that bash won't print a 'Terminated' message that
> -	# distorts the golden output.
>  	echo "Killing stressor processes at $(date)" >> $seqres.full
> -	_kill_fsstress
> -	pkill -INT --parent $$ xfs_io >> $seqres.full 2>&1
> -	pkill -INT --parent $$ fsx >> $seqres.full 2>&1
> -	pkill -INT --parent $$ xfs_scrub >> $seqres.full 2>&1
> +	_pkill --echo -PIPE fsstress >> $seqres.full 2>&1
> +	_pkill --echo -PIPE xfs_io >> $seqres.full 2>&1
> +	_pkill --echo -PIPE fsx >> $seqres.full 2>&1
> +	_pkill --echo -PIPE xfs_scrub >> $seqres.full 2>&1

Removing _kill_fsstress is wrong - the fsstress process has already
been renamed, so open coding 'pkill fsstress' may not match. The
_kill_fsstress() code gets changed to do the right thing here:

> @@ -69,7 +75,7 @@ _kill_fsstress()
>  	if [ -n "$_FSSTRESS_PID" ]; then
>  		# use SIGPIPE to avoid "Killed" messages from bash
>  		echo "killing $_FSSTRESS_BIN" >> $seqres.full
> -		pkill -PIPE $_FSSTRESS_BIN >> $seqres.full 2>&1
> +		_pkill -PIPE $_FSSTRESS_BIN >> $seqres.full 2>&1
>  		_wait_for_fsstress
>  		return $?
>  	fi

Then in the next patch when the _FSSTRESS_BIN workaround goes away,
_kill_fsstress() is exactly what you open coded in
_scratch_xfs_stress_scrub_cleanup()....

i.e. common/fuzzy really shouldn't open code the fsstress process
management - it should use the wrapper like everything else does.

Everything else in the patch looks good.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
