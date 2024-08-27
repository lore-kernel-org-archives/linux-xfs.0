Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414F619DF70
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 09:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724751902; cv=none; b=kI3mV8ZeSze30TcKAibomNxTMQigi15YIwnQbIqBeYpbsjsFqs+1v6c0LXopk7D9vn+fk1hyBE98/klxIHmTgbnM/UoNuKizK8EtyCXEAjjhN7pigxtUQDA9Xo9SIhe+dgZ6FOJ6ddscCIypR8bB4FeXy3hKVZwl2HlXx+Irc7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724751902; c=relaxed/simple;
	bh=HR9kEdFGs5k5ryFzh1lLm0d2p/NzdCuiRI8wXS9GJN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bzqWjPmgE+O0L/pbE08BYkywU8t3+1yf70iTA+kzNHV1kiaGQZlXBezlJoXn2FePVvDC5ZoCPna2c3vJ564gOSLtARHULf895whrw4C9PbMtosxIkfIPr0YT7qPjqRUVUmQnlErAJ9Zj3Zi+4emivqCAHm3vpABGOWXI2oH3UVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Qpj+zzUX; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Qpj+zzUX"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2020e83eca1so49385205ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 02:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724751900; x=1725356700; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lxadA1uVmtYpE3iUCEP+EiUHlr4cvtop20T8uo5yqIA=;
        b=Qpj+zzUXJwSWQvJZ9T794g/qc0seSIm+ve8QISc8MAqG72VvFhTmMEtegsraItuXqp
         5K3bA9N5kX7H8QCHHGyo2FpD5lkib1yTCC5f84DLCMGR+NraUHnc1QcvTdNiLuoC18+U
         cb6+jG90b5Nbav2H3fWoljD3qr1k2dYb0GgD9Jd5eJth8OMG2BnNzFF/Y+PdkDjsTuZh
         BcgI1lmpZxOEyV0ytNozEiXs8cJD20U+cZxkkD8Eq8MjqyBlr5uv9fuVWYiNP8YWIK3u
         VUk9MJaDQ2Kn+l5FJQYP54OdsqtwcBLB+TDOFeQQB9r/71PBxrqnlAO9mj90UnJJBJpj
         XyHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724751900; x=1725356700;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lxadA1uVmtYpE3iUCEP+EiUHlr4cvtop20T8uo5yqIA=;
        b=lPfZvNA96Vqun7WQ5XWvRe6JZX4XjQD/jVuHeDhqXb8WUKMdfPfDSpTOt4Whvwj+zu
         xWleAZ6eKISz9uMQPGFW8LW3ZUpEMR3qc+U8YOd+Sx1QSnk7Oceykiii27CtyeAExW8o
         VZm5E//yZcr9JlAs6BDkTC1MGXzot+trzaVVSAP82ywA8a0V0BrNbjLQUuKdWTF778vq
         h248+OKN1ISwihxgqdcun4qZZB/GCSdPWMjoR867Y7bGKk+WuZn7xYL37Y7oj48Iqkyn
         wqpZs5ezpbnfnGBIT4nZBvpf5Oqw4UM2J+I+yn9icbMObBAOA4Scis0PvuWa3ZOIBRE0
         sJog==
X-Forwarded-Encrypted: i=1; AJvYcCWIu+OrRF2wyXNUI1Uc7QANhuO2//7K5mCSGrL/qzYuDZF2jX8JAWn7aiyv4Gehc7qatJmdzNuRRkw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd/8/KcsAFF4GKTWmilVHUVNF3/VP1XkmwUzIq1/n0ua4dEUJG
	hl8/37//jROoxpZw2tEyf6a8FawTyxtJ/lViZzLyYwWbTY0VFxtLEKDh3mp0Y14=
X-Google-Smtp-Source: AGHT+IHLeujOmJdiUuAFdpZPgjURWUIXS9vV9l7gfLpb/d733TiKoGmlA+b6i/uGb9St46C4rNbwtQ==
X-Received: by 2002:a17:902:db0d:b0:201:df0b:2b5d with SMTP id d9443c01a7336-2039e52da6cmr111741335ad.64.1724751900470;
        Tue, 27 Aug 2024 02:45:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20385ae4f62sm79531475ad.256.2024.08.27.02.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 02:45:00 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sisky-00EPKc-1o;
	Tue, 27 Aug 2024 19:44:56 +1000
Date: Tue, 27 Aug 2024 19:44:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Long Li <leo.lilong@huawei.com>, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH 3/5] xfs: add XFS_ITEM_UNSAFE for log item push return
 result
Message-ID: <Zs2gGMRZSlmndZpH@dread.disaster.area>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-4-leo.lilong@huawei.com>
 <20240823171709.GG865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823171709.GG865349@frogsfrogsfrogs>

On Fri, Aug 23, 2024 at 10:17:09AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 23, 2024 at 07:04:37PM +0800, Long Li wrote:
> > After pushing log items, the log item may have been freed, making it
> > unsafe to access in tracepoints. This commit introduces XFS_ITEM_UNSAFE
> > to indicate when an item might be freed during the item push operation.
> > 
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/xfs_stats.h     | 1 +
> >  fs/xfs/xfs_trans.h     | 1 +
> >  fs/xfs/xfs_trans_ail.c | 7 +++++++
> >  3 files changed, 9 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> > index a61fb56ed2e6..9a7a020587cf 100644
> > --- a/fs/xfs/xfs_stats.h
> > +++ b/fs/xfs/xfs_stats.h
> > @@ -86,6 +86,7 @@ struct __xfsstats {
> >  	uint32_t		xs_push_ail_pushbuf;
> >  	uint32_t		xs_push_ail_pinned;
> >  	uint32_t		xs_push_ail_locked;
> > +	uint32_t		xs_push_ail_unsafe;
> >  	uint32_t		xs_push_ail_flushing;
> >  	uint32_t		xs_push_ail_restarts;
> >  	uint32_t		xs_push_ail_flush;
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index f06cc0f41665..fd4f04853fe2 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -117,6 +117,7 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
> >  #define XFS_ITEM_PINNED		1
> >  #define XFS_ITEM_LOCKED		2
> >  #define XFS_ITEM_FLUSHING	3
> > +#define XFS_ITEM_UNSAFE		4
> >  
> >  /*
> >   * This is the structure maintained for every active transaction.
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index 8ede9d099d1f..a5ab1ffb8937 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -561,6 +561,13 @@ xfsaild_push(
> >  
> >  			stuck++;
> >  			break;
> > +		case XFS_ITEM_UNSAFE:
> > +			/*
> > +			 * The item may have been freed, so we can't access the
> > +			 * log item here.
> > +			 */
> > +			XFS_STATS_INC(mp, xs_push_ail_unsafe);
> 
> Aha, so this is in reaction to Dave's comment "So, yeah, these failure
> cases need to return something different to xfsaild_push() so it knows
> that it is unsafe to reference the log item, even for tracing purposes."

I wish I knew when I said that and what I said it about. There's no
pointer to previous versions of this fix in the series description -
it's not even marked as a "v2" patchset.

> What we're trying to communicate through xfsaild_push_item is that we've
> cycled the AIL lock and possibly done something (e.g. deleting the log
> item from the AIL) such that the lip reference might be stale.
> 
> Can we call this XFS_ITEM_STALEREF?  "Unsafe" is vague.

In this case, the returned value tells the aild what the result of
the push was. i.e. the return value is XFS_ITEM_FREED, telling the
aild that the push has freed the item (and so the aild should not
access it again).

-Dave.
-- 
Dave Chinner
david@fromorbit.com
