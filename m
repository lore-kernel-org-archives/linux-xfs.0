Return-Path: <SRS0=dxv4=BH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F6AC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 11:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D22DD2065C
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 11:34:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NWh2CZUX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgG1Lew (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 07:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729081AbgG1Lev (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jul 2020 07:34:51 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D512FC0619D2
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 04:34:51 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id q75so12200557iod.1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 04:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=/1/V/xwvQZiGrAs+0Q/dFa/gIpMv8L2HeMvGAgEnHVg=;
        b=NWh2CZUX/SasDwiWDJeWibOpOrfVp9RsYUG929kUpoUxVuZgKLuIOSRWM9FykGDamo
         QXVt0fXEScaKj3ZBxBSLlgNKPO0tFSrSt3fDNuQ6AZH7GkuTWp/JLOHSLnpwYAeQ3vh/
         V74SOTLbvNuMkqd5Bp4vK0R+opOjQ9Lco9LpQ0/1YtdAHg9U2LXqbcuxBGb2FLjVlAX5
         i/Onew3oXSRC71UJFFkIwiM2mZI23dRz2yhtKWXvhbdLxotFvA9ArwEHjUrpnlmeQmdy
         M3USP9FJn597WJxFEZSUex/rZTc2O3k0eOUqHpsjU17Rt/ESqnHsNkxvr2FxqChNFBO0
         NwLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=/1/V/xwvQZiGrAs+0Q/dFa/gIpMv8L2HeMvGAgEnHVg=;
        b=QDi3ln+DaPvdqxD3kdr4LZVUMCzrLlbW63eXntRtKtSdvNwRy+0Zxh80eTZ1N6FXkC
         2c+NsyqUjtkfVgvPqahUbCDfNcqQX6m8fzB85cG5ojr1eQMC5zC6Q2t91OU4RGucf8+4
         iyoZ0plLs/d71L1U0lg6EcMMYkMpShWmER1iz8eB1R3ylYW/U+xAUfkgi5HMM3XjNs42
         X1AqZmMwNWHICAuHma1+2L3a281pRsPDlgW2MXguczcM0uNUxV/KFYbmpRGpd64yu1OX
         wK778SHNjM2nsjZfQa00qtO2FQyawFW5KzWAHzZ8y5KHOrEABz0vP6FBVGYakgvh3Ywu
         thzg==
X-Gm-Message-State: AOAM533axmx7+w19fSDodDZH9jihjoM1CTCswFO54hVEySGjM+QV2NFi
        rpzLPoIOfINx/sleX+i82liQhMGpbBstDrCdTAQ=
X-Google-Smtp-Source: ABdhPJzN+84ipVlQjFNKmf1TdI64o9kGglmx8aqzUyrFtC/vqC6a9Ii5xUvdmCBTDw2DzSt4EIL9pfXcIwi8IxcAr1I=
X-Received: by 2002:a6b:6509:: with SMTP id z9mr19618936iob.127.1595936091116;
 Tue, 28 Jul 2020 04:34:51 -0700 (PDT)
MIME-Version: 1.0
From:   Zhengyuan Liu <liuzhengyuang521@gmail.com>
Date:   Tue, 28 Jul 2020 19:34:39 +0800
Message-ID: <CAOOPZo45E+hVAo9S_2psMJQzrzwmVKo_WjWOM7Zwhm_CS0J3iA@mail.gmail.com>
Subject: [Question] About XFS random buffer write performance
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

When doing random buffer write testing I found the bandwidth on EXT4 is muc=
h
better than XFS under the same environment.
The test case ,test result and test environment is as follows:
Test case:
fio --ioengine=3Dsync --rw=3Drandwrite --iodepth=3D64 --size=3D4G --name=3D=
test
--filename=3D/mnt/testfile --bs=3D4k
Before doing fio, use dd (if=3D/dev/zero of=3D/mnt/testfile bs=3D1M
count=3D4096) to warm-up the file in the page cache.

Test result (bandwidth):
         ext4                   xfs
       ~300MB/s       ~120MB/s

Test environment:
    Platform:  arm64
    Kernel:  v5.7
    PAGESIZE:  64K
    Memtotal:  16G
    Storage: sata ssd(Max bandwidth about 350MB/s)
    FS block size: 4K

The  fio "Test result" shows that EXT4 has more than 2x bandwidth compared =
to
XFS, but iostat shows the transfer speed of XFS to SSD is about 300MB/s too=
.
So I debt XFS writing back many non-dirty blocks to SSD while  writing back
dirty pages. I tried to read the core writeback code of both
filesystem and found
XFS will write back blocks which is uptodate (seeing iomap_writepage_map())=
,
while EXT4 writes back blocks which must be dirty (seeing
ext4_bio_write_page() ) . XFS had turned from buffer head to iomap since
V4.8, there is only a bitmap in iomap to track block's uptodate
status, no 'dirty'
concept was found, my question is if this is the reason why XFS writes many
extra blocks to SSD when doing random buffer write? If it is, then why don'=
t we
track the dirty status of blocks in XFS?

With the questions in brain, I start digging into XFS's history, and found =
a
annotations in V2.6.12:
        /*
         * Calling this without startio set means we are being asked
to make a dirty
         * page ready for freeing it's buffers.  When called with
startio set then
         * we are coming from writepage.
         * When called with startio set it is important that we write the W=
HOLE
         * page if possible.
         * The bh->b_state's cannot know if any of the blocks or which bloc=
k for
         * that matter are dirty due to mmap writes, and therefore bh
uptodate is
         * only vaild if the page itself isn't completely uptodate.  Some l=
ayers
         * may clear the page dirty flag prior to calling write page, under=
 the
         * assumption the entire page will be written out; by not
writing out the
         * whole page the page can be reused before all valid dirty data is
         * written out.  Note: in the case of a page that has been dirty'd =
by
         * mapwrite and but partially setup by block_prepare_write the
         * bh->b_states's will not agree and only ones setup by BPW/BCW wil=
l
         * have valid state, thus the whole page must be written out thing.
         */
        STATIC int=E3=80=80xfs_page_state_convert()

From above annotations, It seems this has something to do with mmap, but I
can't get the point , so I turn to you guys to get the help. Anyway, I don'=
t
think there is such a difference about random write between XFS and EXT4.

Any reply would be appreciative, Thanks in advance.
