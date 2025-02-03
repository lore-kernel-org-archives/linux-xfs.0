Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E59212B02
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 22:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738622368; cv=none; b=s5kEYcgA2s38bDAmJPl+glkq0A+bwSi+jAbojiofV5VafSs7XM9qhhe1eCgN1fIr6OUooyIXNvlLd8udZ42/1aqHJvKl4jlATiVaLa8uq21JVAIVQUWfyK0s/0u3EKaWbHFPKPrUIkKf5DOyG0PSmmnr3w3jWIaANwTF7/0azIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738622368; c=relaxed/simple;
	bh=K1VNqIvXyYYBViLsvU7jTEwkBNtEo6tSllkcYykAnC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LRiil2jJKVWVD9vmHaKJJNRNkU8BOTGkwcfa+y6BochFjB1na+MO3/GnGJYUBLwKfl+A3wyGTGUHNyrnSEpiqeZJq1iegM7qOzbb6nMMRBfGTuO0TYj0hBissdHeJ8vLbFCJI/93GZdDMAi6hqVslwPLxiZW6iZdNUgjCDx56j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=hFlAdqE0; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="hFlAdqE0"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2f78a4ca5deso6342819a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 03 Feb 2025 14:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738622365; x=1739227165; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7KpVGyJ2q1bc5O6QMLcMEUWtGlTAt/NvAxettw3RvKg=;
        b=hFlAdqE0Ps+xBkFt/kwvpqEmDliL7EctUd/lDWrFGs76+zatNRa050WXpvHmGvp/lW
         lzXS+vE3Xrngsrv5Ais3d9tXAHJlivO1592p0Wucl8P5hd4Vu0KuL8Wn50wpwQHWqwij
         pnAQ5892Q6/5uG5MnhlLvAoOYH10UlfQ89VAhVhoZbDOMWpEXZz/cpSJlCfC864pURqH
         e7Z4BlE5pe8TTi8/Zq04avhEDMyTfmTVVayxLYqw7OjXt7PG10Cy8JJFbm2WpNYZnwNq
         Cyhk4kXMTz105AI5BKxMgpUgj5EMOUTOFa7izZgfR0WXQyJ2R5FrnFkicFuOaEjKicZd
         0iIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738622365; x=1739227165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KpVGyJ2q1bc5O6QMLcMEUWtGlTAt/NvAxettw3RvKg=;
        b=GDVT/py9v2T9ahtgtMzk0ZMwRDIYOV+7okCvvogl2Ms+qNS9PRr3TPsA578JoLDJKs
         oU9SlxWxKUJ1HDnCQXhamZHXlXM1c1abWLjhxSehnHVupPr2FdCLonFXdQ5qc04vRjYu
         yC36IrYr8r+wQreGWIjp1XUZ6P6gB08qwD2N+IHrFxwL+vzfrmk1v+OD2arEZRoCYrcK
         98pX3fMp10iXkZilgQsOa5k8LXhRisjMvEpjDqW0vfMgVCunNdaukapkCLvUhvaWGTFW
         fmtmU49S74BHGahpFBeavaPeopCABonR7xW98JcqefE6RmQai1GfmFDboySeDXySSugz
         91Qg==
X-Forwarded-Encrypted: i=1; AJvYcCXM7x4ap5q13lzXnXr9TNMxZt1RpqntTJRvxhhmeLTil1H5NiYcFYFotfBdL65M+qpKH8PyOO/nTdw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaYYZ0PZ4+z0sGv4mXAspTzUG5PGQj7UWRwZycnWaTbAaIXHiK
	+kTtzqSvs92ZfhawqXKd4J3X/gUEqkBzt2OtEk91I9s8MqiJ3UQRYq+pd1VzZWY=
X-Gm-Gg: ASbGncvAQ8C3v8uEdrtnJtMyHRgVFjdehB6hzr1qAgGpCN8ZIJ64ZMaULKOmpkb03+g
	ZU0d24l1mJc1mXaH3MXbC35lC6MrWd3ebry+ZO8OkwGqO5rre1tJdHVt6c2k7K4kQT0WTw7qs/Y
	5VRTAxoJ8zdkOBgPJpXMo6QN4ofACcOKRAWsQXDhbOJlcsQTYkVsJv16Vz+e4xyeEF3VBuAk4Ac
	trnDqBn3zpFIjDV9EkcOm2TpruAOTDiFyYrQnBBcK1WaNG4kZZCKn301MD2oSPa3DEH0qeKlRvh
	tk+bPTpyi9+uOUnOEX8ECxoiOg5Pr9e6FXe3fi6SBVkgpUs7C7wiZupY0wkrpAKWJdI=
X-Google-Smtp-Source: AGHT+IEPTrAiWBg1qg9Pn7U4MfER2lZWbpMPOOLGPLK2BHWop9OkWWimId0qcnZrm79vDgsDbkrIXg==
X-Received: by 2002:a17:90b:524a:b0:2ee:5691:774e with SMTP id 98e67ed59e1d1-2f83ab8baf8mr37128948a91.2.1738622364086;
        Mon, 03 Feb 2025 14:39:24 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de32ebabasm82038825ad.129.2025.02.03.14.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 14:39:23 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tf567-0000000EGx6-3IMd;
	Tue, 04 Feb 2025 09:39:19 +1100
