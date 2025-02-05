Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFE079F5
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 00:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738715827; cv=none; b=l62Q3n85Eon+Y0qzoMeJ1OGqF9tjQy49VpWvRbsqc0jjQZ2HIQU5+E4MJZfbU1eLJ/ORNLa+A8kjUT8RhhGNHQIY4i1Jf6oVFgVm+OiEmWIazL7nPjGrAQhGz+gdJss9qqs1idR+mOCW+zHZGLzHHgOekwr1ESnh6ghHTCOr3bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738715827; c=relaxed/simple;
	bh=WbgrX6reo4859QCILu/fyJEynNDQB3xCeU/jslB5X98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F3xruSsl8ypGnr3mAJFQRsGKP6IeU5HiarXjAip3LLNYLmkgtaObuR5DahKZSYnIpRE082MC1tj98saKpcXK948BPzObiWOp67gnG6ptxOJ0SML/pT9kAXSlVy8GF2xhe0HNMqmWFgLJhzrB+Jx0JimMusshpWqTO4d0V1HxVZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=fGFQTQ7I; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="fGFQTQ7I"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2163dc5155fso109509615ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 16:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738715825; x=1739320625; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zCOBfzpFTeNSK9rnRpzmFIzU5EiYDyWt4jjPVrCth4I=;
        b=fGFQTQ7I5Mib6B1ufmh4mBezrb4yS8vgcuuk96bZXUBF/swXuPThrB22ksN1Ys/50I
         MSnr4dIRobvszcWCP8ZuXUCGRCTnZ4oLEyo7OvR41PhB5Ywd1ZbYVzkK+3NkxkbqjLPZ
         H8+LXtOGe1sB98DBDBrvoz1wt3YKstMMFORsQalUhD9Upgou5wEqjm3b1rnWeBXdwoKV
         dNUwkVG9MfNiYfYyfhGNWu7/MqtutA1VhyOzajC+Lalkh5Y5sInrp2QFyw2wvXtiKG+8
         FZxIKL+OabkPVww0z9D4jHBe9JBhh4cLVu9ChMZzcY6PvxuursfeVgB2FZywBk9Uixqm
         RLPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738715825; x=1739320625;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zCOBfzpFTeNSK9rnRpzmFIzU5EiYDyWt4jjPVrCth4I=;
        b=l7kW4u5OUpQlf3xUjFb47M8583VR5j03k+dfyxG0KK/uz8t2Q8lFD1HZrC3ReDt5mh
         GQoo/xMAeknd1R1LMcCuUrHae1jh0bCELoPqxQiv3+0hHuU5gZf1+/A+hSgbbRZBCcJY
         US8xgU2Q5K+YAlmnIcXVnKf82zCoWaks5YMA3EotT2KcQhQPIMryOuRNzUlyzln/g1um
         MebVneR/MzXNDXqh+38+QCFVddlBy2Z+fXvCI8H3g5C2VbAmaIz6RdTbliJlK2O3zp9Z
         gjz0obfK4B5nmdZzX9a7dhMCDQiUriHXb+Z8tBxCXxiMulQUWX3Cel+1JNBfydp3ZwSn
         IuzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUai9Mtd7j90soI8LnndjhX1CM1ObDBf3qEl2513QaRWIwy5o718tIBos7kVyzZhrYa6E3dieVKTbw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyS9mx6q55/dzPceDrbPHM9307bn3iMqVzIwmhxgdt+qCTxCR/
	fRXioVVk+ZQFbzktVuJUsejJNr691xWv6OKZuWeGHhHt9MyJX9B67YxkZXnp3J4=
X-Gm-Gg: ASbGnct6vGmRCvLrvW0FzwA7LlakPvqdj5Q/DGpJX9Fjeh+y6xmi3saB6Gzv963r9gs
	q3wQpi7sJTkR7D2kjl6Si6bCVmUoSKu2XsO5zcntpGIBJRPQaNx3Wb6P/IttBbsHTi1Ve8ZhjZX
	00wKAoQ8BS+H61aq/LlfT1lNDZLTW4PKYoDPmY5x7134Vr+zYxxJBufDp9mITh4KnrfcbmErgIN
	s3Cu6Sy/DCphIhTFUz2OAp082o3h3STBENePt/TG989e5dTqCFNHtl9IqJpt5OgsuxNRmaUjlAh
	BaIKdSkU1hibxrwRa/twwyC7fwDS6d4yyO2kmlnUzDnHMIC9M7mPeZcc
