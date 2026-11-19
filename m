Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795047921;
	b=UVz+bz6JDC3oYdYtzz0JBxuGvpIQuJbIjQY/FEDv7e99W46zL1IatdJ+3tclJ/u7Uh1i
	 uFUPhf9UaV7UG4Afc6b9mgqITC5BgtQzFLSXSApzYy71knBVRZb+vDTEjGd7yZOJ6JdsC
	 VDvWeMf9fPlS+v/slXoIQinI1i4yo2eGALlsM2yNylQ/G7AnzdgaZGqTxSdQjwn0qrNI3
	 hq8OSv73UeeQknMh16hh+tLNiR3YqVEaS//ehBsaQIkRtot0AL7XdZL8SwYfSyRvkYOc/
	 agpXpSpbuCYCw1foBSEhwMOejwEQZHFY+GvZt65CCwFBPj3L01ceP9/RBNYFJT0yhLg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047921;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=M4+iI66pVBP+4vibL3T75xrw5k3lOfdLMjtLDFVvV8g=;
	b=wqeSsJnSj5MnLz9/TWsk4OfI0vMb2UvbiscxK8AdRPTtNbNU91H9yKKq84NwEKy/TfkJ
	 v6DuXivfKbawx9ZesCwew1jiy9o+m4C9ZiLuBIbGnZkdkX0igNFx+9aIHhT2Whhg95zhC
	 izBY0jj8woMlzgewpN9LqXbCymQdp82vS3pTmuAv1tO0JtYgTlMoVQx9vs4rnLqpBYmCn
	 3u8O94/xEwKaKB728IE6A3NB53V4HA6i6AcFkrFg01GO2cHWfNji4arxERD3WQPVleIKi
	 GV06/mtpUAYAUZUUq2Mb8cU5CjIFbdeLZk5GM4+ujT4r9NwW8nD5IkwWJqDwDtBvvRQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=figiuMqN;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=jLmZwlYf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B33360A2607
	for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 00:25:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B33360A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=figiuMqN;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=jLmZwlYf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795047919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M4+iI66pVBP+4vibL3T75xrw5k3lOfdLMjtLDFVvV8g=;
	b=figiuMqNPSbJSC+rppKYW73jTrxg0F5RFlFTF8isncIxQMPE1WxN7Bn1FHZTvLkpofJq4d
	7m420J1xkEdKbn3Rcx5/MaC0RJqvUstWY08DU3pgmjHol80seQFiw6J/Lwkk9/s2t1SRbD
	9rIFexGnSFloom9KDpPKlHqDR/WtULw=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-0X0TNq6bOn6pSuwFvwhQUA-1; Wed, 18 Nov 2026 19:25:18 -0500
X-MC-Unique: 0X0TNq6bOn6pSuwFvwhQUA-1
X-Mimecast-MFC-AGG-ID: 0X0TNq6bOn6pSuwFvwhQUA_1795047918
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-8b3b7d66416so21995307b3.3
        for <linux-xfs@vger.kernel.org>; Wed, 18 Nov 2026 16:25:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795047918; cv=none;
        d=google.com; s=arc-20260327;
        b=bkDRDTjFRhTm08lvX7qC+XUs2YaWQGR33rI1bbB+wxcNLThMirEzXmzJcB5goCXe4M
         qzEXYhxXhM9hUmz4dSAGBpTlBBIdBzsE2ks9OUIIMzbTSmNhbACvntpRlIjJ3YSsap8F
         1Vnhewb07bX2IPnKmBPPEd56K9bLHMZ4JyTil3YC+cbmV8m+o1xvzX8xPAVo0fmNeU62
         i6ICiVx6X1Fl/WnLEY4rGGGzTi7X654rmTgVw0XycGFCfmRWb8Gn2a3w/kdiSksagmNt
         CBICPZwz7hID4HIQe9Fh17OmFh676UBOxEO10CJQLzwpbiwibOTGtjDpgFGd5v/heikh
         Pzfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M4+iI66pVBP+4vibL3T75xrw5k3lOfdLMjtLDFVvV8g=;
        fh=5iG+FU9bRQ3E/6P8vkkhwZjklQrcxgdZF8BpeClSsMw=;
        b=mM7cxPM2tNII95DFANaK6r+THXTOnKMu0A5Ke8AUD83lHptPN2RtN60NjX/mO66cNT
         NRO0/NwIgCEQuVlQ2+ycrPs7v6uyzIddQQe5mFB1FzyElCVnSK2xam7voqd8S8cp/YQP
         vv4cxFz8svTQWpgJZ40wAdiRdAV+xccXoHjfUc6HrC+pacXU4yVo2vdbaTzyqojVor/N
         V1KaN4wRxh15VO2L3sOwGRTLVQxsaw0uM07Sbw0iwMHpYlz9v8+6zDbt1HduWjJgRbKV
         kkPvF2vau2uiQwHyJCxN3FCDh1lQTfhJJZl9GJk2yqKVnYuAQwPf+U5oepQy9OAoABoL
         nPlg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795047918; x=1795652718; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M4+iI66pVBP+4vibL3T75xrw5k3lOfdLMjtLDFVvV8g=;
        b=jLmZwlYfC08YZsE7NZqnzqtNRb9j7+aWTCuWxNICrjRgOyTFNw2qopsnuLRIKtubge
         SyXrPiBDCQfpf0LFFRnDSd+DIvFVRdzG2YRu9TCqUWK5sNv7Z1Uqn0gq8SiaOlKPnhfx
         uwT+RdU4FB8YJp4P2wKoF5+dFY9U5Fp4TdN7E6eBfBuG3jnkqe/LADQMCJ9ORFvAB5YH
         dUxaSUkERdpNg7dEcsiG+UJAFXBupr+caaYglv/xdghZxNuB2GxSqwwO+wbPY1eT9tFr
         3kDm+8le+U/HRrD6tSfDTtROC6jjC/U8tYVoT22aRwCOZWnqBE4ln02mMJtObVuxWXDr
         lllQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795047918; x=1795652718;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M4+iI66pVBP+4vibL3T75xrw5k3lOfdLMjtLDFVvV8g=;
        b=vMNL2MJrHU5B3QORw1xd+5WCz3xoKibuEUXxFOJM7cUJPj13bRfbYvkCJr5QXX3IbU
         MojCaqGlMDEfhC9s6JEcsrtPO4uie+5oa/YXK0CdC2qNets+/qJEu1UPmTma0IRoPFmS
         SS3+rAVIwjKj/vOzDGA+S1NnzezTqgaQ29JveIwwWgOzP3C3RvFLtdMqjZ56g1Ds6Owz
         +1sJlaVSNzQHHlkNH+wUe4plW/V2CkSwlKnh3W9CihC6NjLeywgjePDPC6EMern5RMfk
         icjRJwmfZkz9ZU2/PB/IvhgzIhJgGaQZkSJm4CAY2nrY0dc3QrPezJfbnObIubPZ7WQS
         RZfw==
