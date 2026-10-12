Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F65B4C650F
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 20:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791836848; cv=none; b=LAqktAvGpBh5nsXMNBy0qxb+SkS9z/qdLOhT3sO3BHEr/ToNK/QcJX06EbCsngmzBwjwwp4b58MNliZ+10xomI/7bLPjbdYAezevtzAzzAN14aixWuAD1OZDXFsm0R0pcwTobxH0k8Fk/5Tw2EFUROjL4mQfr8XfHPiqgTQnwj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791836848; c=relaxed/simple;
	bh=AyoC94EK9vpQWgV4XxtIbxwGkrxrvQz6epoVwZIMcDo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=WMjaNnq8FWNxOMQrSyMMao6tHz99u7yYLvYmV4yt7x7nuTDEGUuJKJk4db+QbYQ4Gj4gMmfspcmZLaiuDPrUvh7gK86WeH1nu9e+OSCwGk4rUA62o27nPyXmVlC8eb5XiXR/R1BWNp5CNfNaWvupD0UgPDnAN0TKy3FlDUtilsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fSq9ILX7; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fSq9ILX7"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a0213948d3so14014035e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 13:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791836841; x=1792441641; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dOWX4/2FZNwbfZ45QI8y2QNhKW80s5ngK5wZYM8h0VE=;
        b=fSq9ILX7Xz41rSdrcJSGs8lxZ9oxYqb0N5IxBm2+DelXCRL2hoXwWC1Qh2R91QiHY5
         /F9iB7vupjb0F254AC4i//rO3PmlbxnNGvZ1TcqKfUD4BP95xz/2RqkQ8w8Rf6iAldSE
         Iqmz3LMRk4MAIVQk/L4/gz6SpKGE5Nn3T1S57Z3J7NkjyZzyZDWIMdOhYtPMuz27lJA5
         7K9YdV41WOQQJBJdSIl6OrXMaxmZQ8RBKkzF4hE/ezh4kAPWjhq0FfowgjQh8eIvBmag
         6bQa8tLVGxrQ0oU+R1c0MdAIBwOPij8n86uBRJdTvk7hHbHzcP6G2PQTMO8qJ1FC5D9B
         zy1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791836841; x=1792441641;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dOWX4/2FZNwbfZ45QI8y2QNhKW80s5ngK5wZYM8h0VE=;
        b=25Q6MNH4Zt31+4YRRMpsBnuFKGqSbf5HlQqbox2HFheNqJdxlsagxXqdSpbKXHIlCK
         ekSQx+J7QZuNErt8G90J4iPnEg7W39RWLZDzTNmxzJ5yfwnLN8LyTMhY1cKS7jhkkWQC
         KvDgxydu78XvlRab2IkSzlGSFojEuapJh7HSRHZ5NEfL/MtBuNS1bhIsuj6UqjiKW/yt
         6p4J/+Sd2Buy4f6MLiHJdouWDEM5XsHM38S81IJY0Y2ZOmrDuqHcWjjA4CRdUxzMhDyJ
         sTJRBaxbR0VtItQMOjf6trmy/QGf7fKuQVOA9JI0Ju61Sj0PpKRVSDqh6wceYxmQ1ABI
         KOmA==
X-Gm-Message-State: AFq9FYKgOnvCKgibprVD05VvqqXeSn8kutN5vBIMnhZsAV7XoaalCAZh
	m7Fu+RG/BQKMoCnVUY8X7b9m6srUoRqUafPIybZlOOAqnCQSqfhit0+d+YXCkT13
X-Gm-Gg: AYBFou2Qk3dANVZfFA6VLY4J2FmPc9bl3pO6czDSlbnWZ4HL6nId/Cqz109VoXMstvu
	Dnq66oEZfWZuizrjrWclrqjsUH1MUFhTu5Ce51eTXgdFtJOItRH5faPxWljhuB61c1yqvG1noY3
	4S0hep1EzUCpshMqZyGJxuwkp8vXskA24p0KPz1Ipx3IItEhKeQ+TRetIwZY1HIRm151RKUpJku
	ePACTSe8pCeJVqX2g8sgyblsnbKSnvccvhKJHaoeoA8LZsStYxQGJroc/IDClD/kVxqAI7zb5Gz
	Z++TMqxriqXsWIZ/T6YCrPSkTeeWDweofrD+kY+/Y83DC4jPlWgkYPpctwtfzeqkCqx/53YN8eM
	Dy57xS/4hc0PctliwUnrlel2n7U/ZY9yp1lB5wlrRxCLBLboD2RBNRx4XL2M6jvaifaXSnRM+ix
	YzYDyNUtsAjgrKnw9FmmZzol1f8i+5lqShVOvNTeKPwVpuzw8H/9p2
