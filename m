Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07A08488;
	Wed, 18 Dec 2024 01:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734485503; cv=none; b=gCm5qkiuCr3zvH8nWPV2rQHvT+efwk3hpPX3KiTG7KA2iy8s4vW15hwZcUC6wEKJRaDEW998wEv6pnDleTXk1p1S5QHNlYLSOgnZgGOc0uTsrSKLkhphqhJv0xs05BSgPjAyC/TUSjYkfHZsXxk0nDsuJX8iAWLsanqxjIVRjnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734485503; c=relaxed/simple;
	bh=O8H9+hRSE1uwUg/G7oVEmi67z3aPvoF24tz/i6yZPdo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nCEFklyykylq8BXcmrAgxUXtCnKHdczDUERdwj9kMkMpdsIPmk1YUIUGDqoi6UAMlQQCTMqIbPc71NIpZ9Br6Zin+NleLqk6dDTXANglht2peg56B27c3fqWt2N7Ey6JSezU4S003A2Gck/2lmUFRe6feSYYn1Doc0bCl3FO6Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c+pDpb7p; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c+pDpb7p"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7b8618be68bso58400485a.3;
        Tue, 17 Dec 2024 17:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734485501; x=1735090301; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SgfXVdimZyFGsiDSsorVhm0EV9HOw8uluyn3y12l4wg=;
        b=c+pDpb7pAGXa2OoUQYwUOziIZ3pEOgKpbGbW56qv8+KtFmRUMjmzIwZqbMz1UKWLZk
         EmIP8U690pbT/AUm+eWFCp9EMmwWXx7u2XcsaXrv9a7bsEtL40KnwH02+SPpKXZq82bn
         j4vNRt30F7HYmGLYj/K7SwVO1o33dEbVlp5/NRgk6X4uaN7lWggs+edCgvQoLSzEvSBf
         vXwO5toIS0Dg4nq19XxxBEbqxTLBSCbov48G6FgIutnc7iOYmIvfX98AMEL3tXrX3t+J
         N3xMhguuePWWn76zPVs4t6+2K95H0mm822DKQgTBfKHBNCgelejcyVH8PZWR4rCY6e6x
         Cx2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734485501; x=1735090301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SgfXVdimZyFGsiDSsorVhm0EV9HOw8uluyn3y12l4wg=;
        b=eYhxkWQrMdW//mvu7Xsyx5EIbiNzPdjOP2xTCKhT57hcrhodbuN7qxFezN4wvmrd6e
         kWxbQGxzbmHPZCDfCuyYrgp2LV/wLP6vRF3LzkeeVzj15PlFQEsK2cSYsTjGFUNr47Wr
         5pN5QJwVwcaXCjLlmTcMaD1ly5z//ZX6C/xVeVKf9ulYJgHKD5QftCPcn/1shQR0XOAG
         BdTEugD3pt5qPRRVjOJUjoG5l394nShmtDS5gbzlRouhzimOEH11WZDUgSzCQ/8ze+6Z
         W2ONqjnRn8+dUHfnz2AZCBNBmnoAJXZ9+dm5Y0A1m99ddV2bGp4aQyTJmwOHi87fCoLX
         Mxhw==
X-Forwarded-Encrypted: i=1; AJvYcCWzU9mwBgPyO85TUJ+/Pl9oxy+BqgwSYyNi0Vocn24ULJOACKgSOnsybWP0EIFeWlMd7/NMuIOsCCI7t1Q=@vger.kernel.org, AJvYcCXV0CpCkU2/wvLA+yzR/6RqBWbbK1JFs667EirRpAUJ+Qjs75eVV6lfdNIHiXibLX0Dg3DZkmGyniOq@vger.kernel.org
X-Gm-Message-State: AOJu0YyfcBGwY2BeYbvu9IFIAiOfZRCFwuYHp4cGCA4qZngsZrRvJaSB
	DDU3LuEbBZ8LpveVYdk7PHSvPKqjofBdep9RUG/E++FtuFMZ8OCu26dp1TFSw12hjT/DZ55Id5L
	aaCh+0BNuye4wqveoF7ZOofkJvX4=
