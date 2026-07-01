Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968DB3E0C59
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 19:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782934541; cv=pass; b=GubinLhN1czAxiAqP0yE7vRhTEhm8CiBTi78OozfDfkDOLkpfmwO7IztPVVwzgBvYcnSy7RHYnyLHe7lIvaYGRy/P0M4cR/GxshAPvKlgRG48KOD8Xrgr9gEvqC1aEzqXLElTrx7M4l+4NTnT91L7RloTVnZD49q/nnXDbYZzIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782934541; c=relaxed/simple;
	bh=W6CJBvffePQ1xTgxagHeLlloRE/H6DklNbAaM7XMEes=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T4ia7crAYac6rXDfWL3/SD459UYTLa7iQefbqevRYDnX6tOlQolJJOH3fe2bWUhaJ7v04A0ZK3a5sBSVYJ4JeTjuTrpyweuov0WYfUT9CRg8+U11ZKlROGdC96cNNURIzc19YlllW6lAHRUPHmTN9mbPr0uWSbyweB8Jd2eoBKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dkWeW4MO; arc=pass smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dkWeW4MO"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-461edb387ddso937873f8f.3
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2026 12:35:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782934537; cv=none;
        d=google.com; s=arc-20260327;
        b=PKyQndnLz+uDgwClfmk29o4W+6vhDAtn1Tf7Ne92tXs5teDX4rx+uBSwf5OmCF4fJG
         KO9JsvP+794cwW8C9umZIGcJfGc+aRDt7yeK8E5+JaeU3J5LyrPkzufSmoYmCbEjA0lb
         qEubhjQOwpVJl3Kvy/j1SMFALCdRh8C1y4TtkTvJa55I5wduHsC3dTxQeAZpF317hHqq
         YxR2CaUIUCULL5VHqaZWwgqUJf1ip32GRWMd38/S8IuIlYs9Wbza/KotYbMn9sE7DdH7
         +UB0WfRnTRDB3IoYocUnuBVFm9hWLbbMxbFGi6kzb5oBldlBQ4jOedAJGeXA1CqVdVlZ
         /FPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pGGDxr3N3ZHTVGBYFBwUmfiD25X2IVkVBZj7x5VdJpQ=;
        fh=n+IEKpMGHrh7NC+v2vvcJbh7mR/m0VnavNJi/2+m28I=;
        b=hX2eJhMRG9L+6WKVDrO4KytbJj1RuIJiRV8u+YW+Kp9VBH7PKuogH8MTu+JDPzwcab
         invWkPdBVswVNSM0Qs1gZFM95MOY+LHFi/oFw0qHi3UIHzYRo/v7KuRf42M3NCUB5WZM
         rzha/6RfBkcCAU7tDXwr62+2qpE+QAWb/iE0hm0xndquvuUjiNIQf+zV5ciP4u8WYXCt
         wdqzFmxmnqyASY9IXDVl8ojbcC3wJHE5GS8iuJetkvtRc7gOYo07t23HoiNdi+i4VLwY
         HxUbF2AidFudrKJ/LS32ICPoLPKhSRSlMbK+9DJky6oLdlqT5uuYLYAsXdZ/bP82bM3O
         t9ZQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782934537; x=1783539337; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pGGDxr3N3ZHTVGBYFBwUmfiD25X2IVkVBZj7x5VdJpQ=;
        b=dkWeW4MOYHjKBIGKBMixuDTcGthkx7tZXP9qzgxCHl0Bhnw7UPL730ubvrQwSAEbaw
         N1P6VfwhITJJgbnUb9K6TjMyMC5EMPXVByrQJSNCizIMoewbHJQxE9Boi2WHOZ2HoOtU
         8vsQigsZL8uiD07U8I1r8mMD5o2u+HH7JuIGZZ1biooJQwvQKXDMI3eMP+qF2HyZIqtu
         Er8v6T7q1EY5r/kHM9q+VWDlBnCeFjUFZYRTBD5dyqKKXbr/IZpfdMyqA+cSdk1+EvMl
         ZHrcGQWI7znAwTXcwS6VvN9n4vzlYri5UNI0P1Zd3pezzoouXNDwkzrg5x4ha3faPdn4
         hEag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782934537; x=1783539337;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pGGDxr3N3ZHTVGBYFBwUmfiD25X2IVkVBZj7x5VdJpQ=;
        b=N0oi823D1d4ecwZ8bsXwWOZPgIQjFtwjQwHxuA9UYqMLAF7R2GxAYOmXMTq9NwSY7+
         CEEbnwB1y2vMVAPopWvskgFeoZV1WCO3Y3/YE06gRYXT10qdU6g2U3tWVsGgp0P8xp8t
         jxJe3wp5ayKi0et14gG2C9dfde/VFG3wM6JCYPBhjfYww0Byp2fDqCeVEOYcnquRpBpr
         tVT3aFCBof57aOtwwePtCvHHNxkB89d70YPdzwEgzauI7hb6T7Jf3Uukjqv6JPetKpQR
         yvmo+fz+ri7xYbhZQNd4FFygoI1V5nnhlTZrp50SSAnOScVYKKSPnJ4clCZin5H4COXt
         8jJw==
X-Forwarded-Encrypted: i=1; AHgh+RqhhANzuRwsMcxwkMLYfU8w9ODtLEDHAQmfcT7rBTzlL9vIcpE7G6ynKGXOjghFhwk/BrLFxAXvPT8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1WnBRofHNcRRM4hUYLtwKjrEgtW69y9E3tHssLHgzRPG9uDV4
	I1DYiqutFIsjNGUuLESP4N0V80/1gWHmPy3B5jkUuGzgjOKcBLvSGMTCephGwMXa5o0HNUBaAZq
	E8LYK/9Pm8Q4CPYCIgp1QUh6L4WDqIcA=
