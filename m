Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1973240A932
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jul 2026 13:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783343765; cv=pass; b=Ti++aWg+3BW29+z1wr6rjZz44p8y9L/5GcwDCuT506moqk36gWd09xnAkJZg+IY/+rjWDZnF0l0Bso8JbFE9j22FWSg48L9YB1VtPE/p6jzB7utOupJ6eU9YszNtndFqY8Kr77yspx6F59MeijOn9kJcxz1kX3F/lHHV+PYpq6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783343765; c=relaxed/simple;
	bh=ZG4slmePuA8hAwfYnmF/1n5HJkJeLXV2KFDHoBeiAmc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=STN97/KnIGF31sP/Kv8rkKskDiagg8m5vypuFdcjfHCx+dIx1wNGDprVaCOKQLyaz8K12igZkLDIm2YFkS+XI1lpbJvFJYc+9pgW19Qpk+iSSRboU0eT11TREQICbyO1ln+BNgB3Z525E2UmZQK1ZYP2WgbImahhZk7vhjN0uaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CxSA+Lc1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=f3K6Jtan; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CxSA+Lc1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="f3K6Jtan"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783343763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AxMOA32PrhBgJC1rEErLDcIUQtikuP/rNGrPj73qrKE=;
	b=CxSA+Lc1ttmV6E3ihZHLeSTzE87AL/TAUAhffhYqZBQrOqVfR4kV5aaMb2jC2ihvtEIlRs
	UfKxj9MsrHi9qR+PKUpq7EJNUhuccd4stO+bP792h/ywbYjxEy/AaJO4FJDCoHSovACndl
	+vqldmk868fRcC/z/pctQbtaGJcEXQk=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-0K_-hzBYOMOU2kl1ARNYbw-1; Mon, 06 Jul 2026 09:16:02 -0400
X-MC-Unique: 0K_-hzBYOMOU2kl1ARNYbw-1
X-Mimecast-MFC-AGG-ID: 0K_-hzBYOMOU2kl1ARNYbw_1783343761
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-664e8896822so10201136d50.1
        for <linux-xfs@vger.kernel.org>; Mon, 06 Jul 2026 06:16:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783343761; cv=none;
        d=google.com; s=arc-20260327;
        b=rlllZv58nR3SRNIjs5y+BYna9+591HEb/xzFkkc8ldb2khWo5KzvB0EcFfsrlePKHb
         VjoTKPZOaNczcf7daMEy4tjEFQMEdQQvc6+yRIJ5vhvbtR55F7+Zlh6QdBLLq4cbmYUd
         IxjM7dd6srE3km1x9/6x8UyZIsxwQsJ5K8qJSpcZJ8StPNO07Io8lEArZn4ZP9SuBulB
         HcEVfaSAR6GaVkG80Nc5Trm0o4c7O/ZyjC5cgxPY4uFUGG3YgglcWfiMevEdzW0PC+em
         xvRNZfAjR5irONUSBtywcs92/u72LoUhjDezsUGWbbHyMytvHaq6v8UwXQCgBPBs1HPL
         c1Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AxMOA32PrhBgJC1rEErLDcIUQtikuP/rNGrPj73qrKE=;
        fh=jJJhRCbhojL1ThUoJDTkTK3Xn36F2GI3lyYEyJmqg2w=;
        b=cqyG5+5ea+5KXSV/LfWEggXUkHldK59yjyr1L7tEmQqYh/BM6H+2b66FeIYsNKcn6c
         YPdDd9XfV4Mk2+TLzkT3NlhwWgtbuK+TOw7yb0zOIvgCf2RrxeG72mJMhSSHHed6dMBV
         Ic2MA21q/u2+ZvIDYhw2whhxyUBudWdQNIDZZZPrbnhg/0rrj8KtstqCGSkT8UFC4Ua/
         e7JrUvzAiTX/kuoQG79PjnWGRc1Wb8tRHIyjQPjAzCwk2VWTIz3yA5ksRdUm2V7wMaU+
         XIOgHi7V0TBq4kAZN87CNoK6axoc9U+mM0xnvZj5gX23ZjxcOWmvHBZqdOrd3E1pWUMY
         x1hw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783343761; x=1783948561; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AxMOA32PrhBgJC1rEErLDcIUQtikuP/rNGrPj73qrKE=;
        b=f3K6JtanNgJILT3uUd5Ns5F6a/HpxST2yALn4yZ8Lix/FKn1ujbu9sGfoS423cym3T
         +Bf9peWZMif98A5vl49Q91m0qXy1i8MngpA0+aPMEOf2OdPKi4QbndK4ti+C19ofqzUY
         uNlGCgIXgt3QEV+YxZsSLtiCR3wXKPe/Alo6rChn+7aKleuqGdVnpjj6l2slNeg6ClPo
         kA0rqNfWcaYQdfJ/u63uFsy3/q1RW3nuPtQT3oM3nT1eafHIgxgF4HOQ5tazb7Qc+gQN
         jH9HrvnXA2rWfginu9fNo+kLd/0OqCchRd8nPSfx5MEJDalpSkaVoLw0kstiXDhhh7XF
         4RTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783343761; x=1783948561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AxMOA32PrhBgJC1rEErLDcIUQtikuP/rNGrPj73qrKE=;
        b=RaVfRtxJA1lUW/j2PtdjtVCwiy+UAOTtm/9uf1buBccs4PvjLVxWnb/67xuXie5G8v
         RUYwfXjAyBiSY4s1w8Hg6WdMDZWnTudEDOj46sWbEOOiaLtY7/Rl9Va676L+vkhPIGWq
         WoYHGdpIPEa2Y+eA6UJteTilwrnlTTMf5+C3zJuqaZQft4ZORXkeeU0k+iBGbz2Kwaa5
         rFGodft177uFptbUTSmbmxKP2BdacqlCdHgv64B5zqQYPejjf5JNkiWCz6P6bHx2zCjs
         buzsQEG1uFnuVZi/mo8h5Oi41kyvH1L9uBloYYymNheL9Whleifa4tkZVuEcff0VcUGU
         F7Kg==
