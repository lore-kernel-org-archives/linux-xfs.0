Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726D12ED844
	for <linux-xfs@vger.kernel.org>; Wed, 19 Nov 2025 20:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763583399; cv=none; b=mHEaWv+dJ/l3L49DVcsMoLHOQ0dv2IlIVpTIDqVfJd+oBLb6rnGQHrjKc6DUj3ift9o+lV1l1xX1SfY2Ftqdc0oz5GpMF6MZzGyPehZLHhSksk2ubtvDDm98YWwdEVSLrpxKGAKTBJWLPaM7xfiGTzb6rJcWnUFpYa+BsdajJkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763583399; c=relaxed/simple;
	bh=QksrpYaGBMg4ks34+bzn2p6qiF4oQKkk6zREhcjQhko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYwn/idlNNgc5L1LZgrvFZ7PeYsHOPV+fMLUJRpw/cOFACZc8kce2M42Wmb2WPacIa/NQJmzinSJgDUqDdR857209/IG1w3mlzDq+is9Sl4oMibaOYuHwKIUbYxROMhVeVZa4G1F4dwFAIg8byyrBfO44fH/jO3l/QLSxKAUiYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=CwlDLdSO; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="CwlDLdSO"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7b9a98b751eso109044b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 19 Nov 2025 12:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1763583398; x=1764188198; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dp4JZo+dI0J2859+KK1IS1522ME6raCu/+5sU4TezG0=;
        b=CwlDLdSO7Q55ZOVrAHfjI0AMPrrqCO5nqd33sodOT0FHMwrJLUP2T3QvI0vYVA6Unq
         LaXSC0duwCv8KfwCLhYn/do6W3TtB6oCEgkC+EV0cpCoxf3FYeNTOf+BlTekARNSQZsv
         1lcB7WALwoqADjlzantixiFCInkMFD4oCXgmEQ81VjM3WX8rsjsyci9xYkxXN1bD/eaS
         E+ow++hXPfaufYv0GzO1kLAkG42JgAkaUHpvdtYnncPc02AtuYhS5OzDOdbFL58+ER/D
         Q0NKfq6Y+wGShNFhb6iuiJu6Sfz1H2gwLWOHV4XtOhlo+EKIF774Rib1PeAZw9Cy6Pu/
         EjSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763583398; x=1764188198;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dp4JZo+dI0J2859+KK1IS1522ME6raCu/+5sU4TezG0=;
        b=rfyCIhGt4h8bx3CMErxsl2lAe5oertxemjn0d3mxDM/NBbRFpFWLA/kDewh8Etru2C
         H4rgsBuu8YriCXGuVcpWfbLJ5M8UrQUgY33E9FkhrCtfnzzBfzU19XjpdCw8/0temdfy
         Zr4sfPdhvXsTIfhqHUDFT0bMMTUYwBseQ83MP8WPVYf18iFH6b7KOfmYsOciKrrpZYt5
         NQLmot8VBS2vflznLn4EQobUPizOIP6dOP/JL36HGBfqrGfQeJlUs/fyaeS5TjguyyGl
         aeFXhSb1FOy3HqpS6LpNqeHjj/x/vJyfxqZZFaxRS63r49RapzBvUgMtkRQp38uiDkFQ
         d4Tw==
X-Forwarded-Encrypted: i=1; AJvYcCXODU3TMnOXDdy5lDOXNLAQWVsWg5OHr2+YH7HG3FNSu+01JYyTcuIWfI0UfalfZZVwTq6j67u/Wkg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQ0CAm4ENy1JblF5cL2cJR5XddS21QuL9qUh8qsKryDaf/FA54
	6bc366tgEBI60xUxYITJS9V0YJumqt9Rjl3ZmlV7HUdlF1NGbEZDp16fut9cmsQgd+w=
