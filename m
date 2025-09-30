Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105CE72617
	for <linux-xfs@vger.kernel.org>; Tue, 30 Sep 2025 09:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759224133; cv=none; b=LbvNrkOKQrT5shDqPhaUacY0Asx/gvuwAb9lmn0DzkUXXLAKJC1WvkVAqsStbNcuqAiGTr8In9POTS++U4FIy8RbHk5dqlt5zpofz3Gq56279fO3fuC6HxT5e02pfP3QzyI8NxN87mlTWD+TmFCUxKVbuQLdioseNFkalulvnrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759224133; c=relaxed/simple;
	bh=XkO986q4nY06iAKa3FHh1GujcQgCTqwXRPZywq/JE0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tJlZUc5CgedA9iCV90zktogKA995e/a5O0fNZNfUyyAwrXzC+Dxa+jTlTch8Skm/SvCgDdMcdX3wWyql/LA9wfQxeq9SVuzyB6TJr3x+kyCbBlft9wg8RXNfPeiNrK17EFkJDxkpahuB2qnnfjdrzxeuAcE4mPLmclzDOxyF0G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=mefYXiys; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="mefYXiys"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b57bffc0248so4455613a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 30 Sep 2025 02:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1759224131; x=1759828931; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yx7o3O6YtvHQ76EF/GABEEoYbGRcXC2q9Agv6V7wx6M=;
        b=mefYXiysxT7khtJfLcCwXW5V6cISCc5g1xmv0KrgKcAy4kq/p3io5EFNSXwKESVL5I
         WjMvF/dEY911LUS5lXT1XKSxgCaBRTH9gNjb8Sv1ALf5xL8nNmrn0z4ZNIwrYVxEFEk1
         DKBUgfIekkJe4Xbe4R8MBPYx/waMfO0IGYyCT6ont+iOwEf/AoSacuPmZte4s7tGAkqO
         PINOhs3LB6jEED+n4ctGkIDJ3FGPv0I3vzUMDZvWtBGQ5NVniuNsarNOvq93VL61n8fu
         hRg+uY5YuSYuAaIxWiPc4FLPxMZrwouNPu0d4llhf8oUI6OSOPrt6Kfjj7za3OIBHhSQ
         RTDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759224131; x=1759828931;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yx7o3O6YtvHQ76EF/GABEEoYbGRcXC2q9Agv6V7wx6M=;
        b=P02kk0yKSybLQypejVw/LVvuGls+4QkQG8cKgMXeId9hDFgmcTwxs3KxEFX/2Qk10s
         m1SfOGiiVQ3pqQdGhSv8zxigquOxfsoi3/9TmeV35pqkX7rxVweM14NYPYWGyEmO/GpW
         qtNEyM1j9bsFEIQarYi2/hP9NmpbMKL2q0EpZGksbtEpQU1phqOOfhnec9tHSHRJBrdr
         kXVaKRLrujqB7T+Njes3UtDU58Ha77aQNJ515ZQdx7/4pT/a7mpSdHqs4bPCZYLBFCqV
         jPHBj6gChzHEszHb8+EW91qyjyJ4vfiy2j6cEPLS8irhiPyhdq8ks5Cw7eh3DPOog4js
         3tyg==
X-Forwarded-Encrypted: i=1; AJvYcCWAEw7zQTgBeIqWyZmZsGAlvTbAPk5rasdZHw7zdDnOZr8G1tGKHY4R0IDx4Y29/ALkRQU9KCidAwY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs2D99oPfxM0z7gtF49+eUBwm96mDOLkmLNfRkKy4veWLU0YOh
	NW4xx2KH2upxN5qgwBuR7hLBPT4o0oUkJfPw+b+r1c9wWunYICKleaG7xJGqgj5arKo=
