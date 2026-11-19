Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795090692;
	b=3Ku7xBwxWoZilZFa8SpdjDqc7piW9cMOipfMjxh5FrBQgpVbSHiM9SCdFRmqptlbN/62
	 N/t1inWrkZoTxR12FBb2+hGLbHMRFSqlcMcAMT358MnmZitnp/jK7p77dto2+QpODIqbs
	 LJEp/HypD9NUNWE21UL51s4hF7EtZawyyD3LjCj8v/jGz7LZ7axru+Avwf3qlSD+6iSji
	 BkT9kem6vFl+fnv9vx4ohIXkys0truV0e7G1MFjHi6mu4Kjb4/YwfSt+UA6NYLiBfGAsA
	 MdP4eJpvYj3Kr61F+UQRu4Si774+ERB7J3S+7rgMCH55rYXD6Z2FiVfz1Mqp0c2S5uw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795090692;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=gqZVLpTgCP2ySw8awFBFsKWriU/az/ZtPImm1nmYhzQ=;
	b=W+QZgq5V636e5yISLbdkxtrsynKQoK4mMNC3t02kPnHyrTjxpU09UsF8sSgCp8wcPb8V
	 pkyG0ZoAjgqfXQsbc+f8VSYVg6aAytAi2cXoC+983BdlAKsmYNzsw1g7wT0E6s7A20Dn5
	 NXo/H+FVOgbIsW0fNnDWcxuG8BJmnE3t8v5aQNAJ09Cnai9h+6CkE0L6rxMLyNPMZpFUC
	 R0e0crV3RUqRC5yLr5Y1MCFi6o+GSn2MaloSOoIPCfTtuBACX4TBPFs86/JmI3jafPb5M
	 p192zNB7dO5Oo01PEztqz0BaJy917PDLP+Lg4/OV3QLImwcfbydlGoL8sKAnOWFTDtg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ifOPtyq7;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=W8hMqnqB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD79C606A326
	for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 12:18:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD79C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ifOPtyq7;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=W8hMqnqB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795090690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gqZVLpTgCP2ySw8awFBFsKWriU/az/ZtPImm1nmYhzQ=;
	b=ifOPtyq7o5N4Ryx1i6vms8hUs2TwLy/VT4TTh2PTFt5Ky+OtK2Z52Sg2aRI2r0PQwmRxBb
	acR+rLmvVt0D4OyixA7xHRuMWoYGjGUOCoPGcEsmuGXMRTaLIb6JOZFk6q6oA5x3CSRdRx
	qdccUlXVwKZytBZoZaDb4xPQUUNiPN4=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346--v4I4G7aN7-MG_fGImSb-g-1; Thu, 19 Nov 2026 07:18:09 -0500
