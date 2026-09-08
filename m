Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751AF53CA99
	for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2026 18:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788891624; cv=none; b=BrF+2dl8fUmlCafgr9xogMZKJUA1YtRnzDY8zdDukefSXWl5og2koxrkaqSz1xRMT0R17LdKXMktTDnFTgEldr7nUbijtNjEKlEXJwmBDKUdtiG2edNsei7AYYdKQEjkLJDKfxXPB5rDvu+kPcZNy7B+aAFh4MJegtNxMQ/LdcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788891624; c=relaxed/simple;
	bh=T5CqmSnaexzm2YVCpEARjs9sSTWJkEnstf1yOs8SLpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ip7SLF8RbtHOlHbKQqsw4suD2+Lu45Ee2oYIOqefjnHzrCZVztznu34sYuFXwSphBsazOmz1IY+U24EeO80XJfjznYN8oyZbk0N8pd4Quf/RVwAH4gvrj61hDgYN4+5L2Pt/yiEumSMutsbbLxOyOe//svtVgoUmneCzwaZYDJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=YNaEizYI; arc=none smtp.client-ip=74.125.231.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="YNaEizYI"
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4b6070b67beso114093b6e.2
        for <linux-xfs@vger.kernel.org>; Tue, 08 Sep 2026 11:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1788891621; x=1789496421; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:feedback-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=herbp2Xpm1L8idqOVaAZ+EViPrHS3n9/4a+1URgNpeU=;
        b=YNaEizYIsXJ4rAEbfX3NHeF8r2OZ0wleToLDBPNexgZUIsm0bBReLTtqe4B47V1uLb
         dnXH9YOMzxfCiMpzTtQHan4CtHlgyEsFyLBTgJ+IXn2KcYYe9mIznofjuPE0zvKPZap/
         Sd3BC8aBleAFMPGp1Aqc+N9WTS+bEPJ67McFw2cslBuvxuCdz6fC7XCQHwAldJhk10Mt
         n5UulZofMn5OnRB07O3rAlTsMc1NRd51eQJ3K5Evu+g1itd34krix4wpiRl5r7NK+sab
         +F6G1JCync/y5WjOae+6TWGBR9/5VceRLFDDVXLSZ7TEheYhCaWUY3qrNOB9APuMRcA5
         On5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788891621; x=1789496421;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:feedback-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=herbp2Xpm1L8idqOVaAZ+EViPrHS3n9/4a+1URgNpeU=;
        b=NJToaS0aDl7XJZDKinWOJU+1PglrAQaNgo7PyJtvPFejnC7896ySMtVQU8m+omINN9
         tf5zoo8G3uEyz0sUxdU61pxMcVK/2CkDywxXbQKL+sXiWe/wVgFuSrbrpXbEh3x42iSD
         aLX8pEdG8FbX/YrzDyTsx3uhyEEwshz8Y3Gt09pV7UOfW53Ga637J5rfqDfkZo6Gh4VP
         eCDKOJmm7JcQ2zgEr4GT+6KFD3uWZQkVqLyL2lUINVUe2oA197UPRuHsI1HQQpfIPyGV
         6/4kDIcn1NXwqDsqUS2uayuJUfdEGYb+m6GxzQ/ZRpxP6z6F5TrxfhCh10u91P1IW3Sa
         Ljug==
X-Forwarded-Encrypted: i=1; AKwUvBwnM4elJa5LMAX2A1NrIEKO62CI4ZK0M/gYOI0pJulhxXkWYkJHgJoKnZYOc4NRXRqieooYKGjn1Pg=@vger.kernel.org
X-Gm-Message-State: AFuF++l3Jr42lJYfxigKTUNgo+0wmdUEPjhL2kxLbkwMocn/JkiAx9iF
	wgb8fA9TIxB6wjyAjO1sTcwVbqRJeLNbqkj80nyStJ8/jnGGiQY2Mumu+aUXDcgFeLoZQ30H1ny
	JBa4jEa+AqQ==
