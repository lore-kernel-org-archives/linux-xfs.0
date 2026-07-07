Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535D83074B1
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 15:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783436893; cv=pass; b=ql+WRnqOOvAM10ivEppb10FdLjry5BpkYdop5QS70LVYSCzKo/omAJ47Z4zYg7ZtvSclNQRt9moN02l2UhJjfIU156+iDtyRHRB6DICM6Rtrb4EDDkO8osz0CrCvlfnmVPOd3tPi2DskN4BxGeUA+sdOJXGKlpDvWF3FJLvkErQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783436893; c=relaxed/simple;
	bh=Wa/VuEMxonEPRMT1usYypUf/WUPegi08SnJQOCR73F4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lfgghkSyt9vFtAU2s2cRT8F5vMwEicSrmTwcRmtx7Z9uUx/rh8l2T6C70aZugv4R3VMhRwnDYMlQso3zCZTDoEh8Eq8akSSfrnJDWrQO0U8H0ZB775VrdTHrC9iDX5XH7OtpkByJPEs+IHUSaxUzoRbw3fYxjydcFhdG7TOY110=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lEiIffCG; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lEiIffCG"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-698aa8d4dafso4311364a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2026 08:08:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783436891; cv=none;
        d=google.com; s=arc-20260327;
        b=JsbMjXUjEOuQI74xDIG999YW98RWVETwT5JjfvBFP1u41weFzOpjwnCPCni34c+T0o
         44N+J35rw42VJ6Fzk8qW0pth8VbTqGjdGfUdrtgWKeDKjn7CFw7LCl7OsWZ5iJPz3TeP
         tWAsXAEKInrd4fCGkZoUMj+C6J467MDMyp/NwHDB+An//3CQZOE6OKC4vKc9RkpLlOl4
         iSgftc6fuAkQi6dd5bZAajBHAPrPxtRRzPZ9ei+Ounl7c9o3GGyVBFUQVh+gHZc0gV3I
         qDrOh+gXshU9WsDDTSjAQyuKaZlnJv7S3CFtb8cMoOd7j3WJfisYwFlpUOtC7pa9TqO/
         TOeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wYVnGR2Vk5DT2xSl8QifhE0cwutuJGcOpDS3t9DQtfc=;
        fh=q7FLQNMxUUFpgJZbe3gYjKo+pWQAHiWEeYHHulP29gI=;
        b=OwgAQ3G6zCrp6pV7vAc7PzYLq4OcFrsUU8vo2dcec1MQYqPBQWOuZUQlAGzzoQ4e8u
         Qw4APnwr55ZJG+8+n/nnXBIzPhTUIfqtPrsN4N6x8YH5F4q6CsUYvjQyCowJS4Ou9SxB
         zK2rRcgA/g/PCWH81o2OZPiWeDVwx2Xfa09yHtJJgHoeJykzcGTpDLkYPfzw6wv1bknq
         p/31iKHzTs3PPu6WSyFzfWHrLKOOpCm8AFGV/2gMZQMSRD+LJu2oRJ6F5tndZCujdJ2g
         //GUi7S30xG7gVSunHbsCxu0rQDQpAp/WtD0946//D444UoAM2st9cqsZWbx2kgx1mKx
         XKLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783436891; x=1784041691; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wYVnGR2Vk5DT2xSl8QifhE0cwutuJGcOpDS3t9DQtfc=;
        b=lEiIffCGjMXAkLJzJ6v6c0ja6W9DQ79FqqaPIIhWqkWjA3o37Plp/SGVBUdDpqukhR
         rH7aa1KMcfCAtBsVHvT6cAOs2QqYrsfKgO7D8R4ccFqRDvRQXlOYRG4Tv5cDaFbhwipE
         nu61mRRTeXOSAXAMDKl85T+qacPycHP4v2MeTCODGVTFcpcdjcUfGhaC4NEIBoLyPRjk
         eteums38EmHEBzR6cdh9ibB29kQ9E0a5bB7oDzt2iDPaNMZEk/ugmOz0FeH8ny1BPt47
         KEQLmMTr9GNmeaWizH5aTLp+l0xB2QLgQVphXm/Lu7uC3OWHBzdCi4GutwX6bi3asREe
         8jeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783436891; x=1784041691;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYVnGR2Vk5DT2xSl8QifhE0cwutuJGcOpDS3t9DQtfc=;
        b=OA2tZKvwuqmqwLYzKWJcAxlj5W4bUdH9pwxhbYe5nM15Vcj0DgPnjLOtQwJN4mA2PN
         FCFV0QF9I0IyY5Lax3iF6oEwE9loWFMs/CrHzvOKWzuzLlo3XfIWUtGvdhTfu5g/2rwM
         0BSWujrLdE2KuBZFIFnIoPW+xUGr4yzLtna1OhrRU5goprkg5xgAaVIEmngXv2Fxa0Qo
         ZgsItIFe1eHW1+vIAnrDkCG/+7DndiA3LFAbX+UvcpPWx5KMwQn6TPYr5iiQTaWIsvkj
         oDXGa0UHo7gt3HiesOLILDe7rg1p7kRjWsQCAFOw85k1/AJly4QJE24jWIcp2alU84dK
         P3ew==
