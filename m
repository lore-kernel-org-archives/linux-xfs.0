Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F5E2F2619
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 14:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782485494; cv=pass; b=fRAujbhyryFMTkUgMY9mgOQlsWjwrXIdKx++owJCcKqJMDuYIqO7o+ezBIYPHVRTx7MzR1GjQ4JJWrRBqrQMxvT6skSVux+xtK5mVEHAfPugsLY2mYveAWwS/pP7vft5oUz6f7/1GRQ26+lCmYdfp5MpqiF3DAepWvvqw47Ytpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782485494; c=relaxed/simple;
	bh=F/vTTa+gFZE1/PfB4U5xRpdZYv0DcxHltEmaOMRgRKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OHR5Ari/PoKFBCSixD+Sm02hr7FiopPa0QInDZhzmY+rfGpSaIwK20F8UNv8zKyMcNBHIw6DO/nwO5VwxsxxIuoHNYyDsNBs4rYgtmkRRI+1sxwcrCMageYmNC8hsoKASQad/xUW3lfZ5PriK2RhEO0398R3dgCX+KWfBhA2Qkk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ps4hgRy1; arc=pass smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ps4hgRy1"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-46066e640easo580738f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 07:51:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782485491; cv=none;
        d=google.com; s=arc-20260327;
        b=KnGt0xyprkC9sAG/ni9TAGlF9SDRnq30MS8GzfXeG7kezk/IXi92oLk1rO/9rOKp28
         /jcLZrgYItAGtp1wwo9gs38zIMWGJeaum7U00fQu2/+ttR7DnvDXXu40Pnk6FixF6On5
         9UyJrW6F1x17+rO/2EE/YaSIAG/f3AkKVlWq+eplz8VyWF638ghHhGR32Yb3pwd7WPKQ
         5ueBPOWmB72E2E8QkFKM3ug1YhwdN8rMLZ8U1W8btaxU7eSNKkw3b2X4qCq6riSmi6AQ
         al6cbwPdLKvf+HB/xCUUM/xd740nnFXIEic1bzR7Hx0VGzW05JkpgepuUkkSOZRutJuG
         tTVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qEFu/GsLUdYzJ5HEI3yfKh2VsiakBP97CsT9SHwpvI8=;
        fh=4KuxPtr1Ngwz/eBoHuSJUcJFwBFzcsg20hc199AQpmU=;
        b=iKGM2Kt47U/Y/nx4oI6xxk5kCGSWXzEqaRr/ZadK5S3JX3uH56SIYbK3e5N4K4/TWy
         HNr41gymezMMmj2jpsoOPQ9FHPj9Q9H+h/fGfUZposT1R62HWbFggm6CUbnxejjkDdju
         qPQ/Y6UgT0wiUfoDA/ktTiqyftmeSg2T2Ov4ugOIU9SeMBpYs36uxMOeMFAhuJYuUe8r
         63DQBfYFKYMVH9N+AAzKUhntMOqaqfDglebrY56Q6+S0v/ckldTr6QCp+o4I7w8T5JrX
         FQWnv6PnjN+e39lE35g+/J7ssv4Yu9q2HFaxWQBzq/fAmUgKZLOmUOdmpvV6GrpWjITt
         4JNQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782485491; x=1783090291; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qEFu/GsLUdYzJ5HEI3yfKh2VsiakBP97CsT9SHwpvI8=;
        b=ps4hgRy1TOSS9Riyv3W173MqEmxS0jYow5bSnuvVnKOOWngRr9msR0u/sU4Nz66e9A
         KFzMejI8vHcUiFAGV0qXjJliUOnN+laMroqRrzAApP3BCZeq1MO2Pyk4wAQNhIQkQLoc
         rgMUGsC06Kp/yaqAQrwIOAW2FhzEEoDsUKtabw2AsStH4xzvq5LPUB1sHTUedthWS4WB
         jdGIRKg7TywTT2XMl6dBYB3vG8gw9GLR3KpZ4wmrFkjR+c790I6LbHtKKplq2UGcpD08
         zQxbatEmWFt2p9PFrhF2HVxHcV/gEeluH8H1EUgZA/dre7weEkJT9H/m1r9GvlFIiOFF
         O2MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782485491; x=1783090291;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qEFu/GsLUdYzJ5HEI3yfKh2VsiakBP97CsT9SHwpvI8=;
        b=Oykrz7YHa8v0/lx+Dhh+hIheuwtNp3Tnno2vTHLG5Ch+oErOdB0AtQtKrgYz+p4RAT
         MhWJv1sAJ+NxnRArnD+WzUpfXUvowpD/VfVUdRu75fFBV8e/HK5xGAG3JNvHQmsUfRui
         LM8PAMer2oj7iYeqPltJ+MJhpfr0N7kXvc4OiCAVOrWDET/8HRYeZfrQdBg2jc8C0Zpu
         3WP9Wm+b1mJorrAaUgoeDALDG2rz5HEHxLdyJGTROtl2Z2dU7k6E5Z3QO8uvNJHcj8j8
         UcUMtc9mM13N6mddTXgmnksTBtd1ErxfroSCLu3QmcYKWLr8LEuZapwbJPBBiHXx1UKK
         jsNw==