X-Gm-Gg: ASbGncsJPlfEkJlycRmKuGghaM+aSjH+EXLeaamOIX/inVl9RM4TfJfXxwxR3lf8V8I
	QAWXtMtHvwMgQe17xu6+RbjyCrsDo+IRbXi3ZOA0nU0S9juZpt5N6T9ykzh9T/xCN3IpQs1RNiO
	AK9MAK6Rcx7j5g35yRk5Ct0awAKqkfP7VKuLp9TKdJy//GETVUu/h/8CYncUnXn/tQg43pE0wvw
	Rn83IDfrgJ4+pbH2miCNiftPhIjkn1XXjyQxOAr2HJHBCvSxiwzCAK1tDYVUzVeWCCnrsD8Oi3/
	Jb3JRZ2T9dZNODYCjMJXCLjt1C84K/vHLAvQ92me1MqIzSzV0Bd7Lb7VZZbMjznWR7eAl8v3hFa
	C+Egh1a5/glV7uQWaHKkIiK0ltJCN8dHPENZBIPWdLBYwso8REPSwbJwZ+FJgCLHp5PsVMLRFGh
	WjmxudfLk+mbiMVQLDI6PmG31YKRxRjifvywIYlucPa5M=
X-Google-Smtp-Source: AGHT+IHYPe1VJPTWM+kmiCvuVo8QgcQvLJCumlS0JaZYX6EA4+MrKG2LxK12BUhNWS5XNVCf+EYclg==
X-Received: by 2002:a17:903:2f4e:b0:25d:510:622c with SMTP id d9443c01a7336-28d1718d306mr44060125ad.28.1759224130795;
        Tue, 30 Sep 2025 02:22:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6727ea7sm154559655ad.61.2025.09.30.02.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 02:22:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v3WYh-00000008crZ-1bjd;
	Tue, 30 Sep 2025 19:22:07 +1000
Date: Tue, 30 Sep 2025 19:22:07 +1000
From: Dave Chinner <david@fromorbit.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "hubert ." <hubjin657@outlook.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Message-ID: <aNuhP-zyhfy34AT9@dread.disaster.area>
References: <IA0PR05MB99750EB3605E36DEF8874BACFA31A@IA0PR05MB9975.namprd05.prod.outlook.com>
 <gjogpxo65cozoccj4fps6e4fzeu4ncibeofymhkyzys4hsclzy@vvrl2kndu7k6>
 <IA0PR05MB9975ADAF48C73797473737BEFA38A@IA0PR05MB9975.namprd05.prod.outlook.com>
 <IA0PR05MB99755ED06F9965745B20D9DAFA1EA@IA0PR05MB9975.namprd05.prod.outlook.com>
 <7qd0IjCTUj1UpKLm2g6sPrhFI8HEoYrqIQ23o_ANTShTu58S7x7bgoMYTvXfR_fpqPdB85XxZoz16xrnllDcvA==@protonmail.internalid>
 <aNZfRuIVgIOiP6Qp@dread.disaster.area>
 <ip6g2acleif3cyslm65uzdxd47dgzfum57xxgpmk73r4223poy@shhld7q7ls7i>
 <k2WmSRFVtx7nB1UFDzxjDchWiWXHpB7iqgQdpjse19hi7nXOWfn6A5nKlf9stmEopKn16IAsArviy0SpjDfJ8Q==@protonmail.internalid>
 <aNhx0SD3zOasGhpp@dread.disaster.area>
 <bwfvyxyntorkrcg3fyjey7mbjqgrt4xx772xgkkdj64xifkbbo@ny54t3meeloo>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bwfvyxyntorkrcg3fyjey7mbjqgrt4xx772xgkkdj64xifkbbo@ny54t3meeloo>

