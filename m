Received: from mxout5.mail.janestreet.com (mxout5.mail.janestreet.com [64.215.233.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1C54BC03B
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 17:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=64.215.233.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781025320; cv=fail; b=mUGdFFiVyynTFK0Ya+7gPyfWEYbxtyh7YVCmd9tO0N30v/TDYJFb5yaFDoqxpJr8HFLpBL62b49RfURQbuCp1vj67qId3tJFsCrqDWVhZjyXwE9KDz2pqr5RKewJCkBXrObHrggQDsgVf9rp25lH85LZESXKpCDPTrrM98nUfe4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781025320; c=relaxed/simple;
	bh=2inTUhdt8YIA2l57282yKhLtyF6GdP0EAnIKVqphNjY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TOu04JlHClz+iN1f7WE32643wE5dpDF63ryKAm4qCtjaGb1FBIsL3jMFkGwkQ3hIchKRDN6Wh6D3+zLuqVObQEPbFT4U7J4P+qSEESwxPYznLBNr5LFyi6wWAGjBPzO1vKMPIHWh74kKnzi+HwjIv8D38AjpcpiFBNvqHbglqJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=janestreet.com; spf=pass smtp.mailfrom=janestreet.com; dkim=pass (1024-bit key) header.d=janestreet.com header.i=@janestreet.com header.b=14GHb+ju; dkim=pass (2048-bit key) header.d=janestreet.com header.i=@janestreet.com header.b=bxuhayvq; arc=fail smtp.client-ip=64.215.233.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=janestreet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=janestreet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=janestreet.com header.i=@janestreet.com header.b="14GHb+ju";
	dkim=pass (2048-bit key) header.d=janestreet.com header.i=@janestreet.com header.b="bxuhayvq"
Received: from mail-ed1-f70.google.com ([209.85.208.70])
 	by mxgoog2.mail.janestreet.com with esmtps (TLS1.3:TLS_AES_128_GCM_SHA256:128)
 	(Exim 4.99.4)
 	id 1wX02o-00000008bJc-3mdz
 	for linux-xfs@vger.kernel.org;
 	Tue, 09 Jun 2026 13:15:18 -0400
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-67e32a60b39so966880a12.0
         for <linux-xfs@vger.kernel.org>; Tue, 09 Jun 2026 10:15:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781025318; cv=none;
         d=google.com; s=arc-20240605;
         b=UNXMnJZ3uG3H4sP+o4o/pkjy85cJuax+iMV6VhD+FgwvxFLQfPrQtlEaFcoaWLWUn9
          cEz3flRWvqG3idEgEQ8zKCs9BLhwCV34tuJl3EPVLUB3wmwkOOGZ5RgLWaSXvl/0UE1x
          XWx2G5Rh0/uvhLeFcViGRUMcsS3rL9CH4oHEeetHLuuWUItUBzbNcH3CQOqDjmaKM3n5
          CDaRXYo9ObXkV87fRWgVbIn7UlzFy3V3aSrs1MP593hsfaZYh+EBnhFu3Cb/Z81B8M11
          +IZ9nVUaLwjBzwhGelImkdthcEeJtqJ6EbDdQ+OVNgdFk9LPoQKhpGNrNdeldPjstRSC
          M/yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:dkim-signature;
         bh=G+/6fdbcggFvGkAF9hirx6Oyq2sHXWyVk+eenuvWMpU=;
         fh=P34MJWH6vY3aUbK2gNtoW6ddA7K6r6If+HsMBeHoZUU=;
         b=Pgja1ZmWC3rHoTtV1BvyOV5tsxue8w7J2iMyLkhTz8/VCxuCW9wAU9YKOskINFwkd7
          4G+43DU+IOQVL9FrmsaHCO3vedGetcJIoXoT1Z7/YFnkWWuXTnR6iYcl7Src3djVTrbS
          ubg0Rxwv5bajNE21MRz8DOEWTC4kfEoEuQmyqE3Ya8Wk9NOmtUkqooLN0ATReg55IoBX
          KDygiSYJmEZWKgp29/ONkDucwkmCNRJ4unAov7IzViSj7okSviwh96vTvAm09VOV0Qpv
          5dwmEWTb844pY6B9AtTtRfUIYlWGBBxEOn8CpreuhTfy4q20m8BUiPtk8NBCcpIr7k9w
          7Chg==;
         darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=janestreet.com; s=google; t=1781025318; x=1781630118; darn=vger.kernel.org;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:from:to:cc:subject:date
          :message-id:reply-to;
         bh=G+/6fdbcggFvGkAF9hirx6Oyq2sHXWyVk+eenuvWMpU=;
         b=14GHb+ju2esx3Wgg5mmRt5GlrxqrjzQSjDzjgES+bcWzonX1Le6Wjr34/Y9S0yFT+m
          NHwejsCJoUWIia+KzYYZFkDup3N+2hO+uLUSGtGKAytHhT8bIr2/nAUGDi9kdgFNPtSJ
          n8siNmQHrCaZFjEJiaNMulUYVPCnZCGoNuXGE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=janestreet.com;
  s=waixah; t=1781025318;
  bh=G+/6fdbcggFvGkAF9hirx6Oyq2sHXWyVk+eenuvWMpU=;
  h=References:In-Reply-To:From:Date:Subject:To:Cc;
  b=bxuhayvqwKiq94VNY4I3FizRPKEkAZvNdQ0XgwNLsnK4zKGWG7aDf1nI6Gj/XYzaH
  txwxQFIK+TUgeT/CqJKeJjx5Zth31vqXejR5X+iiroxlu3PPdtAdYnQTPplv1zGMpu
  5CoJPG3F00KSZm4LGURzHqgL2uf3/Z7wxn2VtqgNnbVZviaRhaEobvHL41mFnp0aZJ
  w75apA7w90iSVzJW/CjHQGUGba1/v1cRalC7sJ0sLmIwfTr1aVb8JE6Gy6QXAVcvdv
  0tEYkM0qV1eDS9jyLoiKMfNGxcxSvlKRiyqfxN1mo8iAygC8m8ACafgAzYpDiAYmiD
  QxQ2KD7gg8Amg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=1e100.net; s=20251104; t=1781025318; x=1781630118;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
          :to:cc:subject:date:message-id:reply-to;
         bh=G+/6fdbcggFvGkAF9hirx6Oyq2sHXWyVk+eenuvWMpU=;
         b=AdMlKOHtuSXziPDmKSqTl91HSB4gp34rCcwU5qonX/Za8+wOzBNC5VAOgTAz214Bpo
          uTwehKf5NCaC/HkYkfCl2aE9ac+cDjiVnVmK0Th05XOIDpuYSHbpSxPD4sYCzvfL3gbQ
          fRXRxqbb2jdWrdvEnctyHMvCSkgBS7rPSCsk4X6J2ffA0gguI+IeLvehzBb59daZGJXL
          pBOJlsTc+JM6p2RBGhLjlENkMCxx5Sx9INGGGfUYogdbUefLYuS47180hzf64vmyEG6g
          JM4VM/L8Ic91YHkEiBMmbRYbSOMl9XITekRn7qbIphVlI23taLx4KZeIbgAt/uCbfRve
          EcAw==
X-Forwarded-Encrypted: i=1; AFNElJ8M0ONscYZlx4ZljbzzUaHaLdw20nH6rrrReSWWeOT19bo0Q6xSr0YxIfYLMJr7ra+Tj0XjTAc9Moc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBazEIOA2sA5rxpdSH8Nc0XW1qgQaiuEO3k13EjnCLo6XPu/6z
 	nj4bSbfEJtdWDZT3a2JZLjlXWcHFreZXGc50L1GUHQap/g0tXzjzKtz2Z6jxacwSeypzZq98tiw
 	acGKgQdEDEcktH65FHGHgp8rVomXTemjAV7idB9tlO9gRx+IpZqiwVUM14CLQR/Tbkxix7LW+uu
 	oRZnia063jadf93p1r/gV+pUH5Ycn3uvfcgiE=
X-Gm-Gg: Acq92OHw2dTWYFXrKs5DbaTMOvwWHUGyHsj0j3glV6LxBamfUlqPPlgEKLtfXxpmYty
 	cO94Mv+zwQzNr5ruS6MVvBi7y7jDxjBaftE3lj0gCEhuXgWYq8gXw3QCGngxbu/S7tmxnXUdBO1
 	jlxJr7LBeEJKEyUdJSnvyij160Vaq+/7iI3Ij1V80iUgYB8mFtbolEcug6W6/k7TSVp71tAxsX6
 	BwD/8F7qOAtJtFj
X-Received: by 2002:a05:6402:524f:b0:68d:b17a:543c with SMTP id 4fb4d7f45d1cf-68ff2186061mr8591395a12.12.1781025317841;
         Tue, 09 Jun 2026 10:15:17 -0700 (PDT)
X-Received: by 2002:a05:6402:524f:b0:68d:b17a:543c with SMTP id
  4fb4d7f45d1cf-68ff2186061mr8591366a12.12.1781025317308; Tue, 09 Jun 2026
  10:15:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFN_u7FrgM4Dzie2jjkLwWV8P0dvUG_Wwy3Q9B3-2HnnWiDu8w@mail.gmail.com>
  <aiLxe-9Sub8cI3Py@bfoster> <aibns0xP6IVVNWh3@bfoster> <CAAH4uRB+Bh9UEVEW8Sb2yM4YhB-Q5UJ6KJJXari3DDF3n3S+-g@mail.gmail.com>
  <aig9Vm2a_13bPc5G@bfoster>
In-Reply-To: <aig9Vm2a_13bPc5G@bfoster>
From: Gregg Leventhal <gleventhal@janestreet.com>
Date: Tue, 9 Jun 2026 13:14:40 -0400
X-Gm-Features: AVVi8CccMZBf_W2neiPGuRO8YpErMCyF7o_iyXweU0WZ58K3osa4MMBejEkzuNY
Message-ID: <CAFN_u7ELBj3YKncm6HA4-QUNyi-a3qPDEYxuLP+skVhm-r87uw@mail.gmail.com>
Subject: Re: [BUG] iomap/io_uring: O_APPEND async buffered write silently
  re-appends a data chunk (corruption) on XFS, 6.1.y/6.12.y
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Hagberg <ehagberg@janestreet.com>, hch@infradead.org, djwong@kernel.org, 
 	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 	io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I reproduce it by running 25 ~ concurrent instances of the attached reprodu=
cer,
each writing its own file, on an otherwise-idle 15 GB VM:

  DIR=3D$(mktemp -d /tmp/uring.XXXXXX)
  for i in {1..25}; do
      ./repro_uring_dup "$DIR/file_$i" 120 48 &
  done
...
*** CORRUPTION DETECTED in /tmp/UmgK/file_17.1 ***
  bytes kernel said it wrote (sum of CQE results): 53621960
  actual file size:                                56218824
  extra (duplicated) bytes:                        2596864
  first mismatching offset: 6791168 (0x67a000)  page_aligned=3DYES
    expected u64 848896 but found 524288 (content from byte offset
4194304 reappeared here)
  (file kept for inspection)



  wait

*** CORRUPTION DETECTED in /tmp/Gznx/file_18.2 ***
  bytes kernel said it wrote (sum of CQE results): 58112616
  actual file size:                                60303976
  extra (duplicated) bytes:                        2191360
  first mismatching offset: 2191360 (0x217000)  page_aligned=3DYES
    expected u64 273920 but found 0 (content from byte offset 0 reappeared =
here)
  (file kept for inspection)


On Tue, Jun 9, 2026 at 12:20=E2=80=AFPM Brian Foster <bfoster@redhat.com> w=
rote:
>
> On Mon, Jun 08, 2026 at 01:17:10PM -0400, Eric Hagberg wrote:
> > On Mon, Jun 8, 2026 at 12:03=E2=80=AFPM Brian Foster <bfoster@redhat.co=
m> wrote:
> > > Another idea that came to mind is to try and just replace the -EAGAIN
> > > return sequence from the low level iterator with a flag that triggers
> > > -EAGAIN from the next iter advance. The idea here is to allow the wri=
te
> > > to return partial completion (i.e. so no iov_iter revert) without hav=
ing
> > > to return an error from the lowest level in the stack. I had claude c=
ome
> > > up with a quick patch [1] for reference/experimentation.
> > >
> > > This is based on v6.12 stable and compile tested only. It needs more
> > > review and testing in general but might be worth throwing your
> > > reproducer at if you can..?
> >
> > With that patch applied, the reproducer runs clean - no errors - and
> > gets roughly the same performance (maybe slightly better) as when run
> > against a 6.18 kernel on the same VM.
> >
>
> Thanks for testing. I'll look into some more regression testing of this
> patch and try to clean it up and post it for proper review for stable.
>
> Are you using the reproducer program in your original mail to test? If
> so, does it require some concurrent memory pressure to reproduce, and
> are you using anything in particular for that?
>
> That test seems small enough that we could potentially include it in
> fstests, though I'm still not so sure about the mem pressure part..
> Since you guys wrote the test, any interest in porting into fstests? If
> not I can look into it.
>
> Brian
>
> > Thanks,
> > -Eric
> >
>
