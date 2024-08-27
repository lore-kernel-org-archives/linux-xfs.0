Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B6215CD4A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 23:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801848; cv=none; b=U8UBlZI7VEOUHXRduZw2KH1B3IXsFMGxYyKUO+tiXO8tyDEBTv/qlx4xp34k06MRTelKt9heZP5LLLtyX3Ob2kIsvUEEOOFaQMIJty29sFx85IRedUmY6tzZzOpWzugrfJEHUdhiILSMnSSPWf4+Ry6KU+rSnGzdTKh7vmfD4Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801848; c=relaxed/simple;
	bh=jG5xkoq0lVzTHUswIg2VGSuJ37xm5da7CFUxf8MDhXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l6ki6mHch6BWp0bB8SEqHZ3xQZ7X6oYe9ifIh2qSF5oKKBjNYNPPeOhRx9Q7ch8IgjNc9vzR1VcKrc/7/n/PvA0oO295O7ML5652tklq5as7RBILEvfKYanIGCsvmdsdFAf2/6OQsvuYdSCgO/4Eyg2KqBebrS+TTX0fzRyAmis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xshZFRed; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xshZFRed"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7cd8d2731d1so4031317a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 16:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724801846; x=1725406646; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2+DLvUCYUqW/4mUMfgPkkePGl5rYEz/UNsr5Vh8It0g=;
        b=xshZFRedtR9jPz39UxarDO3PVHSNrx+BNZfGQjgZOL6itSRL2qTSH+Zok23I3U176i
         VWZaWBbXjqxjWqxMsi67Pm7ubSsriHcBBfmn4rr7zRayBp54+jpY8ICvJEDkkw47fMvq
         brYgAhT0F09WfRWVmEX8i63vvSns7oY1sVyIEWOg3Gp2wCrfnNrvfshB1Lm+8AvCvRoW
         an9OnZ+qkmji/5UqmyrQztWtBpzlM5VhajT7jkhw1agDe56C2HKlKJ5QlRPfOfSZU4Lh
         HINpQg8WEMe1d6pwJCa9NqKj3qII8Xo5REMf1/ws0QlYE9lXKI5kWnP2pAw5igQ2SdsZ
         4+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724801846; x=1725406646;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2+DLvUCYUqW/4mUMfgPkkePGl5rYEz/UNsr5Vh8It0g=;
        b=SZap405mFh4nRFbLyQn6qob6i3EH6WXEB/fpQHUvqmeoGG12j/VbLAvZVa1/Ic+k+j
         Je2Wo2VUL8aGhCMOzNx06JJyfMKXEKzw/lCyie2Ymy/oYRyHtqx6I112JX4Euyil7mU+
         QzTOjn2Q9APs3SqYGcyUV839MN52LKWT8Rn5lMl8HOA12NHKaZcxM3ySpymx71hezZJl
         TLMDLBB7W2XbgPFrNdxpqgrJ5TRgcjJhwTOgPYcMiF2yGHVN7niFfdh7wEB1P3L8rFJS
         BDgEqTwVIntqjIdBDEHrxCIYqQJXNsUBdyZIspdwVtVR1n3hNNExVHCSG7+hPn6L1oPk
         32Mw==
X-Forwarded-Encrypted: i=1; AJvYcCW+vejcja1OUguaaHGP5kcIgMyifUNI5o/U7ZEaQT1WkVSBXSnTULwht4cGPP/DND0i4wqle1UjKfU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn8l9PfURujAH+xSRygTtsVV4Nfhndb4ZNY/QvaHDdFwnb+3DX
	31OVvn2vcTUgQwQ6EKG/WSwYTOpoIrGT1LYGx8dVZgKsXF57Xns/IYW2AiDas8QfvN+a02RkHJ9
	9
X-Google-Smtp-Source: AGHT+IHRvaJNkzwFGujkF9vxnnczLJmpL4cKkTj2RVJ275vr8Kzq+PvtHbNSbHR2YQe3girKTXoXQA==
X-Received: by 2002:a17:90a:a094:b0:2d3:c6a7:5c99 with SMTP id 98e67ed59e1d1-2d646b9d9b4mr15651404a91.8.1724801845547;
        Tue, 27 Aug 2024 16:37:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d84464222asm86351a91.45.2024.08.27.16.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 16:37:25 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sj5kY-00F64r-1X;
	Wed, 28 Aug 2024 09:37:22 +1000
Date: Wed, 28 Aug 2024 09:37:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: liuh <liuhuan01@kylinos.cn>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	cmaiolino@redhat.com
Subject: Re: [PATCH] xfs_db: make sure agblocks is valid to prevent corruption
Message-ID: <Zs5jMo1Vzg9gxA/J@dread.disaster.area>
References: <20240821104412.8539-1-liuhuan01@kylinos.cn>
 <20240823004912.GU6082@frogsfrogsfrogs>
 <Zs1GxsICOpY/SKzn@dread.disaster.area>
 <7e23cd96-e022-2458-0b7c-b0138db02718@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7e23cd96-e022-2458-0b7c-b0138db02718@kylinos.cn>

