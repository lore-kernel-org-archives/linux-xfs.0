Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2061913B7A3
	for <linux-xfs@vger.kernel.org>; Sat, 21 Mar 2026 10:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774089009; cv=pass; b=PoIY7k7KWfwh85EL41HsaXKgs3uU9v3biTz7uYVXlfBMfxLIUOB5tjraLgCMqWBMgnea1np0DT7Ognf9O8ieDzAVP8HcAOBqYjZXFk9DmVMO5M2hiXvg/WGszU86iNnBK4CS5nE0g1Yev0fwcghkEZAJFdPyVGqWf22smnhFtCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774089009; c=relaxed/simple;
	bh=EJ/YNYsP+xhMycJTyyc8byjhq0kZ3YMsWYpFsstjOd4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=DMJeMn9SsjV/8R3QAohmRZ32WY1YUHgHUqpb+t9QK+DHl5gNRR0zRX5cS2NdRV/AgouWCMo4kxlIw79E9ovggAjC+zG9sdvAd+RMcaIfwOsLNvD5l0UPgsyk2YCTtPN5WIrINemM4SawkiolGXX1gBVGvQNxSoY3ug+Mjgx6QDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iONINjJ4; arc=pass smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iONINjJ4"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35b905e9dc0so1817295a91.3
        for <linux-xfs@vger.kernel.org>; Sat, 21 Mar 2026 03:30:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774089007; cv=none;
        d=google.com; s=arc-20240605;
        b=XjYCXCiLtqc7u9MusoaokMr3JLec+ra+PXKfyeHbZ/SX5BwFF+pwZl8b6U3Xp6IjKs
         sYgPUGfqnHo2pG5CS4nS/hX2PG/oS0D+Uk2wtsMoaCtRBNOmDwZ45fGNTcaNc1mPgtUo
         abo+u3Ds4U5VwJ75KSKGsHCEVemrJx6rbrXpGaoOgkSLRURKZbG4EMLBiXb3beaopxwp
         ipPbSsJYe1gXVTnneOxbF9M8Og0G3pWu0ehALkNtOuGNpaGqRN6M7Wn4yxeLHVoKZSzi
         Xx23EDOMKqL8/AY5PG6QQ9jrwL1sxXDpLeM0/wz1b80L4GRRdcmj5EVfkDSZ+ZeYO0fx
         Onqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=EJ/YNYsP+xhMycJTyyc8byjhq0kZ3YMsWYpFsstjOd4=;
        fh=717UJfa65qmxQPHgXYe7gUuNhUmUVEsh3JzHptCWmjI=;
        b=Lgizk0x5l78qCi/BCRECyeHQIJ3H3mmGoOktnA/mqUdAJzVlsKZvR8/Ae4jOAmgvVx
         6fx501gz/kNkN9uLc1wQCZWAO0r9k23t4h8WyWKp6TIxZ4rrULaYbdHEALl7pd97Z9E+
         AYef1LrHtVWX4X4iJM5egoC0BRM7LI3hoVr0/P/xP3DG+WvfvFqxvz2ZIZIuIyO2TKzw
         WVuVpJHkUIpf+sH3zYlI2uS/Rq3ZoDZQsp4vealcbP3Ra7xZJbXRfAehdqa7GQTxp+jI
         wvNLZTBsvJMdQ5+YTzCCqPycle44lM0oFPH4om4BfTswCxTluOJdU/4gcRwMMowhQBKJ
         aIBQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774089007; x=1774693807; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EJ/YNYsP+xhMycJTyyc8byjhq0kZ3YMsWYpFsstjOd4=;
        b=iONINjJ4Wl1BxrEFrD90w1nZMSm1zUWR0OueiGT6x8RmEb07cjOVdwQoJ1TDRKMYh2
         6NDgXBPcxr4f1lKT8TTW6M+H1u0vGJ5CDzitaK5wYa3J6Wu7nImYyywmZYjOb8WzIzHa
         D4ITz5vRLjJZRvSOgeFlITVSqXOkHSqNVrhpZJbFrG5XsiGK1TbgxejuZ02ymIV3vYqs
         YfpuLTK8e5GbDbarzjLUqpTqmojLkZrauWIM7JVQms0qHG80vHq0sKMEqjT1WUeXi2jt
         LB8v6a5g2YtMfjWNY+rKWat/rohkxjmC9hWQXLn7vIibRNje7J+6RZ8g/rS9MW5Mi7I0
         zL0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774089007; x=1774693807;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EJ/YNYsP+xhMycJTyyc8byjhq0kZ3YMsWYpFsstjOd4=;
        b=fVnaFxzLV/lUQdBYj4okKvLPA5mAog/11o85tdMZ6QMApCUGjxz+EL1QmwK462O/Yo
         oiZ3PcWfHuSzREg8CcnG+jW+FuuJxsh9wU0TcfGPhmMXzT+nQ2qqHKeSdba1l+BNVmHP
         BpHmr63OFZHHlj5vJPRKvt46rEIjFDKkvY7UaTdu+gwhcDEnn2icA6SaxxtXPYnF4YKU
         RlquXLVJJW4QFgaWkKYzqEKjY3HpzS3Y2rW6WrpHoQSx/bySmiAw/Uvu/w1FvrxDBMWY
         7tKuvgF4VYnFnpF9MyhVLPRYGMC+9LAtNVYZU1NBUDQpBk66EPiOsCDV/mChw87UOAAf
         hgzw==
