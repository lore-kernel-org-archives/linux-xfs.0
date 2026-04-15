Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B453A5E64
	for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2026 13:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776259457; cv=pass; b=oFmuy8tbnK/ciX+DG9KPL3Gt4bJ1kvCAZoelwDod3DSxskF8cehuH7suNNGOggrzaMXYIMYDKq5puP09sB+oytD/zoEfYlMZIf89yRhIZZ04ANcRRbF3MoLwVUqTWtNdO27kc/j4WvI07bp7+1lCIoBxfMYfxv0THquXJbVw2+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776259457; c=relaxed/simple;
	bh=p4Y5Pcu21usvk7w9ipon8j1IaaG9NHtcgi8eCmSKFTQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mx63yYgRGTAU5DsCooVt1a6Y92UU/RW4RFVGHeSDUn/QDQIHXOVkli7hq0FQk0fFWrzI41WI2DCw/mYyHjhbrK9XVRzfVpim3mr5B8mMcDkma+xtaSo5honYUiZgvrO50FHKCYEBdIt7gS1LY7a1dJIzq7PFObXV/IYfs7/dMOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aTWyuEtC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=M+Qiyb5U; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aTWyuEtC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="M+Qiyb5U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776259455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p4Y5Pcu21usvk7w9ipon8j1IaaG9NHtcgi8eCmSKFTQ=;
	b=aTWyuEtC5mextQDBDmK1JdNFO7YSqFizl4vvJrJNFmT6hEP7U03TD0g5uxog6KIeVUtLVY
	Vb6JeSFbLOvbbmi7y8BJAzwZeVlAngezTm7HZ3mgO1dlkRrUqaLk/0Gc1SvCZYn4VBNiI8
	WPcdOlwJyimD+t5abg7L1+Hy3hA++Ko=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-egUvqedKMEK74eb6k_SuDg-1; Wed, 15 Apr 2026 09:24:14 -0400
X-MC-Unique: egUvqedKMEK74eb6k_SuDg-1
X-Mimecast-MFC-AGG-ID: egUvqedKMEK74eb6k_SuDg_1776259453
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b9ca1ef3403so380575666b.1
        for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2026 06:24:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776259453; cv=none;
        d=google.com; s=arc-20240605;
        b=DOvVJcJSmh5JpzzTIm0lw50BbgMaYaWUcEZbKBuIH2sCYCm9xJEIyX+6U5ITxwTzCs
         zLkZxqp15YabDUFkN8QIgADDmT9GKJxWaTU5FdxyOXkEgAEne75cumxLzaGXmzasCufD
         Qv5KWlR+kX5aaKOX3c41/Gc5vg0CUQdjw1da7o558qgICXgqCjTKoAoQA3nysQgkxQyM
         5WiPwClOVxUDydPQ/S6orpDhMJchI5qHV+yIFmiR1K24/fYmudFtDAiEsDTMMfC3e65i
         MrUIp/BO2/7HLWFyt42/hHmx7KFmLgCqdLXLRBqfVXC+62Ss6eSL89LtD8hkUmNF+gi7
         PXNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p4Y5Pcu21usvk7w9ipon8j1IaaG9NHtcgi8eCmSKFTQ=;
        fh=clwkdnuvt6MfNmx4IuNEBXt+jxiS+Mutcf4dJKVBWiU=;
        b=SVh8eWRfJ9m8N3YYd0gotGK8DjTFyJjUwX/3zosRMyHYPVVgKqDrHXJYB2V6lZC1BS
         gAcvUztkW6KEZUtwbscuTpRiUnkkBWFaRK9q6i6/ZRnjm1FSoNKq3Mjt01D2JOPcte62
         ml954pHTqIp3V/l+pP9cPFFISl7kw1gjZxg7zMSxdq0eP7+7SH2Zd5XDYkKrwLYJFh94
         IH+ktw880/wk/lKv4mQO2Gl4U1utK/E14g5XBg378sL5q1fH4md5JOqdz1M06d2Awd6Q
         Q3feU01B/9BbFL/6Vxrn0FlEQXawPpCYoYdImon+cZ8yZZRE0joGIprwl8WUt6lED67Q
         9ZDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776259453; x=1776864253; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p4Y5Pcu21usvk7w9ipon8j1IaaG9NHtcgi8eCmSKFTQ=;
        b=M+Qiyb5UJfulDAaIUJkWCDV0zGLN6haBWB4QmxF6FWImSPRgQTE6YhAyFoGYAgz7WG
         IaV7ML17hqKbvif1k0xP4XBFY1e+yeEh6Nb+3m8dnKc2gYOsas9+o3XnhZ0FsG5VAgu3
         9JnYiZrHyH+UzuNhcK3+ckHAwacMcgxQcBT2JNO/2xBSYCZQbVpCB0yeTWtyPMcHr7yW
         m77YswxizNGkMXRTBWKAyC3AetoCK9zUf1Sndxz33A0NX3RQAk8Zh+ClO9m6ifktbZTT
         toh3amJUaGLsHjRkqoQJ+qfKt08LRfDScNKGScKpSL5lDxdxCRreVnEWmFqZXP0734Qn
         l6lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776259453; x=1776864253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p4Y5Pcu21usvk7w9ipon8j1IaaG9NHtcgi8eCmSKFTQ=;
        b=LesSbyqPP9Wht3rvYfFVI0lDDWSK/bK8zV6JyHXQaDDzPgLN7VIQQP55cQRx/Jmkgv
         jeZ/RvXIPTlyiZOpBfGnCmL5rGwr0uHjJZHgc5hROOlQeoRPSMdQhAHqDQbbVGREAadk
         9ipd7cg/Gu/nJ7WD8KYjTj3S6VmxXHQ0gleRWLd97nlLmq9Yoy8mj85LO8HXl1YYAh6r
         pEGCDpnc5nj27PdTmhgmgSCCOrGfFmkduoi5rNCT+IOdVFwgKZpIPGuVS6FKug6syMN8
         2vhZzhH2C33xR9Gua1NhLe5gLmfZZywOB6g2hyvVbiNrNrsmpKrcdlt5cy/Gq3dXfr8w
         Xrdw==