X-Forwarded-Encrypted: i=1; AL+hErG9Iu8GlDbqlN3pRXaXHFA1lrrA9hzsdH6e0w9WIVa9glglHaU8poR2EpHbuyFI5uoTeD3KNLiaZWc=@vger.kernel.org
X-Gm-Message-State: APuU4Z++mCqVjrVpSdRGctTCWzU8Qj0WAOVY+5Okvb5uwPkdzzQXCHEt
	X6OKcQqSuy7LVs4P11CiAuVi6RRAnN5glRkLSqi9nuWJa4z1A1ZNx9jgUXyU11KS8KFKCKb98qm
	O3pbuSXisuKb5oxZUSZINRe1QomqQmw6/50OnJHZm1eeZAXVoc3H0vT482bvHQj7DnlQeEAX2zJ
	EFn2gbS1rr8c3bt0ed0tBfqSzu1lwLYh8EcR2F
X-Gm-Gg: AZFdTZfUbbZpLV9/EkbuHEowSu8dgBD5V3gqeSVep1WEWsNi6CRLKcnHTUFYPLvxirG
	CK+gMfUO6cwLb4+n1gPihJve95JWGLMi1+w92Bf1VA7IKTQpTQXik/o0b6BZpFAWJb3XqMPei0r
	nrg+ZdOaSNdw3r8u0QaMtCUmW6ScF4oWeCe2SpJ0rvUwb0TrgNRmukNuxIAjUIwfJk92iVqO/rj
	bzfMa89GawlwIoHZ8G5jwByXTPlL2YUvhllrmANCS+MWA==
X-Received: by 2002:a05:690e:1553:20b0:67d:b309:a247 with SMTP id 956f58d0204a3-67dd3f89d1amr1300403d50.81.1795047917499;
        Wed, 18 Nov 2026 16:25:17 -0800 (PST)
X-Received: by 2002:a05:690e:1553:20b0:67d:b309:a247 with SMTP id
 956f58d0204a3-67dd3f89d1amr1300383d50.81.1795047916923; Wed, 18 Nov 2026
 16:25:16 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116171044.6938-1-jack@suse.cz> <20261118145941.1063127-21-jack@suse.cz>
In-Reply-To: <20261118145941.1063127-21-jack@suse.cz>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 19 Nov 2026 01:25:06 +0100
X-Gm-Features: AclHuK8SUbQZgISlLcenRaPXTNhazVJfuhMt4GCT6fjiABD73HgWRuB83sKw5Dc
Message-ID: <CAHc6FU7qgJ1R-bz2icUyQTQFs7_mKt=tat-ut66K-cgn-uet3Q@mail.gmail.com>
Subject: Re: [PATCH 08/13] fs: Provide inode_or_folios_dirty() helper
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

On Wed, Nov 18, 2026 at 4:00=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
> Provide a helper function checking whether inode itself or some of its
> folios are dirty. We'll use it in filesystems instead of direct i_state
> checks. Note that this check returns true also if only timestamps are
> dirty when lazytime is enabled.

This is confusing. Can we just say this here?

"Also returns true when only the timestamps are dirty."

> This is what users really want.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  include/linux/fs.h | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 025f5d890689..f602deacf953 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2228,6 +2228,13 @@ static inline bool inode_is_dirty(struct inode *in=
ode, bool datasync)
>         return inode_state_read_once(inode) & mask;
>  }
>
> +/* Check whether anything in the inode itself or its folios need writing=
 */
> +static inline bool inode_or_folios_dirty(struct inode *inode)
> +{
> +       return inode_state_read_once(inode) & I_DIRTY_ALL ||
> +               mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY);
> +}
> +
>  static inline void set_inode_metadata_writeback(struct inode *inode)
>  {
>         spin_lock(&inode->i_lock);
> --
> 2.53.0
>

Thanks,
Andreas