X-MC-Unique: -v4I4G7aN7-MG_fGImSb-g-1
X-Mimecast-MFC-AGG-ID: -v4I4G7aN7-MG_fGImSb-g_1795090689
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-67a781c1069so3141344d50.1
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 04:18:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795090689; cv=none;
        d=google.com; s=arc-20260327;
        b=K21q07m/xQrO54xegJWXODx4BvrgX2gMSjVivPOg6m+iIqJUvtylCEJ6EXBk7w9eCr
         CLZB1uiu5mWt2/v6Q69Cqt7uTkkfW3j4TUO0IZ/R5LC8e6jHpZUg2JdLgVFSvX5rZ1HF
         cX7bonvIbvg4v2NFYSO5snqENyk2tf4LQDWOxe5Chu3Xx/2wzIPdKrzzxXL3mP1Fpwon
         qtuVBeSX9QqngpasYnM8yljatlZ/m2+R+lf407ExLgEIxgQ7AaXMv2n/ZxfasZ2F2O5O
         CDXIEERbmMd08ItFj24LtyUvUA4Kh+L2LvAuqMgvKILZbHUQsgxfY/RJgz4zt6FtsSyl
         HuHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gqZVLpTgCP2ySw8awFBFsKWriU/az/ZtPImm1nmYhzQ=;
        fh=oqbOGK89/OLJ1zArPQoxkGWsCI9FCMKHn9C4VkpkpZY=;
        b=oPHYnKXlX3RJuPwwjuRJclbY8nwIwkTTCe4flaG0ktN/fW66SnGUbLF9vozefG/Kus
         TxNLn9DFL9hL8MumAQ2/Q+CLAoHjLDZcfjK++uWgIXN3/WgBa93N/AyxnU/FgWo61RuD
         dlI7F6Wq7yeigp2ty81lyBvjUCY1/efR/fbiP7fEFQKDH4BnQ3Af29SOHU19iq1t42mA
         ht98nCloBhn8Ntg6OM8z9GzIsTEjajD2mpT+uIcD7eVxOBoajPVc1z1w7i3dR0I6a9+y
         21rgv5i3I7aWDhr0uit8d/z9X4PYNH3Cm1c5TJk30GyrVL5orWGqJtq+gA/jqa6kYfgp
         U3Gw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795090689; x=1795695489; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gqZVLpTgCP2ySw8awFBFsKWriU/az/ZtPImm1nmYhzQ=;
        b=W8hMqnqBRGair6EoKrRvZxO77dqdj+YfYgkTq7D/3LAyjuaoOoDi6CBjJj2/uTyIN/
         fDpxDop4wdBIhC4E/qClwWzfxDsRKlC+fQO3UGaRGo+wxRGTZreAoLQjwFDN+CvKuSdK
         Xfn4nra5rpcDvAioHGKENKEPM3Q9kGHAhtzrGoyfmonoJyWGpgd9XJyQO6Ah/a7T2Ppn
         zsB9YEoDNUbUZ+k9HrlxOWcwAWQDOlDoV3XTlJHvYLtC3OS9sGUDCz3KiS2aQ5OT+IOK
         ip3K9h84fcgxMAozSavkACkeLTUU+AZnecsWcPbDZVD/GsrbNUaLtT+6HgqlfHiMchXd
         tWww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795090689; x=1795695489;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gqZVLpTgCP2ySw8awFBFsKWriU/az/ZtPImm1nmYhzQ=;
        b=TLUKnbR0xK3T5ZlirQ873DwRFH4n8pqITIsZf1MXNevY74rCYTS4mcvor9KQUQOzHM
         3Rc7hbeN9kwEf8cTdUlZ1XvQspIXqYDDeCHdAlsmepjy7ecdcnrOpT9MXIZ4+9h+t3MF
         +g4ZKd5B5lDQSEOJrmX2oVdisqkmsCceNkTLCAT9KEwUYsrbakc6IhRARNg/moHKxWgw
         wXqWvy9ngrK3Q8O2HlSNJqGv9U6IMrwWLYVY8bTNWNCPgBWodg/lkZwzGrdJ5qF3m6Vs
         IA56m07Xrn3/N/OLpPt5/C6rTw7sQ1Rr48rz5ATD7YrYVew84k3uBBAm16gEmdrCDSJj
         B6Sw==
X-Forwarded-Encrypted: i=1; AL+hErGVF5lzgcr8BINwF3RczAJ+Nv63LnGiCYSV57MRpFW6kydYFx17UmTx4ploumuQfBDe7GjDcyqGCwo=@vger.kernel.org
X-Gm-Message-State: APuU4Z9RdoX7kzipFtJ2kT6KnftYsICaaTjUpMMPKrqovYwYzW5xzjQi
	acN/U9GRIl+NtB16iEYnpXeUiw9id0ND/+HFhiV02f9DiS5xvgy3TVymeLzqMw7difogmBwokN0
	83pbX584ZdCcDHJY6dhEYWo3lDefhEgPxHqhEz/GtmaoRuBhCSwBWpSqIF8VlMUWyS41DSgyWW5
	f/hYhbN74yK22mXgsInup2q+2RQB2/pP3BeWJn
X-Gm-Gg: AZFdTZf1mp8oPpIPcrx/2ty+5bvOtEQOXub0tyYvE/sZhvHCepi1PbK9svTu6AejtVD
	SePTV5pRx3c1CbMCNxUY8zU/fApKoKXCn0gp+AbjwDoH7uEYvJR64Ho1Vc2VfFWAEyBZFVuubTL
	NZTY9YLcij1i3FERr+6VAWyv+NAjLiVhFDJYTGsP5icmGH9poj6OxxEDT64vuI9G2cKbDf7Y3MJ
	MOT/pQ6pZrUcooIgj7MVhvs8JQcMN2B7TmVvg7UhirCuQ==
