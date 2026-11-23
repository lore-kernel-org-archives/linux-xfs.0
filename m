Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.158
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795467030;
	b=bamEIgpaHLgE41mnAj3MGn4cPVbyN1cXK01nxuJIw6C5q7iYktknouCJ1ptCrFo6+8om
	 r6nIRKWbWovW/dWJEtfxW1mQa2PT8vek38q12XSZe+Uhl0ntHGwHBeph5411h1WgjAAi0
	 tW3MjnzfUXOGTqq8/wxQ1Ldu/UTi37rjsl9HmmcsRDO42C5n87QTXjQC3NEVS/wx32uj0
	 Lh2qFsF83JJxO+xMOO/mwBU0aunxwAivejQMLjHdGJxJPZiVXsSWFIBM4kXo7nQz3yD8F
	 j5rF2LReVyLscGc0rOH1cZEZDWZ7KLM6QdVNWyMznYgPvo79+3imPktkF8oFLWpPuFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795467030;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Content-Type:Content-Transfer-Encoding:MIME-Version:From:To:
	 Cc:Subject:In-reply-to:References:Date:Message-id:Reply-To;
	bh=7wNwm3nBSKYEO3ZsBLQilTK2hdyTPsdyQ2l3ESaYKDQ=;
	b=4ObB1PEEhP2my/akBSEZvFVKj7n0eSn8LK4MGTpij1fM1OI4LGJNvlKbfbSOuUfUH3hk
	 P66b76DmhfwpkUadWSTKT3gPcaCo1F8VLhoPa1nwN0Bpkio2CrjPHJ0VpgjJ56wJatOfe
	 FKoMk/Oyv+QE4tjr09/IciKJCtHEhbow5Jo8A/NWm53dIlvyz99iTnxbHhkveyxsNF+Xp
	 NRdhu9rPj9dmetveLUbRpyiL9WT13JUwlVQviGUNGR0aG5UPyIHrFSYoOez13sudR9qZm
	 /u1s3knP+CFtNVufNOT2Vcf4xqUr8BSZl2JQ8NfxEtwiYUn3hOT8cIYcvn1nhMym2bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ownmail.net;
	spf=pass smtp.mailfrom=ownmail.net;
	dkim=pass header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm3 header.b=Qk2zZbxU;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b="UfMUy/Ss";
	arc=none smtp.remote-ip=103.168.172.158
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68CB606A321
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 20:50:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C68CB606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm3 header.b=Qk2zZbxU;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=UfMUy/Ss
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B455A1400392
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 15:50:28 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 23 Nov 2026 15:50:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm3; t=
	1795467028; x=1795553428; bh=7wNwm3nBSKYEO3ZsBLQilTK2hdyTPsdyQ2l
	3ESaYKDQ=; b=Qk2zZbxU2Aui9OQqqvYvqyPFFydbIhediLXcMerExjkx/xb+T8M
	h/Qu/BOiv0zkkO7IaTm+Bl9RAHezGJjVpRT0dIodJqclRh43bL7Jhgu9pULqv+Ja
	KmxyvzgM4NAhmBQZe9jg9Dno1/1XSACw8jleRt1qMaB8zShiengb7J5PIy9qu26w
	BSsjr7eNpRePlF4io9DVr9Kq9wzWQCowR6m5Y2OmFmUT23izjYmAqdNybGgl9mnu
	au4bDV8zDHJGg3nZMHw+HSBEYc52wCwqd1apAPnIs2u9nw4M0xQJm3mBi7HYQ1Pq
	RXAIYXWAjT3ErfePIklQ1nP2L6fdUl9PJOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795467028; x=
	1795553428; bh=7wNwm3nBSKYEO3ZsBLQilTK2hdyTPsdyQ2l3ESaYKDQ=; b=U
	fMUy/SsP1HWB/ZWJlerzDa+vezVqwgWDqLWCe1vnDDKcfE/bmxCM6QIRpq+i16nh
	ECxW4/17qdeb9ZUx0AsHxpyja2K2zIICcab0YD1HQhsUS4zV+r4UjiXdfIQf4XeD
	/Bzaa0Q0bigLbG+DriwEXkDoxz6AaP/z8JM6SZ0rR2r4t2HjLH9VSW3xPvsAPBZ0
	v5x5UZFTg1crf5p9arXzhkiiWZfsY55MLk675B9cVzTvAMBVcV7eYk2TYqn3/H7X
	iyLZ/SyWGb7FW7zL4bvug53L+Gf0I6pK1t5DenOLw82Vb/1LjkwB67whjS5GSyPE
	6q87D1xEg2aGSEnlgLaaA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=ownmail.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795467028; d=ownmail.net;
	mf=PG5laWxiQG93bm1haWwubmV0Pg==;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:gYPjUfVae7PbqyoeP6a/8v9vavHufm7c7gAQ/+FYwmEJ2kd
	R/pWlSByf4ZvAIdoT4LEP/xYIIacjx7zIG5UJDm8/yft0OYhzF2hxIHfTXhlNrJm
	1ada6c4OtXLZTpEHIQjv3PvF5gKXVTb5ANW1j0llxjgJ0V60JoU9QnD/n+5gXIJy
	LMbs7L8ws6t7oSWLgKE6JMi7bMF0KiaI+0+OpQI2ncGzgood8RgOBcRimTDXu2Tz
	WfJLIaf7Z6GFsdcONDa5CMaKfcw5jniAamXwYuUYc/QOR4LQnuaB6egZ2ZH7F7lC
	sKvXki+OwSggKwt7YbuO5ZUJZ1khT2Mz08BKskw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,reply-to,
	subject,to;
