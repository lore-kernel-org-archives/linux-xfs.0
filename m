Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793225391;
	b=zmW7iXsG4CQcfGKqOGPpytHoOmnORFIlm3LGTGGd652XwmT4igeQMFV7BbM7ddFt5I3l
	 i0m3I3IClrFU3mMOma4g50UAmHPuJewFwzW35d2GcYvKbJvzj2kmYwvHvGTVO/Q9C4dFq
	 gYzWZdDqlt2bM6IfqEGJN7bI5T8m3xrOYPU5d8NZSSXbqKSJGDZgzHmRqic7i7x7OgYLt
	 SgLyjfQGOBZEnI/SRj8qPPKYol7om0U7tIXvQr/7aqTWAEDOuDZumEjpqkkDJVxh03+ou
	 Ao7Ug+jehnxdWztUWcBxQTzO3AUArg+Oh4PULTM9pDny0FWpfTuRLTYcQld+dSlSe+w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793225391;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
	b=ho0nHoYegAjimZ4GblTsHMKqeU4ocNRLpi7zBTge+aFPHRh4jfyc3eHT2gtcLhQamRLE
	 5LJaARMgYTj83xIeY7eQxrvP2blBNnMFNxV7ID3gjcut/m0Q7TKn4bVAgrnp4+F8aW3nC
	 E4K/iViATq+3rwNs1t/sb1MQVK1onWgbYO5yDU7tc3LaB91IENhMVZb+8qg0Jf46AyvW8
	 l2ZPBqxSw+dZ6MEAQ9g7wfmdxPlVMqBZeT9cegdo2SRP/ToKeWDIzq6EQbzRU5n6t4IWi
	 Ty+fKK+cIo48SAFy5rpFUSKaJH2Rv+HX0g2FQvChW3I5gOgZFNVdzTFU2fggfIionlw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PNja0RrK;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dMvVeWef;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A594D606A31F
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 22:09:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A594D606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PNja0RrK;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dMvVeWef
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793225384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
	b=PNja0RrK+GAXFseGHRAPgDcQljq0pWRU5IrNz2yhBUldeqB5xObADIbjyjHyNHrutF7Pt+
	rJoNk3kv9NPLEvl8XKZoimFvycT999RKjoXG01AAR++Ak8kkM30MDhOQrx+KtOHBWo5kfK
	yRocWGrPgLWx6N9WURbn5mAhp5Y0UlA=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-440-rXWN3Jm6OqSzD0CWNmLNBw-1; Wed, 28 Oct 2026 18:09:43 -0400
X-MC-Unique: rXWN3Jm6OqSzD0CWNmLNBw-1
X-Mimecast-MFC-AGG-ID: rXWN3Jm6OqSzD0CWNmLNBw_1793225383
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-6756044f260so288261d50.0
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 15:09:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793225383; cv=none;
        d=google.com; s=arc-20260327;
        b=iPe2q4MsemkxLZd6sbXOjS8gOR8rm0wsNdLbeCXt/6VYsCsNd0Q0YYrD1ANibAumuI
         lgUiATWSg9VSHkdLBfA0dcscBbEKJfL6SVe71YnVNPO7vN59lFBu5cV9+J7Hftlf6x47
         UbRw/yTggXUwO9I4BY2LQUsan8v5nNydfdkY6O9fvY7eQQRW+4ErrtA9uQMIyx/Fcv6+
         CwjBHvNzq7HEkw4r56YnP3QXORG+fLWGYDeH3BosNABlQKZpIIIcPgP5lOHXNaCRLLRw
         czUnuNuLCS6LGFIO3lCATSx3daL5fBsxszOmlUHrrDAa1E4RxKFec/aetmClBJwyAS4S
         WlOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
        fh=CiCiEBXSaW1MqAqUQx0Rz3HqN1Xn2UxsMpvJRyUobwk=;
        b=p+VI3EDD4CrWwr3Htw0kQN5iPHVey4CPAzyqy3gTXqDTQKSCSpwATBUGZhxyDkKhc0
         P7/Tpy5ULkAeDju2Olyj/wtVKEcrHm0k8J+50Quv2NiJ1OfKVfDwlr0qpJvvVVhWxWZL
         VqqRY2JFStm59Sfqo6FzN1clOy0w8qGitjh4j5GhL5KDNAZwNGomDBkbFYYX9Dv34nc+
         +v5QNwTZQnPvcSiKMRuyOyujQC9n3MC5JJrXJlEYux02u4GN30lT3JXCVjv9AvJi2/Dp
         e5sdiSLQNqodf6cZGCZgYr4dIwmA7pOdd3xm6Pc0SYL40dnLdKiOWDwHy78NLmJAYNAv
         qgCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793225383; x=1793830183; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
        b=dMvVeWefC8P+UdQKNVCTRzDnhWHngZQGob2rSgzwsZSnRN8SAHr7CL96OPYJXufFq7
         zSTFFPllhPr/w76wrseeWsykFIT3XNeylizZvRvScikFw2Vx8ZBVf5aKYuJSSTUPuuch
         XBaTxNgE5Gyy25Odb94BXqgaNMMlvyhAsHvl+cohQ1ckCaDBDm4+NkPEdFeD/j45D4SX
         9JdubWa1Rkola0sqbNiDrUuR0ynjj8Js5euvpFf83x/dOZOzpzImQtYe9Q9exxMiq/qr
         mXS/pEC6VjG6Gc4ktJQ1wDheP9WEZsIfL+MfkoZBHHuqMX4NfKOOS6gRPfYVsrX4HqWa
         L7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793225383; x=1793830183;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
        b=Hesu7B2Xo3V5Uy9sItksqInaHFho7for+4hHdPrfCreVEgWplj0o+BzLhIjDzj+g+N
         7bv1OZono09rWkzX0Ur8sm8/FaJ+muQ/B+fSJmeV1ntnk19rGI4PRtI03mkLEPnr97Nb
         cwOqjXasjR2Bq2eVW8gaInh1Hlrj/DKwscqTlJhiFQmpCoirGAk+V9bW9TGRzbgeGcNk
         L4tgtKWsKDWuLb+DsK0YwEbKMplMEbHv+z5XTTmZm3hWs2ZRsc23O81K584xyigtvYqV
         3jSsI+EJvwC2DAOnFPhrBvIYLOHe0XcGGNRHojHJhh5JZOrROFa/F1faLdrV1SLnuC+p
         4wHw==
