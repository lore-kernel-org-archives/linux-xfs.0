Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BB434E74B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 09:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771840142; cv=pass; b=qsKzquGFzvYleL7Q33VXjLT03S0HeMHSoyRyTqKiSuFO/OBJ/Loj3cGdoNRHvvcMeCoY3VUIEhQzH7tZ+bQNgwUh1JD4OTh5iOhIyn6J8bf2PSlVn3hyOb70BwZvcI8dyGRG1Nt7sa7iYd1pCYT1+PsrSFgxf0Z+buNB4vyJu0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771840142; c=relaxed/simple;
	bh=RqBS+1o8DLCR034fZG0Eo3xwZ5S3iexwBiRxenXF7oY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=BMScRWGVnNEppawAf4d23cNfb97VSToaa2RedrsTyWNDQpNhfEBiekevftvdFHt9xPyZH1PigQk+JBpJm3/XDXWBKDbmcweWtjtGUqFfJSdTZXIFCmFC2p2cV2rq2jK57xmiess6UMqB+lZqqStP5PLkUNSPdg3KSZqYuMtITbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BZ3mg3pO; arc=pass smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BZ3mg3pO"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2ba90683995so1674432eec.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 01:49:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771840140; cv=none;
        d=google.com; s=arc-20240605;
        b=HeXhxii8Uc5hS2RjCYsFaVOIHSDTIlHmHNY4WfuL03wCFVX1RbE02hZfrjf+E8Ga1K
         JTf+B2Ui8UEk7VtM6ZMKISDCFPWC+4pHdxzId2zmauO28pNEZ+8Wen7r0BKhpmAufwra
         v49U3JRSapKPJB0is+ghxOT3YBikNUPDvoZwaIvRff48BhYImgmLmGsnx2EXEzVUeYxY
         bflMNtdSmz0gp8B02XsqM7k8yO9goU0klZ9FXra7v/tZtXCD/IiuBZZP4zGoBG4MoQ9j
         +Zwm/HPNbJCpzpu4e38gzN/1el+JlhNUhh4ls+H17hy/1lNlZt38o++bca9xyOUk4HVd
         JEQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=RqBS+1o8DLCR034fZG0Eo3xwZ5S3iexwBiRxenXF7oY=;
        fh=717UJfa65qmxQPHgXYe7gUuNhUmUVEsh3JzHptCWmjI=;
        b=TW4s28KyXw9WBA52ZzJFTBH2mtv2nKDrw0fWzQd5uz2xL2zufCvOuesycagqsYN0Zu
         YjRn638csd6PiYlQpOKOSwKRwMgQlpLceF1b6ffbgnXMcrB2vu6MJyH7kap8nBT5btA/
         aGhU9mYB5RtAA1ZAuyx4TlTHvADylFTrf99Kzd/YTDNoWkd7PpeHnczbtASkzhfNd67h
         2Y+HaRgsf+STf6PdZQyYs2Zj2F2zWJyVD7Aq0mbZwPVCVpdM+BT5wCsvJU7qJ/PchqTl
         dj33sNtEtbAAcFthggk2BKy42kNSeMaBUeyBqn7NqKWu9I/W13LDDOqqhfkwHffflrms
         fFDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771840140; x=1772444940; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RqBS+1o8DLCR034fZG0Eo3xwZ5S3iexwBiRxenXF7oY=;
        b=BZ3mg3pOCBLzuFc4jyeSyLK36QNuXWhRyXaoonVvIL9N9cb7oRNRGjh0sjzGn4CDKo
         Fg+eisimy2LkMGHypRJ8t77gWLvtX4DTmwIximT5rqH9hn4MiAmo5ZDFJqMyo4VKyMKq
         4ndOFBFqEfsRue45d0w5994B/G4CXJDwf9oSlTa/84KUSY+c35VrD++z6/zZpd3lpaGg
         0kbhhyYPLdZWnxgLvOWd+NdUyOqpI58u4dkgzr9M/raf85O8j0fUV/1tB6avgYJ54uzi
         Qb/ZtPTZe5+1MiHqksCy/j/lvsb4dkN4R2PXvXb29iOW3F9fQOj2bjE+ZvGgwPU4JZMX
         WAGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771840140; x=1772444940;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RqBS+1o8DLCR034fZG0Eo3xwZ5S3iexwBiRxenXF7oY=;
        b=cate1FbOwh39zcyueecertSPkDz1CD9k1zf6bEr+8hA7uNVte0n8kLWTp/dCCAlQLA
         n94F0CioNN5pGVz77CSe9tDomg48dvkgjh/OGYPSLU6LSKDzEPhsNv2gy+VBMwSmruYq
         I/3BTHI8pk87WQG8sm/kmfDd60RSTYLtEX71RjnUjOGHkViHu/DhoZdvYmoDVr7Lf+Fn
         A3/LcOqf+5pZ+H2q1t5wpZhfQ7kNdvOU7U1iNRaqKYK9CTypm7jSmml9ljY8LCiwng4T
         zwe0kOEo/dGmdXW3/7F4cAZJXYiUpn23T2QtBEphHyjlvceFK+Ito62I+l9ISL51tE6U
         FhWw==
