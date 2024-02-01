Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0325B2116
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 01:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706750171; cv=none; b=nPcmwEWD0YqIHtCvc8HhTIMvl6RXXrvpJPBJoQy0F7qDxWoEcGGT9592f5qe2lM+SfSFApcBCvECrHPt4nryT/zrIjaNFw/8oOv1jmuiN4Ihg+KgUNKZhazt/34hoRp9o/FzFIbjWgHYD0cX+LhZcCA03H0b0E7vyuROx3w4yGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706750171; c=relaxed/simple;
	bh=pz4e3aGQDjO5g44Yw1PnbFckuk6ZlalxTY3JE6+Bgtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FmPDAfJx39Tex0bBYyuuFaY/jEHSh39iC6XaCnZygEzzDzlmPTKT//aG7BD1Mn2LhynCEFaKJNzTHkzjS4hRE6FklCYwHTFepDZpj/sxtNEqxLB+V64058KWFn9KPMX3kt8zx3Tzwj/J+e+QeV8fkDWJu7P15ivipJucajqWXRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=kN3+Z7QH; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="kN3+Z7QH"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d8ef977f1eso3044925ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 31 Jan 2024 17:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1706750166; x=1707354966; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v0tuUc8c4kzs8xFDizuBddVjVGMjBQVowCFW9wlmfO0=;
        b=kN3+Z7QHEv7SeZ/SQn5sUI8WKRGRGIxb7rSPH7rKccyCcHFq0lccxtN7MXTJcO38WQ
         MWkoBBUblU+dXMEqTpNqB8v14J+BcqEZv9iyJpJydNItINJNCaEZPMrJbKnZ/NAwJ3MD
         9cZ9aG0XZuD8xkoJLqOB53o9eA3Nc3032e1PxDWbnMrK/XFZVIWOXxoaelTp75apmHoZ
         VTDxkVNddHoCxBW9EuL9e13gpO11wdYKuH3MJgBxOGj8jTv0EHVtSuaczgXjrQdQao8N
         jUFF6YUhiKEJ0OJOsC3eruDyhRjfvhLsuxfHbgcrf6HU9v+pLSceYHXPmQVg66lag4/a
         2iWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706750166; x=1707354966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v0tuUc8c4kzs8xFDizuBddVjVGMjBQVowCFW9wlmfO0=;
        b=hL3+O6IDn+mCrUtJ48hnKFfEqEJKI6+r+DfkOIYJi/z/h3n/+YqgUHNdmWpBXYpSHX
         MdgsWjpDHoK5yydrO67EWc5xHH4xfQxCV/T6MEbrulNDWUy80d5mEfT7eaXp0LWvff+g
         8HwQB142prKMB/E8hi5VzdkKA83zLfwhOHUwUntYRwDzs/Usy0QAIqOHlxFVFC/QoJ8T
         Ode3uFQ6k7DMt0oY2ZznMTJfO5Nwwt2IjhNoa6SaMadZrrvNzDDKE7yV/rqSlVNI/p3/
         8q/gEi4XskdSujTaVxovrQKMl7ze1WulaF1wghiJT9yn+5HoIjRiIBXKqmFSmN7CfrWf
         DaoA==
X-Gm-Message-State: AOJu0YxD2a0LQyfmeyrDANWvKR34LhW6jYjj8QlGjf5x6dn6/1VlzZfV
	flAhnmkWGJf250qddYCgIHntRqeYskDvf80m/05yAdNsX254S9Hjqd4e+IYXRL4EMq3/5vw14nv
	U
X-Google-Smtp-Source: AGHT+IGnHKIOIkUwxuzh/e9YqI94IyCQgQNRa8Vo11AjLJC4/NY1IQC558GVRJFVfqCAv+1nle+lRQ==
X-Received: by 2002:a17:902:da8f:b0:1d5:8cbb:a9d0 with SMTP id j15-20020a170902da8f00b001d58cbba9d0mr4002920plx.25.1706750166093;
        Wed, 31 Jan 2024 17:16:06 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id p12-20020a170902eacc00b001d72f6ba383sm5683346pld.224.2024.01.31.17.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 17:16:05 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rVLgR-000Ocm-0A;
	Thu, 01 Feb 2024 12:16:03 +1100
Date: Thu, 1 Feb 2024 12:16:03 +1100
From: Dave Chinner <david@fromorbit.com>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <Zbrw07Co5vhrDUfd@dread.disaster.area>
References: <20240119193645.354214-1-bfoster@redhat.com>
 <Za3fwLKtjC+B8aZa@dread.disaster.area>
 <ZbJYP63PgykS1CwU@bfoster>
 <ZbLyxHSkE5eCCRRZ@dread.disaster.area>
 <Zbe9+EY5bLjhPPJn@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zbe9+EY5bLjhPPJn@bfoster>

