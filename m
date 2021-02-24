Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B6CC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 09:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77B3164E05
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 09:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbhBXJNW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 04:13:22 -0500
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17170 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234537AbhBXJMc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 04:12:32 -0500
X-Greylist: delayed 987 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2021 04:12:29 EST
ARC-Seal: i=1; a=rsa-sha256; t=1614156907; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=pvXTmcBIYjCz9V/ivdv616Su5Kb0P0DuUkLG89Kv4GyIhcMEwmtXZ9yMfVDUwPUEQFqNLayAFGXnVEKj6jSwXDhxCCnpVadrQTto7qY/XUb6KxrQk2VJ4a9zxNoXs+b+WFsMBYZ50VXlFVMvzmkaPlQSeZcX4plm4L52Srou/SA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1614156907; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=YvrCdFwNCwi6NmY8GlAug+MEP+8/DwZCVjNFbH6AICk=; 
        b=i4ga4DnGhCoZjZkAcHLSNpySds91TIl71cX4TYka42Cc7oTYJrpiOYWQihwE8j2i8nuGbLaXwdo9msFqvH1vj8Or4iuqc1S0xwH4tt/JC/LPSAQDh/l63fH8ubapi+zTfSUzZpfcoOp4eYs3J+obvJATickZsiiL0b08IHDLy0Q=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1614156907;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=YvrCdFwNCwi6NmY8GlAug+MEP+8/DwZCVjNFbH6AICk=;
        b=JHbYjlj8cmJAvx0eDvfYP56Nej7vGaWSfvALJ/3EJDtOuZHY7b+i28xZhjjlXc7E
        5m/P6u6KJfSL8upA+lD3SMAdzsJ0QMgSu4EMueAZxvOrTAUdHDuw1ClgIT2acB+qVKU
        clkyaws6mZ5zVcfW38rENPwsLLlCbcwgN56ryRyE=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1614156905983533.4742617740758; Wed, 24 Feb 2021 16:55:05 +0800 (CST)
Date:   Wed, 24 Feb 2021 16:55:05 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Su Yue" <l@damenly.su>
Cc:     "guaneryu" <guaneryu@gmail.com>,
        "fstests" <fstests@vger.kernel.org>,
        "nborisov" <nborisov@suse.com>,
        "linux-xfs" <linux-xfs@vger.kernel.org>
Message-ID: <177d33fbdfc.e695e59715728.7280718543024605154@mykernel.net>
In-Reply-To: <1rd5rim9.fsf@damenly.su>
References: <20210223134042.2212341-1-cgxu519@mykernel.net>
 <4ki1rjgu.fsf@damenly.su> <1rd5rim9.fsf@damenly.su>
Subject: Re: [PATCH] generic/473: fix expectation properly in out file
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2021-02-24 16:10:39 Su Yue <l@=
damenly.su> =E6=92=B0=E5=86=99 ----
 >=20
 > On Wed 24 Feb 2021 at 15:52, Su Yue <l@damenly.su> wrote:
 >=20
 > > Cc to the author and linux-xfs, since it's xfsprogs related.
 > >
 > > On Tue 23 Feb 2021 at 21:40, Chengguang Xu=20
 > > <cgxu519@mykernel.net> wrote:
 > >
 > >> It seems the expected result of testcase of "Hole + Data"
 > >> in generic/473 is not correct, so just fix it properly.
 > >>
 > >
 > > But it's not proper...
 > >
 > >> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > >> ---
 > >>  tests/generic/473.out | 2 +-
 > >>  1 file changed, 1 insertion(+), 1 deletion(-)
 > >>
 > >> diff --git a/tests/generic/473.out b/tests/generic/473.out
 > >> index 75816388..f1ee5805 100644
 > >> --- a/tests/generic/473.out
 > >> +++ b/tests/generic/473.out
 > >> @@ -6,7 +6,7 @@ Data + Hole
 > >>  1: [256..287]: hole
 > >>  Hole + Data
 > >>  0: [0..127]: hole
 > >> -1: [128..255]: data
 > >> +1: [128..135]: data
 > >>
 > > The line is produced by `$XFS_IO_PROG -c "fiemap -v 0 65k" $file=20
 > > |
 > > _filter_fiemap`.
 > > 0-64k is a hole and 64k-128k is a data extent.
 > > fiemap ioctl always returns *complete* ranges of extents.
 > >
 > And what you want to change is only the filted output.
 > Without _filter_fiemap:

Without _filter_fiemap:

[root@centos xfstests-dev]# git diff
diff --git a/tests/generic/473 b/tests/generic/473
index 5c19703e..35f28677 100755
--- a/tests/generic/473
+++ b/tests/generic/473
@@ -60,7 +60,8 @@ echo "Data + Hole"
 $XFS_IO_PROG -c "fiemap -v 64k 80k" $file | _filter_fiemap
=20
 echo "Hole + Data"
-$XFS_IO_PROG -c "fiemap -v 0 65k" $file | _filter_fiemap
+#$XFS_IO_PROG -c "fiemap -v 0 65k" $file | _filter_fiemap
+$XFS_IO_PROG -c "fiemap -v 0 65k" $file
=20
 echo "Hole + Data + Hole"
 $XFS_IO_PROG -c "fiemap -v 0k 130k" $file | _filter_fiemap
=20
[root@centos xfstests-dev]# ./check generic/473
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 centos 5.11.0+ #5 SMP Tue Feb 23 21:02:27 CST=
 2021
MKFS_OPTIONS  -- /dev/mapper/workvg-test2
MOUNT_OPTIONS -- -o acl,user_xattr /dev/mapper/workvg-test2 /mnt/scratch

generic/473 1s ... - output mismatch (see /git/xfstests-dev/results//generi=
c/473.out.bad)
    --- tests/generic/473.out   2021-02-24 16:51:23.254845067 +0800
    +++ /git/xfstests-dev/results//generic/473.out.bad  2021-02-24 16:52:04=
.440737816 +0800
    @@ -5,8 +5,10 @@
     0: [128..255]: data
     1: [256..287]: hole
     Hole + Data
    -0: [0..127]: hole
    -1: [128..255]: data
    +/mnt/test/fiemap.473:
    + EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
    ...
    (Run 'diff -u /git/xfstests-dev/tests/generic/473.out /git/xfstests-dev=
/results//generic/473.out.bad'  to see the entire diff)
Ran: generic/473
Failures: generic/473
Failed 1 of 1 tests

[root@centos xfstests-dev]# diff -u /git/xfstests-dev/tests/generic/473.out=
 /git/xfstests-dev/results//generic/473.out.bad
--- /git/xfstests-dev/tests/generic/473.out     2021-02-24 16:51:23.2548450=
67 +0800
+++ /git/xfstests-dev/results//generic/473.out.bad      2021-02-24 16:52:04=
.440737816 +0800
@@ -5,8 +5,10 @@
 0: [128..255]: data
 1: [256..287]: hole
 Hole + Data
-0: [0..127]: hole
-1: [128..255]: data
+/mnt/test/fiemap.473:
+ EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
+   0: [0..127]:        hole               128
+   1: [128..135]:      274560..274567       8   0x1
 Hole + Data + Hole
 0: [0..127]: hole
 1: [128..255]: data



 >=20
 > /mnt/test/fiemap.473:=20
 > |
 >  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS=20
 >  |
 >    0: [0..127]:        hole               128=20
 >    |
 >    1: [128..255]:      26792..26919       128   0x0
 >=20
 > [128..255] corresponds to the BLOCK-RANGE of the extent=20
 > 26792..26919.
 >=20
 > > You may ask why the ending hole range is not aligned to 128 in=20
 > > 473.out. Because
 > > fiemap ioctl returns nothing of querying holes. xfs_io does the=20
 > > extra
 > > print work for holes.
 > >
 > > xfsprogs-dev/io/fiemap.c:
 > > for holes:
 > > 153     if (lstart > llast) {
 > > 154         print_hole(0, 0, 0, cur_extent, lflag, true, llast,=20
 > > lstart);
 > > 155         cur_extent++;
 > > 156         num_printed++;
 > > 157     }
 > >
 > > for the ending hole:
 > >  381     if (cur_extent && last_logical < range_end)
 > >  382         print_hole(foff_w, boff_w, tot_w, cur_extent,=20
 > >  lflag,   !vflag,
 > >  383                BTOBBT(last_logical), BTOBBT(range_end));
 > >
 > >>  Hole + Data + Hole
 > >>  0: [0..127]: hole
 > >>  1: [128..255]: data
 >=20
 >=20