X-Gm-Gg: AYBFou0yHctEUxmnnbY3FuhcsEdUzBHpLeIzu2axVYFm+8+ogwtZZYqfiQyN6UZK9uA
	yJWdj7hIxGyG0KPGi3YQ6QYUbL56VlAcGSKZfPu9A/ifCBUfoYkIXZlv+7L/BTBhp0f/NbDAQNw
	Z5Svy/Sz7VFkA1lJububpdijZ1qDxb0lml/E1xYQssIwKByjESpFLTKXQu3+c01KxK4HVlgriAP
	VfRW7Rx4gbmVRdtwHkqZympXnIbVFObISV3jXUyukktVfRrkJLytavEn+4kR8+oMQ8Y6ZVeAhAZ
	pbEC1/q2PpR8kx99R74x+mkJsx10M4Cpb7vrwVZsCGUCgiCU/1q4uKxw9F0IGCoPv1sQEu0tO9/
	pmfoZqehyv40WfgUZHPPCEVyFUiOwx+r/GziCwVRpBYAiLN/3RNQ7lXCA0UjBJ1DtYG6pewJWxL
	2RTyWFOExuSx1TsU+5mnXReROGbyjNRtQ9MzLTEYbHlV8BNqU7wiC5wQa1pNsu5LIXy8hp3cJLm
	g2JxNdvyHD3gu8+cE4v90asujxmnt4ti1Lcv6ZP+dM5JRZA7Q==
X-Received: by 2002:a05:6808:198f:b0:4b5:7880:14ee with SMTP id 5614622812f47-4bab06631a2mr13445513b6e.5.1788891620848;
        Tue, 08 Sep 2026 11:20:20 -0700 (PDT)
Received: from fauth-b1-smtp.messagingengine.com (fauth-b1-smtp.messagingengine.com. [202.12.124.200])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b96eaa508asm14666943b6e.1.2026.09.08.11.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 11:20:20 -0700 (PDT)
Received: from stl-compute-03.internal (stl-compute-03.internal [10.204.2.63])
	by mailfauth.stl.internal (Postfix) with ESMTP id 7E5E1780043;
	Tue,  8 Sep 2026 14:20:19 -0400 (EDT)
Received: from stl-imap-04 ([10.204.2.95])
  by stl-compute-03.internal (MEProxy); Tue, 08 Sep 2026 14:20:19 -0400
X-ME-Sender: <xms:41GgavDUKpi4K_P3IbF1M1OJonfDzawIh7h1EX3o1634E_tB-NIkLg>
    <xme:41GgagUeW46RO6Rfmwnq5drk1mzJM8gRrohTe2vuD7ZaJCQdBjDOJiEoPE9ZVPynL
    p28OgUf7KKVhSDYTlZaIM-qeXFH3zQtHvJSEnayjYTX86dRPNnBOU_z>
X-ME-Proxy-Cause: dmFkZTEv5A3HKbH+oRsA88IwAiXmYsutMQFmHcjXXyMekw9JT7sLTOF8bMWRSyYBfbtL/x
    JtsDNYtbnbbpR3p9Y4qzfrV4rGgJkBQI9t4kYW9DG0JEKrF2ZBGngPwxKzUnVEJcapuoPV
    Hg+Cp6SFZtaRXV2UbJNNeqny+Q4SIZDQHzjE8Ls4LZbthfWb1vjdI/LFuRKT/Ta+j4j116
    Y06KJ/B4sA3Wq0rVepbkMZYD4PXL3jc4lnDmis73EtSud4V055YPbqXRhrKsC1pyAM9Bcc
    BN2xaPrZ6kCv5E6E6TawXMuHaRAoVUlZ+XpaiSVzgYKW2/5kQwJLpzo8dphHk4Db+Ma3CN
    2nGut+s4kbeM/Tm9oCezP63XlXZLQ39lIEXyCfRxaDEEswbpXVcULnt9CPl8oRnoZjKrcv
    IAxbdBmiifgKNBU03Y/xKCcYSAfUOiGLS4DdeJo8QqM/Cfb1VnP9GjGCjaNaVCrPmoMFLa
    kwC7rURw69NI/VE3bmtcCBjnnAaT5PdLqumb3pvdp1LKLKnCyZn/LzoFgrWJlZsm2q4RVz
    kYl46Uk/cDk5kk09Efu1bZpo4CInVAgTtBKktRCGFLYiYxAnNjijwNYkn/0UWcBIHqiYva
    NUG9CctaZ1cbdxHEUXcOO5xaTTApbvul+zYuj5rdFcqFnEkw2AHg48zXnp2w
