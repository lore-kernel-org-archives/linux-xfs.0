Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C32CE7B1E
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Sep 2023 19:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjI1Tok (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 15:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjI1Toj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Sep 2023 15:44:39 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9AF1A1
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 12:44:37 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-502f29ed596so1660e87.0
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 12:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695930276; x=1696535076; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JRyUr6UVl7FFC/RDg2+bKaNhZoV26yTOAqV73hVeW/I=;
        b=LbOsSbTuw5n0/FarXkmcOgDBifQ6lNhwbkdCZ21Zkh2xtonszR0l6rlWpeDPmrV26i
         qotrtrCIlkt65aEYrhiv6f1nFC1zSRfhyfiCA4fhIvq+rYsrsl68H6+c1uinevSbhS8R
         njDt661GddSFYrU8qjSQMb7fyWh+MoS7e46LSUnOup9w12KZKi28tICehsUBbNuRp4Fh
         mlapBVzBPHyVJovntvmRMeQ5IewZ7TBe8NuRGyYOBD+OKYSnX3aGezOdTTHSEgsizlZY
         iodoqA0g3gf2QtF9kbyoEL2gjKJQPXJf+NB8qZUt1z32fQfQxxS5aVwzg8pG354D+fs9
         qpUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695930276; x=1696535076;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JRyUr6UVl7FFC/RDg2+bKaNhZoV26yTOAqV73hVeW/I=;
        b=uPYDSDZplovf39tvc4JYsoYUb4JTgnZH/ly5dsuYydo4oVoNCRxWVcksSbsFCrPCUY
         hgvGNJBdrOg0JcbCIwSS6xS1EeI6FoWH2UVlNJPA8c0rUBl99kftVYzjjmszz10MjuU1
         r4c9dfGrVJaiWgTF6kdVXSkzq9jrLO5+wtUNSyM9byPwzpuz6eQBsAc9+CvOLuLcLW1i
         hDA2IL7mxxzJl/P6iCvY6SK45wjjUKMgc2bAiqYTg+2oodSNXxrG1/NvG7z+L9XLkBgE
         +ikdz8uihBPnm4s3FmtP0W2ISidsuTSOrWVltkB0ObA0ziCPCX/buoQFcrm8BB/RXIEz
         hItg==
X-Gm-Message-State: AOJu0Yz3csAFK++6cn6/G6/hc1hipnVXLq6sm8OMElO03EGdEal+bScE
        NIVEOhCU4p5+ArBQ/WWCXGWrjZBLdNZ8nBqTOXPG0g==
X-Google-Smtp-Source: AGHT+IFKlbBKVnPaqgfeKYB1Ca18yK3GM5PEyM10qfeD3UfU7Tifq5GZfWfclUM1vEGRG8VhRzADV8ZSB+r3FpENcj0=
X-Received: by 2002:ac2:55ac:0:b0:501:ba53:a4f7 with SMTP id
 y12-20020ac255ac000000b00501ba53a4f7mr252243lfg.0.1695930275610; Thu, 28 Sep
 2023 12:44:35 -0700 (PDT)
MIME-Version: 1.0
References: <4d6c9b19-cdbb-4a00-9a40-5ed5c36332e5@arm.com> <ZRVbV6yJ-zFzRoas@debian.me>
 <54e5accf-1a56-495a-a4f5-d57504bc2fc8@arm.com>
In-Reply-To: <54e5accf-1a56-495a-a4f5-d57504bc2fc8@arm.com>
From:   "Zach O'Keefe" <zokeefe@google.com>
Date:   Thu, 28 Sep 2023 12:43:57 -0700
Message-ID: <CAAa6QmRbDbEamFgEDbgVhwKOf1GHNa90COuyz29BmduOAjbmyA@mail.gmail.com>
Subject: Re: BUG: MADV_COLLAPSE doesn't work for XFS files
To:     Ryan Roberts <ryan.roberts@arm.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux XFS <linux-xfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yu Zhao <yuzhao@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hey Ryan,

Thanks for bringing this up.

On Thu, Sep 28, 2023 at 4:59=E2=80=AFAM Ryan Roberts <ryan.roberts@arm.com>=
 wrote:
>
> On 28/09/2023 11:54, Bagas Sanjaya wrote:
> > On Thu, Sep 28, 2023 at 10:55:17AM +0100, Ryan Roberts wrote:
> >> Hi all,
> >>
> >> I've just noticed that when applied to a file mapping for a file on xf=
s, MADV_COLLAPSE returns EINVAL. The same test case works fine if the file =
is on ext4.
> >>
> >> I think the root cause is that the implementation bails out if it find=
s a (non-PMD-sized) large folio in the page cache for any part of the file =
covered by the region. XFS does readahead into large folios so we hit this =
issue. See khugepaged.h:collapse_file():
> >>
> >>              if (PageTransCompound(page)) {
> >>                      struct page *head =3D compound_head(page);
> >>
> >>                      result =3D compound_order(head) =3D=3D HPAGE_PMD_=
ORDER &&
> >>                                      head->index =3D=3D start
> >>                                      /* Maybe PMD-mapped */
> >>                                      ? SCAN_PTE_MAPPED_HUGEPAGE
> >>                                      : SCAN_PAGE_COMPOUND;
> >>                      goto out_unlock;
> >>              }
> >

Ya, non-PMD-sized THPs were just barely visible in my peripherals when
writing this, and I'm still woefully behind on your work on them now
(sorry!).

I'd like to eventually make collapse (not just MADV_COLLAPSE, but
khugepaged too) support arbitrary-sized large folios in general, but
I'm very pressed for time right now. I think M. Wilcox is also
interested in this, given he left the TODO to support it :P

