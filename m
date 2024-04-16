Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CD8131BDA
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713284409; cv=none; b=igaElB2OsJQcDNQSzXsJ9UtbJhwHbmzwysJ0p4IWz5OH4zlE2GxYEnOtJ7Nl/Gemix8CUp8UVn4VQWuj3htTvglRVoEu7L1VIo/6NGTSUMs2tFsQ53RbqSD29xaHsz+U2lblOcd/tR4PqNRcYk5vu2WNJkWRv4aVCTe8WS2pNAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713284409; c=relaxed/simple;
	bh=+7XWGpx+Yjo6Bl/vpgE5JAayCBPDXNF5pOIsO8DC5To=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HbW5Nwmuw4DjsZ6oWeJIo4fpTVJdv+804R/lLlUlc/DeUOi78ySBzYbcuHQyEsh6fS19++IcfsxMvo3HLJdJ0eWiI7Y7C4C/nTxkGE5xodl4D0vTgDxflAoDpB4coidcasNx3BeVqJuK0J2846VLSjIixXi+et7NF3DEHtPZ7Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LGh72RTY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LGh72RTY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713284407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YLfkmTjpq8gXWYiZb7OynOyZ38SU52cSj4aNSgz50K8=;
	b=LGh72RTYay1T3d69/cEBn/up3jvnimWZ4dYYk3G+sWacxYAsqZK30ewUa/uRrTxPyqbkrZ
	IXaCKzpqrMApkevqmcg4i7nnv8QmX2xrVx0d24/ukSAaGG8FGpa+ZN4W0+TwpKLwZDsdXW
	0+NynxcTe3y4ppQuFjuruakPU2AEbcI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637--wytwUEbOLOwDog-H_REKg-1; Tue, 16 Apr 2024 12:20:05 -0400
X-MC-Unique: -wytwUEbOLOwDog-H_REKg-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a51b00fc137so361260266b.0
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 09:20:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713284404; x=1713889204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YLfkmTjpq8gXWYiZb7OynOyZ38SU52cSj4aNSgz50K8=;
        b=ra3oMGkADIWrIxqgAyyiviwgQvRlekrNFxyw7RkHZzyKWA1+KcwNvO8Glx3UUHQj4z
         Ut9+V5zAxipvsQxmEomggGIYxF3MEXnKN54vwHNlx+wtPKf9rPQpR7Be1AJSwTtMORRj
         AF1X58iXGOpQDycg+pdBCkVsy2Qf89s/7ZUBz4Len2xNk+vUxBYJ+LWn4cW+Hw6HZbYm
         vjc978NJ69/K6HU1OJrYzSvTN9P6lsZUKAzSHCGTPfvSQwhvZOgj9cwJ/pynsuLO0qLZ
         KyDWE+ig8Y6nHfZKH/jX8SoAMGVCSMpTyxdWZYwe86J1PRcLoUvGccJ8pF3VEflp6WoG
         7AIQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4mLcYRl6zQIu42VQlo21bvU3d47XDFidsWyzeEbFuzO6+vuYT33s9DCpqP7h9He+2HbyuGIJpi4TuMzZT5UcjCbROEuLaxFcW
X-Gm-Message-State: AOJu0YydorffYAsNSrgqZblfKyahIbQwy58Tw+CyyamvnJgEWEiXQMOh
	TxwW3y+GrdQ6hyx0QS5y2Sriif0iMzUAIZX6KI828c5c41uepXouwMIqgS+SX6+vvmm+/B/Iwu7
	jVZToeG0Gd/aX+/AIf9neNSt3Sc+vPyjtkocOwnyfp0A9GzfPu56Qy1JPRDFQzLI8
X-Received: by 2002:a17:907:e91:b0:a4e:57c5:e736 with SMTP id ho17-20020a1709070e9100b00a4e57c5e736mr15270450ejc.25.1713284404134;
        Tue, 16 Apr 2024 09:20:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHooAZV4hoAfSqjK5tOTbmDMWMb1lhi/ku6E3/3/RF2ldj7hbte8o2jf2vj6NSHL7zO+q04bQ==