X-Gm-Gg: ASbGnctW1NezhiBR+lZ9TC8neTKOaukkAKtXJlr/Uw5gEkCJIrKoDU8Q4iCDeEnbD90
	8ppVkQQ8qJ92iDP4apgzl1mPqGxsl15knYY1XXA==
X-Google-Smtp-Source: AGHT+IHHzEn8RSLx2dO2YjubvIdrD7nLTpQY9JV5KQY24RTiF2NKVY+xEbTNLPixNWTcLfjdjBmO2U2AaaCfAth5iyY=
X-Received: by 2002:a05:620a:4723:b0:7b6:ce6e:2294 with SMTP id
 af79cd13be357-7b8638b7e46mr148845485a.56.1734485500685; Tue, 17 Dec 2024
 17:31:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241104014439.3786609-1-zhangshida@kylinos.cn>
 <ZyhAOEkrjZzOQ4kJ@dread.disaster.area> <CANubcdVbimowVMdoH+Tzk6AZuU7miwf4PrvTv2Dh0R+eSuJ1CQ@mail.gmail.com>
 <Zyi683yYTcnKz+Y7@dread.disaster.area> <CANubcdX3zJ_uVk3rJM5t0ivzCgWacSj6ZHX+pDvzf3XOeonFQw@mail.gmail.com>
 <ZzFmOzld1P9ReIiA@dread.disaster.area> <CANubcdXv8rmRGERFDQUELes3W2s_LdvfCSrOuWK8ge=cdEhFYA@mail.gmail.com>
 <Zz5ogh1-52n35lZk@dread.disaster.area> <CANubcdX2q+HqZTw8v1Eqi560X841fzOFX=BzgVdEi=KwP7eijw@mail.gmail.com>
 <Z0UbkWlaEuH9_bXd@dread.disaster.area>
In-Reply-To: <Z0UbkWlaEuH9_bXd@dread.disaster.area>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Wed, 18 Dec 2024 09:31:04 +0800
Message-ID: <CANubcdULKcXmc0mQa4E=giG4BvErS4cPnk8gq5FO-AkdhhCgqw@mail.gmail.com>
Subject: Re: [PATCH 0/5] *** Introduce new space allocation algorithm ***
To: Dave Chinner <david@fromorbit.com>
Cc: djwong@kernel.org, dchinner@redhat.com, leo.lilong@huawei.com, 
	wozizhi@huawei.com, osandov@fb.com, xiang@kernel.org, 
	zhangjiachen.jaycee@bytedance.com, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn, allexjlzheng@tencent.com, 
	flyingpeng@tencent.com, txpeng@tencent.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dave Chinner <david@fromorbit.com> =E4=BA=8E2024=E5=B9=B411=E6=9C=8826=E6=
=97=A5=E5=91=A8=E4=BA=8C 08:51=E5=86=99=E9=81=93=EF=BC=9A
>
> is simply restating what you said in the previous email that I
> explicitly told you didn't answer the question I was asking you.
>
> Please listen to what I'm asking you to do. You don't need to
> explain anything to me, I just want you to run an experiment and
> report the results.
>
> This isn't a hard thing to do: the inode32 filesystem should fill to
> roughly 50% before it really starts to spill to the lower AGs.
> Record and paste the 'xfs_spaceman -c "freesp -a X"' histograms for
> each AG when the filesystem is a little over half full.
>
> That's it. I don't need you to explain anything to me, I simply want
> to know if the inode32 allocation policy does, in fact, work the way
> it is expected to under your problematic workload.
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com

Hi, sorry for the delay.
Seeing that others(adding them to CC list) have also encountered this issue=
:

https://lore.kernel.org/all/20241216130551.811305-1-txpeng@tencent.com/

As an reference, maybe we should give out the result we got so far:
+---------------+--------+--------+--------+
| Space Used (%)| Normal | inode32|   AF   |
+---------------+--------+--------+--------+
|            30 |  35.11 |  35.25 |  35.11 |
|            41 |  57.35 |  57.58 |  55.96 |
|            46 |  71.48 |  71.74 |  54.04 |
|            51 |  88.40 |  88.68 |  49.49 |
|            56 | 100.00 | 100.00 |  43.91 |
|            62 |        |        |  37.00 |
|            67 |        |        |  28.12 |
|            72 |        |        |  16.32 |
|            77 |        |        |  19.51 |
+---------------+--------+--------+--------+

