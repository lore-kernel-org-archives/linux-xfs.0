Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9D63BB5A
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 22:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760654001; cv=none; b=KLXSAyOVKkbE4GCQuCI5DlrwkyVdQEzvGajCY7qaRydOraF8PoqgCbH3VRzo8hhMzr3mt/Wy9kRgG4fA2L1fCUA5yvvlVLNolzvYGHlaWhw6W6BXrYUUFuC+k+2aBRzG8W84GA/D4elkE2C1X+pazLOBtQTtcGtr54j7QiBdVrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760654001; c=relaxed/simple;
	bh=5HeHjJKQT+heuRAfANSmHQCiXgQ0Glwl31BAOVaoUn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pTVwt0EKm4WnT+ybJAGZvY6QT88rimttTcp/9bx5IoJ4ZWaflR2bUiZDPajY6gGWVJUpeT7SBMndX7PBYmLUYeF5A64srbaiFFKYVJJchIiC/0yxvMAcAqOG5RIJM8g7zzqnJOMvVkUl+PUo0plbiBm/TzLDQPFY8nttgwIiGUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ho4QRk8x; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ho4QRk8x"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-27d3540a43fso13545875ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 15:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1760653999; x=1761258799; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cyHszjXwr011mdavyBxcCiQ2SmN5DwUbyqKyrEqEbK8=;
        b=ho4QRk8xqBKzQHLQCzMUjHycKPCCF0aiKDh61soOT3K487PRs0FwWllHtj8lLurwgb
         3Pbou3uJWIB+kqqjrONe/ABPtHzC4u9oyAlZXTY5Pwe+YVkEEP4UmAZVkVn3GETxv63/
         8VX5v6qkNUCFOKagtD0YgoCva7zTOB431RFi/9RQhBDDILaBTabwvPPbr/rguhS27uKJ
         oZ+X8Vnxa7iLAxcAgD1ed/xMnLvMjc99Q/9w56k4gg7TgAf2uMxSmXbse6ZT3aHe9DLS
         9PsoSDsPHA0QoWZOdsnzC8tkPTUQC4U1D112yZR7O75R0nyVRr5rABY9U8iAZfzDDlBE
         cY/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760653999; x=1761258799;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyHszjXwr011mdavyBxcCiQ2SmN5DwUbyqKyrEqEbK8=;
        b=hY1b2gpXJlzOvI0MKDY8aqj7JP/9QYiE2+Cfhe3wf6Ru8yR6mbJ8Ns8dn3Mp1mVv28
         LmTHfg7EC3Hk71eCSRK1rqDGwMNdzHQ+usfIzbkpxyoprB/fT7/cT/JifqEnQhGMseY4
         9q3Kgv+m6aGOMN9N7LwVDUMW3fl1RAZcgIG3IdFwuBFOVRn05jSzeC29dqOgdfEppIwK
         Yp+8WMa+7sISg4k5mtuLIlMlpzNWhKWIerq19MqHwcUqVWmjQ6pSrLD2gZVfOukZpKG5
         jZLoZKZqmgGVHvxD6RSxgnJx+dkCrp4HHtkXoqtr4+h1Xzuq1eIy11uoPYAr05+CmNf2
         7fFg==
X-Forwarded-Encrypted: i=1; AJvYcCV9Bd7jnfN0X/qCz8rKGOUJG5rKbZlpE3CED5XMSQQQPXFUuTnIJswizTX4WriZEE1SVsI7xOk8okA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxmnfX4ys0Sx48hZCsQpfTbF4Mm7C7s5s8Ga0bkrFRWs4dLt8r
	+E/8697b7QA3hp8/m/MtCIBoh4RcU9Xolgre4394RpVPIv+Od3mnGKtDC6g3/tgHZaI=
X-Gm-Gg: ASbGncuGIM4VSSFs4Kv6UuQ2zpiMrtHflf0q2462bTyfcpreeRcDbUhmhJ8mXjcelSP
	h2QNddUbPSed1IGBbAiOICQKLNse3eHyr1wMJDweKTVJyBDsOJ0YjRrTRIFVN6VG80gxfNGg9dR
	OflxfXXnawGjDjmrNiLtYH8C/rBrrq/dpVi7HwWuSLPJs78VJU2fIfmNmNfw3FlubBdcjkV865D
	7KxW5nz+zbYEx9Rn6NT8U0HXQ+Cx9Dk4d1OxuGaaWneajRfJS1fhquijY8Efnl9nzXaSOKKOGfW
	+LITXM9L6b5nQNQJZh/av4+8PpHDcTalJlf3gNx+MhsCKNcLq84vzucgQUoMkumQxH0tRlVx/te
	SPtqEvdGt2thtKImCpOGPX5OkM6Ha6xd+gmSlMfYGnPmq2abSWdrORZeBipGdfe4K5gDxefjg8o
	btIYZ7dg6+ex0fGUFFJnUHgGBtD1bmHIfhx055nf2xVSJKeVJSOJRowPzz03Lb8A==
