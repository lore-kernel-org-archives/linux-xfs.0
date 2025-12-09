Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E462E540C
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 22:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765319129; cv=none; b=bFMyxYRymDsYQrOuotWBqvhu57MQZRx560FOVAL/22xZM2i9NBjwIkA07ttfw0TSxiAyNW6jhzUHQRiMR9YJtyA3Xg+zmX81ceLqiQ7r9XU7WPth5jTrhakU6G73HS0kYSSy+w2F632QOJJqg1HAJ4XOSG50x5TEYYAc00xEniY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765319129; c=relaxed/simple;
	bh=QFnHuXxD4HYu3D/GJM45spLxccXvEZxhwmTRv2exHbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ncQ58j84Q7TA7cxOduK//pb8RsXWqHgMX4g0moGI2FKq1M5fi75+C6JFoKP7p8Nr+jO6gF9WTSGslvi+2joDiuBjNJ4JPQopoTv6komDAzL4ixOmTCvJ6e7OAYRjt6fFgUtx4GYaByCAY6x3u9Re8jM0uKmXeVcPCqfvZgxF+bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Wuu4S1mT; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Wuu4S1mT"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-297d4a56f97so77934955ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 09 Dec 2025 14:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1765319127; x=1765923927; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ClZUkbKvWzK2TOu2ajyMleFd5hnpInlMGggKqMUhh30=;
        b=Wuu4S1mTZ0p0+cY08jZX5vJ/Ai67GntgpoAZ6sNW6OxpjdXoYMIJs8pF7/XG5JJqNk
         Uq+fcc3gd7IdplEHhvAXgcQbeCjIR2ctRsYTabNHdfFWvP5Ea2DTyR6XAd3f4YE4yWFQ
         gbAcCKJGY0apjTRbZ3ZVLSICsWMZDIvnaoMjBs2B+3SySiZlKzUvxXfQNRfXBlOtPDZd
         GmpcvJeCEZwv42x1d24O6ChGgagmG4pQbYCZW1gCdeWO0P9NYQqw5S6iZWh4KBRsuGYO
         fsE8tINg6IQzXxu3922bj9DNWKRTYn3iBbxnbV3wkBZwR1p+rfBiQcyqNrvh7Pi/KKF8
         Dk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765319127; x=1765923927;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ClZUkbKvWzK2TOu2ajyMleFd5hnpInlMGggKqMUhh30=;
        b=BlWCto+LGB86VuWT9q3yOHgn9yoM7AsH20iUB9okMPZK3M1DWfqBDy4j1N765SETTQ
         KA2oQaIDK7uMk2LKyRCG6Hqq8O8m78f3TawZqwDQn1B0/AKgj3XsvdIzfZ5FfJv0YpHq
         yGxHLzEpEWyAUfHL7Vi7xwuoQPICzVwCF6iMKLq1ZlJIqFNkJwRWaZnoGmYZlYpfrMpi
         O8Z862Ab7fdEZJodZ7+7nWTCXDFfLPcV2IdccDH0gh3CtriLQWQB2YprENaa0hWKbnFR
         S06idhbD6+xN0t/qavvtPM5sOJlcAsanR/7s04kHl1K4Ct2cpAhLsXpCfu45rbDrP8kp
         fNcA==
X-Forwarded-Encrypted: i=1; AJvYcCVO6zQNdnaSq6q6dbus7cgEJmS6UaGg75yr61g55GlyX4gD4cOccjwpoWcowfsLSXj7ghsjnrro1Gs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOjNrlDcLOtaZUYjCvH0vQuklPkDUXvG5W2aPSxZM9kpcrtbcD
	HdUKnYPxcrbc9KZ2r/75OwGOysA+WrloQI+qH0/7ME52vk3rST/GKU+sgh7zSYH3enr3K7lxH/J
	MTbVi
X-Gm-Gg: AY/fxX6Ka57QmzJnBt2OEcEEeJZ9gL4UCirBgSWZVu7rZjKliwaY6wP0JeCRINWQ1Qr
	MwoAePTFZ0xKj+8+vxFWzXUARyVfo8jZHJArV+sYYvaNaWE72MeguxJv1+ypIlEOGTshgqsxAH5
	HOsy+Me+HyD3Tw5jGPCzaRw8USidZi4GLdXqhFmKXBUTWF7nHY5TyaADwDbwObN5CXoNWUp4y5U
	cEpX2FG+XA/swP+1KwFCNOpqJ2qXS5+w8sHwSKGfUsaAq145uxHZEXbDS2fFVq089hEMICQAXUE
	mF8G7o8yrt/WLmJBycMf6/rLCEH2O2nWvCW1iW3jW+bEG+jCVJXXarw1JZ9btvGw6tIuHsk06ds
	ik4UbJrPWGlfAj461QCmWMJ/Ux4WRcXuiXThBPsdwPJ6ruUjOQPhjnj8zvM1Ixg5EIq6ZycGn69
	VNKQL+3UsCJSXFaWOmmHT5gv4tFUv+K7Z9+iTG9DIka/v28gvYLfX4nujPVFY=
X-Google-Smtp-Source: AGHT+IFjBtnot29WyDAxriNFV/Uwi7UY7TrDOPyWKKOYB5BU3jbo6y/034rF1+vBI87SyIFOSR7u5Q==
X-Received: by 2002:a17:902:da85:b0:298:43f4:cc4b with SMTP id d9443c01a7336-29ec22f1764mr3487715ad.26.1765319127122;
        Tue, 09 Dec 2025 14:25:27 -0800 (PST)
