Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B111FC7C9;
	Wed,  5 Feb 2025 17:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738777429; cv=none; b=AqVK9CcRit7W3CrIhootOhmTem5JKQvUm9/fveF3e8bl5W+ppFDHfBdA/013CM3Y1GOZc6Jx2lWBhBNnXd7AAYxWZtgVst+3m004sk8Km0qWr1YXTDEzvhH3/szAIa9u81dRY30m2SVGtG4qHl6y/SiG0+eVEcITLZItu682bOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738777429; c=relaxed/simple;
	bh=Xy3SaJny3+YOjdtSmGRIV5qV3Qb2mvQdjsOazHL0edY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1p8VFJMKjhA5u1kfYD2hMPSjsa9MTn0AMV/suPSyEiuoSCuhmlefelBuVi6+2Q1lwAky7uY+/g4kMlWQyEER2cwhNr0URsRtbJhZc+ObqiPP2Wimbvb4d19BpWwDLf22F2V+ot6+SCAM1Cd5MqiI0OQhbmdaKV44quP+HiAmtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vOv1K3kB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vOv1K3kB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE4BC4CED1;
	Wed,  5 Feb 2025 17:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738777428;
	bh=Xy3SaJny3+YOjdtSmGRIV5qV3Qb2mvQdjsOazHL0edY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vOv1K3kBbJ9uRVhfRtYaAZoxWhBsj0EVZFTq6togWYjV7eOn3DK+4oKc07IlpCsv4
	 d1/5q/JQVFRNRH/xQTw9wrZik0QEG5NyF3IAgZfUpNuxuCbqO3js6FI8/mN7rEwZGS
	 X/H/Yp83KKz7mtJ7wRYB5DD49vokUSiiYfJPQE9dm9kxmfzCAoJhgMJZ2qf56jdSfk
	 o5R3QdNwsBNN7dqKppCTUjWN7pIHvaf2PLTkIbYoTSk2Cb3DDNF2mlopdsQEp5RcGE
	 rJhyY8BgCmlT600YJNS7xBEmmALQY9zBijdoCPc1etC+M2mMA59JJnppaNnztNPFgp
	 Bg7aVEomN7C6Q==
Date: Wed, 5 Feb 2025 09:43:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/34] common: fix pkill by running test program in a
 separate session
Message-ID: <20250205174347.GG21799@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406322.546134.11678961837706398324.stgit@frogsfrogsfrogs>
 <Z6KvbgZnaIA1PTmv@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6KvbgZnaIA1PTmv@dread.disaster.area>

On Wed, Feb 05, 2025 at 11:23:10AM +1100, Dave Chinner wrote:
> On Tue, Feb 04, 2025 at 01:25:57PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Run each test program with a separate session id so that we can tell
> > pkill to kill all processes of a given name, but only within our own
> > session id.  This /should/ suffice to run multiple fstests on the same
> > machine without one instance shooting down processes of another
> > instance.
> 
> I thought you were going to drop this because pidns stuff available.
> Also, because it is only check parallel that needs the pidns
> isolation, and I'm not doing that external to check. Hence we can
> just get rid of the 'pkill --parent' requirement because the
> concurrent tests are already being run in isolated PID namespaces...
> 
> Regardless, if ppl still want to both pid session and pidns directly
> into check, the code is fine.

I'll make that clearer in the commit message.

> Just one little nit:
> 
> > diff --git a/tools/run_seq_setsid b/tools/run_seq_setsid
> > new file mode 100755
> > index 00000000000000..5938f80e689255
> > --- /dev/null
> > +++ b/tools/run_seq_setsid
> > @@ -0,0 +1,22 @@
> > +#!/bin/bash
> > +
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> > +#
> > +# Try starting things in a new process session so that test processes have
> > +# something with which to filter only their own subprocesses.
> > +
> > +if [ -n "${FSTESTS_ISOL}" ]; then
> > +	# Allow the test to become a target of the oom killer
> > +	oom_knob="/proc/self/oom_score_adj"
> > +	test -w "${oom_knob}" && echo 250 > "${oom_knob}"
> > +
> > +	exec "$@"
> > +fi
> > +
> > +if [ -z "$1" ] || [ "$1" = "--help" ]; then
> > +	echo "Usage: $0 command [args...]"
> > +	exit 1
> > +fi
> > +
> > +FSTESTS_ISOL=setsid exec setsid "$0" "$@"
> 
> The wrapper should be called 'run_setsid' because what check is
> using it for has nothing to do with what the script actually does.

Done.

> With that change:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thank you!

--D

> -- 
> Dave Chinner
> david@fromorbit.com
> 