X-Google-Smtp-Source: AGHT+IGbzMoBUcU/wDNhF8zFHmw9a+LbIFtR+G86aGKWDMm9zz/rR2pps/AKce1FPj1hH1c38HK5UQ==
X-Received: by 2002:a17:903:28d:b0:21f:14e8:e87 with SMTP id d9443c01a7336-21f17e0c237mr12002795ad.26.1738715825498;
        Tue, 04 Feb 2025 16:37:05 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-acec04796d6sm10685771a12.55.2025.02.04.16.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 16:37:05 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfTPY-0000000EjIc-1u4f;
	Wed, 05 Feb 2025 11:37:00 +1100
Date: Wed, 5 Feb 2025 11:37:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/34] check: run tests in a private pid/mount namespace
Message-ID: <Z6KyrG6jatCgmUiD@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406337.546134.5825194290554919668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406337.546134.5825194290554919668.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:26:13PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> As mentioned in the previous patch, trying to isolate processes from
> separate test instances through the use of distinct Unix process
> sessions is annoying due to the many complications with signal handling.
> 
> Instead, we could just use nsexec to run the test program with a private
> pid namespace so that each test instance can only see its own processes;
> and private mount namespace so that tests writing to /tmp cannot clobber
> other tests or the stuff running on the main system.
> 
> However, it's not guaranteed that a particular kernel has pid and mount
> namespaces enabled.  Mount (2.4.19) and pid (2.6.24) namespaces have
> been around for a long time, but there's no hard requirement for the
> latter to be enabled in the kernel.  Therefore, this bugfix slips
> namespace support in alongside the session id thing.
> 
> Declaring CONFIG_PID_NS=n a deprecated configuration and removing
> support should be a separate conversation, not something that I have to
> do in a bug fix to get mainline QA back up.
> 
> Cc: <fstests@vger.kernel.org> # v2024.12.08
> Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  check               |   34 +++++++++++++++++++++++-----------
>  common/rc           |   12 ++++++++++--
>  src/nsexec.c        |   18 +++++++++++++++---
>  tests/generic/504   |   15 +++++++++++++--
>  tools/run_seq_pidns |   28 ++++++++++++++++++++++++++++
>  5 files changed, 89 insertions(+), 18 deletions(-)
>  create mode 100755 tools/run_seq_pidns

Same question as for session ids - is this all really necessary (or
desired) if check-parallel executes check in it's own private PID
namespace?

If so, then the code is fine apart from the same nit about
tools/run_seq_pidns - call it run_pidns because this helper will
also be used by check-parallel to run check in it's own private
mount and PID namespaces...

> diff --git a/tests/generic/504 b/tests/generic/504
> index 271c040e7b842a..96f18a0bbc7ba2 100755
> --- a/tests/generic/504
> +++ b/tests/generic/504
> @@ -18,7 +18,7 @@ _cleanup()
>  {
>  	exec {test_fd}<&-
>  	cd /
> -	rm -f $tmp.*
> +	rm -r -f $tmp.*
>  }
>  
>  # Import common functions.
> @@ -35,13 +35,24 @@ echo inode $tf_inode >> $seqres.full
>  
>  # Create new fd by exec
>  exec {test_fd}> $testfile
> -# flock locks the fd then exits, we should see the lock info even the owner is dead
> +# flock locks the fd then exits, we should see the lock info even the owner is
> +# dead.  If we're using pid namespace isolation we have to move /proc so that
> +# we can access the /proc/locks from the init_pid_ns.
> +if [ "$FSTESTS_ISOL" = "privatens" ]; then
> +	move_proc="$tmp.procdir"
> +	mkdir -p "$move_proc"
> +	mount --move /proc "$move_proc"
> +fi
>  flock -x $test_fd
>  cat /proc/locks >> $seqres.full
>  
>  # Checking
>  grep -q ":$tf_inode " /proc/locks || echo "lock info not found"
>  
> +if [ -n "$move_proc" ]; then
> +	mount --move "$move_proc" /proc
> +fi
> +
>  # success, all done
>  status=0
>  echo "Silence is golden"

Urk. That explains the failure I've noticed but not had time to
debug from check-parallel when using a private pidns. Do you know
why /proc/locks in the overlaid mount does not show the locks taken
from within that namespace? Is that a bug in the namespace/lock
code?

Regardless, the code looks ok so with the helper renamed:

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
