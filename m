Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B5D1AB7F0
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 21:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707167621; cv=none; b=ew/zoC35lW2fBTlSGSEf98c68pbZUsz1WF5I8xQ+zwAcqvXwkOo3LbOBdNCdq4UAo4lByi8f9AG6BBTpuhJCvUZ4IQe5JTajhC0Uu7aHkjVuPYOrUloR9uodqoeN4bLIswVaEXTu7AwcNXG3XjN19V+04/KMv6R+3abonhe8Rxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707167621; c=relaxed/simple;
	bh=13l6eG+fs48XmRRtchpk51xDVSUtF4X8wLvSauiE73I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UHmYcY4X6RtpJ+dcODzUsnWxpnlHI5qf8dUIQAJjvAsBSpwqyCAppDXwPmP9Kcp3Fl9F5cFa3LD2ePMfxsoS3bLrjcDL4gvTT1aJu+AsC8TPa4PC4rAMFZgSPyT0vxBAx2vI0iSx0ENcxe0sfpE0gcHaoQcNF7I9EUHfxK7aqo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=nCDmhtrx; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="nCDmhtrx"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d93ddd76adso974815ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 13:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1707167619; x=1707772419; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f3r+qq22DmacUgGxPQrXNRVSMoRDx0IAeJG4ATrfk58=;
        b=nCDmhtrxUnDPlV2RQP/6JmMEswN24EfZu5pEZ+XogwlCsU8H93kYIp+UJl+PKCOKnw
         q0Aeyxftd/whaIWtm8Kt3KU6Hn9aSQrdjAb0LBnw4/MDvkK9PmaTEDQnT+UbwUnarlje
         YSq7YBgwa8ZP/2VnqtGz8p9mvf4pwm6zffgIhOtzr975jCrSD2McQ4bj6OrshrDi2tkf
         mBWwQdvmfNphk7DoP6aafUdxZhNE7CZlrWDHXIOkzrQhEyG59+Vpr+ueWmIiusGxzmsV
         oTzRBXRCD33xU+Vlh6xb18yVFQu9zHrR0bFmbbcjg0qNo6rZMN00cVXRUw+RbRRYmrME
         6TIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707167619; x=1707772419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f3r+qq22DmacUgGxPQrXNRVSMoRDx0IAeJG4ATrfk58=;
        b=oQKfKLMl/ojPw/ZH0utGRh5R2ULE9DL8MlEUgZnUyClbLlyACnzZC8pkchIpTrUpTW
         rR76Jdj86Wv0p6NVCF/hWCS9q2RHVC6hgpafNnDcHWEz01Vjf9MO4yvuv0iOItSSKwQY
         olKYHZp+F9FxVef9aa4MFYDt4PCKcIKgO6lnJ0P/k3LWzXKXBI4S0EwgfsdKTtYjz39S
         sPE7Uiwa3Ec5gTlzvVP+NbNpvPPGqC74r7qTcKxKsQg1VoImUKaEsmwpy/PAqKv08cSv
         CfZdpHagXuaTJe76vz3aKf7GiwkcS/FeXYhRjfajfVo1TUf8WTJhrlJhnDgbyxMQQSrx
         s6hw==
X-Gm-Message-State: AOJu0YzJyEbAWWrMCR52URunxFRHCizyionnkDe/g6OwPb3JyFHg2myk
	7noOhjMS68RHmXJgygLcU+NLb8S73Tlf6AbXWZ04d0+DxMYAeTwfGU5JOK2Wu6DlcZPe0Cxc0kw
	f
X-Google-Smtp-Source: AGHT+IHwdDgZKazDGYkqjHh6smTc0yoCcshlEA7o3+fVyXsc/OSLIS/0p4qMD1fGH2HpJ+4aqvtRBQ==
X-Received: by 2002:a17:902:b281:b0:1d6:fcc3:c98f with SMTP id u1-20020a170902b28100b001d6fcc3c98fmr778263plr.29.1707167619331;
        Mon, 05 Feb 2024 13:13:39 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id j6-20020a170902c3c600b001d965cf6a9bsm316564plj.252.2024.02.05.13.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Feb 2024 13:13:38 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rX6HX-002Xqq-1v;
	Tue, 06 Feb 2024 08:13:35 +1100
Date: Tue, 6 Feb 2024 08:13:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: Donald Buczek <buczek@molgen.mpg.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [QUESTION] zig build systems fails on XFS V4 volumes
Message-ID: <ZcFPf8R8geZwBgIV@dread.disaster.area>
References: <1b0bde1a-4bde-493c-9772-ad821b5c20db@molgen.mpg.de>
 <ZcAICW2o5pg7eVlM@dread.disaster.area>
 <39caab25-bf87-4a62-814d-b67f9c81a6e0@molgen.mpg.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39caab25-bf87-4a62-814d-b67f9c81a6e0@molgen.mpg.de>