Date: Tue, 4 Feb 2025 09:39:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dchinner@redhat.com, ritesh.list@gmail.com, jack@suse.cz,
	tytso@mit.edu, linux-ext4@vger.kernel.org,
	nirjhar.roy.lists@gmail.com, zlang@kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] xfstests: Centralizing filesystem configs and
 device configs
Message-ID: <Z6FFlxFEPfJT0h_P@dread.disaster.area>
References: <Z55RXUKB5O5l8QjM@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z55RXUKB5O5l8QjM@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>

On Sat, Feb 01, 2025 at 10:23:29PM +0530, Ojaswin Mujoo wrote:
> Greetings,
> 
> This proposal is on behalf of Me, Nirjhar and Ritesh. We would like to submit
> a proposal on centralizing filesystem and device configurations within xfstests
> and maybe a further discussion on some of the open ideas listed by Ted here [3].
> More details are mentioned below.
> 
> ** Background ** 
> There was a discussion last year at LSFMM [1] about creating a central fs-config
> store, that can then be used by anyone for testing different FS
> features/configurations. This can also bring an awareness among other developers
> and testers on what is being actively maintained by FS maintainers. We recently
> posted an RFC [2] for centralizing filesystem configuration which is under
> review. The next step we are considering is to centralize device configurations
> within xfstests itself. In line with this, Ted also suggested a similar idea (in
> point A) [3], where he proposed specifying the device size for the TEST and
> SCRATCH devices to reduce costs (especially when using cloud infrastructure) and
> improve the overall runtime of xfstests.
> 
> Recently Dave introduced a feature [4] to run the xfs and generic tests in
> parallel. This patch creates the TEST and SCRATCH devices at runtime without
> requiring them to be specified in any config file. However, at this stage, the
> automatic device initialization appears to be somewhat limited. We believe that
> centralizing device configuration could help enhance this functionality as well.

Right, the point of check-parallel is to take away the need to
specify devices completely.  I've already added support for the
LOGWRITES_DEV, and I'm in the process of adding LOGDEV and RTDEV
support for both test and scratch devices. At this point, the need
for actual actual device specification in the config files goes
away.

What I am expecting to need is a set of fields that specify the
*size* of the devices so that the hard-coded image file sizes in
the check-parallel script go away.

From there, I intend to have check-parallel iterate config file run
sections itself, rather than have it run them internally to check.
That way check is only ever invoked by check-parallel with all the
devices completely set up.

Hence a typical host independent config file would look like:

TEST_DEV_SIZE=10g
TEST_RTDEV_size=10g
TEST_LOGDEV_SIZE=128m
SCRATCH_DEV_SIZE=20g
SCRATCH_RTDEV_size=20g
SCRATCH_LOGDEV_SIZE=512m
LOGWRITES_DEV_SIZE=2g

[xfs]
FSTYP=xfs
MKFS_OPTIONS="-b size=4k"
TEST_FS_MOUNT_OPTIONS=
MOUNT_OPTIONS=
USE_EXTERNAL=

[xfs-rmapbt]
MKFS_OPTIONS="-b size=4k -m rmapbt=1"

[xfs-noreflink]
MKFS_OPTIONS="-b size=4k -m reflink=0"

[xfs-n64k]
MKFS_OPTIONS="-b size=4k -n size=64k"

[xfs-ext]
MKFS_OPTIONS="-b size=4k"
USE_EXTERNAL=yes

[ext4]
FSTYP="ext4"
MKFS_OPTIONS=
USE_EXTERNAL=

[btrfs]
FSTYP="btrfs"
.....


IOWs, all that is different from system to system is the device size
setup. The actual config sections under test (e.g. [xfs]) never need
to change from host to host, nor environment to environment. i.e.
"xfs-n64k" runs the same config filesystem test on every system,
everywhere...

> ** Proposal ** 
> We would like to propose a discussion at LSFMM on two key features: central

I'm not going to be at LSFMM, so please discuss this on the list via
email as we'd normally do so. LSFMM discussions are exclusionary
whilst, OTOH, the mailing list is inclusive...

> fsconfig and central device-config within xfstests. We can explore how the
> fsconfig feature can be utilized, and by then, we aim to have a PoC for central
> device-config feature, which we think can also be discussed in more detail. At
> this point, we are hoping to get a PoC working with loop devices by default. It
> will be good to hear from other developers, maintainers, and testers about their
> thoughts and suggestions on these two features.

I don't really see a need for a new centralised config setup. With
the above, we can acheived a "zero-config" goal with the existing
config file formats and infrastructure. All that we need to do is
update the default config file in the repo to contain a section for
each of the "standard" test configs we want to define....

> Additionally, we would like to thank Ted for listing several features he uses in
> his custom kvm-xfstests and gce-xfstests [3]. If there is an interest in further
> reducing the burden of maintaining custom test scripts and wrappers around
> xfstests, we can also discuss essential features that could be integrated
> directly into xfstests, whether from Ted's list or suggestions from others.

On of my goals with check-parallel is to completely remove the need
for end users to configure fstests. i.e. all you need to do is point
it at a directory, tell it which filesystem to test, and it "just
runs" with all the defaults that come direct from the fstests
repository...

It is also worth keeping in mind that check-parallel can be run with
a single runner thread, in which case a single check instance runs
all tests serially. i.e. we can make check-parallel emulate existing
check behaviour exactly, except it uses all the
auto-config/auto-setup stuff that comes along with check-parallel...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
