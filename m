Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795102357;
	b=CJZ6Xk7z7gfWeIqphJGG6mNDj1eTe/NXGmDwE24cAz01u+Uo5wDvBDYSQ/Bjeqsg21BN
	 aIHQI2iNDH8plt2rYkHQgeJvjG7yoJmO8+nwCxcjymrGZqwq1gLYYd79dDEYU5RU18vrX
	 U0cW9eNPzRvg1fLyY3rztbKzR7SiOx0QS7ftlrF4wrqakYh+H2xzDfJGfymnspkllriih
	 O37BLgjaVXU5m3Bq98EGtlZEbJNTPs8pcToBH9GUihbo/8WVCpzT/fxLkcgflfyP7ArTh
	 Rs8URtVEk2sd30Yozc7IioTDaMjEjlfW0spy2X/JiwvNEwSMaULF7niLDAv8kceUuaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795102357;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f7T2TmAinoSSVrUkDLWCSHpGLO0VMoU6RTqJIGDHf8c=;
	b=3CMF0J+SKR37KFoLZJCTA3rc0BxefYuMc9VeSILo4qxaNC7/XNa+pIepgthSZ0qnGQ9u
	 aSpSxZBj8kLj7YxYFT/9c2PvGwj+vAZFVK20V2RxibpAsQ/PeA4Z3zJWW+OCreeYJgwlM
	 6ceJHoBo4h1+t4KEZFCrCnyT7esUdEnIEhvmvR34zQAuwVRt8Sr1maDmiRwyD5ja6U88v
	 nhpxETN4bq9t4SKq+gZwFz08AfNvFNYKJsf+Evy6sSXJCnpU3ro2i3BHk5LfWRNJkPz2y
	 5xchqkW9wW8lhclr7YgeBkCQds6rp3vDvxKmeiO/dJzPSzsBSlPNQ1lBVyiGwd4fRZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EriZpb1V;
	arc=none smtp.remote-ip=209.85.208.171
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601C260A261A
	for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 15:32:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 601C260A261A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EriZpb1V
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3ae25c9f857so24095861fa.1
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 07:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795102355; x=1795707155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f7T2TmAinoSSVrUkDLWCSHpGLO0VMoU6RTqJIGDHf8c=;
        b=EriZpb1V/2zno0fmMO54HL34Ty+nBUS/4UO0C6MvrvxZFEYE5Wk3AXr9C+UsTd1EKu
         e7VRl67WTxEo3VDt+hkZtLmFiEHnR1zJiLfC/Bq9BJKAFBDFohxqHF5Q1gg0wFZRWOaP
         GGmxEOrPJV8MRv3PkF03h/86SpZPKw+8KkyhjjjSRymeueMiKP4mQ8rtd0qNdqm/fzoE
         MNeg/d90yqGf1ngIGXcTcG1X2LenLIoGjIMBxdm9LKyp4bnMI848kU3NoOJqH9CbrAin
         fitPeVcUyIY+ve4q72M8iKNlPUyICj34RV6qW8QMN0CuPmRvl1c9rcr7e4C4EfPjdOm/
         0D9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795102355; x=1795707155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f7T2TmAinoSSVrUkDLWCSHpGLO0VMoU6RTqJIGDHf8c=;
        b=b5gB7arRXcX6Ur+gbzjalN+SO4wANP+MBGBfqj+2wNT0hzlAO6c4mGOi1IScgluoeC
         RGwL3MoLED/54r3CCI6M6K5H7q2ILj/bN+pnAVE9fWh2G+6G8l6F0Zz3sbeQEO309qmr
         lZcNErCBlRe6QI0+/p8fOIehWm2LhSlLi0X9qnGz/MFXfE+gPpBtrdKnrWTYAfptVkbR
         tdHtKLyU09J8BMAFcAZwBVWZ7zXKmWIRct1up31Sr3zq8t7M1Jj6dUREi9685q+E9CW4
         G4cx1W5wn9ka0nKC7DtC3mCN1v9Y7U9Fp9U/geF5aW1O10v1nCd5oAkhPKm0ftDtds2g
         m38w==
X-Forwarded-Encrypted: i=1; AL+hErE94dTrmEGb7sjOLUFn3Q5n4EtBhSKZPb5yeHsA5wFqOnQ4fnu00gLtNdC1FjSysu2mNOp/YehBYDA=@vger.kernel.org
X-Gm-Message-State: APuU4Z/b4IyZibrqCv2oAx4XVAYd3QjU+nXCiD/nyd8TqA0FH1k/KLUB
	x1Zen+oIMOtKVSb0WttSEJhWcjds65JVJG2y6p2M0OXeEz64dVDVr8U9