On Mon, Feb 05, 2024 at 02:12:43PM +0100, Donald Buczek wrote:
> On 2/4/24 22:56, Dave Chinner wrote:
> > On Sat, Feb 03, 2024 at 06:50:31PM +0100, Donald Buczek wrote:
> >> Dear Experts,
> >>
> >> I'm encountering consistent build failures with the Zig
> >> language from source on certain systems, and I'm seeking
> >> insights into the issue.
> >>
> >> Issue Summary:
> >>
> >>     Build fails on XFS volumes with V4 format (crc=0).  Build
> >>     succeeds on XFS volumes with V5 format (crc=1), regardless
> >>     of bigtime value.
> > 
> > mkfs.xfs output for a successful build vs a broken build,
> > please!
> > 
> > Also a description of the hardware and storage stack
> > configuration would be useful.
> > 
> >>
> >> Observations:
> >>
> >>     The failure occurs silently during Zig's native build
> >>     process.
> > 
> > What is the actual failure? What is the symptoms of this "silent
> > failure". Please give output showing how the failure is occurs,
> > how it is detected, etc. From there we can work to identify what
> > to look at next.
> > 
> > Everything remaining in the bug report is pure speculation, but
> > there's no information provided that allows us to do anything
> > other than speculate in return, so I'm just going to ignore it.
> > Document the evidence of the problem so we can understand it -
> > speculation about causes in the absence of evidence is simply
> > not helpful....
> 
> I was actually just hoping that someone could confirm that the
> functionality, as visible from userspace, should be identical,
> apart from timing. Or, that someone might have an idea based on
> experience what could be causing the different behavior. This was
> not intended as a bug report for XFS.

Maybe not, but as a report of "weird unexpected behaviour on XFS"
it could be an XFS issue....

[....]

> There is also a script cmp.sh and its output cmp.log, which
> compares the xfs_ok and xfs_fail directories. It also produces
> traces.cmp.txt which is a (width 200) side by side comparison of
> the strace files.

I think this one contains a smoking gun w.r.t. whatever code is
running. Near the end of the first trace comaprison, there is an
iteration of test/cases via getdents64(). They have different
behaviour, yet the directory structure is the same.

Good:

openat(3, "test/cases", O_RDONLY|O_CLOEXEC|O_DIRECTORY) = 7
lseek(7, 0, SEEK_SET)                   = 0
getdents64(7, 0x7f8d106b69b8 /* 21 entries */, 1024) = 1000
getdents64(7, 0x7f8d106b69b8 /* 21 entries */, 1024) = 1016
getdents64(7, 0x7f8d106b69b8 /* 21 entries */, 1024) = 1000
getdents64(7, 0x7f8d106b69b8 /* 23 entries */, 1024) = 1016
openat(7, "compile_errors", O_RDONLY|O_CLOEXEC|O_DIRECTORY) = 8
getdents64(8, 0x7f8d106b6de0 /* 16 entries */, 1024) = 968
getdents64(8, 0x7f8d106b6de0 /* 17 entries */, 1024) = 1008
getdents64(8, 0x7f8d106b6de0 /* 17 entries */, 1024) = 1016
getdents64(8, 0x7f8d106b6de0 /* 14 entries */, 1024) = 968
openat(8, "async", O_RDONLY|O_CLOEXEC|O_DIRECTORY) = 9
getdents64(9, 0x7f8d106b7208 /* 16 entries */, 1024) = 1000
......


Bad:

openat(3, "test/cases", O_RDONLY|O_CLOEXEC|O_DIRECTORY) = 7
lseek(7, 0, SEEK_SET)                   = 0
getdents64(7, 0x7f2593eb89b8 /* 21 entries */, 1024) = 1000
getdents64(7, 0x7f2593eb89b8 /* 21 entries */, 1024) = 1016
getdents64(7, 0x7f2593eb89b8 /* 21 entries */, 1024) = 1000
getdents64(7, 0x7f2593eb89b8 /* 23 entries */, 1024) = 1016
getdents64(7, 0x7f2593eb89b8 /* 25 entries */, 1024) = 1016
getdents64(7, 0x7f2593eb89b8 /* 20 entries */, 1024) = 1016
getdents64(7, 0x7f2593eb89b8 /* 19 entries */, 1024) = 992
getdents64(7, 0x7f2593eb89b8 /* 22 entries */, 1024) = 1016
getdents64(7, 0x7f2593eb89b8 /* 22 entries */, 1024) = 992
getdents64(7, 0x7f2593eb89b8 /* 17 entries */, 1024) = 760
getdents64(7, 0x7f2593eb89b8 /* 0 entries */, 1024) = 0

In the good case, we see a test/cases being read, and then the first
subdir test/cases/compile_errors being opened and read. And then a
subdir test/cases/compile_errors/async being opened and read.

IOWs, in the good case it's doing a depth first directory traversal.

In the bad case, there's no subdirectories being opened and read.

I see the same difference in other traces that involve directory
traversal.

The reason for this difference seems obvious: there's a distinct
lack of stat() calls in the ftype=0 (bad) case. dirent->d_type in
this situation will be reporting DT_UNKNOWN for all entries except
'.' and '..'. It is the application's responsibility to handle this,
as the only way to determine if a DT_UNKNOWN entry is a directory is
to stat() the pathname and look at the st_mode returned.

The code is clearly not doing this, and so I'm guessing that the zig
people have rolled their own nftw() function and didn't pay
attention to the getdents() man page:

	Currently,  only some filesystems (among them: Btrfs, ext2,
	ext3, and ext4) have full support for returning the file
	type in d_type.  All applications must properly handle a
	return of DT_UNKNOWN.

So, yeah, looks like someone didn't read the getdents man page
completely and it's not a filesystem issue.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