X-Forwarded-Encrypted: i=1; AHgh+RqGYd57i2ii1lY6Zim8jKcjYDgOUyT2lhDHtCWBpglAEMGrQ3R/WAczm3Cq84rGnAVuLWybXsnyyhQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUJawiq2cVuVlUUYaauOFCSziqrTg+cyXpDyeyteBq2RtCA1hR
	2W2R775hXS9mgaHM9/8Th8v7DXPlBNhFV17PPmvj7sjPfdWKN2saQm0PGf1J1Kdylb6tNS+HAyA
	jWwTYugmllWvmjW0HKYHhnUY3dMoEuH0QJRoaupszgW8A9xy2JO31It0qAUMmh2xdhl6/jOhU3i
	USF7AgjTsJx+pqV3lhE55Q9GWH5BpWp91qEX5A
X-Gm-Gg: AfdE7ckrNHNY5cnemIVnA1hRyMtXTyzbwX//X9TlPxaBumvHEFsC/4FgtbA+QaqPL0s
	65iJ6iFE4huOoMG4RAcurzBbXfY0rA6vHJv7ACOGHzWq6Gem3oqg4WZaX5X0ZJKqA/tomAhAW6d
	27BtikNpWkVkQdHg2xuvmZlL6M9p0mEg2SWulOrfZ34M4sQK0nih6LVtrFJEUMiqmyMat4dqcgq
	UIpVmRu+qds9mNwNPxCs6XpByGhsFEs5Ff3u6dcKJmtH5g3HxdQn8Q=
X-Received: by 2002:a05:690e:2027:b0:666:53bb:bc1f with SMTP id 956f58d0204a3-6677fa5a3efmr346429d50.1.1783343761055;
        Mon, 06 Jul 2026 06:16:01 -0700 (PDT)
X-Received: by 2002:a05:690e:2027:b0:666:53bb:bc1f with SMTP id
 956f58d0204a3-6677fa5a3efmr346388d50.1.1783343760532; Mon, 06 Jul 2026
 06:16:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHc6FU4tz8-HmEf2_XKT0NT8N=rv5OMcY79PxTACkXAVLOAUpg@mail.gmail.com>
 <akZEjH2Hf8-RR8yQ@infradead.org> <akhaWrUHXcubQQab@casper.infradead.org>
In-Reply-To: <akhaWrUHXcubQQab@casper.infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 6 Jul 2026 15:15:49 +0200
X-Gm-Features: AVVi8CeZ90TZOgMX_QaiF2EyLUwZK6uqeXE5eQFowT0YnNBZfC21D0pOzkVqfoY
Message-ID: <CAHc6FU4-GsE1jtw8kXe0h_-T6VK2bB5QuVm2w16Ek6FiUV77tg@mail.gmail.com>
Subject: Re: iomap_writepages WARN_ON_ONCE(PF_MEMALLOC)
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, gfs2 <gfs2@lists.linux.dev>, linux-xfs@vger.kernel.org, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 4, 2026 at 2:57=E2=80=AFAM Matthew Wilcox <willy@infradead.org>=
 wrote:
> On Thu, Jul 02, 2026 at 03:59:24AM -0700, Christoph Hellwig wrote:
> > On Wed, Jul 01, 2026 at 10:51:06PM +0200, Andreas Gruenbacher wrote:
> > > Do you have any suggestions?
> > >
> > > The above is on RHEL-8, but a similar code path exists in cgroups v2,
> > > triggered via:
> > >
> > >   echo reclaim_amount > /sys/fs/cgroup/.../memory.reclaim
> > >
> > > That code path starts with:
> > >
> > > memory_reclaim -> user_proactive_reclaim -> try_to_free_mem_cgroup_pa=
ges ->
> >
> > PF_MEMALLOC is a sign of direct reclaim.  cgroup code is doing really
> > weird things when it is set and it is doing writeback.
>
> If we're going to blame the cgroup people for doing weird things, let's
> cc them so they stand a chance of seeing this ... original at:
>
> https://lore.kernel.org/linux-fsdevel/CAHc6FU4tz8-HmEf2_XKT0NT8N=3Drv5OMc=
Y79PxTACkXAVLOAUpg@mail.gmail.com/

This is all pretty ugly: inode_lru_isolate() selects inodes that have
a clear i_state to evict. Among the inodes selected is at least one
gfs2 inode that has the GLF_LFLUSH glock flag is set in
GFS2_I(inode)->i_gl->gl_flags. That flag means that evicting the inode
requires flushing out revokes. Before that log flush can happen,
ordered inodes need to be flushed (ordered journalling mode). And this
is where iomap_writepages() got called.

Unfortunately, filesystems cannot refuse to evict inodes once they are
chosen by inode_lru_isolate().

An acceptable way out may be to set an i_state flag whenever the
GLF_LFLUSH glock flag is set so that inode_lru_isolate() will skip
those problematic inodes.

Thanks,
Andreas