X-Gm-Message-State: AOJu0YyGIyNwTBAve3rMztAWLv2N8svYofvCIP9UctLSVLu8fBudjojx
	UKjZwc7PKK8kV9aeP/c8ObCmjo4fIgeSpvuSX+23TNhq62/ARo3q0LMCTB7A724+1CaNdDp5NH6
	lU3HAiVMhfe5U6G/GoES9cDuaBZNwYS1HpSlx
X-Gm-Gg: ATEYQzw4ZySn8i7ZuA53lEZO6IXzFG7dT14fMX9vpfVqi/YwbU/gP1tdZwN8nO6RKIB
	FN2nw/K/AQaz8rLH8XTEx0KFXya//mexMCROwIYV19ptD8N8RrD5YOO232gGuACnJZDXpoML+eR
	ycFDPb1LHgtfFIKxB1qSdjbvi3UDGv0clSHQdoxLvVMcziQ6k6NvZgxdQGbk0egoyAnJpzZ1eS6
	fFQ3zOOMO57yTxdHaMjzSZT6qRgSH7kAYPyzUngQ5leHJr5KmUZSXgSHNI9cSzz3yTLBpTLlcLG
	ccyTrg==
X-Received: by 2002:a05:7301:1f14:b0:2b8:68cd:a7b1 with SMTP id
 5a478bee46e88-2bd6065fcfemr4784561eec.0.1771840140293; Mon, 23 Feb 2026
 01:49:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
Date: Mon, 23 Feb 2026 14:48:48 +0500
X-Gm-Features: AaiRm51bxg5QV7jqug2M3T9JBU2bmhtk4-waCknrwQZdqjjXg8ubDaAgn7oll3A
Message-ID: <CAEmTpZGcBvxsMP6Qg4zcUd-D4M9-jmzS=+9ZsY2RemRDTDQcQg@mail.gmail.com>
Subject: [RFE] xfs_growfs: option to clamp growth to an AG boundary
To: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I ran into an issue after growing an XFS filesystem where the final
allocation group (last AG) ended up very small. Most workloads were
fine, but large reflink-heavy copies started failing. In my case,
copying a ClickHouse data directory with:

`cp -a --reflink=3Dalways ...`

fails on a filesystem with a tiny last AG. Using --reflink=3Dauto
doesn=E2=80=99t help either, because `cp` doesn=E2=80=99t fall back to a no=
n-reflink
copy if the reflink attempt fails.

To work around this, I had to write scripts that compute a =E2=80=9Csafe=E2=
=80=9D
target size before running xfs_growfs. The alignment I needed is a bit
awkward:

1. Round the LV size up to the next multiple of the filesystem AG
size, so the grown filesystem ends exactly on an AG boundary (no
partial/tiny last AG).

2. Then round the LV size down to the LVM extents size (4 MiB in my
case). Rounding up to the LVM granularity can reintroduce a tiny last
AG.
If the automatically chosen AG size were aligned to that granularity,
step (2) wouldn=E2=80=99t be necessary.

This feels like something xfsprogs could support directly. My proposals:

1. xfs_growfs: add an option to print an =E2=80=9Coptimal grow target size=
=E2=80=9D:
the current(new) block device size rounded **down** to a multiple of
the AG size.
A --json output mode would make this easy to consume from scripts.

2. AG size calculation/alignment: when choosing an automatic AG size,
always round it down to an alignment such as 4 MiB, or (preferably)
consider the underlying device/LVM extent size when it can be
detected, instead of using a constant.

3. Docs (mkfs + AG sizing): when specifying AG size manually,
recommend: choosing filesystem sizing so the final size is an integer
multiple of AG size (i.e., no partial last AG), and aligning the AG
size to the underlying allocation granularity (e.g., LVM
extent/segment size) when applicable.

4. Docs (xfs_growfs): add a note that it=E2=80=99s highly preferable to gro=
w
the filesystem in multiples of the existing AG size, to avoid a tiny
last AG.

5. Optional grow mode: add a xfs_growfs mode/switch that grows =E2=80=9Cas
much as possible=E2=80=9D, but clamps the resulting filesystem size **down*=
*
to an AG boundary, and reports how much space is left unused (e.g., =E2=80=
=9CX
bytes left unallocated to avoid a partial final AG=E2=80=9D).

This might sound like a corner case, but it=E2=80=99s easy to hit in practi=
ce
when the block device is resized to just arbitrary chosen size then
xfs_growfs expands to consume the whole device.

Thanks,
Mark