X-ME-Proxy: <xmx:41GgaprzbbB2W657M-0HEZuU5eVru6qpMR4TCpnza2l7x3F114c_ZA>
    <xmx:41Ggapcixd4HqBzvrCr5qX8DolzWk016dnSDGNnTDvXzxSVxDxi49Q>
    <xmx:41GgagqaeHlim0XyvavY_TBilDJpmhgUV28dp_kj1mPes9Gyx71pew>
    <xmx:41GgaiHgjA7duqQ_FAC4fIqBXkiOGpa_KE2lO_4IYNBjPlzeG-pVnQ>
    <xmx:41GgaosnsIfRjUF4LRpZogkC4UwHGU3DcimhHgmOTsxuK38fUso3RNdR>
Feedback-ID: if7264b73:Fastmail
Received: by mailuser.stl.internal (Postfix, from userid 501)
	id 44DC380064; Tue,  8 Sep 2026 14:20:19 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
From: Javier Tia <javier@peridio.com>
To: Dave Chinner <dgc@kernel.org>, linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>
Subject: Re: [bug v7.3-rc2] dabtree block accounting assertion failure in xfs/286
Date: Tue, 08 Sep 2026 08:45:56 -0600
Message-ID: <20260908144556.ehhplwwele@jetm.me>
In-Reply-To: <ap-mIH9nTNkpWq9K@dread>
References: <ap-mIH9nTNkpWq9K@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Dave,

On Tue, Sep 08, 2026 at 06:07:39AM +0000, Dave Chinner wrote:
> [ 5725.316568] XFS: Assertion failed: args->total >= dp->i_nblocks - nblks, file: fs/xfs/libxfs/xfs_da_btree.c, line: 2387
[...]
>  xfs_dir2_sf_to_block+0x143/0x800 [xfs]
>  xrep_dir_swap_prep+0x134/0x170 [xfs]

The assert is right and the caller is wrong. Sorry for the breakage.

xrep_dir_swap_prep() builds its xfs_da_args with .total = 1, but
xfs_dir2_sf_to_block() goes through xfs_dir2_grow_inode(), which
allocates args->geo->fsbcount blocks. m_dir_geo->fsbcount is
1 << sb_dirblklog. Nothing forces those to match. At 4k blocks with a
4k directory block size fsbcount is 1 and the reservation happens to be
exact, which is why the default config never trips it. At 1k blocks
with a 4k directory block size it is 4, and total is short by three.

The non-repair caller of the same conversion already reserves it that
way: xfs_bmap_add_attrfork_local() sets dargs.total to
dargs.geo->fsbcount immediately before calling xfs_dir2_sf_to_block().
The fix mirrors that. The attr side is fine as it stands, because
xrep_xattr_swap_prep() passes 1 for m_attr_geo, whose fsbcount is
hardcoded to 1.

args in xrep_dir_swap_prep() is a stack local used for that one conversion
and then dropped, so the underflowed total never reaches a second
allocation. The understated value did reach xfs_bmapi_write(), as the total
the allocator sizes minleft from. That is a spurious ENOSPC at worst rather
than corruption, which is probably why it sat there since b1991ee3e7cf
without anyone noticing.

I have not run xfs/286, and I do not have a 1k setup here to run it on.
The patch alongside this is untested. Dave, could you put it through the
config that tripped the assert? Carlos, if you would rather have for-next
quiet in the meantime, reverting 0fe77e57588b is fine by me and I will
resend this behind the repair fix.

-- 
Javier Tia
