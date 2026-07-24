Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A903AF65C;
	Fri, 24 Jul 2026 12:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897729; cv=none; b=kdUOaghgA3JwDg7xhFLG11adFR1GCCIQHBFCgkOhrBfaK+CP5ONRf2hRo5Qn7kVU/xhO/GvYls6igYQBaWV6xL8MjhH4GC63NDr2DhGSwUbR5e9qHdQlZwlY1d+FREbAn/Dzjq83Q5mcw8BCkahItK/SoBsNttK06b2wsD2ZbFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897729; c=relaxed/simple;
	bh=Atso6eTFVlXuQzKWroX2tKvyn9UH/Jw9He7IIkfzQy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bNrSoX2wKojRLy5u6oVBu0XRqkm9XwKWxFhkwy5JeON3hGZ01uC/gSCLmxjvena4XnyCbftvR6m/3pBiWR1uk+FQHJ4MvQmLbyuM4IacCAtGWAvj3VWYTsMH0t9kiGt5mM0PLH5qbK7zqj8525kkasdwoHb/jGTkkIw15b0dm+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hcpa2Bww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hcpa2Bww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5559E1F000E9;
	Fri, 24 Jul 2026 12:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784897727;
	bh=e1sJFLnJvAPzoO9Ku3fhd3gRDnpbUCGV+lyqPJopFvM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hcpa2BwwptFMpmIhlZl9WNK0cOK4CnZd8PoIeto/G4BSAOmL/62lF0h4ojbRrGuE7
	 G5Zuh/JINm/igjZlx//3O0R/T5SyKstInokwCmpezlg/hOrWErZuPcvvkpQM+wLZim
	 3KX9YPvlTNjPZy2kb3/iV6n4/ukwoOZYJFNWML5HZurAdyMPJNGbOuApVSFqLsR0KB
	 3+hkxMDfU4Y5VBOPCHABwM4QAIIFEVXgcjX2VfUnOT1E/V77CE/5Y7dT3zsUxiG+7K
	 pMTEbJI7bDzTTX+BuzSoY1peRqc+u3hSbRrs5wLNCA8DNNTLLadFPTPnuMnBtv6Zfc
	 zVq5o84kwHjpw==
Date: Fri, 24 Jul 2026 14:55:22 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-fsdevel@vger.kernel.org, jack@suze.cz, djwong@kernel.org, 
	hch@lst.de, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] xfs: replace ns_capable_noaudit()
Message-ID: <amNgjPELg6a3MBSs@andromeda.toxiclabs.cc>
References: <20260626114533.102138-1-cem@kernel.org>
 <20260626114533.102138-4-cem@kernel.org>
 <amIXSTSc47vQUOgk@mail.hallyn.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amIXSTSc47vQUOgk@mail.hallyn.com>

On Thu, Jul 23, 2026 at 08:29:45AM -0500, Serge E. Hallyn wrote:
> On Fri, Jun 26, 2026 at 01:45:22PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > We don't need to use ns_capable_noaudit() as all we care is the initial
> > user namespace, use capable_noaudit() instead.
> 
> Looks like some of your other xfs fixes conflict with this.  Do
> you mind sending out a new set, and I'll pull them into the caps-next
> branch?

I will Serge, thanks. I was hoping to send a new series this week but I
couldn't, and I'm out next week, so I'll come back to this in a couple
weeks.

Thanks for the heads up!

Carlos

> 
> thanks,
> -serge
> 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/xfs_trans_dquot.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> > index 50e5b323f7f1..30c2f6ec0aac 100644
> > --- a/fs/xfs/xfs_trans_dquot.c
> > +++ b/fs/xfs/xfs_trans_dquot.c
> > @@ -835,7 +835,7 @@ xfs_trans_dqresv(
> >  	if ((flags & XFS_QMOPT_FORCE_RES) == 0 &&
> >  	    dqp->q_id &&
> >  	    xfs_dquot_is_enforced(dqp) &&
> > -	    !ns_capable_noaudit(&init_user_ns, CAP_SYS_RESOURCE)) {
> > +	    !capable_noaudit(CAP_SYS_RESOURCE)) {
> >  		int		quota_nl;
> >  		bool		fatal;
> >  
> > -- 
> > 2.54.0