On Sun, Sep 28, 2025 at 08:11:05AM +0200, Carlos Maiolino wrote:
> On Sun, Sep 28, 2025 at 09:22:57AM +1000, Dave Chinner wrote:
> > On Fri, Sep 26, 2025 at 03:45:17PM +0200, Carlos Maiolino wrote:
> > > On Fri, Sep 26, 2025 at 07:39:18PM +1000, Dave Chinner wrote:
> > > > So there must be a bounds checking bug in process_exinode():
> > > >
> > > > static int
> > > > process_exinode(
> > > >         struct xfs_dinode       *dip,
> > > >         int                     whichfork)
> > > > {
> > > >         xfs_extnum_t            max_nex = xfs_iext_max_nextents(
> > > >                         xfs_dinode_has_large_extent_counts(dip), whichfork);
> > > >         xfs_extnum_t            nex = xfs_dfork_nextents(dip, whichfork);
> > > >         int                     used = nex * sizeof(struct xfs_bmbt_rec);
> > > >
> > > >         if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
> > > >                 if (metadump.show_warnings)
> > > >                         print_warning("bad number of extents %llu in inode %lld",
> > > >                                 (unsigned long long)nex,
> > > >                                 (long long)metadump.cur_ino);
> > > >                 return 1;
> > > >         }
> > > >
> > > > Can you spot it?
> > > >
> > > > Hint: ((2^28 + 1) * 2^4) - 1 as an int is?
> > >
> > > Perhaps the patch below will suffice?
> > >
> > > diff --git a/db/metadump.c b/db/metadump.c
> > > index 34f2d61700fe..1dd38ab84ade 100644
> > > --- a/db/metadump.c
> > > +++ b/db/metadump.c
> > > @@ -2395,7 +2395,7 @@ process_btinode(
> > >
> > >  static int
> > >  process_exinode(
> > > -	struct xfs_dinode 	*dip,
> > > +	struct xfs_dinode	*dip,
> > >  	int			whichfork)
> > >  {
> > >  	xfs_extnum_t		max_nex = xfs_iext_max_nextents(
> > > @@ -2403,7 +2403,13 @@ process_exinode(
> > >  	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
> > >  	int			used = nex * sizeof(struct xfs_bmbt_rec);
> > >
> > > -	if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
> > > +	/*
> > > +	 * We need to check for overflow of used counter.
> > > +	 * If the inode extent count is corrupted, we risk having a
> > > +	 * big enough number of extents to overflow it.
> > > +	 */
> > > +	if (used < nex || nex > max_nex ||
> > > +	    used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
> > >  		if (metadump.show_warnings)
> > >  			print_warning("bad number of extents %llu in inode %lld",
> > >  				(unsigned long long)nex,
> > >
> > 
> > That fixes this specific problem, but now it will reject valid
> > inodes with valid but large extent counts.
> > 
> > What type does XFS_SB_FEAT_INCOMPAT_NREXT64 require for extent
> > count calculations?  i.e. what's the size of xfs_extnum_t?
> 
> I thought about extending it to 64bit, but honestly thought it was not
> necessary here as I thought the number of extents in an inode before it
> was converted to btree format wouldn't exceed a 32-bit counter.

The filesystem is corrupt so the normal rules of sanity don't apply.
The extent count could be anything, and we can't assume that it fits
in a 32 bit value, nor that any unchecked calculation based on the
value fits in 32 bits.

Mixing integer types like this always leads to bugs. It's bad
practice because everyone who looks at the code has to think about
type conversion rules (which no-one ever remembers or gets right) to
determine if the code is correct or not. Nobody catches stuff
like this during review and the compiler is no help, either.

> That's a
> trivial change for the patch, but still I think the overflow check
> should still be there as even for a 64bit counter we could have enough
> garbage to overflow it. Does it make sense to you?

Yes, we need to check for overflow, but IMO, the best way to do
these checks is to use the same type (and hence unsigned 64 bit
math) throughout. This requires much less metnal gymnastics to
determine that it is obviously correct:

....
	xfs_extnum_t		used = nex * sizeof(struct xfs_bmbt_rec);

	// number of extents clearly bad
	if (nex > max_nex)
		goto warn;

	// catch extent array size overflow
	if (used < nex)
		goto warn;

	// extent array should fit in the inode fork
	if (used > XFS_DFORK_SIZE(dip, mp, whichfork))
		goto warn;

-Dave.
-- 
Dave Chinner
david@fromorbit.com
