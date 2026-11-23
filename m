Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795443551;
	b=gvQD2FJrEHt46HxacAOzKU/RBjIX1V4MBCK7PqP+7lM+Bi5Mz6Nge1jRJKYFOrNnYzDx
	 bDqr7HNwWVzM8N73UnjZkvgvtnO6QvxFztgUkI5OAuv2ri54SWbcUWkL5juJLN1ENXtCk
	 cdS2Y6VbnABTDEqed8VPmk+Ga56ksYtC2Y7f0419w1CAWPfrOjvye/XkZWFqoOklVh1jc
	 usj6kmM3SS4qP8eKCg0ksAq5daH4ixD6Q641FLD1DJEq6fbU1EJAZ5T9DT6qJ5JXhmXit
	 nP8dqIQWIRyqobYSw3/Wcf0KX5pVinyHoGnNqFLO7olqiwPVmLeyJpz9AKPdCzwgz9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443551;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=SGqpzMMXOxhLnysXHPX7ervAuuBOMpPxjnvIFfmSlbo=;
	b=FJdx9M+Dqylwe4KaHuyj7tZs0bmsKV3eJQOzGG4H7DDN7WlP9mh455X+VPVpxyze2REL
	 8UlQ3kU86BKcgmMNLstUfCgdF5qjTHP98aTdWqwHUUNw7GTpPur/yXIrocCKvtKonDBLE
	 gTVsTELtisWcl2NWtncZV1wJl8DaIs3fZTSpD+s+9D1uCHNjdD9B1J433u3jt3k/6LEQo
	 Wlh43v7rpDNcKwOb497zg3jSjGBYupRbwsmzZKPJeY0ZGwQHPyViuX8IHFvfKZgR5YVsB
	 MsGgip5q5qtsN4loptpP2s3IDsSXuq1kRlnLQ2528Im7V/0xPRBJxZ5KxDZLaFilrLQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="ia/9bOu8";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6287D606A321
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 14:19:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6287D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ia/9bOu8
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b167ffd132so5070954a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 06:19:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795443550; cv=none;
        d=google.com; s=arc-20260327;
        b=kSEWv5xDFETcSbfg/xGP0SoxJhzffJi/AShIUziNl3l5XdI17wZzzxt3ldagQtjZPf
         PkdTPevh1GmfF14+dfOTItqyTBGiv7CiVSOPa+sZthDSmky/7gByEGZSgd5B6sTVg/oT
         cTEV3wK0xbDQ1GezFZDnnPsOns0v9COMtg7RySRJRSkPy+Z5Lp/CiYW1rVoj+mHN+5qy
         Y0L51aVSPDxj4vPu56JXa7NBS8jJdmMfXPtNTORIjrFT7kuNsCGsvc6YGGWjkn9wXMB9
         Yy5/S8aZBXbFDtyTBvXjNF82gVFKR31TwdC8KVf0p/tgT+U+YxvSpRhVr+7ylWKKL4uR
         FvcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SGqpzMMXOxhLnysXHPX7ervAuuBOMpPxjnvIFfmSlbo=;
        fh=qhazUDKlD6bnTBNocujq2l5N3SBx8CI52s61nqHVl+M=;
        b=gxw/8/fcRj9TFyHG9bclgQM+uEAvZt3MVgPa7fvLJ4C2GCouDKc3qKlMj897/UCtEh
         BpkDxCb/qdBpESRHwv/5IkZgpr7M04p1AJwiVtBisdu7akfq4lY1cEeoVHipr/39Oums
         vAawlqsm0opMwMtoi7RoGE2za9AQjuLZsGYHzhntJWfDEZHRLW98djLDRenbkibbC+DW
         /zHyx6/ttsxuX2P2kIMtqjCSVdZip1keXehYiQlxFs/8/WibpgvPmAsfUP/ySD/D/Qai
         KXamvdnKLzhM201cld6+5AFjAjGGfQ1nnMZIs1ROjUnOA/PfDAXxRueY7PFB64NmpweB
         lj/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443550; x=1796048350; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SGqpzMMXOxhLnysXHPX7ervAuuBOMpPxjnvIFfmSlbo=;
        b=ia/9bOu8jSdEcdklu7sre/wKzZoFdki81W2YJr5dws7NTbMa6eVh8vfd8h7EZAJ14D
         zJ0mFNzTG9vSV7EDC7ZzObA4FfyyFHJFmlg2OfQnE1GzlKJYEiaPGS+81TXDzscV3Lmf
         e1X/UPfaxn/OuM29vOeBkbikjniBtlasyUheiBxZBmZndMWZEYV/NoVgu4CKY5knEIJ4
         FHLmL5+7Zqnk0SKhO1f5Rpk1eEaOfaYiP0nRtrE5LwUEhOM5CmVruhmq/q9f3TExFydB
         fjuNhxX5EXWG9T9dmW5z9mMjNIKUvdWzXZN1cU45mM7c3rZLJkxX3+ShE2gwYEV7l3VB
         J4+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443550; x=1796048350;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SGqpzMMXOxhLnysXHPX7ervAuuBOMpPxjnvIFfmSlbo=;
        b=nGwIIzzDqfKqzaQyc46/NqSJmfik/5VpWtYVdA65fbgPAIIH3gaciLjkdF38+eonxG
         K2j7Ti4Ld+jD1ji/qGaVfpEvxrlWH2vpszHi1e60imZFY8S9YqS3IszYEA50UCgir1ae
         NMcgTkjj07Bs0josBqrXlktplUfnNF4GM4O0IzgAW7xdRns0UmijbckdSi/ZbWLs2f5O
         P+dxXGjqK70ptVXUMjFsD85GloY5QAM7n0lXVTlplvQ1hSfxf1OgavO5kfhwqh3TY+Ey
         iWy8DrgGOFMTPC9sx3ZFb5dFieC13oatSRK45SrrsgdfH4Dwq7xsYyf8hP3uzwocq/kD
         /mPg==