Message-Instance: m=1; h=sha256:Np/fWzmHZC5erycw7HnvO+QCIip28SFy+uUQS6N7pK0=:m0FG7+Uh2WED7ZvyFUpiUoHsdyufIrpxlBwM/xTCTIU=;
X-ME-Sender: <xms:FKcEa5kO4iN0rylq_HdwL1JiMb7xxFJs7Whg83Gr-DQS9CHLmoMkEA>
    <xme:FKcEa2NEhOVipYCXS_EJCKd7oCiPIXG5Eda5s8aZo8bhb3fnbd7V8wtceTw1HPtCq
    gQFI1v_wZrEdmptyzpP2lQdSzW4mqb61933chuxO8VjF3Oql8o>
X-ME-Received: <xmr:FKcEa47PvA8BntpSaUFEQDceUQ76YK2njWNe8DCCqa_6uGHOaYQzOlxFwK729TxFyMs9WQ068bMfDRM__QAg-FVnFhW-CAc>
X-ME-Proxy-Cause: dmFkZTGC/swz0pxpsPkswi5DsSiLwwOeEwGs5e7U5/fwF8vzMGgEmQupo2yU3CQdPHeXr7
    mGbCB/U88ktr6GSAQSn2dc2ASCs/k0e580Zj3lhFBFNM3un6r2cd5t4uCPBIpA+E6XZckt
    YseQXMD5tnrMT/dOTg2cmfHREwHGKsjFQEjfrvSPts30IHDXrMhIhLjlgST3xVcTeAEtL+
    YZv0a4E/fdIWeSB2bkuGjkOJL6KZUHWY2633W5wDKYU/UlNG02mgKVLCuyGZM67SJx1jiY
    Y5x3kuNlP3ieJWqhWTO7+wIJiXN/JSqg+jHnFH+4WSWoDhLO7B8xm8kQXOWSlXnXk1YNJ9
    H8EmltLrurw0ZsY+f5DiqCGpygE2tNHDiRDFdkv5VsU6b/bbR5Hv2u9kAKg1iUsi7XNaVH
    LK0gYGLPXKC7XjvJqsHxikpkoBdfEQjFffnFIE366sSgvXq9OjCmZ5q8PNFodunZ7OupbG
    vWhJTsRg3TG8Kuz4ZUGZwAf8OxI+ihuuBnOUunjPrqxi9LyJkqWNa2IW1wk747kWJJsdP+
    WrldQ3MUv5DLkWkOX2Z42puMLD3OJyJJlCpzlrHv9aSz1FfmB6uqpncg4058UbDveFiBMW
    qY05guPEhXiGdsQBLfHO5mPnhXZbecKnJMt7y0ZCj2q5DOzEwp5UfRFnLn8w