On Mon, Jan 29, 2024 at 10:02:16AM -0500, Brian Foster wrote:
> On Fri, Jan 26, 2024 at 10:46:12AM +1100, Dave Chinner wrote:
> > On Thu, Jan 25, 2024 at 07:46:55AM -0500, Brian Foster wrote:
> > > On Mon, Jan 22, 2024 at 02:23:44PM +1100, Dave Chinner wrote:
> > > > On Fri, Jan 19, 2024 at 02:36:45PM -0500, Brian Foster wrote:
> > > > > We've had reports on distro (pre-deferred inactivation) kernels that
> > > > > inode reclaim (i.e. via drop_caches) can deadlock on the s_umount
> > > > > lock when invoked on a frozen XFS fs. This occurs because
> > > > > drop_caches acquires the lock and then blocks in xfs_inactive() on
> > > > > transaction alloc for an inode that requires an eofb trim. unfreeze
> > > > > then blocks on the same lock and the fs is deadlocked.
> > > > 
> > > > Yup, but why do we need to address that in upstream kernels?
> > > > 
> > > > > With deferred inactivation, the deadlock problem is no longer
> > > > > present because ->destroy_inode() no longer blocks whether the fs is
> > > > > frozen or not. There is still unfortunate behavior in that lookups
> > > > > of a pending inactive inode spin loop waiting for the pending
> > > > > inactive state to clear, which won't happen until the fs is
> > > > > unfrozen.
> > > > 
> > > > Largely we took option 1 from the previous discussion:
> > > > 
> > > > | ISTM the currently most viable options we've discussed are:
> > > > | 
> > > > | 1. Leave things as is, accept potential for lookup stalls while frozen
> > > > | and wait and see if this ever really becomes a problem for real users.
> > > > 
> > > > https://lore.kernel.org/linux-xfs/YeVxCXE6hXa1S%2Fic@bfoster/
> > > > 
> > > > And really it hasn't caused any serious problems with the upstream
> > > > and distro kernels that have background inodegc.
> > > > 
> > > 
> > > For quite a long time, neither did introduction of the reclaim s_umount
> > > deadlock.
> > 
> > Yup, and that's *exactly* the problem we should be fixing here
> > because that's the root cause of the deadlock you are trying to
> > mitigate with these freeze-side blockgc flushes.
> > 
> > The deadlock in XFS inactivation is only the messenger - it's
> > a symptom of the problem, and trying to prevent inactivation in that
> > scenario is only addressing one specific symptom. It doesn't
> > address any other potential avenue to the same deadlock in XFS or
> > in any other filesystem that can be frozen.
> 
> We address symptoms all the time. You've suggested several alternatives
> in this thread that also only address symptoms. I see no reason why
> symptoms and the cure must be addressed at the same time.
> 
> > > I can only speak for $employer distros of course, but my understanding
> > > is that the kernels that do have deferred inactivation are still in the
> > > early adoption phase of the typical lifecycle.
> > 
> > Fixing the (shrinker) s_umount vs thaw deadlock is relevant to
> > current upstream kernels because it removes a landmine that any
> > filesystem could step on. It is also a fix that could be backported
> > to all downstream kernels, and in doing so will also solve the
> > issue on the distro you care about....
> > 
> 
> I don't think a novel upstream cross subsystem lock split exercise is
> the most practical option for a stable kernel.

No, but that's not the point.

If you need a custom fix for backporting to older kernels, then the
first patch in the series is the custom fix, then it gets followed
by the changes that fix the remaining upstream issues properly.
Then the last patch in the series removes the custom hack for
backports (if it still exists).

We know how to do this - we've done it many times in the past - and
it's a win-win because everyone gets what they want. i.e. There's a
backportable fix for stable kernels that doesn't burden upstream,
and the upstream issues are addressed in the best possible way and
we don't leave technical debt behind that upstream developers will
still have to address at some point in the future.

> > I started on the VFS changes just before christmas, but I haven't
> > got back to it yet because it wasn't particularly high priority. The
> > patch below introduces the freeze serialisation lock, but doesn't
> > yet reduce the s_umount scope of thaw. Maybe you can pick it up from
> > here?
> > 
> 
> I don't disagree with this idea or as a general direction, but there's
> too much additional risk, complexity and unknown here that I don't think
> this is the best next step. My preference is to improve on problematic
> behaviors with something like the async scan patch, unlink the user
> reported issue(s) from the broader design flaw(s), and then address the
> latter as a follow on effort.

I tire of discussions about how we *might* do something.

"Deeds not words", to quote my high school's motto.

Here's the fixes for the iget vs inactive vs freeze problems in the
upstream kernel:

https://lore.kernel.org/linux-xfs/20240201005217.1011010-1-david@fromorbit.com/T/#t

With that sorted, are there any other issues we know about that
running a blockgc scan during freeze might work around?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
