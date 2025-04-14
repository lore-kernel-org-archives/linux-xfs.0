Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7BA2820A2
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 16:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744649630; cv=none; b=CO1aCeRrzFW/58solFq6gdXy//ydIBEWaZRLyrY6RbjYLaZTa3WDSYWEu7fzOIUefTbl82gxYcb7Wjo3pN+t5A4No2+LSYKmXkQHtd7EQAJqZCtQI3jOM/4B22j20BJaukCzkG6r3JBqlVYPLUi/Ja5m+fvPEfNNcY9hFHPvT94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744649630; c=relaxed/simple;
	bh=DojN9jDozDGA7y9JQ1ZxaNSJ5v8oW3SRA6UhM/6Q50E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o5H5QoiMTJ/RXnGExuORe9DNe4FQSrWHj+7+Rb4hTYPSEWxBRx/JwyKQWDL/thyKu07n0m0QHNugLSIL854IlEB1CpoRtiCGOHC/AxFAroRMFL7hfYdU3/3329WQZEkyxzlXtgibdPj1lO3hVYhzvTjpM9HahHnX6CSyl0aoatE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chainguard.dev; spf=pass smtp.mailfrom=chainguard.dev; dkim=pass (2048-bit key) header.d=chainguard.dev header.i=@chainguard.dev header.b=ZD57E211; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chainguard.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chainguard.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chainguard.dev header.i=@chainguard.dev header.b="ZD57E211"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-523dc190f95so2197718e0c.1
        for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 09:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chainguard.dev; s=google; t=1744649626; x=1745254426; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oss9JVKjaq+x1C3a6qWnyqThPb7dKUsur/mH1WkKz4I=;
        b=ZD57E211Kl2Y5ObvtsQV1rLWAn+wuHi0lhQuL54At5TPW9cFg+E8h95HGboB/6ofrP
         f4wP2XmKj4uRvMwahMoAJyVGH1I55XPnYbEuROhUy/0hD6YwZ46HI/cFN7nc1YjkOqwB
         CDo/cmCFKSB/F0p/ESXqVV7Uea3T5NAJK3ayVEvimDkOKrL/97T95CahdxTHTAsjeb91
         cBXlChKcmpXzgbIvYy34e2QJZletSid8rwV1oohTm2nKVRCYVdkSnMRAOaVyk9zEAciy
         NQF7eodbop1FCsBU4PzCObjVRv7dDN8N5K83W+ZkOVXX3Xi7PV/whtYatfKTQpKsEtzR
         mpYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744649626; x=1745254426;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oss9JVKjaq+x1C3a6qWnyqThPb7dKUsur/mH1WkKz4I=;
        b=Lgll41VmIz717Zf98pKq0bj+nbMqroctqfxrjJWk9uwDvQCQN55fwiKH5humB31pao
         mG05lVpdrY+m1sA/9dg3hTyEJqI7g6/zODbg+oIT/Y7+I07l85eEKMPaEDzSvJY4yXgc
         zkpVNHo6nBFMyX25mayoq/nqPpSRrxIISq1QQ6Iq5rIq5Svj8lG21cLLEVZsTdV84z0u
         rjdXNUSgd6qgXxWfe+OoCtGlyjk+k+gi5qJB06q09c/3oipNKg/f7OheHSSmEtCOsEiH
         g8zdZe/oHWTQryOZL1z7UXifOjeYR5PfOo4HtsWX/PaLMI+XtvIgUMaNNbWTWTittm9D
         g8fQ==
X-Gm-Message-State: AOJu0YzL07/smph1aoi2DQSIz1kPA1treeQIYrSQh9DnerkJVKFOnx0n
	4LwHwsJURPHp120rqMm6oNQ1yKDe+CkmkEMNKCIgMauslHyJC7GuCTzvKU382wXf9vLVGfAx3v8
	77Kp75004kf2DgvJJUqBmXojT9lPzmeJCtRz2Ag==
X-Gm-Gg: ASbGnctH8UyWmxPqu3LZ1YyjU36AqYtZyb1rIbyWZAxp0z6yKU8tkgIO1SwrZA2Br2j
	DijCfgqe+vHFhqbyPObMXOXbT/6EHDFSn0PERLkIQ2Udu6sv33wPPIihHBF1qIpStyscKAhtkSU
	qUXKI2i9rFphJ98GL/8VFfBBVj9V3jG0mgbBlKTzKDD9pfzKOZfak=