X-ME-Proxy: <xmx:FKcEax2qvNRJSOyrDv1A_bFGjj_sEnoxtPuthY-rxGsIJVt4Dd_GLQ>
    <xmx:FKcEa-qFjCO3QcdkyfwzYV2dje60Uw_vo0KlqdPjlLqq6b-BzzKIBw>
    <xmx:FKcEazmewNerqlvgmX7-hf_Y5pTmi_UOKaNjCSUaDMVrXlFfShtLcQ>
    <xmx:FKcEa4TmpeeewTZFgRHFWFGR2x0LlzKzUNImlqWe2FSnBP9Rpc8Taw>
    <xmx:FKcEa--DIOSc6ypvM7zC9IJlcYJzptHEu_Bv1ZVhnaSd_GHCOovNkxw4>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Nov 2026 15:50:23 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Jan Harkes" <jaharkes@cs.cmu.edu>
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>,
 "Richard Weinberger" <richard@nod.at>,
 "Anton Ivanov" <anton.ivanov@cambridgegreys.com>,
 "Johannes Berg" <johannes@sipsolutions.net>,
 "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee" <hyc.lee@gmail.com>,
 "Carlos Maiolino" <cem@kernel.org>, "Jeff Layton" <jlayton@kernel.org>,
 "Amir Goldstein" <amir73il@gmail.com>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org,
 ntfs@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] coda: don't d_drop() early.
In-reply-to: <20261120173041.bd3xeidt4ndkmimd@cs.cmu.edu>
References: <20261117000115.1433875-1-neilb@ownmail.net>
  <20261117000115.1433875-3-neilb@ownmail.net>
  <20261120173041.bd3xeidt4ndkmimd@cs.cmu.edu>
Date: Tue, 24 Nov 2026 07:50:21 +1100
Message-id: <179546702143.1728055.104338881046944851@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Sat, 21 Nov 2026, Jan Harkes wrote:
> On Mon, Nov 16, 2026 at 07:09:14PM -0500, NeilBrown wrote:
> > From: NeilBrown <neil@brown.name>
> >=20
> > Proposed locking changes will mean that calling d_drop() could
> > effectively unlock the name allowing a parallel lookup to proceed.
> > For this reason it should only be called *after* the attempt to create a
> > symlink (in this case) has completed (whether successfully or not).
> >=20
> > So move the d_drop() to after the venus_symlink() call.
> >=20
> > Doing this also means that if the upcall that handles venus_symlink()
> > happens to look up the name being created, it will get -ENOENT rather
> > then a possible deadlock.
> >=20
> > Signed-off-by: NeilBrown <neil@brown.name>
>=20
> Acked-by: Jan Harkes <jaharkes@cs.cmu.edu>

Thanks,
NeilBrown

>=20
> I was sort of already assuming that the userspace cache manager should
> never ever traverse into the mounted /coda file system tree because
> there is only a finite pool of worker threads. But it is good to know
> that this change would fix at least one possible deadlock.
>=20
> > ---
> >  fs/coda/dir.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/fs/coda/dir.c b/fs/coda/dir.c
> > index a85be5962e62..b47299527b65 100644
> > --- a/fs/coda/dir.c
> > +++ b/fs/coda/dir.c
> > @@ -249,13 +249,13 @@ static int coda_symlink(const struct mnt_idmap *idm=
ap,
> >  	if (symlen > CODA_MAXPATHLEN)
> >  		return -ENAMETOOLONG;
> > =20
> > +	error =3D venus_symlink(dir_inode->i_sb, coda_i2f(dir_inode), name, len,
> > +			      symname, symlen);
> >  	/*
> > -	 * This entry is now negative. Since we do not create
> > +	 * This entry is still negative. Since we did not create
> >  	 * an inode for the entry we have to drop it.
> >  	 */
> >  	d_drop(de);
> > -	error =3D venus_symlink(dir_inode->i_sb, coda_i2f(dir_inode), name, len,
> > -			      symname, symlen);
> > =20
> >  	/* mtime is no good anymore */
> >  	if (!error)
> > --=20
> > 2.50.0.107.gf914562f5916.dirty
> >=20
>=20