The raw data will be attached in the tail of the mail.

The first column represents the percentage of the space used.
The rest three columns represents the fragmentation of the free space,
which is the percentage of free extent in range [1,1] from the output
of "xfs_db -c 'freesp' $test_dev".


How to test the Normal vs AF yourself?
Apply the patches and follow the commands in:
https://lore.kernel.org/linux-xfs/20241104014439.3786609-1-zhangshida@kylin=
os.cn/

How to test the inode32 yourself?
1. we need to do some hack to the kernel at first:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 09dc44480d16..69fa9f8867df 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -253,9 +253,10 @@ xfs_set_inode_alloc_perag(
        }

        set_bit(XFS_AGSTATE_ALLOWS_INODES, &pag->pag_opstate);
-       if (pag->pag_agno < max_metadata)
+       if (pag->pag_agno < max_metadata) {
+               pr_info("%s=3D=3D=3Dagno:%d\n", __func__, pag->pag_agno);
                set_bit(XFS_AGSTATE_PREFERS_METADATA, &pag->pag_opstate);
-       else
+       } else
                clear_bit(XFS_AGSTATE_PREFERS_METADATA, &pag->pag_opstate);
        return true;
 }
@@ -312,7 +313,7 @@ xfs_set_inode_alloc(
         * sufficiently large, set XFS_OPSTATE_INODE32 if we must alter
         * the allocator to accommodate the request.
         */
-       if (xfs_has_small_inums(mp) && ino > XFS_MAXINUMBER_32)
+       if (xfs_has_small_inums(mp))
                xfs_set_inode32(mp);
        else
                xfs_clear_inode32(mp);
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
so that we can test inode32 in a small disk img and observe it in a
controllable way.

2. Do the same test as the method we used to test Normal vs AF, but with
   a little change.

2.1. Create an 1g sized img file and format it as xfs:
  dd if=3D/dev/zero of=3Dtest.img bs=3D1M count=3D1024
  mkfs.xfs -f test.img
  sync
2.2. Make a mount directory:
  mkdir mnt
2.3. Run the auto_frag.sh script, which will call another scripts
  To enable the inode32, you should change the mount option in frag.sh:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
-       mount -o af1=3D1 $test_dev $test_mnt
+       mount -o inode32 $test_dev $test_mnt
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  run:
    ./auto_frag.sh 1

And we are still hesitant about whether we should report these results sinc=
e:
1. it's tested with the assumption that the hack that we did to the inode32
   will have no impact on the estimation of the metadata preference method.
2. it's tested under an alternate-punching script instead of some real MySQ=
L
   workload.

And I am afraid that Dave will blame us for not doing exactly what you
told us to test. Sorry.:p
Maybe we should port the algorithm to a release version and do a few months
test with some users or database guys for the inode32 or the new algorithm
in a whole.
We should reply back at that time maybe.

And Tianxiang, would you mind working with us on the problem? Teamwork
will be quite efficient. We'll try our best to figure out a way to see how
to let everyone play an important role in this work.

Cheers,
Shida

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DAttachment 1: Normal=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
test_dev:test.img test_mnt:mnt/ fize_size:512000KB
mount test.img mnt/
file:mnt//frag size:500MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  285M  676M  30% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1   63630   63630  35.11
   2048    4095       1    2923   1.61
  32768   65536       2  114672  63.28
test_dev:test.img test_mnt:mnt/ fize_size:204800KB
mount test.img mnt/
file:mnt//frag2 size:200MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  386M  575M  41% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1   89127   89127  57.35
   2048    4095       1    2923   1.88
   8192   16383       1   14226   9.15
  32768   65536       1   49144  31.62
test_dev:test.img test_mnt:mnt/ fize_size:102400KB
mount test.img mnt/
file:mnt//frag3 size:100MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  436M  525M  46% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1  101877  101877  71.48
   2048    4095       1    2923   2.05
   8192   16383       1   14226   9.98
  16384   32767       1   23492  16.48
test_dev:test.img test_mnt:mnt/ fize_size:102400KB
mount test.img mnt/
file:mnt//frag4 size:100MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  486M  475M  51% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1  114579  114579  88.40
    512    1023       1     811   0.63
   8192   16383       1   14226  10.98
test_dev:test.img test_mnt:mnt/ fize_size:102400KB
mount test.img mnt/
file:mnt//frag5 size:100MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  537M  424M  56% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1  116730  116730 100.00
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DAttachment 2: inode 32=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 test_dev:test.img test_mnt:mnt/ fize_size:512000KB
mount -o af1=3D1 test.img mnt/
file:mnt//frag size:500MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  285M  676M  30% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1   63887   63887  35.25
   2048    4095       1    2931   1.62
  32768   65536       2  114407  63.13
test_dev:test.img test_mnt:mnt/ fize_size:204800KB
mount -o af1=3D1 test.img mnt/
file:mnt//frag2 size:200MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  386M  575M  41% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1   89487   89487  57.58
   2048    4095       1    2931   1.89
   8192   16383       1   13858   8.92
  32768   65536       1   49144  31.62
test_dev:test.img test_mnt:mnt/ fize_size:102400KB
mount -o af1=3D1 test.img mnt/
file:mnt//frag3 size:100MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  435M  526M  46% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1  102235  102235  71.74
   2048    4095       1    2931   2.06
   8192   16383       1   13858   9.72
  16384   32767       1   23492  16.48
test_dev:test.img test_mnt:mnt/ fize_size:102400KB
mount -o af1=3D1 test.img mnt/
file:mnt//frag4 size:100MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  486M  475M  51% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1  114937  114937  88.68
    512    1023       1     819   0.63
   8192   16383       1   13858  10.69
test_dev:test.img test_mnt:mnt/ fize_size:102400KB
mount -o af1=3D1 test.img mnt/
file:mnt//frag5 size:100MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  537M  424M  56% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1  116730  116730 100.00
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DAttachment 3: AF=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
test_dev:test.img test_mnt:mnt/ fize_size:512000KB
mount -o af1=3D1 test.img mnt/
file:mnt//frag size:500MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  285M  676M  30% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1   63630   63630  35.11
   2048    4095       1    2923   1.61
  32768   65536       2  114672  63.28
test_dev:test.img test_mnt:mnt/ fize_size:204800KB
mount -o af1=3D1 test.img mnt/
file:mnt//frag2 size:200MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  385M  576M  41% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1   86974   86974  55.96
   2048    4095       1    2923   1.88
  32768   65536       1   65528  42.16
test_dev:test.img test_mnt:mnt/ fize_size:102400KB
mount -o af1=3D1 test.img mnt/
file:mnt//frag3 size:100MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  436M  525M  46% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1   77038   77038  54.04
  32768   65536       1   65528  45.96
test_dev:test.img test_mnt:mnt/ fize_size:102400KB
mount -o af1=3D1 test.img mnt/
file:mnt//frag4 size:100MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  486M  475M  51% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1   64186   64186  49.48
  32768   65536       1   65528  50.52
test_dev:test.img test_mnt:mnt/ fize_size:102400KB
mount -o af1=3D1 test.img mnt/
file:mnt//frag5 size:100MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  536M  425M  56% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1   51312   51312  43.91
      2       3      11      22   0.02
  32768   65536       1   65528  56.07
test_dev:test.img test_mnt:mnt/ fize_size:102400KB
mount -o af1=3D1 test.img mnt/
file:mnt//frag6 size:100MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  586M  375M  62% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1   38486   38486  37.00
  32768   65536       1   65528  63.00
test_dev:test.img test_mnt:mnt/ fize_size:102400KB
mount -o af1=3D1 test.img mnt/
file:mnt//frag7 size:100MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  637M  324M  67% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1   25633   25633  28.12
  32768   65536       1   65528  71.88
test_dev:test.img test_mnt:mnt/ fize_size:102400KB
mount -o af1=3D1 test.img mnt/
file:mnt//frag8 size:100MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  687M  274M  72% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1   12783   12783  16.32
  32768   65536       1   65528  83.68
test_dev:test.img test_mnt:mnt/ fize_size:102400KB
mount -o af1=3D1 test.img mnt/
file:mnt//frag9 size:100MB
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   960M  737M  224M  77% /data/proj/frag_test/mnt
umount test.img
   from      to extents  blocks    pct
      1       1   12768   12768  19.51
   8192   16383       1   16370  25.02
  32768   65536       1   36295  55.47
