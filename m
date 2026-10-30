Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793389710;
	b=lFZD7v9aaBIYt2zHqpXZiQUDlbfr/IHSgUEGIJfMQzRqKzzvk3HyKtRkyjuusgvLd2tz
	 +cCBWPlJqAS4wyoiR4bamH+2UAtdRodeo6t/Lvog91qcGBhox6wL1aFS9U/207nTbzjQz
	 aO95Ti7Q8Y7hPxeySM8kXSKVEL/5rkZ8WOOFi+3yZTRiik6D38JZe9cYQXuS5h1WjqbZN
	 86RKkHSkk7PTpeej5HdVv81EYnzjWHI5kpa8QC2IJ7twBbFx41dmVmc8OuSPMujhDXXA2
	 bFEcuGr6uUvDuPFatAcsS/M30ng/ZoBIE1n6u5Zk0Ty2LnBHtAQsCpoTCmdMmmZpOqg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793389710;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=B3QeQKv83CCubBRhLwLfDBWq4r5yqUeetrN4Gz6lflQ=;
	b=XPV6bCopFHH/yhP4XjCYA1wOuj3ARIizy/s+WwPkvHPPkot7D7sSFCnJK6QF5Rm5fS6g
	 Xss//J6h2TFHoDPVWX6F8/OYcOKrEzhcw0/iFmLGlNAiOjt5VjwX6Tb24ynvoD04xYHJ+
	 GR/b0IAA0ijp5ENokzoX2r/dKWFLn1J8qOGLZaB0IwHvR9bTZFB3CGRMJTQawWI/I6qTr
	 oiHQLFJHCvzi6B8V6KHERkcE37xadRTp4/cO8weSNSAe7XTTcXdLQVpZ68aHrx1vgEydu
	 trbDuxYDthtBnD9L2SqbhFtNdYIrGiIl9SI3QAZgwuBeEVpbl5Y/9qyDRCvllxYxRwg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="wyv/v7L8";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D659E606A320
	for <linux-xfs@vger.kernel.org>; Fri, 30 Oct 2026 19:48:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D659E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wyv/v7L8
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48e47347279so772979f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Oct 2026 12:48:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793389708; cv=none;
        d=google.com; s=arc-20260327;
        b=aPcfQpXwbRN4iP2wjcr06/IDYy6IV5ttep3BPpBLbaiaMz7E1pgDY1UnLqJtrXkoUB
         4xP4c5GxZXwqqfSuMePWH027u1giQsF1lzbmC0zsouUSLomrs0ny5vdHPjStTzyvqUjU
         R1xcFmPHqL+9rEnXgQ3ntuOL2c/bHYYTNbvzrpPGcAzQgpRZUYorIZM3TCqCBka/7sXU
         I2OB7GZqirf3naS8eAvJw/+CCyU+FrSqh8tw/CJqqXbsLe3js9AD5xzXDUNEs4hVYvY2
         K+r4c0z+euT9hyHUUcVWQWfhiN3Zq/UvtBxn/hnzOnVaBwInR/EFMdp06CFLRhCKydsq
         McCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B3QeQKv83CCubBRhLwLfDBWq4r5yqUeetrN4Gz6lflQ=;
        fh=BiNPvWh47juzrGiJMo9ZBOEnK42Ntl0ekuJPRw6ynKs=;
        b=R2zRE2LmXvyxLV2PVzyROYkJ51Mi9BKqWM6WKCb0FzFIAJwMKwnWroCSdJ5g8YUxPS
         VH3TUe4N4fDEcUGNfwg55H+5LOl3ly/0L3suvm+RWvRKtk0pu+qhylc5UxmARGRKG+jT
         TBY8uLe61V7WW48X9HHU9KBj7GWaIlaNR8RV1Po+VWkRwFBH1EfdckIrT2eGqullAX2j
         adprBc7tSq7fMKahZC5Zxmsvn+TSqkqdVYS3M7qDoF9rSS+gBT0x8qsdFGSgUr3+05Mm
         MjH16+7/CZm5wm3b2N/HREHQV3mdvVzUTxWbjyO/LURCOCcMwX1YPV3xOUTJJM8xhNx/
         Aneg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793389708; x=1793994508; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=B3QeQKv83CCubBRhLwLfDBWq4r5yqUeetrN4Gz6lflQ=;
        b=wyv/v7L8ZjnHsyc20OjjJOPmD/d8wZkqutlwDLWfoawPlVGaLkb+9+1Q4rDqm0kyyr
         lbSR15f762gdfiaSH5Q7eEU9n6kF6PrrymY/LNTU9ZS2K3cEw4P7hxyB3qy3qk2K3HX2
         9EACw1yTy6dG+Th59oeBPohq82am5cg3DuP5ilBO2nTZwcaEXu/Qokyz/TBYdnp8BIec
         9WJho9V8nkW9owQOoX+dF9K+f+xSf4u195/2QTDbn5vRjTcZjNCpDHIMZM1Dd5YXUJWX
         VvuQq7SrYbYvRUp5v66RyLaybHGnVGnuRLAkTqvqY0/1OiP7Wkf58D4Sf0ROqP8yLS2I
         GfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793389708; x=1793994508;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B3QeQKv83CCubBRhLwLfDBWq4r5yqUeetrN4Gz6lflQ=;
        b=YVxV80UMFHHNzhXUIJWm3nFRFGXxFQ5uQAwBCOcu6qrctaovCuYwhH9f3iACkVgyiI
         y4lB7u+PWI++mR20L652umKW5Nxw45ICJGWKwMXcaAX5BK9ykNBYEKJlfF9T2NvCSMoi
         cUqVSk6FjRtRIuv9NJylZP8hIJGnpbOHMU4O+mpkMqH+sbBxrDTptBgn08HIlIgc5aTT
         bhu41CXDzRb5PUoahQrB4VzWMhUEj3FTW3iUYpy88YNGUxckTU35xS2Vy514vdKvdm0k
         Dqr8H4tiIEqrTs/uAvm0G+A4OeXGYUc8b2soV53SI0M/I26G/VEDwh7wHcyd+7julrOf
         5swg==