X-Gm-Gg: ASbGnctMMQMxlUIa1MGMK6NC23Ey5uXqUBDKFDMBJuz2qDPSoDKMKmch+Wn1OHyDiFD
	7h8pFlTc2H/M+na94SEChIjTJT/5uQ581ph6BIv+dCei3HXwACCAjhBIiKpPaM4DFoyrEUkYEVt
	qskupGPmUci6wlGkLjvRyelhffNhJAhCSCnoio4nKzzq3mVWTdtTbQWKg7Zl1AaLFQEOasFXvpm
	QceKLMuZ1kT5x4YIHonTjw54SxbHZXinRxdUQm1TCeFAzA6FWUGdkUGyfUVEgFEMoO4lRZBiF3L
	wz3ZfgO2mKSHPrFaK22jMnKYxmEoS1QI9CPVsVdCTB+z0sOVndfsEYjX6hqBlu7phWxtOnFinRM
	uhh1cFfbqVnFhDKH7uY+aFPty2lmB0wadSE1sYPpitpuOUvO22drVe6BzD6FQtNICFmU4FLwr3r
	LmTpu3HN5U9GE19+hHcz7QEKLfh/SWxsXaxplyPgkTfaKd+I3ihjgHQ5zwCwrDI5XawMJgbiFl
X-Google-Smtp-Source: AGHT+IFRtwMeHsixmDe3avA54rlITFhQkV+XJJmI491YLjAVrD0oJZeKgatd8Xpel4RieEeNlnyHZA==
X-Received: by 2002:a05:6a20:9187:b0:35e:11ff:45c1 with SMTP id adf61e73a8af0-3613b518491mr821160637.18.1763583397551;
        Wed, 19 Nov 2025 12:16:37 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3ed076eb3sm232098b3a.1.2025.11.19.12.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 12:16:37 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vLobS-0000000D2N1-1UMB;
	Thu, 20 Nov 2025 07:16:34 +1100
Date: Thu, 20 Nov 2025 07:16:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Cc: cem@kernel.org, chandanbabu@kernel.org, djwong@kernel.org,
	bfoster@redhat.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] xfs: validate log record version against superblock
 log version
Message-ID: <aR4lorusQ0L3uT2V@dread.disaster.area>
References: <aRzU0yjBfQ3CjWpp@dread.disaster.area>
 <20251119153721.2765700-2-rpthibeault@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119153721.2765700-2-rpthibeault@gmail.com>

On Wed, Nov 19, 2025 at 10:37:22AM -0500, Raphael Pinsonneault-Thibeault wrote:
> Syzbot creates a fuzzed record where xfs_has_logv2() but the
> xlog_rec_header h_version != XLOG_VERSION_2. This causes a
> KASAN: slab-out-of-bounds read in xlog_do_recovery_pass() ->
> xlog_recover_process() -> xlog_cksum().
> 
> Fix by adding a check to xlog_valid_rec_header() to abort journal
> recovery if the xlog_rec_header h_version does not match the super
> block log version.
> 
> A file system with a version 2 log will only ever set
> XLOG_VERSION_2 in its headers (and v1 will only ever set V_1), so if
> there is any mismatch, either the journal or the superblock has been
> corrupted and therefore we abort processing with a -EFSCORRUPTED error
> immediately.
> 
> Also, refactor the structure of the validity checks for better
> readability. At the default error level (LOW), XFS_IS_CORRUPT() emits
> the condition that failed, the file and line number it is
> located at, then dumps the stack. This gives us everything we need
> to know about the failure if we do a single validity check per
> XFS_IS_CORRUPT().
> 
> Reported-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
> Tested-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
> Fixes: 45cf976008dd ("xfs: fix log recovery buffer allocation for the legacy h_size fixup")
> Signed-off-by: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
> ---
> changelog
> v1 -> v2: 
> - reject the mount for h_size > XLOG_HEADER_CYCLE_SIZE && !XLOG_VERSION_2
> v2 -> v3: 
> - abort journal recovery if the xlog_rec_header h_version does not 
> match the super block log version
> v3 -> v4: 
> - refactor for readability
> 
>  fs/xfs/xfs_log_recover.c | 31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)

Looks good to me now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
