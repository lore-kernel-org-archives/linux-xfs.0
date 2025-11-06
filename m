Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF7627510B
	for <linux-xfs@vger.kernel.org>; Thu,  6 Nov 2025 10:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762423478; cv=none; b=tOVYKVhJkZZxXGhFsYfXqXnGz5cWfMj2MHSPj3A/w3uRGpxo1BWE/sq5AgbWN0mTNGPGjjgUC8D5U99SXNfA8RECFtyCrE/Xe68JzqqoHtpPxsSfZD7WcPrxcHZRJYPLpjD41N1cK4MeQDtDy1J94NSAUqQ5qcIe+y3L+gz3Kto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762423478; c=relaxed/simple;
	bh=vT6p2Ft83AUVQpnKCW7qD9vJskfIVgaA8WibD4YKicI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FoRr5HMvlokD6Z1xDsj/ATv/n0mpGd0fTLGYSpQKPHzdjOvDtCRD/bZZgjYxPFblke1rBtAV55jGxW+EDUz1ybs/1QNjWgT/3sH8P00XpNIjj217YaN5fg7j+SWm2d1SJqmz4x5/f2XBKev1FurCiDMdxzDrD1FOZnT5LjG2alc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EWJw7Utr; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EWJw7Utr"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-429b7ba208eso478744f8f.1
        for <linux-xfs@vger.kernel.org>; Thu, 06 Nov 2025 02:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762423474; x=1763028274; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9pzqQqc6IcRolbDep+B7yNbdFvNbgM81NTbfjuCoPvY=;
        b=EWJw7Utr7kFd1f8ZUvIiWqRkqtKpp52g+YmchQCC4S05k6Cd7cFYbI+ad6Z/wgp0vc
         l3t3z4j+yGbb0fk4sgWWdegtBJxI7obj6qrPaE6kNk8wzESqc6MD/iCcSb/mmGOXArGL
         mhkhgr1QN2TVly2laj9kolEjdnI0pFcssp/wBrHarXmhYgzioJfGI39iU6o3sTh0K5Ca
         qLC4ZWZb4HKr+Vjy5a+nNMWqiCWm9OZxnLVoca1XNJZBF02yK7jlDllo8dxNSvUoOVbQ
         rwmSQewTkbu/RagiSfsR/QUNYV97HrT5pqew0iD3rNbxZ+rLSmGbbTzi/FimbAeDctQw
         y8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762423474; x=1763028274;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9pzqQqc6IcRolbDep+B7yNbdFvNbgM81NTbfjuCoPvY=;
        b=VPigB8Vv8PJuzysXuqJ2s9UZxSBaw70bb3IkMJhs96fCl7fVBqYcj4LgBz/TNMXmk0
         1DuBq4EZGiY+qlwSCuz+XS729X6Y0Z1xc1PHYv/RAu04gN1ySv3sXrNsFTDzRTh/4Nyd
         13f/cYMvmblxrjTxMkFETleMQ3xLjzWoEij7eDWAR7X2bDUz9cKkLgPujnR8UXc/GJS7
         kVyqRVL/OmN6I0VanXWQWI2MyOE3+hCiarJ950y2xG+fy4Bc1XywNNfjOdj3daLPzCaA
         XYafXGaf3SZeukF/JiHAaTqiPCukQc7Rtyx7+micdIUD/Z0iMBAgAoXHf25fO//MR1Gy
         5O7A==
X-Forwarded-Encrypted: i=1; AJvYcCUh6VHpgwcswpQ+g1u0ZSwqNX8/wxBtVbw+Fay4W7dzgfK8YeAjbZCam2yC6itsiKngpadbvl8NFyI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1ZvIBLfFWpxVt3hQ9+hpB4EtwuzG39Mw+5Bv2VxGIIYTzg8LC
	JgY9gRtrsSdoF1e0Ahs/sPGZoBHtJtrKCqGsfodqj/lVLQzOTpXVt9g3MQpZQmkNUPke71m2yrM
	eVduO/5I8vGkG9Agvy00PD1fZGx3w8vUSMFxkqtFg4n0lus4IM74K
