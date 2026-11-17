Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.173
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794956929;
	b=IqPmtyBNaL0ehxYGFbiKXQqrJOFUMwIhgE1JAvi9dULRvW17gSpQypmq3FgMfpAL2E2p
	 08shvmcngnFOyME/4PbSQx+m/a7EKQAOvIyIFGs3tlbU31YGs4CX1quT9L5Kmhuzhl9Qb
	 cY2PiZW5+AJHr5pbSR1EfE9JqWDKtkWG3B1wRcPdesrqUeckNdGdYanO3A2mlmn+YKepC
	 43G+B4w6ARtFM1S+EA9vraYugSZPt681LemrVoF4maryuYqgtayFjg9XTLMduo+rFaj91
	 zw9XHZrhnU+ZiESjFJQ48y+UdgQvYjg7KxTqkV0Y3ehwYxlO8+2tjh+ctBOBHeI2Nuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794956929;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=c5oD0tLMxNN+L1nREdH0vs+Q+g0/BB/zfqPp5PmXkHo=;
	b=5FBT3evqUG9YwBguJEz6Iav+ac5YylIsGIZ6apAxMYLgFXvVt1oyciH980YHRf6KO6eg
	 wwwNGXNSLBQs6KKZU/tEynSpZJV9Y44KMA7NYBlU7tW/WpVAxmEEaj4UUwtRDj7hQ0ony
	 RiS8raTwZ85usbGhVUwaYnPP3CYQQCs7jOOq9Q3TMOjYumbp/CNXfZjOoG7UxcjBAPFRz
	 oNtQ7kcKuxqelr7I3gzStYJ5l54e5RVeIrk9MkwLl427Gc32kLvy8airwIOgrnbOs7N3K
	 63VCSn0SPi176IVp8QS9sNj2rFj5maHtd5kor1jkvDpFCCn8x7WFEE1FUVUk/TVMOhA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Tv5L2OH1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.173
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A62606A32C
	for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 23:08:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50A62606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Tv5L2OH1
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-93f269e335eso47243385a.3
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 15:08:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794956927; cv=none;
        d=google.com; s=arc-20260327;
        b=Y4BxNKlJMfgkZ9eaALiMNr/IbST6DICDHHNa+8YFWskHoxJPtlBLAVRLCnk1kWXPnm
         7WrB/yuUC7yyJX8LwnbzT21y4xUv8nMNnlJHo247pgE020v/f1eo4BXQjMFFmimGCyN7
         LX5A2BU88WJrvOy63xBby5yGcLtWSN2wZvG5z3LZt/WHimt6q/2qA+8dVwLnmiBix9KI
         tRldTSdI3B3buiOLvGkNPGumoI91WTXgr47SHxZ7oiweQ1MLzhmr2OpqZ0C3ZOXhUXXX
         ib8frucbhkyYqsRO7cIjfuKo6NmJm+1oVzlDDX5yHMzFttaIv/Dm8cxVgQogF1nLjrQB
         e38A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c5oD0tLMxNN+L1nREdH0vs+Q+g0/BB/zfqPp5PmXkHo=;
        fh=fS++kGwS1QGmIQpO8Hy1N/D4viEHaSp3g+Csq4g058I=;
        b=V+1SpI4WOLYhuiK/OdkFHCcBS1aDYGV8bFxu4Ctppt44ByaFGjbNODAtogwsqiqZUG
         4HA8uN5UQhppgQXNJhnDc0t4DmTQ7GtCmYLlYnFwd70l8sXzwoFAqlFs9nek+ajVYrwO
         2Sy+6R4mJCbSprWJC4iBYvVOFZBJ+87GGfNTplFVnTLHipH7oUC1WdCWOveuAnz6nGje
         0U3ntp96UtxEBPJiXVMa0wvFwTiq64E/qF2QeaZiEViH6LavX2bWUQM/5EtqbPoVsPhM
         rm7mmXwzOgoBtTxlLP6OeizgrY08izeoKGbhwprs7oP8HTcnSM5qn6u8fU5XrGSukCvz
         7MPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794956927; x=1795561727; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c5oD0tLMxNN+L1nREdH0vs+Q+g0/BB/zfqPp5PmXkHo=;
        b=Tv5L2OH1FQpdOSFR3ZvqD+zPqDpGvd4wbf71Cu/yrag1dW1t0h4FG6jYLxaoyMi72d
         UwvNOB78cpsZPgBd21kka2hA0sSG/6nRwSdZnGPJu7QZoBDat/c1Ve0prfridK6Knyn4
         ckFi9dB5sEtfUGFlv2fOkkkwrUAxGd5WaO7nSfQLS/PuYhK3RWeojpHpS/W4vHq9A+1D
         zj72iiFpbWFlt3MPfrkQvFLnONhyzEwbzKq3zINBl0ZGArn8PdZye51aw3rCON/ObgX2
         +x98YmkqReMGOg2bNRqKPOkKuFUsi3jI2K4M3QnpRK29kcfBr6Rryi6zUUwUsP2BbCFi
         ebZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794956927; x=1795561727;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c5oD0tLMxNN+L1nREdH0vs+Q+g0/BB/zfqPp5PmXkHo=;
        b=Mu0PcS5cIHTsLxJKlOQYZ2OaSc0tCwTg4nxbVV5N8lb+e3sVs50Px7sHEQ12CZX0e6
         Q8lh/aKWjfhCukj5CO9VQLhMiCt28Rkjr7cTRter4j89Fm1bsKR74Gs83b+mbWIvNQU2
         LajFgFAWkSZni7Trl/fHNE/AlAqHRCCZd5eP4UR6MEmaVAMA/Q8YLpiTYtDhToPfAxW+
         7i9wSvAXLS9H/Ng0NP00mjkdtj69nJLNsTbhDrX+5oo2cuvteKFq4qLtRROoRKrWW865
         V5TSJJHBAwiorMce4xzZonprz5+4FoaxiLRI1BsP4yS9wVm1z4MAYfOvuQeDtocEMEuC
         9rOA==
