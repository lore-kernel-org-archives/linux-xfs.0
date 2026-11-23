Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795466942;
	b=cnOR9NcpxGj5WRtgFTMShwmF5HqN3BNoOyXICv7HOrOs41MpYCQqhXVlY/J5FnSozRF3
	 igxQcX6spblr9yDuV6wUHya0a4LTfhYVVads3X2glC6bg72tkrpYot6s7xEum49o3np4M
	 3O/NvGjeXPmt2lDwPGNunD46cNbBTvRCTaR1jkVDXvMhryF05B3/b/PbFQ92ra6yHYZqN
	 lep1UmBHRrgaf5Tj6BlwZ8CsA2fMkKuk7Eei00e7R0GDbUTFn/FP4kbJHi/KX8HVxzqt6
	 iJLdUmHrV/CCiOOxkmoeM8MgzY3w7x/+pBXYkyZ5Pm1n51dVNc9c1Dglgodc4avi1NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795466942;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Content-Type:Content-Transfer-Encoding:MIME-Version:From:To:
	 Cc:Subject:In-reply-to:References:Date:Message-id:Reply-To;
	bh=o9zLSXJuEnjCYOHrQ29UaL5++JY+uZSugjvH7QOgkgM=;
	b=jO3WA06vVLxNAdCunMNPqBOQbXNBXIkiSdQ3GB2mlfVOFobA6sGU8Sj6e7c2eUrbtUIh
	 0phTTzo0qadXKHWfqAnvzSeP0++bnq74RJSkpY5W6liB4YC/MzFgoy9k1d5pKXmB1p91V
	 9tvau/aBrsz7IAR1Kkf2sd7WddW+2En+9JfgiU6AqjciikkPxzSukDKVAfImWY6nTjjul
	 fVra6XzXBf5PH/ArojXjx1uOiffJczejHbWI3FUmRVuDZQpZzDl2QGqBmJT2Y8XVZ1210
	 8wLdQLLBNyt1yeG1kEcLTRwf/HL6z03vpTkaCPC8R7BkzirJTaT8VVOHgZgaDizmtlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ownmail.net;
	spf=pass smtp.mailfrom=ownmail.net;
	dkim=pass header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm3 header.b="GUqi7D/+";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=GeCTSuUL;
	arc=none smtp.remote-ip=103.168.172.145
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06DF606A31E
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 20:49:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D06DF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm3 header.b=GUqi7D/+;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=GeCTSuUL
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 08B0CEC1FDF
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 15:49:01 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 23 Nov 2026 15:49:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm3; t=
	1795466941; x=1795553341; bh=o9zLSXJuEnjCYOHrQ29UaL5++JY+uZSugjv
	H7QOgkgM=; b=GUqi7D/+zOLrqWSCzm+MYwrgGUjLKLl+XyO3sqEMlbWx7SCD96N
	xOr7y+zBHvOJU64RURKgirlFowf3Nwr3aEDK51YyBQlTYsXZPHXQBIekNZKCnUv4
	KsJ7waiQTqtIfKfIciO2t0+seQCxjIoBE/jzWA+bLsUFuvppgIe1oUUDuduARfs0
	t3JPhbBc3ixP9z2lo3LiqRiZ6svS6iP3JqTZaE4IPjo6wwG/9Hk1S2y/EdvPD7i7
	VeW9Ha3EU2WYxmJ3DxwIb2mHDAm2WO5nWwgvgUT3UiPRd1agj+ERpo+8YO9P8RIa
	pHNuAA3m5BdklG2F+1juF+ysaWNVwkdTd2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795466941; x=
	1795553341; bh=o9zLSXJuEnjCYOHrQ29UaL5++JY+uZSugjvH7QOgkgM=; b=G
	eCTSuULw905Aod95KYVphrgcfjTxFP0oxax/QIzCt7Z08DmPbXq87xmjvsq87B1o
	T7FpSf/jOkxbzNfI9K9UvX8+L+n3jzN0UFd38r6Kqug7Mikbl1O/2EmrG2SO3FI1
	KHnotRnxKL/i6//1NMYSCNNAQD5Lw8zQIP5We+msQKoeN8HunYpxYa/NgEin0FBL
	OrwyXhfhr1+ovrOEMzpq4EqB2X4zDBEfT7EuPoC4GZVcDg7QuNgDviNaNXLJmX39
	10qq1kOBTAvLEMe0kGmTgufHnX1lPRueLiduAXke6LIBKcNxkA/MXcp84nvwDaqA
	INQFdl5CmGnTdw0oHc84w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=ownmail.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795466941; d=ownmail.net;
	mf=PG5laWxiQG93bm1haWwubmV0Pg==;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:wLTRuWuBPsmlhrIabZkMOiXFCBJ7D+kaDoQqv1Tal0Ve/eb
	F5LybaALGH5Saa4lYdEuFOBEBZjb5AKEig9ZxwlgFob+vixYFf+9bX41d0cQhMGy
	5cTgpo1giPg2GxX2b9zPdxCJKdGl1uFqC/UwGOy8fbueY6BEF6A4sB65c3QFk5Cq
	AeoskxyA0+j0HDzOIdEyjXb6ld4b5DC09AZ5tj+rZrMrAWgiycQpJy5lwZTGMah/
	xpswAWxTAIvBr+QXqFs1W/zjTxKjuY6iqI3gVRRiJnvDWXokryYDx/TvFdZq6B/t
	wVZGOfs7X+WVCoTb2DsUnjgk0JYBoj3xfdkqzvw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,reply-to,
	subject,to;
