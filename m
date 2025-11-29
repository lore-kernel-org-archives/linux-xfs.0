Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD340189B84
	for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 01:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764379207; cv=none; b=PG69UDzkfrXIwawmrZC+seRaKjZsU2LVA4p32YlNgPrA//Qq96QWXKgo5YPIBBqw1Tk2einguSAWjiWPD5/kunvNJL35liCbY+bftcGRRFW6IjC5p3tt+dCJu7DibUFx0PgyXAwxtIHBUWnMLE32YL5h6T2346eAsc7YHuKyqVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764379207; c=relaxed/simple;
	bh=CQ4gu5qwHISanFuymuvKH3qflMdaqJ/uuGBrjJ6tlTI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZFeKLA1k5wmSS9QjmA5a2ijCOH9jibbNDtUk37eh9CoW4NkEBQwYuSgx9EI7PalpvNTidjHSuAswWEyxm/KOdXMOAjDkZueKftXS1Opo/RcLZf051/yYfBtPOy2nerqtWJal9z0eZ+at8/rwPi/uZbLV75bOWnVWnqo/0Omv5Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mx1oiJ55; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mx1oiJ55"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ee19b1fe5dso28497941cf.0
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 17:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764379204; x=1764984004; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fs0ohHvC2dybiBLIXiSQxGJyUXrOOQGSRM7UOWCS5dA=;
        b=Mx1oiJ55XOPXMyCAiN/Br5JFA3l1n2xcoNVlmgHTqEMYK+hrtl5bY6f7CurTScUiUz
         yRo6zDSIsPseHekpeKZlMJEnTeZPKLEVk4bJUHMUeeGWtVjHwyxC7NfzstE02D7PhQZe
         cUuVXgAensM9BqOkyuN1JmUc+x478me9YpEmKsW8oEB7sX37qyXCjNPI6QqGdmS8YiAt
         XoUo5REunWFNrEbtzHsRTuJftl5Z85x4meYDc4yQLp8zvQ4WPoq39zoCDnx41WOhWYTL
         uiZ6qVuE4mtikutYXDXrISPMG5kIpN1XYJqGpye5MMY1HxFHrPfiH+fLJzpajKKWwxsD
         oP/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764379204; x=1764984004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fs0ohHvC2dybiBLIXiSQxGJyUXrOOQGSRM7UOWCS5dA=;
        b=TLB9Fl1RsrTA0NPKHVyiiiIiSkRsR9oipJK19NikM0iCnpR1jhl12vG2vFW7ZmOeQ1
         V7UGJiQnXl8m5wXwtK2Yhf+WZ3WDJ2d4cfFyK5G/ix3Qzvz9bcxhdZk9kL2jtRAMm3PK
         I63pg6Kmo20LmjeZuF3GI2BPLxlklTeajfLebJBuxaLFImuZqlD7reiWYsSCfy4Da7j4
         zz2Te/C8H9oDuJ9OGfu9EHF1BgBIs0azAA7p/YCicOwFVzncixJNWwu8G0ZW7Tp09YFA
         R9ufppSe110jHTqLIwT8mCaDfK9IQ2jUSbLBy8GSCVIZzJ6+aULGVzBTX+XLtDSyFibC
         s1xA==
X-Forwarded-Encrypted: i=1; AJvYcCUHTfW/6LWnigrmDvZmOWpB4TA1LPzwjlSvWaYfGqy8udimv6HMRSlf308T3mCodwSPD/fkh8OqiiM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFNk/R6iki6eCvYl1MGFxYX7eOz40qj+y1Za328adtliej8qaX
	6ooq8IGPc8i2tCJCwaSvcAFdCOz4IuIUIR8mNjFqv34eh+7c3sjqDdPtteRJVb3jP8vv58MmfMm
	1QjaE0AfC3G04MNOL20/8Kf07GFfEkVc=
X-Gm-Gg: ASbGncvLpm1z5KHPr5uCwonBjo8puc6zPpiquMLAUK35rpIDrs4rmi4w88z6YrPTxmO
	LNRa6PwvgJgHvf6vCZXGXNNaCWft9xxKBkUI4+aORy33QxlvXf2MRPdpyLmmfWjIA+CdeiyCGeW
	SAJNf+4Lit0yTlVTw2B2MeTvyzgPNmH91Af0+bXcMjy9e2bnQa/1tXzkFd6+iQ1XovLEHzPunN7
	ug0P/ys9lazT/6fTO+7wdctiTT2PQE4Ym1STkPotZVfKJyuYpCX1WdJ4v8SETKvTnMCTA==
X-Google-Smtp-Source: AGHT+IGvVajIc41VyAxCuPyxqWUXb2OrVTIXZXouCyBBkNWEtauVL8pGUlccoVwLRAWDPyhKgINw+5nh517v8WUU60c=
X-Received: by 2002:ac8:7c43:0:b0:4ed:b1fe:f87f with SMTP id
 d75a77b69052e-4efbda3957amr254551091cf.20.1764379203672; Fri, 28 Nov 2025
 17:20:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn> <20251128083219.2332407-13-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-13-zhangshida@kylinos.cn>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 29 Nov 2025 09:19:27 +0800
X-Gm-Features: AWmQ_bn06KtcfeC8pChk4HEBjz19bArSXx8IRJxxttyX3p2OYoBSLr0JgGawFZU
Message-ID: <CANubcdXJyE6Y5J3C5Zgc1jA7qSXk+_Hb0pm8Q-8cTb3Z_eM4sA@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] nvmet: use bio_chain_and_submit to simplify bio chaining
To: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

zhangshida <starzhangzsd@gmail.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=8828=E6=
=97=A5=E5=91=A8=E4=BA=94 16:33=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Replace repetitive bio chaining patterns with bio_chain_and_submit.
> Note that while the parameter order (prev vs new) differs from the
> original code, the chaining order does not affect bio chain
> functionality.
>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  drivers/nvme/target/io-cmd-bdev.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-c=
md-bdev.c
> index 8d246b8ca60..4af45659bd2 100644
> --- a/drivers/nvme/target/io-cmd-bdev.c
> +++ b/drivers/nvme/target/io-cmd-bdev.c
> @@ -312,8 +312,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *r=
eq)
>                                         opf, GFP_KERNEL);
>                         bio->bi_iter.bi_sector =3D sector;
>
> -                       bio_chain(bio, prev);
> -                       submit_bio(prev);
> +                       bio_chain_and_submit(prev, bio);
>                 }
>

My apologies.  I think the order really matters here, will drop this patch.

Thanks,
shida

>                 sector +=3D sg->length >> 9;
> --
> 2.34.1
>