On Tue, Aug 27, 2024 at 06:24:25PM +0800, liuh wrote:
> 在 2024/8/27 11:23, Dave Chinner 写道:
> > On Thu, Aug 22, 2024 at 05:49:12PM -0700, Darrick J. Wong wrote:
> > > On Wed, Aug 21, 2024 at 06:44:12PM +0800, liuhuan01@kylinos.cn wrote:
> > > > From: liuh <liuhuan01@kylinos.cn>
> > > > 
> > > > Recently, I was testing xfstests. When I run xfs/350 case, it always generate coredump during the process.
> > > > 	xfs_db -c "sb 0" -c "p agblocks" /dev/loop1
> > > > 
> > > > System will generate signal SIGFPE corrupt the process. And the stack as follow:
> > > > corrupt at: (*bpp)->b_pag = xfs_perag_get(btp->bt_mount, xfs_daddr_to_agno(btp->bt_mount, blkno)); in function libxfs_getbuf_flags
> > > > 	#0  libxfs_getbuf_flags
> > > > 	#1  libxfs_getbuf_flags
> > > > 	#2  libxfs_buf_read_map
> > > > 	#3  libxfs_buf_read
> > > > 	#4  libxfs_mount
> > > > 	#5  init
> > > > 	#6  main
> > > > 
> > > > The coredump was caused by the corrupt superblock metadata: (mp)->m_sb.sb_agblocks, it was 0.
> > > > In this case, user cannot run in expert mode also.
> > > > 
> > > > Never check (mp)->m_sb.sb_agblocks before use it cause this issue.
> > > > Make sure (mp)->m_sb.sb_agblocks > 0 before libxfs_mount to prevent corruption and leave a message.
> > > > 
> > > > Signed-off-by: liuh <liuhuan01@kylinos.cn>
> > > > ---
> > > >   db/init.c | 7 +++++++
> > > >   1 file changed, 7 insertions(+)
> > > > 
> > > > diff --git a/db/init.c b/db/init.c
> > > > index cea25ae5..2d3295ba 100644
> > > > --- a/db/init.c
> > > > +++ b/db/init.c
> > > > @@ -129,6 +129,13 @@ init(
> > > >   		}
> > > >   	}
> > > > +	if (unlikely(sbp->sb_agblocks == 0)) {
> > > > +		fprintf(stderr,
> > > > +			_("%s: device %s agblocks unexpected\n"),
> > > > +			progname, x.data.name);
> > > > +		exit(1);
> > > What if we set sb_agblocks to 1 and let the debugger continue?
> > Yeah, I'd prefer that xfs_db will operate on a corrupt filesystem and
> > maybe crash unexpectedly than to refuse to allow any diagnosis of
> > the corrupt filesystem.
> > 
> > xfs_db is a debug and forensic analysis tool. Having it crash
> > because it didn't handle some corruption entirely corectly isn't
> > something that we should be particularly worried about...
> > 
> > -Dave.
> 
> I agree with both of you, xfs_db is just a debugger tool.
> But for the above case, xfs_db can do nothing, even do a simple view on
> primary superblock.
> The user all knowns is that xfs_db goto corrupt, but don't know what's cause
> the problem.
> 
> If set sb_agblocks to 1, xfs_db can going to work to view on primary
> superblock,
> but can't relay on it to view more information.

Yes, a value of "1" will avoid the crash.

However, it is obviously not an ideal choice because a value of 1 is
not a valid value for sb_agblocks.

IOWs, Darricks suggestion really was not to literally use a value of
1, but to substitute a non-zero value that allows xfs_db to largely
function correctly on a filesystem corrupted in this way.

> Maybe left a warning message and set sb_agblocks to 1 and let debugger
> continue is better.

When two senior developers both say "do it this way", it is worth
trying to understand why they made that suggestion, not take the
suggestion as the exact solution to the problem. We've provided
the -framework- for the desired solution, but you still need to do
some work to make it work.

So what is a valid value for sb_agblocks? Is that value more
functional that a value of 1?  If it is more functional, can we
calculate a better approximation of the correct value?

Go an look at all the geometry information we have in
the superblock that we can calculate an approximate AG size from.

	sb_agcount tells us how many AGs there are.
	sb_dblocks tells us the size of the filesystem.
	sb_agblklog tells us the maximum size the AG could possibly be.

Go look for redundant metadata that we can get the exact value of
agblocks from without relying on a specific sb_agblocks value.

	agf->agf_length should always equal sb_agblocks
	agi->agi_length should always equal sb_agblocks

Look at the sb_agblocks verification/bounds checking code to
determine absolute min/max valid values.

	XFS_MIN_AG_BYTES tells us the smallest valid AG size.
	XFS_MIN_AG_BLOCKS tells us the smallest valid AG block count.

So, how would you go about calculating an approximate, if not
exactly correct value for the missing sb_agblocks value?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
