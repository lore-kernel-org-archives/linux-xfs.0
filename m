Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7053F5BFE
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 09:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780563880; cv=none; b=GlFtpIpu8OpSsbLofIP2f8UeXbHeCUeZxB5sIe5dRfXvDHCtcC5tEb1lk7XoSsbqL2Kz9kuJU5EK1tRlcHoyEd9EYS7qFf/mRvhUYixJ1as2MnNSnDFumFAC0l83Ns9Kqm3z+TVEHSvhCvYH+bmdxokfjxZN/oHZPUJH6AWGCyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780563880; c=relaxed/simple;
	bh=PDUUSU7kmVZUxeHMY1MJ5BVFtGwJ68ein9IpwK/HpUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CfCoY2Xi6Fpvq9utRfEQpRNxQx6KY+ravMzgH8k9CFioGdAT2KZuM//W5nYIadZklNVWteFc19oNW6llZplB0qQ7PX9zzLm8a5F1GjJCyjH4id1BoT3tnADxNPz0AA7z9WzUqeXDL1GSLAkdQzTMOi0WdtZZWhPhT8DduszsGK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OX0cU1VZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qz9GLDgt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OX0cU1VZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qz9GLDgt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780563876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lQs9dI0tAeFPaJ8i1YwQIsal8XYYdyr4lp1F85T2xk=;
	b=OX0cU1VZzlzQXUJiY0B5ejGyseFhdkB4n7aBW/tHtF3vXB6jvkQJ58nYLfVWzAJrHwxSGv
	jl5i5uSfsa7NYGN30V658NXVInBl/ALnwYReJ81SZZigU7zNkTW5sqVsskKpYoT5GQfrkO
	HSm0xNw3D8LRQjrm+UVrrRfE93bd1Vc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-207-vZKHsl4EM6SXq4Y7zCNgXA-1; Thu, 04 Jun 2026 05:04:35 -0400
X-MC-Unique: vZKHsl4EM6SXq4Y7zCNgXA-1
X-Mimecast-MFC-AGG-ID: vZKHsl4EM6SXq4Y7zCNgXA_1780563874
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-45eef10d5ebso240627f8f.0
        for <linux-xfs@vger.kernel.org>; Thu, 04 Jun 2026 02:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1780563874; x=1781168674; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2lQs9dI0tAeFPaJ8i1YwQIsal8XYYdyr4lp1F85T2xk=;
        b=Qz9GLDgtLtISnCfgP/4urs6jsoO4Q4b9/whS91RL5tIMBYkAqf30YvWT9E3QDi7l/Q
         QyOi0ycgRCwywfL8W0BkAKo/dRS1HhC1SUbF8j7uUT7ipAZ+YMKJQtM/k9XumtfIVxbn
         bxGcCjGX2kN205Qmc/HEe7kkdoKweYVdypewv2jJmfeDpLw2vUTFWuAssI9DANnBTZoB
         9jCC4k2pMXQQH+10xJJAGqE27mj931J4fLsC+ZQ91eA+IXFkn6/C8SqemPhFjMHTt2aI
         OaQF5GfZSAqUCgpASg0uiyqRbM19a60sRZ+xKIK266mpRsZcsjBbbpk3liP9wbTyy7hg
         v45g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780563874; x=1781168674;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2lQs9dI0tAeFPaJ8i1YwQIsal8XYYdyr4lp1F85T2xk=;
        b=OSjlcTazsJs6wBtNDCtMSssWKUlbRn5ZQVFhajZWVxngzBQfQabiKvTlqSg0DVRdVS
         d77k9oqxwS8+gbgDlqy5s8o5cmA3YC1C7gaxZN/GSsyTtiLeodBqVB03uTtF7ehxAHoi
         Q4PgKhFDcqP3dPrx8RcVUh+iOI//NDohmwT1HEWgrdg04YMXIHPgCQroC8j67K/CrPEP
         c06EuREgKplhOJhkuVUN6yBMOU1ViYacekvq5FzHWrjCdO3QOezO1xkro1sQdIdOTcTj
         isAm5bmCgMjtjSCaOyKM3Mv1lG5RnCwLJ60vl4+2ArM9dKWhdDecG3e4srfbbgCje3YU
         xxDw==
X-Forwarded-Encrypted: i=1; AFNElJ+yhm5qWeNzzoga9UYsCIpQdYvYM+rcrwCo7l6RQUxD75Wy5T/yAmcirRp9vZejsZhlGBkdcZuSYC0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFd3S/IaaUtmIj2HIN3SIUQSeVb3rifQ27pZcVt1Jp7qhkN9pl
	/ebmbCYS/DD3A406wuxYw5mCm87Tjm92TxEEOBEa+LkSD/+373gJmUjetS2+e9Pnw8r0jMToIQR
	R80AiuPjLXY3sGr4nqEHZ9EehSswqPeif6fdoB61rIVmmtJXPw3fX/lDVNI9N