X-Gm-Gg: AZFdTZeklCxvSAzdtQJG6FiEGklZaHGMzD98SyfGGLQkEgzd1QZX2rk9K2kjP4YU3Tp
	KEf4P8SgaG60cBfe54SomOxHUtvf8TY5SzITyU7SdVTN+eRgJfnF6ku1vvG4jlFi5e/FdGS/t0Q
	FeO1Rz60ng23IbtKVMr5kd3Lp7SB3Re+aEYi6ZbM1UQXwFY4jSSYtrT4YJ7CNZmRv+3isMG3B2b
	VH321CdJA45mVhcoWc2mK3pM58EbnKeVmI15LiSDxVw0SYhSs7tGQXSui8Y179DYYvLMYYHqTsf
	eQD3iG1hAbXau+9doiNlrdToYyhYzaqoxZgK6Sl9g9zqX3ylNXOcVk37kyreXsxbdOBfkt2TkEW
	NCplHI1cbZm7gyGUXbVn2Po5lfgkr5W+JFnKBgpZeCEZ7I7kaiBxL9qOIAvLMEHcnk3YZKb2Nsr
	8fc6bGl0HCj1THCYfy59s2aNRVZcsO5rwd8LhU88+YxdImacpfK6BHYc98eXq9EoYSeJvYKN1/1
	uDB6EibRdw+jmSvu6RpQtQkWKG52u0YNlqDUGYO4bUQQ8uSKo5pqu6ZQ9oyGNwXjcVE5BvmLWtR
	1C9sqpMaS0haaqg2lcbYsHDNN8ISsZikMLbjjuKuJUk599P6I/6drzGdcwwy1cLPsV6JYEmdcot
	2XFTQqUN731ERRZ6UqcMFWUhBM6Uvik8BtPwBtLfjVq+82AolLAG9KZciZ38=
X-Received: by 2002:a05:651c:a149:b0:3aa:ef31:e51e with SMTP id 38308e7fff4ca-3ae7fa644d5mr1204161fa.19.1795102355312;
        Thu, 19 Nov 2026 07:32:35 -0800 (PST)
Received: from Lauri-G-Pro-14-M4.intra.lakuz.com (n2vuxegwnwppvr5uhf9-1.v6.elisa-laajakaista.fi. [2001:99a:2ab:bb00:c16c:a39e:e605:54b5])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ae6ebe67e2sm11532121fa.33.2026.11.19.07.32.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 07:32:33 -0800 (PST)
From: Lauri Gates <lauri.gates@gmail.com>
To: koraynilay <koray.fra@gmail.com>
Cc: Dave Chinner <dgc@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <christian@brauner.io>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
Date: Thu, 19 Nov 2026 17:32:22 +0200
Message-ID: <20261119153222.65195-1-lauri.gates@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
References: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Nov 19, 2026 at 01:00PM +0200, koraynilay wrote:
> It doesn't seem like an FS_XFLAG_NOSHARED flag would touch this new
> change, but I thought it was worth pointing out, especially because this
> patch would also add FS_XFLAG_PROJID and a new FS_FILE_ATTR_XFLAGS_MASK
> to have a way to include both legacy and newly added xflags, so
> FS_XFLAG_NOSHARED would maybe also go there (correct me if I'm wrong).

Thanks, that is useful. I agree it would go there, whichever meaning
it ends up with: as a newly added flag its bit would be added to
FS_FILE_ATTR_XFLAGS_MASK next to FS_XFLAG_PROJID, since your
fileattr_to_file_attr() masks the value with it as well as the mask
bit.

Your mask also changes the question I asked Christian. With it, a
plain "may share" flag works the way stx_attributes_mask does: a
filesystem that sets the bit in fsx_xflags_mask answers, and one that
does not (btrfs today) reads as "not reported" rather than "not
shared". The inverted meaning was only there because file_attr had no
such mask.

One constraint for that case: the flag has to stay out of
FS_XFLAGS_MASK. As I read your fileattr_to_file_attr(), every bit in
FS_XFLAGS_MASK is reported as supported on every filesystem, so a
plain flag there would read as "supported, not shared" on btrfs.
Outside FS_XFLAGS_MASK the flag is also never seen through the legacy
FS_IOC_FSGETXATTR, which masks with FS_XFLAGS_MASK. That is fine,
since only file_getattr() needs to report it.

Christian, with this mask on the way, would you take a plain flag
(say FS_XFLAG_MAYSHARE, "may have extents shared with another file")
that filesystems advertise through fsx_xflags_mask? If so, I'll build
the RFC on top of koraynilay's series instead of using the inverted
FS_XFLAG_NOSHARED.

Thanks,
Lauri