X-Forwarded-Encrypted: i=1; AL+hErHmh8q5ESWQ8Q63+vtsLeG1P1+LIeHOlHlqBJqHzBvXqrumh0tM9dG5XWdOzg5oxF3eYmKhk0MhU2Y=@vger.kernel.org
X-Gm-Message-State: APuU4Z822bU+RC0IggfJBi3Xa37VV9I2JqKdaaH5BVPCibDvNeNhGpoN
	TAWNLL0VO73bz4sTf8lsoIGGCGYLJgAPkyvvpAyfX3VeGn17iIxqq2J3GMTKVrkQP3bdDGd44mO
	iefBDWJ6spTFOxeA/QedXT2R32jJt6mY=
X-Gm-Gg: AZFdTZdVhcDrkMK1T5LWVTBRYlENQCvqQeANb7blrr+qJfqTESTofET+IQAww/fDIlg
	bith9EloS3o2hUSxT5exTR+Jec24jmTKEyyZJDLR/9+TIuIS2XIBmaq/kmiPCDLPwDtQG69ILY5
	I60FOy0e2iIuEu8of66VAy2jibxR9k/7RdYp2ZUaUaM9zia8jlcaZatWdEbh6RTN1JESGpbZQeP
	ey2/nCdCIDyDBS3AWCHRIz+5J1HOR5KNdRxpq2dyvzpw1kog/on7nrA2IlDVCn0xLxT8T7TjAxN
	bjHu/fRqo2b9IjS0QFocN6vwNkNp9yUMim+2f//MIgOXqiMrR8CYy3Qkf43TJynO8pZz3FUwVJs
	R6YXzLy4C4eOO3+Tc+8p0gCwrGFA+TPRCl2IaDwtMlI4ddCSdOqKzTM7RwYbM9sjVTZTLeg==
X-Received: by 2002:aa7:c61a:0:b0:6b9:86d:bb5e with SMTP id
 4fb4d7f45d1cf-6ba37e91e14mr6755202a12.41.1795443549130; Mon, 23 Nov 2026
 06:19:09 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <20261122000856.536902-2-koray.fra@gmail.com>
 <awP8S5KF9v-nqWVY@aalbersh-thinkpadx1carbongen13.rmtcz.csb> <DN2NJH234CC4.2LSWRSOO4TX5I@gmail.com>
In-Reply-To: <DN2NJH234CC4.2LSWRSOO4TX5I@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 15:18:57 +0100
X-Gm-Features: Aa3M54qCw9X0Tb0EaHQOCg1GMA-OBfzeB1bXtwNxs39Fn8cRfeeS4nOAW1KHDXc
Message-ID: <CAOQ4uxiREfVU-WKiUVRZLb-uzMXzDEsmG13FVMW7YBoyq10=Nw@mail.gmail.com>
Subject: Re: [PATCH 1/3] vfs: use goto out on error in vfs_fileattr_set()
To: koraynilay <koray.fra@gmail.com>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Jan Kara <jack@suse.cz>, "Darrick J . Wong" <djwong@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 3:15=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Mon Nov 23, 2026 at 9:42 AM CET, Andrey Albershteyn wrote:
> > On 2026-11-22 01:08:54, koraynilay wrote:
> >> Switch from using if (!err) { ... } to the cleaner if (err) goto out;
> >> in the main body of vfs_fileattr_set().
> >>
> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >
> > Looks good to me
> > Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
>
> Thank you, can I add this tag to the v2 version of this patch (since it
> won't be changed, and link to this thread in the comment section of the
> patch)?

You should always keep RVB when re-posting without meaningful
changes to a patch.

That's how reviewing works.

Thanks,
Amir.
