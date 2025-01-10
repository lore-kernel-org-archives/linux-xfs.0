Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568735028C;
	Fri, 10 Jan 2025 17:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736528884; cv=none; b=J0gdciXT9HVHSONjyrqsr+sF9pozqxkJnF1oF8etmkVmkVIENkboLrUBYKwuamowxwSJw/oiD0Luqj0Cm9DnhmENaZnjOGeCwoq56A4dM1w4wHCNo9EKk4J0ggPvK5rfxSaA8xdMV5/XKIlZLCuj0ee2lTRbJ5EeLMHxJ+2zXAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736528884; c=relaxed/simple;
	bh=h5yTSVKAMaOonmeGWGXqD1HTuvQ59UddMc4WIKNqGW4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QDweYPeu895/opS1J1HzyMYtCUVWMCqbyM/d/6bKnbYdcroFd7kSYJ0neS+xl7eRBHYaO1C+toppzMh1SE1t9/CDp5IPr5Se57QBLpr+1IDtY951V0f81qJ05+PooIcw7h8xSYtixwwGo6dVEGjkDvLrBlunqhS7zFAmcAJPgTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KgpLZIvm; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KgpLZIvm"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aaee0b309adso373240166b.3;
        Fri, 10 Jan 2025 09:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736528881; x=1737133681; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3D0sVjl3aa3fdPEvXFJ91n5OIyFNl07TDhH2YzfWZI=;
        b=KgpLZIvmME1urY3uv2T41wi5jiAJRCN2EMNf3EpO2Pkh51Y1S7kGcCoH1LbQoYX4Mg
         lxAbX3mVA/bjrO8LOJujLYbIWUHX80U/GFv2s926VwlWJbWcumQbJwoW64n4pMwH8MHG
         SOHhfYHo9Pf5mblRouVAUfEcseg1vn5WN53F0VWrfZoC90GmYGYPn416QNDFn1PL8jc8
         mu9U0yMVdkAvfsvxpxIDnJCzUF/giNAfHSRehqSdGD6S2dkq3XWpb0qX5ywu9eOzbzqW
         uJ1aVHb4Q8sUYjo3by8dfyCo0LMV01L2sX2+VTceSRK9EYA9g4xWDr5TvBmv41fPAl4J
         RQCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736528881; x=1737133681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T3D0sVjl3aa3fdPEvXFJ91n5OIyFNl07TDhH2YzfWZI=;
        b=b3ew3YmKx8/ZhN5GCehdpz25lCmDKPNp5+wd8ZodF4Ah3ivaWhtBoZJalsTHF1NXY1
         hXU9Z4h7u3j2bBPsNI8H0h7P5B1Ylj5epKXBh5nJDxQB+Ta+WsofHSid/JhHDpsErB3+
         e5t0wu+SjVy0QYaWXrkX5tahvL2NkC8tDaiqtqN5tbqtWpPiIseXQhRitripE0Wewz5M
         S+ZI3Z1Rq5Qs0YSr1v1nsEgrC6rRYg21e92+SkUvkFBCljAFMEPmNpqg5leAgdzYEvcu
         t3mof6QbQM2OYFzjqcdBu1nibhoB/fUVFoDt5lPIRpOruZHA/bG98holLoMkaVngwlqp
         qAsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHCiyO/Vv6nySj1AH1PXzxrLl/eRxwe2gAurh/NI1FPv0r7bbFiBXSek+Y5mWSn9l0jH9wNqYTnz7+u6E=@vger.kernel.org, AJvYcCXu/IJYDI/wrh4RF1SHa4vcLgD6Qyj0K4tw8mWjjcUNNTf7A0LroaSTDKPHk+7iDe0kWyiR5+xuSC+c@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6GxDhO/3G1+zvQ1HfVw2YUjEN9gXxs+BH6EgYOZvowD0KGWeg
	cH8kPrze63qFdM80hTSQMgHdWwaxgnqE85Al1MVusNy0HGQ20ZITXvECNd/RnqY6n1Xwz2ySh5A
	EEv7cR0WsPuKVAy6JF3+5QVrTNKQ=
X-Gm-Gg: ASbGnctx7oWAH4/veVmu4WTc0SxVyw5gRMeCw+4CbQR7r2xF8NW1jjOs4UCcs//1PcQ
	xyn6OXprbSqOwa6Rb5JVu1g+AeezFA74LutcsDw==
X-Google-Smtp-Source: AGHT+IFx8LMC+TD7As1Xy4ZzyVgtoFkv9yrxUjlDsDiTApgX9jjKl3Ez7my76UKQ3DzrNK5Zb0B+wGKfAVH0z0iSTmY=
X-Received: by 2002:a17:907:7f94:b0:aa6:6276:fe5a with SMTP id
 a640c23a62f3a-ab2abc6e752mr939113766b.43.1736528880090; Fri, 10 Jan 2025
 09:08:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241226061602.2222985-1-chizhiling@163.com> <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com> <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com> <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com> <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
