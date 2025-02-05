Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FE01FDE38
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 00:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738714996; cv=none; b=h7HXFd1NgL/qV+8z6EnRtGt55DqzCJ1IywyY1Nqa4D9Tpraga7rfdG5lArPh4x2UMx/IIRQbfdiKj9Jc60rfbxHCFeSTw4F+dYaimnKBnfWRs/YYLd/yLFjl9hyCgUvkdvoHRRx/H7lf31XkvD51HMZZRK/VpfyWp67WGKePm7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738714996; c=relaxed/simple;
	bh=Hd+Bd1DHfhuoAd8jCHrYUICiIaVX7i7Lf+yJMvTB/9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dwe6yfMWUNeVokTYF+1sj4hXGrBl2MPpsgphWJdepOoqrwGAG+GsPTOW9gHnXXTN1qYzuR3Yp5bKRbWJbI6wvZYvDy2T05gns+Tc2S0QfiV4xmsfU7NxeZXrDHqkiFGt8aOAm3WBljPBsIXvCnu9JWY09O+4zhdonPtBXXHJfhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=C//uXJl1; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="C//uXJl1"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2f9c3ec68c7so1901074a91.2
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 16:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738714994; x=1739319794; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z7eaW4TAv42Sk1OFl7oylyqSQ7nTUoHBIO8gZ5Ee1xU=;
        b=C//uXJl1bS6fblSIfz2BjznA+jYDHpTUPvJ3RhcEQfhbcqLRl/75ApL8gMD7U0tW3t
         fyKQa/Qu1KD0uV2Zx7007OwsGcK73zuUYOkFkBqdItZw1xe93Ah6pamUCaaCCAlcVnvE
         hZTbz7JaJ/hm3zdK3314b+l9AMcVo6B6Rp6WkCcczbhd1gregjQDpotXu1iu5pF/Fk37
         vBzuAwoXeptpfa4oSekUIuPBU1DQYM1T+oaZxX9M3hgw1qivNnd/6trIKorcOLQ9Cnn7
         10RxyU8jtKFxfnWXLC5GgTQaSk6HKzTF6oX/ZksXu7ZW5mcxiHbMN8doa+C/NHsPxiqS
         exxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738714994; x=1739319794;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z7eaW4TAv42Sk1OFl7oylyqSQ7nTUoHBIO8gZ5Ee1xU=;
        b=pZkUnNAJWcF0aWiWRjZkqFwJMPQ0kAW6T0CNfwwfBbrb8XdEL+Rh+VE6M3BUR4egan
         BVj/8jjBdnwx+c3BWatN9l34wa1GoMErDujnNXspXxBSj5MoQZ8kQIbiqDGvb10okUuf
         6bStDzPfKwc8edtRQcRkDu7yDnOSRhBQ1lBH43o+/3KOrVQTOzT0oQ+ODZPMz08nRHVy
         /guPxoT0QEN1rhhqz/LXDcjcooLFUsBJ3UI02ei0OzZ+BYm4xq2Ab4ttsUEgLNFFmcid
         N5s/6rvx9bxixvCrEKAPglnVSx0jny/cn7+muX7mN0Lke6hEcluwBYfGsN2VabsXKKkL
         tf2w==
X-Forwarded-Encrypted: i=1; AJvYcCWs8tKD2km8c3vd8063dw/lV7oe3541nxaoF+446bKr6TUk7rk0qjhMVuqMWhhMJjrG6Y1B0jcB8Ow=@vger.kernel.org
X-Gm-Message-State: AOJu0YyS31fCEZ4Q2nLQ2UrV0Kq28vbjqvFqEQ/6/xQMKuHNP3PPWlE2
	ohXe8Gnm5nztyOLfPoSJD9ecSBIDkhYNd4B5qTMwNsZW8WEuMQWSveF8AUNSjWgUTHSQwEo2eD+
	T
X-Gm-Gg: ASbGncstIKFI+dTzKxA6vmvBWvsQFfU21c6o8pBA87buUrbEp7nX0QbTgb4y5mIbHeC
	tAahq6HhcmoqyS/OQMBvpHSbg7c7dBFeZzr36PlBNzDTB08uF1O1YiQCW+qltIfk44EiijES/tK
	TcLlH+wgQ7O5vduNH3TZHd5GTSfUICQ2bml4JhYUYUGgLcAsoWk9LaxLc+k64b0FK1T9cnd43i8
	usYWi01NDs9ceDUhUkQ7Xk00dC7rsTGl0bz5/Yi6U1CzGZEIWkO1IqWkxiDLHzdugCPihkc0NlE
	i4Jqldb+QcZIwvamwKgcEzJHNlTeY31a7Ra21xqPfnGNhImFe+3JrRD1
X-Google-Smtp-Source: AGHT+IHvBVJTxmuWaZgneAt/xe+HWhF7851xGgQjFxlXhGgIpD2vqxTePbcyB3yrBJvlBGaQbi0j9A==
X-Received: by 2002:a17:90b:224e:b0:2ee:a583:e616 with SMTP id 98e67ed59e1d1-2f9e075f3afmr1303238a91.9.1738714993823;
        Tue, 04 Feb 2025 16:23:13 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f9e1d8971dsm164850a91.22.2025.02.04.16.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 16:23:13 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfTCA-0000000EivK-1FiX;
	Wed, 05 Feb 2025 11:23:10 +1100
Date: Wed, 5 Feb 2025 11:23:10 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/34] common: fix pkill by running test program in a
 separate session
Message-ID: <Z6KvbgZnaIA1PTmv@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406322.546134.11678961837706398324.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406322.546134.11678961837706398324.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:25:57PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Run each test program with a separate session id so that we can tell
> pkill to kill all processes of a given name, but only within our own
> session id.  This /should/ suffice to run multiple fstests on the same
> machine without one instance shooting down processes of another
> instance.

I thought you were going to drop this because pidns stuff available.
Also, because it is only check parallel that needs the pidns
isolation, and I'm not doing that external to check. Hence we can
just get rid of the 'pkill --parent' requirement because the
concurrent tests are already being run in isolated PID namespaces...

Regardless, if ppl still want to both pid session and pidns directly
into check, the code is fine.

Just one little nit:

> diff --git a/tools/run_seq_setsid b/tools/run_seq_setsid
> new file mode 100755
> index 00000000000000..5938f80e689255
> --- /dev/null
> +++ b/tools/run_seq_setsid
> @@ -0,0 +1,22 @@
> +#!/bin/bash
> +
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# Try starting things in a new process session so that test processes have
> +# something with which to filter only their own subprocesses.
> +
> +if [ -n "${FSTESTS_ISOL}" ]; then
> +	# Allow the test to become a target of the oom killer
> +	oom_knob="/proc/self/oom_score_adj"
> +	test -w "${oom_knob}" && echo 250 > "${oom_knob}"
> +
> +	exec "$@"
> +fi
> +
> +if [ -z "$1" ] || [ "$1" = "--help" ]; then
> +	echo "Usage: $0 command [args...]"
> +	exit 1
> +fi
> +
> +FSTESTS_ISOL=setsid exec setsid "$0" "$@"

The wrapper should be called 'run_setsid' because what check is
using it for has nothing to do with what the script actually does.

With that change:

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