X-Gm-Message-State: AOJu0Yy83W9AJOVWU/GJuplYbwp24xnAJf0laX7wV/64Rp95fOB7WPAl
	FrNqsJgtYWr+D4eSkBrBBD65ORoWkTEprxHYopFVyxzKtcoESo/g2MjJN4PGtbPu8txhf3Ghljb
	QXAJ57As5F9fpGv6W353bsbt75hSpzwOIswbV
X-Gm-Gg: ATEYQzyNAJDyYLK3ly8b+mRFRbJ4fmsWIElEg7duIjAAgVvIsiq2r+f9mC+FvIRSaOB
	3J+JjF6cIC/U65it3grytyXQ3g2Tp1dGIC7Z3f3UCxvX3Oi2llXnzh+urnGSo8JZeIEcWMlhNvy
	+6uE2eNbZbzbntMWXd+lfBlG1o9wI6EdeoGuTXlvWnSPQRWJavABETNN5i8ALgCUQKSomYlIj/W
	TmSzT0D2KwSaGYOmDXlHM7WMPQ/3o+kUdVVAADFaJom885pyaDRUrsjaGvPqnF2TcuyO8808Kqf
	D0JgUj1Cmmf1z/kIZ9yPiLDXK8RfjG04hO3JjY8=
X-Received: by 2002:a17:903:2b04:b0:2b0:51f6:d46e with SMTP id
 d9443c01a7336-2b0826f6ce5mr57047465ad.15.1774089007108; Sat, 21 Mar 2026
 03:30:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jorge Bastos <jorge.mrbastos@gmail.com>
Date: Sat, 21 Mar 2026 10:29:56 +0000
X-Gm-Features: AaiRm502m1dibyx39Ym071r0T9BPVpC94HrpmMYXt3AB9cn6cjzGmw1Vvb_5AwA
Message-ID: <CAHzMYBQ8NiXOTpKn5cBtSmb5ObMNdqhnXjbiZxi7wTdd=aA3WQ@mail.gmail.com>
Subject: OK to use XFS with a 4K sector size with a 512n device
To: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Are there any known or expected issues, if I were to use XFS with a 4K
sector size with a drive that is 512B native other than possibly some
wasted space and write amplification?

Mostly interested regarding any possible data integrity issues,

This would be caused by using an intermediate block device that always
reports any device as (logical/physical): 512 bytes / 4096 bytes, and
this results in XFS using a 4K sector size when creating the
filesystem.

Thank you.
Jorge