X-Forwarded-Encrypted: i=1; AKwUvBzIUQYNoJfnxYE9S5e7vunpX+UthZKqKdBHUqFGSHjn7g7/Gq+JP0tzS2XrwZMXUE+YWqOKtfPf02o=@vger.kernel.org
X-Gm-Message-State: AFq9FYINjj+RC9NKbRc0jgp8CRBhrzT4Rv5SM7OSa2OwHkKfK2MZhE2P
	Cl7IPgCCOSzA2B/nRg+8ldpc0M+bWD1aW68QXQygdzUkS55KEtuRBZKFq80j0YBjTVZwQVseFKR
	PRWajQUEy7T3598eZ8GvgZKTflgXU9kKVZ9K97oniKsORUUBiET9ZETsMaIaXsssnoo7ezJSzfv
	Y53YgiNZ76JPZ4UIy4G4Xb2W2lQtbMoV1LT7iS
X-Gm-Gg: AYBFou1o9WNVDE8ebCk1+xt0H9c7D20WR0C245G4LTILpJolh2bLuaHMufMACfrvmJm
	yg7NBcgV2Ejsb+ittqMymEKYY1gewT4Mle4fDQjcz5h3kGS7fIZeq/bhPmDgvy9zkTOiq2vA55m
	9UN/X+n3wAXcpQp/zKAGTopFApmxi3hPZeFGv7s4daZt3ObLdrAcb7zocVN3Ll8jd5RCZ6EDGIj
	nyK0inNWe4ZkWlphU4EC5w48cJUQTQ2az6ThYbMonHwVg==
X-Received: by 2002:a05:690e:1918:b0:679:ad2f:3fbf with SMTP id 956f58d0204a3-67a8d0047a5mr704864d50.8.1793225382832;
        Wed, 28 Oct 2026 15:09:42 -0700 (PDT)
X-Received: by 2002:a05:690e:1918:b0:679:ad2f:3fbf with SMTP id
 956f58d0204a3-67a8d0047a5mr704846d50.8.1793225382297; Wed, 28 Oct 2026
 15:09:42 -0700 (PDT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-21-60743a3dc326@kernel.org>
 <CAHc6FU6z4kX5R3Og8m0dYOHsjFcw+4Btvfe87AGPxy_EWs0E7A@mail.gmail.com> <20261028-zurschaustellen-okkupieren-inkompatibel-d11525ce88b8@brauner>
In-Reply-To: <20261028-zurschaustellen-okkupieren-inkompatibel-d11525ce88b8@brauner>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 28 Oct 2026 23:09:31 +0100
X-Gm-Features: AclHuK9MzobLdiG2EG9M5KT_ibZzYxdrTghiXff6ZlesOE7YSK8Ag_RtXekxyZI
Message-ID: <CAHc6FU6VSAWQ4RJTO_eLnpqN5qvrShbJeT+ADwiA6ohpq8dO4Q@mail.gmail.com>
Subject: Re: [PATCH RFC 21/28] gfs2: don't set SB_RDONLY on withdraw
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 5:02=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> On Fri, Oct 16, 2026 at 02:01:00AM +0200, Andreas Gruenbacher wrote:
> > According to commit d564053f0746 ("GFS2: Clean up freeze code"), the
> > idea of the freeze sysfs file was to make it behave like the FIFREEZE
> > / FITHAW ioctls. This isn't what the code is doing at all.
>
> That's a pre-existing and separate from this series. freeze_store() calls
> freeze_super() and thaw_super() directly with FREEZE_HOLDER_USERSPACE and=
 never
> goes through gfs2_freeze_super() and gfs2_thaw_super(). So it never takes=
 the
> freeze glock. I don't think that's for this series to fix.

I mainly wanted to point out that this behavior isn't intentional.

Thanks,
Andreas