Thank you for the reproducer though! I haven't run it, but I'll
probably come back here to steal it when the time comes.

> > I don't see any hint to -EINVAL above. Am I missing something?
>
> The SCAN_PAGE_COMPOUND result ends up back at madvise_collapse() where it
> eventually gets converted to -EINVAL by madvise_collapse_errno().
>
> >
> >>
> >> I'm not sure if this is already a known issue? I don't have time to wo=
rk on a fix for this right now, so thought I would highlight it at least. I=
 might get around to it at some point in the future if nobody else tackles =
it.

My guess is Q1 2024 is when I'd be able to look into this, at the
current level of urgency. It doesn't sound like it's blocking anything
for your work right now -- lmk if that changes though!

Thanks,
Zach



> >>
> >> Thanks,
> >> Ryan
> >>
> >>
> >> Test case I've been using:
> >>
> >> -->8--
> >>
> >> #include <stdio.h>
> >> #include <stdlib.h>
> >> #include <sys/mman.h>
> >> #include <sys/types.h>
> >> #include <sys/stat.h>
> >> #include <fcntl.h>
> >> #include <unistd.h>
> >>
> >> #ifndef MADV_COLLAPSE
> >> #define MADV_COLLAPSE                25
> >> #endif
> >>
> >> #define handle_error(msg)    do { perror(msg); exit(EXIT_FAILURE); } w=
hile (0)
> >>
> >> #define SZ_1K                        1024
> >> #define SZ_1M                        (SZ_1K * SZ_1K)
> >> #define ALIGN(val, align)    (((val) + ((align) - 1)) & ~((align) - 1)=
)
> >>
> >> #if 1
> >> // ext4
> >> #define DATA_FILE            "/home/ubuntu/data.txt"
> >> #else
> >> // xfs
> >> #define DATA_FILE            "/boot/data.txt"
> >> #endif
> >>
> >> int main(void)
> >> {
> >>      int fd;
> >>      char *mem;
> >>      int ret;
> >>
> >>      fd =3D open(DATA_FILE, O_RDONLY);
> >>      if (fd =3D=3D -1)
> >>              handle_error("open");
> >>
> >>      mem =3D mmap(NULL, SZ_1M * 4, PROT_READ | PROT_EXEC, MAP_PRIVATE,=
 fd, 0);
> >>      close(fd);
> >>      if (mem =3D=3D MAP_FAILED)
> >>              handle_error("mmap");
> >>
> >>      printf("1: pid=3D%d, mem=3D%p\n", getpid(), mem);
> >>      getchar();
> >>
> >>      mem =3D (char *)ALIGN((unsigned long)mem, SZ_1M * 2);
> >>      ret =3D madvise(mem, SZ_1M * 2, MADV_COLLAPSE);
> >>      if (ret)
> >>              handle_error("madvise");
> >>
> >>      printf("2: pid=3D%d, mem=3D%p\n", getpid(), mem);
> >>      getchar();
> >>
> >>      return 0;
> >> }
> >>
> >> -->8--
> >>
> >
> > Confused...
>
> This is a user space test case that shows the problem; data.txt needs to =
be at
> least 4MB and on a mounted ext4 and xfs filesystem. By toggling the '#if =
1' to
> 0, you can see the different behaviours for ext4 and xfs -
> handle_error("madvise") fires with EINVAL in the xfs case. The getchar()s=
 are
> leftovers from me looking at the smaps file.
>