X-Gm-Message-State: AOJu0YzGT0+kjU9QxwffqCFJgTVGotmVjS1BCvv4pw9HlIjYngBK2ZPQ
	FDdXXZa/dIKrxJYOpWXLUQ0VjRx556Qv1ZPJzfySTf84mnmYtDJQSfQajnst/PFEGRVz63Txynu
	hxtpkLNsAxI/82V3SjwGLdoc8vaebUXWOtklJLe8=
X-Gm-Gg: AfdE7ckdslHUwz9MyCBmwHiGLKRdyLqSsNcMRZnAnIAudDFZbL5wgD27LfvXHs0X38q
	yPnmkwJgNk9kSGNFm7M0ie4SeVTCPWq/1iM38tvjofINzO9V8PqkG8rmQe6POkfsMFAoUPtgaBc
	GMJ/ERT2hvfk9CDfllTtDCdYFzoPog+q4L9410VC3IjqoXg/bgYIiluvOCdAyXSeLWGlKSisZnp
	eyzx09UEa9g5/ASWlCKAov1ThB1ucxRHW/WMUraSw/xZaxn4zjXGlTb26oukH688Wj4LA6nqg==
X-Received: by 2002:a05:6402:5406:b0:698:4992:77e7 with SMTP id
 4fb4d7f45d1cf-69a856524bcmr3067925a12.7.1783436890479; Tue, 07 Jul 2026
 08:08:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFnufp2NJj=eXCpfoU4ZzPwSX31oUbsUr=Kstz6NedTZ3dsqZA@mail.gmail.com>
 <20260707055651.GX9392@frogsfrogsfrogs>
In-Reply-To: <20260707055651.GX9392@frogsfrogsfrogs>
From: Matteo Croce <technoboy85@gmail.com>
Date: Tue, 7 Jul 2026 17:07:33 +0200
X-Gm-Features: AVVi8CehKmTy0zqSDl1PmMNB3jxwKcSPuU3VkgoOSfF20K0gPwZJMSUy1mo3sH8
Message-ID: <CAFnufp0jtkh1jryNyZG3JEgyFg64GijhXvRyP-858eXrg+xn-Q@mail.gmail.com>
Subject: Re: ftruncate() after FICLONERANGE costs 300-600us/file, ~10x more
 than the clone itself
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
	Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"

Il giorno mar 7 lug 2026 alle ore 07:56 Darrick J. Wong
<djwong@kernel.org> ha scritto:
> Assuming src.dat is the fully written 90000 byte file, can you
>
> $ xfs_io -c "reflink src.dat 86016 86016 0" dest.dat
>
> to link only the eof-block into dest.dat and keep its file size at
> 90000?
>

Yes, that works nicely:

  $ dd if=/dev/urandom of=src.dat bs=90000 count=1; sync
  $ strace -T -e trace=ioctl,ftruncate xfs_io -f \
        -c "reflink src.dat 86016 86016 0" dest.dat
  ioctl(3, FICLONERANGE, {src_fd=4, src_offset=86016, src_length=0,
        dest_offset=86016}) = 0 <0.000093>
  $ stat -c %s dest.dat
  90000
  $ cmp -i 86016 src.dat dest.dat && echo tail OK
  tail OK
  $ filefrag -v dest.dat
  Filesystem type is: 58465342
  File size of dest.dat is 90000 (22 blocks of 4096 bytes)
   ext:     logical_offset:        physical_offset: length:   expected: flags:
     0:       21..      21:         45..        45:      1:
21: last,shared,eof
  dest.dat: 1 extent found

The clone of the unaligned EOF block costs the same ~90us as any
other clone, it sets the destination size without any truncate, and
the block is really shared. So the whole overhead I measured is in
the truncate-down zeroing of the shared tail block, as you said.

The out of place write is also nicely visible in filefrag after the
clone+truncate sequence (src.dat is a 1 MiB file here, so the cloned
range lies inside it): only the tail block loses the sharing, and it
lands out of sequence with respect to the shared run:

  $ xfs_io -f -c "reflink src.dat 0 0 90112" -c "truncate 90000" dest.dat
  $ filefrag -v dest.dat
  File size of dest.dat is 90000 (22 blocks of 4096 bytes)
   ext:     logical_offset:        physical_offset: length:   expected: flags:
     0:        0..      20:         46..        66:     21:             shared
     1:       21..      21:         45..        45:      1:         67: last,eof
  dest.dat: 2 extents found

Sadly, tar cannot use the eof-block shape for the general case: the
member data does not end at the archive EOF (the end-of-archive
marker follows), so there is no source EOF to link from. The plan
for tar on the affected filesystems is to clone the whole blocks and
write the final partial block, which avoids the truncate entirely
and in my prototype turns the 3.4x slowdown into a 1.6x speedup.

Regards,
-- 
per aspera ad upstream