X-Gm-Message-State: AOJu0YwQ/N6ohwlSkRf31RWFhFEPjjP+iSENEf4jNdITbbtWAt70nDbO
	9opkI2p3jNbASk25Gs8mev7ql5bDWqv5hXj+CS+3Z/6Y5FpIRWUV064vMq/NmN+cDgUNXseNist
	GF4nT+ZW2kiHOAjGsPqOrlYLY3wTACifs/DV8MeOodjEujtWlE8Q8nSIPXsA3Nf+QGp7WCBgPg2
	P8IcKPfWbSah4i7I2V9CtoZCwlUoQP/i0CcrJz5hW1zgpvGj+dSg==
X-Gm-Gg: AeBDies1E2l/SYmmaiXq26CxkbnAyMP1PdxeehxCdOfSnGOw/rJdthzJVBeyws/c+ry
	28dJpeLb4EG+O4UT5VdqlyFD4R+G94yOJuPI1lNUtrE00OdrhKH90YR2kfeBzKKyBTQEu68AwwY
	VCK3v2mCESQ0FxWmSWOtQyN8cweYPrnekuFszrGK5MTdGzfz4zaLwvIdHYvo0KIm7RItFMhwjZH
	jLExbRN4vmriZi/qcG74zbENQW9/McinBeut7VvZUa9qKHr0A==
X-Received: by 2002:a17:907:3d9e:b0:b9d:ecc5:5981 with SMTP id a640c23a62f3a-b9decc55a4emr591881766b.15.1776259452714;
        Wed, 15 Apr 2026 06:24:12 -0700 (PDT)
X-Received: by 2002:a17:907:3d9e:b0:b9d:ecc5:5981 with SMTP id
 a640c23a62f3a-b9decc55a4emr591878966b.15.1776259452176; Wed, 15 Apr 2026
 06:24:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260415071657.23412-1-ravising@redhat.com> <ad88TluB4FIP3yJV@infradead.org>
In-Reply-To: <ad88TluB4FIP3yJV@infradead.org>
From: Ravi Singh <ravising@redhat.com>
Date: Wed, 15 Apr 2026 18:54:00 +0530
X-Gm-Features: AQROBzCmsDNxQUjb9Ho7c-__m1Cu2xEB0WicLl6xTFgmVY-2qbeWoPJ5NYcxSko
Message-ID: <CAF-d4OvKZOsez5589KUYTjRz05PQHCQ-uRkXu-3iaO3tOjcavA@mail.gmail.com>
Subject: Re: [PATCH] xfs: flush delalloc blocks on ENOSPC when creating symlinks
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, dchinner@redhat.com, esandeen@redhat.com, cem@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 12:51=E2=80=AFPM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Wed, Apr 15, 2026 at 07:16:57AM +0000, Ravi Singh wrote:
> > When creating symlinks on a nearly-full XFS filesystem,
> > xfs_symlink() fails with ENOSPC even though space could be
> > reclaimed from speculative preallocations. xfs_create() already
> > handles this by flushing outstanding delalloc blocks via
> > xfs_flush_inodes() and retrying the transaction allocation, but
> > xfs_symlink() returns the error immediately.
> >
> > Add the same ENOSPC flush+retry logic to xfs_symlink() so that
> > symlink creation behaves consistently with file creation.
>
> While we're at it - do we also want it for tempfiles and scrub?
> i.e., should we move this logic into xfs_trans_alloc_icreate,
> similar to the quota logic?
>
tmpfiles and scrub tempfiles are created without
directory entries, so they don't need a new directory block
allocation and don't hit this ENOSPC path.

As for moving the logic into xfs_trans_alloc_icreate(),
xfs_flush_inodes() is a heavier operation (sync_inodes_sb).
Pushing it down into xfs_trans_alloc_icreate() would make every
caller pay for that flush, including paths that don't need it.

I think keeping it in the callers that actually need it
(xfs_create and xfs_symlink) is the right scope.