X-Gm-Gg: AfdE7ckKxlcOGzcJMbUB6iqvzfXW2acZG9JCxfdmqujEOqfCUKZr8PjhSvXIyd+iVWR
	XaWEw5UTc17NbE25BWMY54zCDreiD6tthc02k+QuysXjbKoXTrQFjyHu21vEj4U2OpuRB7qsc5j
	JogZwNr4oNGlzVwM1bFUx4pbj10o91wpNqGfB2QoXoGPvVu5BJ6x66BlReSi7+83yoAFmN3N9CN
	DRK4UfbUgkWYvCk1mBjLbHkVK3SMBiVHfXYgWvIQ2pd6Qx0dY9QOxeyE9j7kT2vMIMdfbPPlUJs
	Mx86/FlV7hweCbfRob7dUcys4aZvDS1q6YrnwEIPFciSPWrd6/Kp
X-Received: by 2002:a05:6000:4818:b0:474:9991:60d0 with SMTP id
 ffacd0b85a97d-477aeb5bef7mr3461724f8f.12.1782934536936; Wed, 01 Jul 2026
 12:35:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701033253.46420-1-changfengnan@bytedance.com>
 <20260701033253.46420-4-changfengnan@bytedance.com> <akT4tJzFSfrBxqdq@infradead.org>
In-Reply-To: <akT4tJzFSfrBxqdq@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 1 Jul 2026 12:35:24 -0700
X-Gm-Features: AVVi8CeXAJXVfUIyr35lv5pL20q_ALlPEdtXwqos7WTDEDHtloeaTCi_lAygHvs
Message-ID: <CAJnrk1Y3yPeXBeBNo+DjTt8eRN-mc2F9apBCUn+j=GV7GMzi4g@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] iomap: add simple dio path for small direct I/O
To: Christoph Hellwig <hch@infradead.org>
Cc: Fengnan Chang <changfengnan@bytedance.com>, brauner@kernel.org, djwong@kernel.org, 
	ojaswin@linux.ibm.com, dgc@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lidiangang@bytedance.com, 
	pankaj.raghav@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 1, 2026 at 4:23=E2=80=AFAM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> Looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> We'll need to sort out the interaction with the iomap_next work, though.
>
> Joanne, is it ok to get this in first and have Fengnan help your with
> the interactions due to the open coded iomap_begin/end calls?
>

That sounds good, I'll rebase the next version onto these changes.

I think it ends up being pretty simple to get it integrated since
->iomap_next already contains the logic to only begin the mapping at
the start and only finish the mapping when the iter has been fully
consumed, eg

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 3ef5e9adca87..e654ec135d54 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -1035,7 +1035,7 @@ iomap_dio_simple_supported(struct kiocb *iocb,
struct iov_iter *iter,
  */
 static ssize_t
 iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
-                const struct iomap_ops *ops, void *private,
+                iomap_next_fn iomap_next, void *private,
                 unsigned int dio_flags)
 {
        struct inode *inode =3D file_inode(iocb->ki_filp);
@@ -1062,11 +1062,11 @@ iomap_dio_simple(struct kiocb *iocb, struct
iov_iter *iter,

        inode_dio_begin(inode);

-       ret =3D ops->iomap_begin(inode, iomi.pos, count, iomi.flags,
-                              &iomi.iomap, &iomi.srcmap);
-       if (ret) {
+       ret =3D iomap_iter(&iomi, iomap_next);
+       if (ret <=3D 0) {
                inode_dio_end(inode);
-               return ret;
+               /* ret of 0 means no mapping, which should never happen */
+               return ret ? ret : -EFAULT;
        }

        if (iomi.iomap.type !=3D IOMAP_MAPPED ||
@@ -1125,14 +1125,17 @@ iomap_dio_simple(struct kiocb *iocb, struct
iov_iter *iter,
                WRITE_ONCE(iocb->private, bio);
        }

-       if (ops->iomap_end)
-               ops->iomap_end(inode, iomi.pos, count, count, iomi.flags,
-                              &iomi.iomap);
+       iomap_iter_advance(&iomi, count);
+       /*
+        * ends the mapping if the mapping needs to be ended. no new mappin=
gs
+        * are fetched since the entire range of the iter has been consumed
+        */
+       iomap_iter(&iomi, iomap_next);

        if (!wait_for_completion) {
                bio->bi_end_io =3D iomap_dio_simple_end_io;
                submit_bio(bio);
-               trace_iomap_dio_rw_queued(inode, iomi.pos, count);
+               trace_iomap_dio_rw_queued(inode, iocb->ki_pos, count);
                return -EIOCBQUEUED;
        }

@@ -1144,9 +1147,12 @@ iomap_dio_simple(struct kiocb *iocb, struct
iov_iter *iter,
 out_bio_put:
        bio_put(bio);
 out_iomap_end:
-       if (ops->iomap_end)
-               ops->iomap_end(inode, iomi.pos, count, 0, iomi.flags,
-                              &iomi.iomap);
+       /*
+        * on failure, iter was never advanced. ->iomap_next() will know th=
at 0
+        * bytes have been processed and the mapping will be ended with no =
next
+        * mapping fetched
+        */
+       iomap_iter(&iomi, iomap_next);
        inode_dio_end(inode);
        return ret;
 }

Thanks,
Joanne