X-Received: by 2002:a05:690e:806:10b0:67d:a6fb:ceaa with SMTP id 956f58d0204a3-67dd3f193f3mr1716889d50.19.1795090688862;
        Thu, 19 Nov 2026 04:18:08 -0800 (PST)
X-Received: by 2002:a05:690e:806:10b0:67d:a6fb:ceaa with SMTP id
 956f58d0204a3-67dd3f193f3mr1716866d50.19.1795090688232; Thu, 19 Nov 2026
 04:18:08 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116171044.6938-1-jack@suse.cz> <20261118145941.1063127-19-jack@suse.cz>
 <CAHc6FU7NoZua98SGP9Kuga58gAcco6X__u=kOPfsUqbefAKLFQ@mail.gmail.com> <wo5723b7wrmu35q5qffzs7zzqwnojk3ireel2jkit2kxgv6bra@yd3gbigdmmdk>
In-Reply-To: <wo5723b7wrmu35q5qffzs7zzqwnojk3ireel2jkit2kxgv6bra@yd3gbigdmmdk>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 19 Nov 2026 13:17:57 +0100
X-Gm-Features: AclHuK-GbM7XVFxqU3dJAQePNml2N4MUSkkmDt3mktzVCdVYt3Td22WOXOu6yXM
Message-ID: <CAHc6FU5HY9x5ntTOz_xk36T0XTzjNc8R4jy2zzpQKo=19HNMog@mail.gmail.com>
Subject: Re: [PATCH 06/13] gfs2: Avoid racy dirtiness check in gfs2_fsync()
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, devel@lists.orangefs.org, 
	Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	linux-afs@lists.infradead.org, Miklos Szeredi <miklos@szeredi.hu>, 
	fuse-devel@lists.linux.dev, linux-block@vger.kernel.org, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org, 
	Eric Biggers <ebiggers@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 1:05=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
> On Thu 19-11-26 00:35:42, Andreas Gruenbacher wrote:
> > On Wed, Nov 18, 2026 at 4:00=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
> > > Check for I_DIRTY_PAGES state in gfs2_fsync() is racy because
> > > __writeback_single_inode() unconditionally clears the flag and
> > > reinstates it only later based on PAGECACHE_TAG_DIRTY tag. If
> > > gfs2_fsync() unlocked read of i_state hits in between, it will not se=
e
> > > I_DIRTY_PAGES although there may be dirty folios in the mapping. Chec=
k
> > > for PAGECACHE_TAG_DIRTY instead and use inode_is_dirty() helper for
> > > inode metadata dirtiness check.
> > >
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> ...
> > > @@ -760,12 +760,8 @@ static int gfs2_fsync(struct file *file, loff_t =
start, loff_t end,
> > >                         return ret1;
> > >         }
> > >
> > > -       if (!gfs2_is_jdata(ip))
> > > -               sync_state &=3D ~I_DIRTY_PAGES;
> > > -       if (datasync)
> > > -               sync_state &=3D ~I_DIRTY_SYNC;
> > > -
> > > -       if (sync_state) {
> > > +       if (inode_is_dirty(inode, datasync) ||
> > > +           (gfs2_is_jdata(ip) && dirty_data)) {
> >
> > this adds back the I_DIRTY_TIME check explicitly removed in commit:
> >
> > 3aac630b5ce1 ("gfs2: don't worry about I_DIRTY_TIME in gfs2_fsync()")
> >
> > Could you please clarify what's going on?
>
> I wonder how you remember this after five years :). Anyway, the truth is =
I
> forgot fsync path is calling sync_lazytime() as well before calling into
> ->fsync and even if I remembered that, then it would be fragile for the
> helper to rely on that (and there are already users of inode_is_dirty() a=
nd
> inode_or_mapping_dirty() which want it). So to summarize you are correct
> that the added I_DIRTY_TIME check is unnecessary for gfs2_fsync() as it
> should never trigger just for that but it is also harmless and the helper
> is more robust that way.

Alright. Could you please include that in the commit message?

Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>

Thanks,
Andreas