X-Gm-Gg: ASbGnctxxaPb6BsInwYABapRIGTx2y9yzjWhYRcnrGiRJjkC5U1/WtriV6lcWbvhziB
	Knp5m9VIWY+x4dvrj0pZg7U8eS0meP+wJJYebP050fpSj+ISs5vay6ro048liy8PztHqqbjOE7x
	n2Tb7jRr2q2gFC3LEUrxvXjLT/wAcr90P3QAjLiErOkJ/xZiUYegl9zyKFwW/CenAvwazGIT/7N
	tKPRSwzCta9TdPa26f4QML+LY2OV182WB7OxbIM0k0uecpqnR2DpM/t0ab8OMkUKXUHDLfP26fY
	bjqYJwd/mE3MKTmN3Ukf8JVhospCmW4vKahCRcG/27jFShOOZ5kguCpYeg==
X-Google-Smtp-Source: AGHT+IF9F1VA3FkhFo+HExPWDHAEgrgxeGGJA7rdOjuOxk6TFCz8t+ouX+7Zbvmcn9f9578SldeY9TT64Kn6ISeqc/8=
X-Received: by 2002:a05:6000:2386:b0:429:d3a7:18bd with SMTP id
 ffacd0b85a97d-429e334019cmr5012608f8f.59.1762423473555; Thu, 06 Nov 2025
 02:04:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104-work-guards-v1-0-5108ac78a171@kernel.org>
 <20251104-work-guards-v1-5-5108ac78a171@kernel.org> <CAPjX3FeEZd7gX1OeCxRXrdBMafHOONB2WQO_JOZuxKoVEygzuQ@mail.gmail.com>
 <5puaizn2a4dpoinvkct2nz5zdvvv5vdrlrmwcz7j6vl7qrxicb@b4qi4yfk4a5u>
In-Reply-To: <5puaizn2a4dpoinvkct2nz5zdvvv5vdrlrmwcz7j6vl7qrxicb@b4qi4yfk4a5u>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 6 Nov 2025 11:04:22 +0100
X-Gm-Features: AWmQ_bl_uakVnhsIAEGayoqj-TUUrVul9249azhsCYCCICpGbdkLg5N_W05IYjE
Message-ID: <CAPjX3FdKdV5ouW3Vjx1jMO8Ye_21x5CDtpOn+BBD_tou1gPkSg@mail.gmail.com>
Subject: Re: [PATCH RFC 5/8] ext4: use super write guard in write_mmp_block()
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 6 Nov 2025 at 10:24, Jan Kara <jack@suse.cz> wrote:
>
> On Wed 05-11-25 19:33:35, Daniel Vacek wrote:
> > On Tue, 4 Nov 2025 at 13:16, Christian Brauner <brauner@kernel.org> wrote:
> > >
> > > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > > ---
> > >  fs/ext4/mmp.c | 8 ++------
> > >  1 file changed, 2 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
> > > index ab1ff51302fb..6f57c181ff77 100644
> > > --- a/fs/ext4/mmp.c
> > > +++ b/fs/ext4/mmp.c
> > > @@ -57,16 +57,12 @@ static int write_mmp_block_thawed(struct super_block *sb,
> > >
> > >  static int write_mmp_block(struct super_block *sb, struct buffer_head *bh)
> > >  {
> > > -       int err;
> > > -
> > >         /*
> > >          * We protect against freezing so that we don't create dirty buffers
> > >          * on frozen filesystem.
> > >          */
> > > -       sb_start_write(sb);
> > > -       err = write_mmp_block_thawed(sb, bh);
> > > -       sb_end_write(sb);
> > > -       return err;
> > > +       scoped_guard(super_write, sb)
> > > +               return write_mmp_block_thawed(sb, bh);
> >
> > Why the scoped_guard here? Should the simple guard(super_write)(sb) be
> > just as fine here?
>
> Not sure about Ted but I prefer scoped_guard() to plain guard() because the
> scoping makes it more visually obvious where the unlocking happens. Of
> course there has to be a balance as the indentation level can go through
> the roof but that's not the case here...

In a general case I completely agree. Though here you can see the end
of the block right on the next line so it looks quite obvious to me
how far the guarded region spans.

But the question is whether to use the guards at all. To me it's a
huge change in reading and understanding the code as more things are
implied and not explicit. Such implied things result in additional
cognitive load. I guess we can handle it eventually. Yet we can fail
from time to time and it is likely we will, at least in the beginning.

Well, my point is this is a new style we're not used to, yet. It just
takes time to adapt. (And usually a few failures to do so.)

--nX

>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