X-Forwarded-Encrypted: i=1; AL+hErFAMGHBVjF0uzB44S6CIbwnKgAEXFC8r/QsojkA+dCNB5KK8+samMWKH0wkTsMCDOXTEDLQt0i1IZI=@vger.kernel.org
X-Gm-Message-State: APuU4Z9YWW9LQzg7DPJ2Nwm/qo2m01O+4YgSxq4GlkA6nIiMbYwyIp6/
	agtfRAQS9Ppwbh38+tZcxbnQ6M7vA3yDOOecymUfYjm7HG9mLV5EzPdcnwMvzImyOPHjvI6G8es
	8hWgVbCJRBVlMVwBGI2v34Idz+JpJwlM=
X-Gm-Gg: AYBFou29VCkTCFkOLsb7+G9gnLRPsJzw82sX5OIYPbvmQh8zVxxSsdHHNS9Izg7/YxN
	roh8JN5yljEDuHFNIeqwQ6cb4zsnIhuwmIs69Ha/BpX0D1VBgYqk6c5PlzUlZL9k7shsFsOsLff
	AGDAF71hEaftfhvCW2iXYdR66+dg12WhpAx3PH3klvqK3NYKBBXQP3aDP8T7OagtRGjVS8KPDXW
	xhAsesndR+8NjJO7W8IX+zXcR3wBPiiguiIE63xZ305+BYxHy09pC0rYsapIL91eztlptZXms2e
	RE+fvuRuCVJ/GiQ+vj10iRIMypxDFKsCMML3sQNnA6lrmi9Epr0D8sifORInV19PuW0JpypC17p
	iPVpIcwU2a8NurSQOIFrN4+RvW7pniSP6tmZNY0Xl7OAQVBlnBViQ46i8SrY12kVCiMUuElPyQu
	9uE5W1n7buamBtBvvaNg9KEMSl3XeYvfx9h1AfPRqXYpKAhb0emqZ0Tgfv5Jaww/j4b2GxD82zH
	7s8TvOkzLlBp4cdlwL4shd72xxeisfq/IVeFb/h5crRAoUgtiScQOqVENuDI5UqXn2PlXeakAI5
	5HH6v0XNd6ZY
X-Received: by 2002:a05:620a:46a6:b0:949:64c2:1630 with SMTP id
 af79cd13be357-949995d909emr225332085a.47.1794956927022; Tue, 17 Nov 2026
 15:08:47 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117164756.97065-1-jain.sm@gmail.com>