Message-Instance: m=1; h=sha256:iRsZPrvVIwPX/h3pXgxfTnT/eDywSz9BnLpkefyq+Ow=:TQjb9nmWbWE1VynL6JHeebg3yoN+S4zxdXHZHN+WKgw=;
X-ME-Sender: <xms:u6YEa7TXivWPuJUmQwTofE3_mOq1Vd-dGbfdKdCpR8XRf4mdVhKkOA>
    <xme:u6YEa-FAq9luXdWY2R16GtwHX7z9lzSVvh-3xidwqcC_0YdC1p2FjR8MM26AohERW
    8Y2RTcrRVy8N0Cfpe0u2k3jK-WQI80vUAOYxgi3mQC340Hcf-54>
X-ME-Received: <xmr:u6YEa1fKzxLr8_1Q8wvmXU9XFcWRl1eA7ksz9FFvxFJ4ilMV2X37c48RFAVhVI5O2MjFjpePCFj_Mpy26V917zelIABh1kc>
X-ME-Proxy-Cause: dmFkZTECMQJK4fdkHy0fWLPUcFTfrq9t91uSnuEGiUSnuJVoCkINLH+FzKpB2tSIh00Nhk
    5BK9SRt/YA6/FrvyPQt1zAAzcR5cOsyqFz7nx9uu0f4KSe3wR0kPiRBN+OVBWFQfytz/nn
    yyGl8KiMZ8B/aculVSmccW/8zngN0Q/vdl6AlkON9HCNZS3RB6++ZKfrcMUpGub8gwOvLm
    AfxvFEkzIq6zthR7ARiUVw30kV7XdmJ780kxcA9EMVKyogzFKXYyTyYLNb86ZISYUb8d/z
    rFvorNZzKKTgs8fkSA6/DEx90/h/JJKzOE5MWqhdr2fZujknKzF4prwngvHkH/gzMXhOjI
    W2qJFidfdQhutil75qA7q28SL5utgHyPCYjGk3jbYPNIWOTW+lgKSOHM9PFUOVE4MR33Yb
    yQOG+YP7xrsB3fg8W8oObe16vE6p/BlLe0wvL9GnHvZqPldBX7whsOfLYvg8K3vS3y7Ztv
    vtLFOJ6eyHRKhRwQUJBelmJtRhZB0ya0x0/gCpihCgyIW69Pz9HM2foCdkHyEPxE8i33+l
    gb6gKLN69B9x5kOtGKlbuEucLQnIluC26ckmgsXzWq+85qJTrQQHreucLfGmT62E6CMJmN
    wfzX1snjy9o8lEEGvvcxDAvGTgc3an/ek3fbgvvdrM0gP8oQwfzLkuvh788w