X-Received: by 2002:a17:907:e91:b0:a4e:57c5:e736 with SMTP id ho17-20020a1709070e9100b00a4e57c5e736mr15270423ejc.25.1713284403506;
        Tue, 16 Apr 2024 09:20:03 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id f19-20020a170906391300b00a4628cacad4sm6999476eje.195.2024.04.16.09.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 09:20:03 -0700 (PDT)
Date: Tue, 16 Apr 2024 18:20:02 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs_repair: make duration take time_t
Message-ID: <7n3vmqw5qjqygt3mvlz6cmtpsnm2wijlgafb7pppbw5tcjzfcg@p6k3govmlniz>
References: <20240416123427.614899-1-aalbersh@redhat.com>
 <20240416123427.614899-3-aalbersh@redhat.com>
 <20240416161230.GK11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416161230.GK11948@frogsfrogsfrogs>

On 2024-04-16 09:12:30, Darrick J. Wong wrote:
> On Tue, Apr 16, 2024 at 02:34:24PM +0200, Andrey Albershteyn wrote:
> > In most of the uses of duration() takes time_t instead of int.
> > Convert the rest to use time_t and make duration() take time_t to
> > not truncate it to int.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  repair/progress.c   | 4 ++--
> >  repair/progress.h   | 2 +-
> >  repair/xfs_repair.c | 2 +-
> >  3 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/repair/progress.c b/repair/progress.c
> > index f6c4d988444e..c2af1387eb14 100644
> > --- a/repair/progress.c
> > +++ b/repair/progress.c
> > @@ -273,7 +273,7 @@ progress_rpt_thread (void *p)
> >  	_("\t- %02d:%02d:%02d: Phase %d: %" PRIu64 "%% done - estimated remaining time %s\n"),
> >  				tmp->tm_hour, tmp->tm_min, tmp->tm_sec,
> >  				current_phase, percent,
> > -				duration((int) ((*msgp->total - sum) * (elapsed)/sum), msgbuf));
> > +				duration((time_t) ((*msgp->total - sum) * (elapsed)/sum), msgbuf));
> 
> I'm not in love with how this expression mixes uint64_t and time_t, but
> I guess it's all the same now that we forced time_t to 64 bits.
> 
> You might remove the pointless parentheses around elapsed.

sure

> 
> >  		}
> >  
> >  		if (pthread_mutex_unlock(&msgp->mutex) != 0) {
> > @@ -420,7 +420,7 @@ timestamp(int end, int phase, char *buf)
> >  }
> >  
> >  char *
> > -duration(int length, char *buf)
> > +duration(time_t length, char *buf)
> >  {
> >  	int sum;
> >  	int weeks;
> > diff --git a/repair/progress.h b/repair/progress.h
> > index 2c1690db1b17..9575df164aa0 100644
> > --- a/repair/progress.h
> > +++ b/repair/progress.h
> > @@ -38,7 +38,7 @@ extern void summary_report(void);
> >  extern int  set_progress_msg(int report, uint64_t total);
> >  extern uint64_t print_final_rpt(void);
> >  extern char *timestamp(int end, int phase, char *buf);
> > -extern char *duration(int val, char *buf);
> > +extern char *duration(time_t val, char *buf);
> >  extern int do_parallel;
> >  
> >  #define	PROG_RPT_INC(a,b) if (ag_stride && prog_rpt_done) (a) += (b)
> > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > index ba9d28330d82..78a7205f0054 100644
> > --- a/repair/xfs_repair.c
> > +++ b/repair/xfs_repair.c
> > @@ -377,7 +377,7 @@ process_args(int argc, char **argv)
> >  			do_prefetch = 0;
> >  			break;
> >  		case 't':
> > -			report_interval = (int)strtol(optarg, NULL, 0);
> > +			report_interval = (time_t)strtol(optarg, NULL, 0);
> 
> report_interval is declared as an int and this patch doesn't change
> that.  <confused>

ops, yeah, missed that. Will change it to report_interval

> 
> --D
> 
> >  			break;
> >  		case 'e':
> >  			report_corrected = true;
> > -- 
> > 2.42.0
> > 
> > 
> 

-- 
- Andrey