X-Forwarded-Encrypted: i=1; AHgh+RrkI4iJbUio14lS0rNqa+7OlZN9ZHc7JVVBWGki0RfAGZuEqyw3QuCtY6nnh/0/IYGbOs05gIeYqII=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBaDW7kykJliGVF0Dugzs2esKgT+PBmzhsQOlO4AO+KVsmnSWJ
	x1bnnVQBr9aMJoDOJeG3dqfMwRXr3TgwMLLIc9vrmOm19GrLg0H8XdZ8UbpYdgl7yTmFESAJ+jZ
	SHvnefXcyozzYnY+KYqEwJ+qjNMmZ2S4=
X-Gm-Gg: AfdE7cmmC+8dY9+xymi8YxVDZSxPavOLxU5z3tBUE1gTw++3+fg9BMtZ2JvKY0a+la0
	oggJUlW+kyKSCP+vIA+tVwExeOmhmJebFodY3loFCPyIfJWTtGC25TX5Y/qYs/+RGFtghfOVFkU
	NpAv6Rci9Ixcs1UbsXxi86zkmwvtd/Kg3lnKoPkftV4I80kiKQ4di9vCihhZLhyL5WAuQdablHC
	D3sE1DDLmOV+BxM6QQ9A3J01Qn6Q/Fb9PLvAQHTzf1dShQQy8OmwWJ2UL0cG4kKJORDrDpcU7ay
	ShmwTeMOXfHQLm3GqgARZt8U8xvoFFVuSJh+YfVdbkiZKHC4qZpAW/a6EDFywCg=
X-Received: by 2002:a05:6000:4b1b:b0:469:3037:37d6 with SMTP id
 ffacd0b85a97d-46dbed361c5mr11889497f8f.2.1782485490511; Fri, 26 Jun 2026
 07:51:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260625120803.2462291-1-hch@lst.de> <20260625120803.2462291-3-hch@lst.de>
 <20260625174758.GE6078@frogsfrogsfrogs> <CAJnrk1YFeirQ4g7qcVsda-8qPLeAtoiyW6ZBuJb2qDsGpxi-tg@mail.gmail.com>
 <20260626043319.GC8078@lst.de> <20260626061637.GA10337@lst.de>
In-Reply-To: <20260626061637.GA10337@lst.de>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 26 Jun 2026 07:51:18 -0700
X-Gm-Features: AVVi8CdX3YEuehBm4GMevCFp3lRCSJHGYeePQFfRezoeBrVyeHAViWscCz8GoDk
Message-ID: <CAJnrk1aJbQ0092f=wcTu8v62rdxZ7-NxyF-1vp2e42oSEo6LBA@mail.gmail.com>
Subject: Re: [PATCH 2/2] iomap: submit read bio after each extent
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christian Brauner <brauner@kernel.org>, Kelu Ye <yekelu1@huawei.com>, 
	Yifan Zhao <zhaoyifan28@huawei.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2026 at 11:16=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> On Fri, Jun 26, 2026 at 06:33:19AM +0200, Christoph Hellwig wrote:
> > On Thu, Jun 25, 2026 at 11:32:40AM -0700, Joanne Koong wrote:
> > > Yes, that works. I think that's a good idea. fuse only needs
> > > submit_read logic for readahead. The change would just be:
> >
> > A nice, I'll fold that in.
>
> Btw, can I get a signoff from you for this?  It looks like splitting
> this into a separate patch actually works better.  If you have a
> preferred commit log I'd take that as well instead of mine.
>
> This is what I'm currently testing:
>
> https://git.infradead.org/?p=3Dusers/hch/misc.git;a=3Dshortlog;h=3Drefs/h=
eads/iomap-read-submit-bio

The submit_read logic is only needed for readahead. We can remove the

+       if (data.ia)
+               fuse_send_readpages(data.ia, data.file, data.nr_bytes,
+                                   data.fc->async_read);

change to fuse_read_folio().

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Thanks,
Joanne