In-Reply-To: <Z4BbmpgWn9lWUkp3@dread.disaster.area>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 10 Jan 2025 18:07:48 +0100
X-Gm-Features: AbW1kvYjydIH6Ib9vpMkZJmi31iAH7K2f_WzLcoWgujy3ncBZ2pptRfed8do3K8
Message-ID: <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Chi Zhiling <chizhiling@163.com>, cem@kernel.org, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chi Zhiling <chizhiling@kylinos.cn>, John Garry <john.g.garry@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2025 at 12:28=E2=80=AFAM Dave Chinner <david@fromorbit.com>=
 wrote:
>
> On Wed, Jan 08, 2025 at 09:35:47AM -0800, Darrick J. Wong wrote:
> > On Wed, Jan 08, 2025 at 03:43:04PM +0800, Chi Zhiling wrote:
> > > On 2025/1/7 20:13, Amir Goldstein wrote:
> > > > Dave's answer to this question was that there are some legacy appli=
cations
> > > > (database applications IIRC) on production systems that do rely on =
the fact
> > > > that xfs provides this semantics and on the prerequisite that they =
run on xfs.
> > > >
> > > > However, it was noted that:
> > > > 1. Those application do not require atomicity for any size of IO, t=
hey
> > > >      typically work in I/O size that is larger than block size (e.g=
. 16K or 64K)
> > > >      and they only require no torn writes for this I/O size
> > > > 2. Large folios and iomap can usually provide this semantics via fo=
lio lock,
> > > >      but application has currently no way of knowing if the semanti=
cs are
> > > >      provided or not
> > >
> > > To be honest, it would be best if the folio lock could provide such
> > > semantics, as it would not cause any potential problems for the
> > > application, and we have hope to achieve concurrent writes.
> > >
> > > However, I am not sure if this is easy to implement and will not caus=
e
> > > other problems.
> >
> > Assuming we're not abandoning POSIX "Thread Interactions with Regular
> > File Operations", you can't use the folio lock for coordination, for
> > several reasons:
> >
> > a) Apps can't directly control the size of the folio in the page cache
> >
> > b) The folio size can (theoretically) change underneath the program at
> > any time (reclaim can take your large folio and the next read gets a
> > smaller folio)
> >
> > c) If your write crosses folios, you've just crossed a synchronization
> > boundary and all bets are off, though all the other filesystems behave
> > this way and there seem not to be complaints
> >
> > d) If you try to "guarantee" folio granularity by messing with min/max
> > folio size, you run the risk of ENOMEM if the base pages get fragmented
> >
> > I think that's why Dave suggested range locks as the correct solution t=
o
> > this; though it is a pity that so far nobody has come up with a
> > performant implementation.
>
> Yes, that's a fair summary of the situation.
>
> That said, I just had a left-field idea for a quasi-range lock
> that may allow random writes to run concurrently and atomically
> with reads.
>
> Essentially, we add an unsigned long to the inode, and use it as a
> lock bitmap. That gives up to 64 "lock segments" for the buffered
> write. We may also need a "segment size" variable....
>
> The existing i_rwsem gets taken shared unless it is an extending
> write.
>
> For a non-extending write, we then do an offset->segment translation
> and lock that bit in the bit mask. If it's already locked, we wait
> on the lock bit. i.e. shared IOLOCK, exclusive write bit lock.
>
> The segments are evenly sized - say a minimum of 64kB each, but when
> EOF is extended or truncated (which is done with the i_rwsem held
> exclusive) the segment size is rescaled. As nothing can hold bit
> locks while the i_rwsem is held exclusive, this will not race with
> anything.
>
> If we are doing an extending write, we take the i_rwsem shared
> first, then check if the extension will rescale the locks. If lock
> rescaling is needed, we have to take the i_rwsem exclusive to do the
> EOF extension. Otherwise, the bit lock that covers EOF will
> serialise file extensions so it can be done under a shared i_rwsem
> safely.
>
> This will allow buffered writes to remain atomic w.r.t. each other,
> and potentially allow buffered reads to wait on writes to the same
> segment and so potentially provide buffered read vs buffered write
> atomicity as well.
>
> If we need more concurrency than an unsigned long worth of bits for
> buffered writes, then maybe we can enlarge the bitmap further.
>
> I suspect this can be extended to direct IO in a similar way to
> buffered reads, and that then opens up the possibility of truncate
> and fallocate() being able to use the bitmap for range exclusion,
> too.
>
> The overhead is likely minimal - setting and clearing bits in a
> bitmap, as opposed to tracking ranges in a tree structure....
>
> Thoughts?

I think that's a very neat idea, but it will not address the reference
benchmark.
The reference benchmark I started the original report with which is similar
to my understanding to the benchmark that Chi is running simulates the
workload of a database writing with buffered IO.

That means a very large file and small IO size ~64K.
Leaving the probability of intersecting writes in the same segment quite hi=
gh.

Can we do this opportunistically based on available large folios?
If IO size is within an existing folio, use the folio lock and IOLOCK_SHARE=
D
if it is not, use IOLOCK_EXCL?

for a benchmark that does all buffered IO 64K aligned, wouldn't large folio=
s
naturally align to IO size and above?

Thanks,
Amir.