X-ME-Proxy: <xmx:u6YEa9v4MlfSFvBYUW3AaaxOuVN6K8LRsbr3wpg2UnQhGQakfgongQ>
    <xmx:u6YEa7dUUoaxCTu3vhu-0mhfleuvvFLqCPMmBXEj7KynRAJsHDJseg>
    <xmx:u6YEaxpDSw_mNUDwFA2fQi7eSu1e-qmUbgp2qhZsZ4P45ocBhlqw1A>
    <xmx:u6YEa58xC17HGroqH_gvx4Lperpo4blG6Pv2gD5Od9dlgym1vNWEag>
    <xmx:vaYEa5q6WPtMSV6UnT0CuFMsOg-aNwZnOEi6QNWbCtNynKKtn7P9IXVR>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Nov 2026 15:48:54 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Jan Harkes" <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
 "Jan Kara" <jack@suse.cz>, "Richard Weinberger" <richard@nod.at>,
 "Anton Ivanov" <anton.ivanov@cambridgegreys.com>,
 "Johannes Berg" <johannes@sipsolutions.net>,
 "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee" <hyc.lee@gmail.com>,
 "Carlos Maiolino" <cem@kernel.org>, "Jeff Layton" <jlayton@kernel.org>,
 "Amir Goldstein" <amir73il@gmail.com>, linux-kernel@vger.kernel.org,
 codalist@coda.cs.cmu.edu, linux-fsdevel@vger.kernel.org,
 linux-um@lists.infradead.org, ntfs@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] VFS/xfs/ntfs: drop parent lock across
 d_alloc_parallel() in d_add_ci()
In-reply-to: <20261120-veranda-tiger-seemeilen-397d57fb2258@brauner>
References: <20261117000115.1433875-1-neilb@ownmail.net>
  <20261117000115.1433875-2-neilb@ownmail.net>
  <20261120-veranda-tiger-seemeilen-397d57fb2258@brauner>
Date: Tue, 24 Nov 2026 07:48:49 +1100
Message-id: <179546692990.1728055.10797595669821351188@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Sat, 21 Nov 2026, Christian Brauner wrote:
> On Tue, Nov 17, 2026 at 10:54:58AM +1100, NeilBrown wrote:
> > We don't need to keep the parent lock held when d_add_ci() is run - the
> > VFS doesn't need it as dentry is exclusively held due to
> > DCACHE_PAR_LOOKUP and the filesystem has finished its work.
> 
> I'm not sure that holds? Only d_alloc_parallel() honours
> DCACHE_PAR_LOOKUP. lookup_one_qstr_excl() still uses d_alloc() and
> relies on the exclusive lock to guarantee that there are no in-lookup
> children at all. That stops being true here:
> 
> > +		if (lookup_flags & LOOKUP_SHARED)
> > +			inode_unlock_shared(d_inode(dentry->d_parent));
> > +		else
> > +			inode_unlock(d_inode(dentry->d_parent));
> > +		must_relock = true;
> >  		found = d_alloc_parallel(dentry->d_parent, name);
> 
> So if "Foo" exists on an ascii-ci xfs:
> 
> P1: stat("FOO")                      P2: unlink("Foo")
> lookup_slow()
> -> xfs_vn_ci_lookup()
>    -> d_add_ci(dentry, X, "Foo")
>       -> inode_unlock_shared(dir)
>       -> found = d_alloc_parallel()
>                                      start_dirop()
>                                      -> inode_lock_nested(dir)
>                                      -> lookup_one_qstr_excl("Foo")
>                                         -> d2 = d_alloc()
>                                         -> xfs_vn_ci_lookup()
>                                            -> d_splice_alias(X, d2)
>                                      vfs_unlink()
>                                      -> xfs_vn_unlink()
>                                         -> d_invalidate(d2)
>                                      inode_unlock(dir)
>       -> d_splice_alias(X, found)
> 
> IOW, "Foo" ends up as a hashed positive dentry for an unlinked inode
> that nothing revalidates.
> 
> open("Foo", O_CREAT) then opens the orphan instead of creating a new
> file and O_EXCL fails with EEXIST. Do a rename() instead of the unlink()
> and "Foo" keeps pointing to what is now "Bar". ntfs gets there the same
> way.
> 
> Before this patch lookup_slow() held the lock shared across all of
> that so start_dirop() couldn't get in between.
> 
> So afaict this needs "VFS: use d_alloc_parallel() in
> lookup_one_qstr_excl()" from your RFC to go in first. Unless I'm
> missing something obvious.
> 

Yes, I see that now - thanks.
And that means we don't need LOOKUP_SHARED at all.

The AFS patches also drop and retake the lock, so they need to be after
d_alloc_parallel() is used in lookup_one_qstr_excl(), and also after the
d_drop() changes.  So I think I should combine the AFS patch set with
this one.  I'll try that and check that it still makes sense.

Thanks,
NeilBrown