Received: from dread.disaster.area (pa49-195-10-63.pa.nsw.optusnet.com.au. [49.195.10.63])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29daeae6d75sm165910475ad.98.2025.12.09.14.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 14:25:26 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vT696-00000000ryc-0JXS;
	Wed, 10 Dec 2025 09:25:24 +1100
Date: Wed, 10 Dec 2025 09:25:24 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: enable new features by default
Message-ID: <aTih1FDXt8fMrIb4@dread.disaster.area>
References: <176529676119.3974899.4941979844964370861.stgit@frogsfrogsfrogs>
 <176529676146.3974899.6119777261763784206.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176529676146.3974899.6119777261763784206.stgit@frogsfrogsfrogs>

On Tue, Dec 09, 2025 at 08:16:08AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Since the LTS is coming up, enable parent pointers and exchange-range by
> default for all users.  Also fix up an out of date comment.
> 
> I created a really stupid benchmarking script that does:
> 
> #!/bin/bash
> 
> # pptr overhead benchmark
> 
> umount /opt /mnt
> rmmod xfs
> for i in 1 0; do
> 	umount /opt
> 	mkfs.xfs -f /dev/sdb -n parent=$i | grep -i parent=
> 	mount /dev/sdb /opt
> 	mkdir -p /opt/foo
> 	for ((i=0;i<5;i++)); do
> 		time fsstress -n 100000 -p 4 -z -f creat=1 -d /opt/foo -s 1
> 	done
> done

Hmmm. fsstress is an interesting choice here...

> This is the result of creating an enormous number of empty files in a
> single directory:
> 
> # ./dumb.sh
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> real    0m18.807s
> user    0m2.169s
> sys     0m54.013s

> 
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
> real    0m20.654s
> user    0m2.374s
> sys     1m4.441s

Yeah, that's only creating 20,000 files/sec. That's a lot less than
expect a single thread to be able to do - why is the kernel burning
all 4 CPUs on this workload?

i.e. i'd expect a pure create workload to run at about 40,000
files/s with sleeping contention on the i_rwsem, but this is much
slower than I'd expect and contention is on a spinning lock...

Also, parent pointers add about 20% more system time overhead (54s
sys time to 64.4s sys time). Where does this come from? Do you have
kernel profiles? Is it PP overhead, a change in the contention
point, or just worse contention on the same resource?

> As you can see, there's a 10% increase in runtime here.  If I make the
> workload a bit more representative by changing the -f argument to
> include a directory tree workout:
> 
> -f creat=1,mkdir=1,mknod=1,rmdir=1,unlink=1,link=1,rename=1
> 
> 
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
> real    0m12.742s
> user    0m28.074s
> sys     0m10.839s
> 
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> real    0m12.782s
> user    0m28.892s
> sys     0m8.897s

Again, that's way slower than I'd expect a 4p metadata workload to
run through 400k modification ops. i.e. it's running at about 35k
ops/s, and I'd be expecting the baseline to be upwards of 100k
ops/s.

Ah, look at the amount of time spent in userspace - 28-20s vs 9-11s
spent in the kernel filesystem code.

Ok, performance is limited by the usrespace code, not the kernel
code. I would expect a decent fs benchmark to be at most 10%
userspace CPU time, with >90% of the time being spent in the kernel
doing filesystem operations.

IOWs, there is way too much userspace overhead in this worklaod to
draw useful conclusions about the impact of the kernel side changes.

System time went up from 9s to 11s when parent pointers are turned
on - a 20% increase in CPU overhead - but that additional overhead
isn't reflected in the wall time results because the CPU overehad is
dominated by the userspace program, not the kernel code that is
being "measured".

> Almost no difference here.

Ah, no. Again, system time went up by ~20%, even though elapsed time
was unchanged. That implies there is some amount of sleeping
contention occurring between processes doing work, and the
additional CPU overhead of the PP code simply resulted in less sleep
time.

Again, this is not noticable because the workload is dominated by
userspace CPU overhead, not the kernel/filesystem operation
overhead...


> If I then actually write to the regular
> files by adding:
> 
> -f write=1
> 
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
> real    0m16.668s
> user    0m21.709s
> sys     0m15.425s
> 
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> real    0m15.562s
> user    0m21.740s
> sys     0m12.927s
> 
> So that's about a 2% difference.

Same here - system time went up by 25%, even though wall time didn't
change. Also, 15.5s to 16.6s increase in wall time is actually
a 7% difference in runtime, not 2%.

----

Overall, I don't think the benchmarking documented here is
sufficient to justify the conclusion that "parent pointers have
little real world overhead so we can turn them on by default".

I would at least like to see the "will-it-scale" impact on a 64p
machine with a hundred GB of RAM and IO subsystem at least capable
of a million IOPS and a filesystem optimised for max performance
(e.g. highly parallel fsmark based workloads). This will push the
filesystem and CPU usage to their actual limits and directly expose
additional overhead and new contention points in the results.

This is also much more representative of the sorts of high
performance, high end deployments that we expect XFS to be deployed
on, and where performance impact actually matters to users.

i.e. we need to know what the impact of the change is on the high
end as well as low end VM/desktop configs before any conclusion can
be drawn w.r.t. changing the parent pointer default setting....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