X-Received: by 2002:a05:600c:810a:b0:4a0:2391:6533 with SMTP id 5b1f17b1804b1-4a18e4a954bmr181971975e9.21.1791836841307;
        Mon, 12 Oct 2026 13:27:21 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bead84esm309144445e9.13.2026.10.12.13.27.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2026 13:27:20 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: Really bad I/O lock contention between non-overlapping reader and
 writer
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <CAF8PYMjKrRH-kYJkHcqXx0O1AjOgPH6PGi3R007G-qVZoXA_Pg@mail.gmail.com>
Date: Tue, 13 Oct 2026 04:27:04 +0800
Cc: linux-xfs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <74884C5A-DB90-4BB3-A2F0-2B957DA69CF8@gmail.com>
References: <CAF8PYMjkpEkoop-Wbk=2oBMdqer-pWh1osPvhSv90D2fwLSv0w@mail.gmail.com>
 <5985D8D0-2411-40E0-B20B-8622F156AF90@gmail.com>
 <CAF8PYMjKrRH-kYJkHcqXx0O1AjOgPH6PGi3R007G-qVZoXA_Pg@mail.gmail.com>
To: Vitali Lovich <vlovich@gmail.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)

On Oct 13, 2026, at 03:53, Vitali Lovich <vlovich@gmail.com> wrote:
>=20
> On Mon, Oct 12, 2026 at 12:38=E2=80=AFPM Alan Huang =
<mmpgouride@gmail.com> wrote:
>>=20
>> On Oct 13, 2026, at 01:47, Vitali Lovich <vlovich@gmail.com> wrote:
>>>=20
>>> I think I encountered suboptimal locking behavior with concurrent
>>> readers and writers on a file, which resulted in huge latency spikes
>>> for the reader even though the writers and readers are touching
>>> unrelated ranges within the file. The writer/hole puncher hold an
>>> exclusive lock on the inode while forcing a flush of outstanding
>>> writes to disk which creates huge latency spikes for reads.
>>=20
>> IIRC, there is no fine-grained concurrency control on the same inode.
> Correct. However, I think there's a middle ground without rewriting
> the VFS layer too intrusively. The rough idea is to have a new
> mechanism for filesystems (that opt-in) to track range operations. The
> inode lock would then only be needed to protect the range tree. It
> still has lock contention on the lock obviously, but the problematic
> operation - needing to do I/O (or even worse waiting for it to flush)
> while holding an exclusive lock - is relaxed when the ranges are
> non-overlapping.
>=20

Tracking the range operations might need the previous/next-key locking.

But It is up to the maintainers to decide whether to implement =
concurrency control for operations on the same inode.


> Thoughts?
>=20
>>=20
>>>=20
>>> I've observed read's taking >> 500ms even though none of the writes
>>> could be overlapping and traces seem to indicate it's the shared =
inode
>>> lock contending with the exclusive inode lock that writes / hole
>>> punching is holding. In my real-world test case traces indicated =
that
>>> the cause might be inode_dio_wait while holding the exclusive inode
>>> lock.
>>>=20
>>> I've observed this behavior on XFS, EXT4 and BTRFS so it seems like =
a
>>> general VFS challenge. Generally, Btrfs seems to have less read
>>> latencies created than Ext4 (~2.5x more at the 0-1ms read than =
EXT4),
>>> which in turn has smaller and fewer tail latencies than XFS  (~2x =
more
>>> at 0-1ms and extreme is smaller) although all filesystems exhibit =
the
>>> issue. Starting with the XFS list in case I'm way off base that this
>>> is a problem.
>>>=20
>>> Attaching a simplified reproduction of what I'm doing with one =
writer
>>> appending data to the file, a separate writer punching holes in
>>> unrelated ranges, and an O_DIRECT reader that's reading data. Reads
>>> are doing random 4kib I/O in [0, 64MiB), hole punching is punching
>>> 4kib holes in [64MiB, 576Mib] and writing is always appending after
>>> 577MiB of the file. The directory the anonymous file is created in =
is
>>> CWD by default unless you pass a different path. I'd expect read
>>> latencies to not be impacted by waiting for writes to flush yet it
>>> seems like clearly there is such a serialization.
>>>=20
>>> cc -O2 -g -std=3Dgnu11 -Wall -Wextra -Werror repro-syscall.c =
-pthread -o
>>> syscall-repro
>>> <pessimistic_locking_between_readers_and_writers.c>
>>=20