X-Forwarded-Encrypted: i=1; AKwUvByDm+1chsXskhh/tQ55M1qW7mQPp27eO5pjUHqCQAIb1MQ4hq72Kg7WiuI9ouLUbuH8WEb4SsB/+Co=@vger.kernel.org
X-Gm-Message-State: AFq9FYJJtWlbMuYD8Uc9raWIm5XnZ85NwmaewV1ayJpnEBdlqLi5vDbq
	pRU3kPTlOVF+ZP/lHkFiRYc3YEYy4aA+peEDXRDHUlXKF2oRGDgPuF6772hCUbkLR2IYZJ7r38C
	RjyrfVedxieYAim5GGRg4adZBsqyiRoM=
X-Gm-Gg: AYBFou3UrsBZtyRMrOQVMkdtt30tS84MqcDdG6rdaHuGJRwEZYsH6Q9qKuAaN1+JOjE
	xom2A4gcRljK1TYZL+nuX8dHMvSio1nNAPVWRAPA15U4FrRThLZP3n2mcSFe5zc4miIzHNnpOcn
	Kwfmiq0h/GMTIzIYbZCBRZuVAO1DGkgXrV9ulUNa3+GJtDENB3YFT5cjZzPROjUSGCTh8VKClV4
	E6DTyCqJWEZ+OJVgf+G1ERprM+kmgreDDj4E0IVkjSFDE7Xr1vgN44GhKOjtY6bQedTPyOTCVVQ
	W9vnP2L0vQ0aFT5yjhdlGFEnX8/OSF7mkMbyFqH0GLf3xeQBZt2O9JxBhjgGfCGStVXyrABGQrg
	AKH7w066Y89Js5k1B5J5lW6WL5/CD/px3ZT4+IfUm7fBcFIqDPqUhhQ6zsGjUpDr7Y4mj2NzoiC
	7O2FszArLe1EYftw6vpA==
X-Received: by 2002:a05:6000:40ca:b0:48c:5304:5e50 with SMTP id
 ffacd0b85a97d-48e6e2620d8mr8708785f8f.0.1793389707952; Fri, 30 Oct 2026
 12:48:27 -0700 (PDT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
In-Reply-To: <20261027215326.2693300-1-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 30 Oct 2026 12:48:15 -0700
X-Gm-Features: AclHuK9oCK5VP76Wbek63tch4M8ewVUH28c6PHPAdmsJkgtv-kMhmrFiNwyHte4
Message-ID: <CAJnrk1bqPCy8ryVjCsUWR2+4jkNE8rJJU2bUFsO3Q7nznsF7xA@mail.gmail.com>
Subject: Re: [PATCH 0/5] iomap: remaining patches for iomap_iter_next conversion
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	"Darrick J . Wong" <djwong@kernel.org>, changfengnan@bytedance.com, kbusch@kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	"Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com, bfoster@redhat.com, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	linux-nilfs@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Zhang Yi <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 2:58=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> These patches are being sent out now in case anyone wants to look at the
> preparatory patches or patch 4. This series applies cleanly to both curre=
nt
> mainline and next-20261027. If anything conflicts by the time you pick it=
 up
> at the end of the merge window, I'll rebase and resend.
>

I pulled in Linus's latest tree (commit abf8c33470f7) and the series
still applies cleanly with no conflicts. It also applies cleanly on
top of next-20261030, which includes the remaining btrfs, ntfs, exfat,
ext2, and gfs2 changes that haven't been merged yet. There shouldn't
be any conflicts between this series and anything else going in this
window.

Thanks,
Joanne