X-Google-Smtp-Source: AGHT+IGEiXEVzB64Cloni2mw+sGnXTJA5vym4MQsjLEQJl8YYIzuJQBZx6jFrs552fhjcBMLm2RdBH5UgNEHMi3Fhgo=
X-Received: by 2002:a05:6122:16a0:b0:526:1ddc:1896 with SMTP id
 71dfb90a1353d-527c32d3ebbmr7756305e0c.0.1744649625753; Mon, 14 Apr 2025
 09:53:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKBQhKVi6FWNWJH2PWUA4Ue=aSrvVcR_r2aJOUh45Nd0YdnxVA@mail.gmail.com>
 <Z_yffXTi0iU6S_st@infradead.org>
In-Reply-To: <Z_yffXTi0iU6S_st@infradead.org>
From: Luca DiMaio <luca.dimaio@chainguard.dev>
Date: Mon, 14 Apr 2025 18:53:35 +0200
X-Gm-Features: ATxdqUEvEbCgR1K8gsQ1jZ29Fmm9X64NXJCWMNxyCm0Z_17EwacikhqGfK44SgM
Message-ID: <CAKBQhKWr_pxBT+jXpaitY3gz6wd1WLqyU4JwQoaRhzKWye8UgQ@mail.gmail.com>
Subject: Re: Reproducible XFS Filesystems Builds for VMs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Scott Moser <smoser@chainguard.dev>, 
	Dimitri Ledkov <dimitri.ledkov@chainguard.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Christoph for the prototype pointer,
I've experimented with it and indeed we get to create a reproducible
XFS Filesystem as such (still using that LD_PRELOAD trick):

```
~$ tar --sort=3Dname --warning=3Dno-timestamp --xattrs
--xattrs-include=3D'*' -xpf rootfs.tar.gz --numeric-owner -C rootfs/
~$ xfs_protofile rootfs > rootfs.protofile
~$ export LD_PRELOAD=3D"./deterministic_rng.so /usr/lib/faketime/libfaketim=
e.so.1"
~$ mkfs.xfs \
-b size=3D4096 \
-d agcount=3D4 \
-d noalign \
-i attr=3D2 \
-i projid32bit=3D1 \
-i size=3D512 \
-l size=3D67108864 \
-l su=3D4096 \
-l version=3D2 \
-m crc=3D1 \
-m finobt=3D1 \
-m uuid=3D$ROOTFS_UUID \
-n size=3D16384 \
-p rootfs.protofile \
-n version=3D2 disk1.img

~$ mkfs.xfs \
-b size=3D4096 \
-d agcount=3D4 \
-d noalign \
-i attr=3D2 \
-i projid32bit=3D1 \
-i size=3D512 \
-l size=3D67108864 \
-l su=3D4096 \
-l version=3D2 \
-m crc=3D1 \
-m finobt=3D1 \
-m uuid=3D$ROOTFS_UUID \
-n size=3D16384 \
-p rootfs.protofile \
-n version=3D2 disk2.img

~$ md5sum disk*
dd06b8c8fe79e979d961291a4f78b72e  disk1.img
dd06b8c8fe79e979d961291a4f78b72e  disk2.img
```

This is a huge step ahead, but we still are facing some missing features/bu=
gs:

- we lose the extended attributes of the files
- we lose the original timestamps of files and directories

I see that the prototype specification does not include anything about
those, are there plans to
support xattrs and timestamps?

Thanks a lot for the help
L.

On Mon, Apr 14, 2025 at 7:39=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> Hi Luca,
>
> On Fri, Apr 11, 2025 at 04:38:10PM +0200, Luca DiMaio wrote:
> > EXT4 addresses this issue with the -d flag, which allows populating
> > from an archive or directory without mounting.
> > Is there similar functionality available for XFS, or is there interest
> > in developing a method for generating reproducible XFS root
> > filesystems?
> >
> > I'm asking this because we'd be interested in using XFS as a filesystem=
 for the
> > final product.
>
> mkfs.xfs supports the -p protofile option which allows populating the
> file system with existing files and directories at mkfs time.  Can you
> that and reports if it helps?  If not we might be able to look into
> fixing issues with note.  Note that the protofile is a little arcane
> so read the documentation carefully.
>