In-Reply-To: <20261117164756.97065-1-jain.sm@gmail.com>
From: shashank Jain <jain.sm@gmail.com>
Date: Wed, 18 Nov 2026 04:38:35 +0530
X-Gm-Features: AclHuK_stX8rGF7FB55S1t8qyAd5lXqjdL2y4CcMcGEKh7vJZTeOKIecSE-swS4
Message-ID: <CA+FWx=nHkuDf_+Wq4Zk6BuxKcC=EwcmZsVVviyQj3WyXF5EbHA@mail.gmail.com>
Subject: Re: [PATCH] iomap: fix offset truncation in iomap_fill_dirty_folios()
 on 32-bit
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

One correction to the note under the ---: it was Willy Tarreau on
security@kernel.org who asked me to post this publicly, not Matthew
Wilcox. Sorry for the noise, Matthew.

Shashank

On Tue, Nov 17, 2026 at 10:18=E2=80=AFPM Shashank Mohan Jain <jain.sm@gmail=
.com> wrote:
>
> iomap_fill_dirty_folios() turns the page index at which the dirty
> folio lookup ended into the file offset it returns to the caller:
>
>         *start =3D (pstart << PAGE_SHIFT);
>
> pstart is a pgoff_t. On a 32-bit kernel the shift is done in 32 bits
> and the upper bits are lost for every offset at or above 4 GiB.
>
> XFS uses the returned offset in xfs_buffered_write_iomap_begin() to
> trim an unwritten mapping to the range covered by the lookup. With the
> truncated offset the end of that range is below its start and
> xfs_trim_extent() leaves a mapping of zero length. iomap_iter_done()
> warns about it,
>
>   WARNING: fs/iomap/iter.c:38 at iomap_iter+0x33c/0x36c
>   WARNING: fs/iomap/iter.c:39 at iomap_iter+0x34c/0x36c
>
> and iomap_zero_range() does not terminate: a mapping of zero length is
> what the iterator takes for the start of an iteration, so it asks for
> the next mapping again and again without checking how much of the
> range is left.
>
> On i386 with XFS (4k blocks) this is enough to trigger it:
>
>         fd =3D open("f", O_RDWR | O_CREAT, 0644);
>         fallocate(fd, 0, 5ULL << 30, 1 << 20);
>         ftruncate(fd, (5ULL << 30) + 1000);
>
> ftruncate() never returns. The task spins in iomap_zero_range() with
> the inode locked and does not react to SIGKILL. A write behind an
> unaligned EOF which is in an unwritten block above 4 GiB fails with
> EFSCORRUPTED instead, after "XFS (vda): Access to block zero in inode
> 132 start_block: 0 start_off: 140002 blkcnt: 0 extent-state: 0":
>
>         fallocate(fd, 0, 5ULL << 30, 1000);
>         pwrite(fd, buf, 100, (5ULL << 30) + 8192);
>
> The same calls work below 4 GiB, and v6.19 behaves like v7.3-rc6.
>
> Cast the page index to loff_t before the shift.
>
> Tested with an i386 kernel in qemu and XFS on a virtio disk: the two
> sequences above hang and fail without this change and succeed with
> it.
>
> Fixes: 395ed1ef0012 ("iomap: optional zero range dirty folio processing")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Shashank Mohan Jain <jain.sm@gmail.com>
> ---
> Prepared with Claude Code (Anthropic), model Claude Opus 5.5
> (claude-opus-5-5).
>
> First sent privately to security@kernel.org on 11 October; Matthew
> Wilcox asked for it to be posted as a normal patch. Sorry for the delay.
> The code is unchanged in mainline, so this is the same fix, rebased on
> 666539eecdf4.
>
>  fs/iomap/buffered-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 6d843b1..846f87a 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1735,7 +1735,7 @@ iomap_fill_dirty_folios(
>         }
>
>         count =3D filemap_get_folios_dirty(mapping, &pstart, pend, iter->=
fbatch);
> -       *start =3D (pstart << PAGE_SHIFT);
> +       *start =3D (loff_t)pstart << PAGE_SHIFT;
>         *iomap_flags |=3D IOMAP_F_FOLIO_BATCH;
>         return count;
>  }
>
> base-commit: 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4
> --
> 2.43.0
>
