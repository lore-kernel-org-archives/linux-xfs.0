Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BD93D9DB3;
	Tue,  8 Sep 2026 23:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788908423; cv=none; b=fIJAZ/ZBji2Hmjkf0737gOV7gQykpkP2o15QKjleOENzqf0wjLK8HDdZLZ/TnA0trv0mkAr0xPHkQTYtWYkieoINKxmP1tC6McDE3s4zKmlzJaukFh11y2n278T0E3J4YEJw5juP2lgfgbN/0sFOws7QwSbJBkFbSV7n3ZrnGA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788908423; c=relaxed/simple;
	bh=lwjFeGoCwHwf0RhLsg74GELBxSAXXN7ly37dd0Lng+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cq+R/ekpaYey3n6QtCYVPcCscJxZvuGeyOjiQceDsUVvSI/KR03mtQOZRsUwwvE/gOp6q0oqrfLNvKEJtU6rpDeHdB+HrzdsjSQIUqA6r/ZlhkIgh9ToDPWQMAnhVgufHMmQRjLuDbPI12T6I80dK0/qexrvuQ6FAjtoMjz4o8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SmS/HH9p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SmS/HH9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B671F00A3A;
	Tue,  8 Sep 2026 23:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788908422;
	bh=Nt4uaGZn/6bmzshlKxJ9+ij5yYtfxkJje7wsxu8z5hE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SmS/HH9pqP7PiJDvXP7YQfPcXwbX7xKB2XpPzeMzWK0UyAdCNhp959gDLCKL9tuJC
	 0yNgnpn+CHngo5uEAsvlAnUX5l4SVHBJ90uYVHZr4pZG4HzBq90kEvXOGZ4DukKuUg
	 TvIzYMrqpJ45EKOKbEfwFAnDVdj0wMUhM1KveY9h1KZ/bmmNyUAB4n/28YIX3Cfnim
	 S8lZGiULxGVXiGyQanCsdDIVHtGqO3U0MkO+BmQq69qaCH9K1WsPqlah/Dap8lcsBK
	 cfZZyhmIEMH6pl8FFqD5k/pSosrSLZ/sFs0BafHu1sRUa14fW7UjlEjadDPxLcKz4y
	 OpUyn/zCYp3GA==
Date: Wed, 9 Sep 2026 09:00:13 +1000
From: Dave Chinner <dgc@kernel.org>
To: Hongling Zeng <zhongling0719@126.com>
Cc: Hongling Zeng <zenghongling@kylinos.cn>, cem@kernel.org,
	darrick.wong@oracle.com, chandanrlinux@gmail.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: bound logged region access in inode buffer
 recovery
Message-ID: <aqCTfSqqywJ5qKcY@dread>
References: <20260907080450.314067-1-zenghongling@kylinos.cn>
 <ap8ucHIw-pKLhh9c@dread>
 <6A9F7022.6020206@126.com>
 <ap-sV2Cc5U5fNMmo@dread>
 <6A9FBDB3.20705@126.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6A9FBDB3.20705@126.com>

On Tue, Sep 08, 2026 at 03:48:03PM +0800, Hongling Zeng wrote:
> 在 2026年09月08日 14:33, Dave Chinner 写道:
> > Don't take the design doc as being complete or correct - it's a
> > working document and really only serves as the initial high level
> > plan I fleshed out.
> > 
> > Indeed, I implemented a chunk of it yesterday afternoon (i.e.
> > before I saw your patch this morning) and my findings change quite a
> > bit of the generic infrastructure to make it handle the transaction
> > header without having to special case it. So from that perspective,
> > it's already out of date...
> > 
> > I'll post what I have in the series later this afternoon so you can
> > get up to speed.

Ok, I just posted my current WIP to the log-verification-1 branch in
my kernel.org repo
(https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git)

This is completely untested, I've only made sure it compiles. Don't
expect it to work. If you do start adding to it, build on top of it
and point me to the git repo where all your new work can be found.

What I've implemented so far is the refactoring necessary to
implement generic handling of log item verification and decoding,
converted the special case transhdr decoding to use the generic
infrastructure, and implemented fairly complete ophdr validation,
including validation of the log unmount record (which isn't
validated in any way right now).

Design has changed to use methods for item specific region count
checking, as well as adding a completion method that allows item
types to consume the item rather than queuing it for later recovery
(both needed for the transhdr conversion). Implementation has been
refined to avoid decoding ophdrs until sufficient validation has
been performed to guarantee the buffer pointer is sane and is long
enough to contain a full ophdr, and then it valdates the rest of the
ophdr before passing it to the processing code.

The next steps are to start implementing the per-item type
validation functions.

I also noticed that the head/tail search code that reads log
record headers doesn't really do much validation on the log record
headers. We probably need to address that, too, so we can detect
corrupted headers during the head/tail search and avoid finding
incorrect head/tail records as a result.

> Once your series is posted I'll start with review and the
> recoveryloop / logprint-based testing, then take the per-type
> validate_region() / validate_item() implementations on top of your
> iterator.

I think it's probably better that you first read the code yourself
and develop an understanding of what needs to be done without the
aid of an LLM. See if you can find bugs in what I've already done
-without- an LLM - you will learn the code at the same time, and
then be in a much better place to guide an LLM through later stages
of development.

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