X-Gm-Gg: Acq92OHjKW035e5jUNk5UFPS0Cl4Z8inT7UntoH2L+DrmpzZMxOaF80GxsKQsF+ijSv
	5CBmFo6IIOQ2dBRvmK1zJt0vhKUJ6islW0LC+ao32W/Ft85Y/CvsW9NlBBMexkTd55CdQjvtBLK
	H5KD6pabEC1tENpQAIZlErdGhv093FnbCsFNv9foN4RVvBRBD9wZ+Eh02WpqqNalkH0GDpRvaPP
	QS+k/UCe3XP5RsYi7AKHr3R4wNGo9fMZQkrEHlleRwCHUGGHfruLrGERKhunawOvShRqraoQGn2
	1KFSdhUHQGLrWB8bbJ0TmBY0XoqIELgvP0Vi4l7KGnhnJTSVLSffpuNkh/LiNbtfts4v1HdnqeR
	LU5LqW652yjQq+c8KK2vn631pRPJy03RpFh+pabsguj9AtXnBjRXyFtGS6UJDlfRu+gU=
X-Received: by 2002:a05:6000:43d4:20b0:460:f36:79b0 with SMTP id ffacd0b85a97d-4602182b90dmr8717140f8f.19.1780563874016;
        Thu, 04 Jun 2026 02:04:34 -0700 (PDT)
X-Received: by 2002:a05:6000:43d4:20b0:460:f36:79b0 with SMTP id ffacd0b85a97d-4602182b90dmr8717074f8f.19.1780563873372;
        Thu, 04 Jun 2026 02:04:33 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcde3sm16539954f8f.1.2026.06.04.02.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 02:04:32 -0700 (PDT)
Date: Thu, 4 Jun 2026 11:04:32 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <aiE_YQc6SGSdWlcE@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260521090705.GA14254@lst.de>
 <gcw7zcg6p4s2egpufwizfig72g6ren7jfmuz5mqskkpb7xepww@e3v35j7bk7dc>
 <ag7uW7KQ5mVyCGEv@nidhogg.toxiclabs.cc>
 <20260522-unbehagen-baumethode-erlesen-811a4065eeac@brauner>
 <20260522120757.GA21041@lst.de>
 <ahVzkf8JoKP-kSC2@nidhogg.toxiclabs.cc>
 <20260528-offiziell-luftleer-misswirtschaft-3503bda2ad70@brauner>
 <fjdfwhwi4aogyiaoijwvw6w4npuu5mbt6ua6fkhwcp5ajlm543@ume2fkxg36cb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fjdfwhwi4aogyiaoijwvw6w4npuu5mbt6ua6fkhwcp5ajlm543@ume2fkxg36cb>

On 2026-05-28 16:50:45, Andrey Albershteyn wrote:
> On 2026-05-28 14:20:08, Christian Brauner wrote:
> > On Tue, May 26, 2026 at 12:19:43PM +0200, Carlos Maiolino wrote:
> > > On Fri, May 22, 2026 at 02:07:57PM +0200, Christoph Hellwig wrote:
> > > > On Fri, May 22, 2026 at 12:03:20PM +0200, Christian Brauner wrote:
> > > > > > I was expecting this to come through xfs tree too if Eric and Christian
> > > > > > agree.
> > > > > 
> > > > > You may take it through the xfs tree if there are no conflicts with
> > > > > vfs-7.2.iomap. If there are I want to add the iomap changes into
> > > > > vfs-7.2.iomap that you can pull in.
> > > > 
> > > > Merging the iomap bits through the iomap branch might make sense, given
> > > > that iomap usually tends to see quite a bit of activity.
> > > > 
> > > 
> > > That sounds good to me. If you want to go ahead and pull in the iomap
> > > bits, do so, and give me a heads up when you do it so I'll pull your
> > > branch locally.
> > 
> > Great, can the series please be resent based on current vfs-7.2.iomap
> > then please? Because the iomap changes in this series don't apply
> > cleanly on vfs-7.2.iomap so we already have merge conflicts...
> > 
> 
> hmm do you mean this branch?
> https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs-7.2.iomap
> 
> patches 07..09 seems to apply cleanly. The only conflict I see is in
> the overlayfs patch 03. This is because [1] (is in -rc5) is missing
> in vfs-7.2.iomap.
> 
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/overlayfs/util.c?h=v7.1-rc5&id=0c8c88b8eb82a2a41bec5f17c076d6312dc40316

Christian, ping

Would be nice to have iomap in vfs, so Carlos can pull and test the
rest

-- 
- Andrey