X-Google-Smtp-Source: AGHT+IHA0ri7OHJpZ/4Fd97oTXQUCyc/5am6RLXoYkFT5WMoFCFwAYWAWovMfIuEjWrsvgSaZLmzvA==
X-Received: by 2002:a17:902:f70b:b0:267:af07:6528 with SMTP id d9443c01a7336-290caf83079mr16312385ad.35.1760653999244;
        Thu, 16 Oct 2025 15:33:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992b060c4esm23661111b3a.14.2025.10.16.15.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 15:33:18 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v9WX5-0000000FmFe-2Hry;
	Fri, 17 Oct 2025 09:33:15 +1100
Date: Fri, 17 Oct 2025 09:33:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>, Zorro Lang <zlang@redhat.com>,
	akpm@linux-foundation.org, linux-mm <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: Regression in generic/749 with 8k fsblock size on 6.18-rc1
Message-ID: <aPFyqwdv1prLXw5I@dread.disaster.area>
References: <20251014175214.GW6188@frogsfrogsfrogs>
 <rymlydtl4fo4k4okciiifsl52vnd7pqs65me6grweotgsxagln@zebgjfr3tuep>
 <20251015175726.GC6188@frogsfrogsfrogs>
 <bknltdsmeiapy37jknsdr2gat277a4ytm5dzj3xrcbjdf3quxm@ej2anj5kqspo>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bknltdsmeiapy37jknsdr2gat277a4ytm5dzj3xrcbjdf3quxm@ej2anj5kqspo>

On Thu, Oct 16, 2025 at 11:22:00AM +0100, Kiryl Shutsemau wrote:
> On Wed, Oct 15, 2025 at 10:57:26AM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 15, 2025 at 04:59:03PM +0100, Kiryl Shutsemau wrote:
> > > On Tue, Oct 14, 2025 at 10:52:14AM -0700, Darrick J. Wong wrote:
> > > > Hi there,
> > > > 
> > > > On 6.18-rc1, generic/749[1] running on XFS with an 8k fsblock size fails
> > > > with the following:
> > > > 
> > > > --- /run/fstests/bin/tests/generic/749.out	2025-07-15 14:45:15.170416031 -0700
> > > > +++ /var/tmp/fstests/generic/749.out.bad	2025-10-13 17:48:53.079872054 -0700
> > > > @@ -1,2 +1,10 @@
> > > >  QA output created by 749
> > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > >  Silence is golden
> > > > 
> > > > This test creates small files of various sizes, maps the EOF block, and
> > > > checks that you can read and write to the mmap'd page up to (but not
> > > > beyond) the next page boundary.
> > > > 
> > > > For 8k fsblock filesystems on x86, the pagecache creates a single 8k
> > > > folio to cache the entire fsblock containing EOF.  If EOF is in the
> > > > first 4096 bytes of that 8k fsblock, then it should be possible to do a
> > > > mmap read/write of the first 4k, but not the second 4k.  Memory accesses
> > > > to the second 4096 bytes should produce a SIGBUS.
> > > 
> > > Does anybody actually relies on this behaviour (beyond xfstests)?
> > 
> > Beats me, but the mmap manpage says:
> ...
> > POSIX 2024 says:
> ...
> > From both I would surmise that it's a reasonable expectation that you
> > can't map basepages beyond EOF and have page faults on those pages
> > succeed.
> 
> <Added folks form the commit that introduced generic/749>
> 
> Modern kernel with large folios blurs the line of what is the page.
> 
> I don't want play spec lawyer. Let's look at real workloads.

Or, more importantly, consider the security-related implications of
the change....

> If there's anything that actually relies on this SIGBUS corner case,
> let's see how we can fix the kernel. But it will cost some CPU cycles.
> 
> If it only broke syntactic test case, I'm inclined to say WONTFIX.
> 
> Any opinions?

Mapping beyond EOF ranges into userspace address spaces is a
potential security risk. If there is ever a zeroing-beyond-EOF bug
related to large folios (history tells us we are *guaranteed* to
screw this up somewhere in future), then allowing mapping all the
way to the end of the large folio could expose a -lot more- stale
kernel data to userspace than just what the tail of a PAGE_SIZE
faulted region would expose.

Hence allowing applications to successfully fault a (unpredictable)
distance far beyond EOF because the page cache used a large folio
spanning EOF seems, to me, to be a very undesirable behaviour to
expose to userspace.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
