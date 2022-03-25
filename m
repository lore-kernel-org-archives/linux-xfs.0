Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52738C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Mar 2022 13:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354681AbiCYNfm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 09:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345662AbiCYNfl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Mar 2022 09:35:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 370CFDF9F
        for <linux-xfs@vger.kernel.org>; Fri, 25 Mar 2022 06:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648215246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=unCeDUSTtWJ5xh5sWcZRj3C3u6c9kumSjz2QTBkgbVA=;
        b=GDWnXdlxt3gpFtBiGRgw9k5kLm2n0yX1IQ8WBZEYKhxiCmQXwojcwe7lBMir9WffYedCf3
        wE/3eSl8wQySYwsPHqjE9QU1BTbHHEHVd7dvdyVBHsHuS+NtKlZPSoMdbW2DckIfzI1BbE
        /cdRP9CovXUYvm4GLoYaDHRHVcJ1CYQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-guw8xnc3P-W_IFWhB5durQ-1; Fri, 25 Mar 2022 09:34:04 -0400
X-MC-Unique: guw8xnc3P-W_IFWhB5durQ-1
Received: by mail-wm1-f69.google.com with SMTP id l7-20020a05600c1d0700b0038c9c48f1e7so5257166wms.2
        for <linux-xfs@vger.kernel.org>; Fri, 25 Mar 2022 06:34:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=unCeDUSTtWJ5xh5sWcZRj3C3u6c9kumSjz2QTBkgbVA=;
        b=6RSPkA+ffj3xQk3c1ib6WciiuZ4xHwUyL3g/FDqfhkq8el7/wmttMqwdKRj/4nLSeK
         yRtOqY3pRQDwiq0d6uxbbkyB9D8Ud9nv4LnMAiZXsvBXRxY1hvD5q/T5r6YV1IJUl9oq
         mlZT9BW+tXT0/NhfThJlWqtEn1B9Ih7q/mkvIsd2Jo9AST3xaZcWL7vbImG+rKXjsvFx
         +TDdTTDT7sXKeiZEBbcSIZmwaUvKph1lOmGudNqyrq9Fa7DpY4pKCemEZ+tCT741Hngu
         6BJ8QhqcrgLbbVm+BO4bZDTS/LgQLuh+FNz/6qtGF7tFkfWDIAV/N6ZTVVhwYoOk+Yy3
         Zm0g==
X-Gm-Message-State: AOAM533lzwtVVHNWITAtx0fioZ9Z0OjHXviOQ6fHB/uWTJwnO5bjxlzc
        nN5gI+tbIPtER6zulM+DYeQVtmu/SV/rm1Nt95wa9mt2leh8t8zls4xZLK5BQVsiEktKYShFEgV
        L2Ztw+Kh3BBTAqJNrpKTI
X-Received: by 2002:a1c:7518:0:b0:37c:7eb:f255 with SMTP id o24-20020a1c7518000000b0037c07ebf255mr19073934wmc.29.1648215243398;
        Fri, 25 Mar 2022 06:34:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyo6PG7adMH7rvbYq2TLEQ1dY661F20SQt2BtKtd1GRNNU7pAeu+ZShm1I8326AEydvnACl3w==
X-Received: by 2002:a1c:7518:0:b0:37c:7eb:f255 with SMTP id o24-20020a1c7518000000b0037c07ebf255mr19073905wmc.29.1648215243093;
        Fri, 25 Mar 2022 06:34:03 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v188-20020a1cacc5000000b00384b71a50d5sm4533167wme.24.2022.03.25.06.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 06:34:02 -0700 (PDT)
Date:   Fri, 25 Mar 2022 21:33:56 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v1] xfs/019: extend protofile test
Message-ID: <20220325133356.ektmgzck7rpaghcz@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
References: <20220317232408.202636-1-catherine.hoang@oracle.com>
 <20220323013653.46d432ybh2zpdhhs@zlang-mailbox>
 <641873A3-0E40-4099-9804-35D1D6792CFA@oracle.com>
 <20220324192600.5dx3vkmrl6z3snu5@zlang-mailbox>
 <20220324201730.GS8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220324201730.GS8224@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 24, 2022 at 01:17:30PM -0700, Darrick J. Wong wrote:
> On Fri, Mar 25, 2022 at 03:26:00AM +0800, Zorro Lang wrote:
> > On Thu, Mar 24, 2022 at 03:44:00PM +0000, Catherine Hoang wrote:
> > > > On Mar 22, 2022, at 6:36 PM, Zorro Lang <zlang@redhat.com> wrote:
> > > > 
> > > > On Thu, Mar 17, 2022 at 11:24:08PM +0000, Catherine Hoang wrote:
> > > >> This test creates an xfs filesystem and verifies that the filesystem
> > > >> matches what is specified by the protofile.
> > > >> 
> > > >> This patch extends the current test to check that a protofile can specify
> > > >> setgid mode on directories. Also, check that the created symlink isn’t
> > > >> broken.
> > > >> 
> > > >> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > > >> ---
> > > > 
> > > > Any specific reason to add this test? Likes uncovering some one known
> > > > bug/fix?
> > > > 
> > > > Thanks,
> > > > Zorro
> > > 
> > > Hi Zorro,
> > > 
> > > We’ve been exploring alternate uses for protofiles and noticed a few holes
> > > in the testing.
> > 
> > That's great, but better to show some details in the patch/commit, likes
> > a commit id of xfsprogs?/kernel? (if there's one) which fix the bug you
> > metioned, to help others to know what's this change trying to cover.
> 
> I think this patch is adding a check that protofile lines are actually
> being honored (in the case of the symlink file) and checking that setgid
> on a directory is not carried over into new children unless the
> protofile explicitly marks the children setgid.
> 
> IOWs, this isn't adding a regression test for a fix in xfsprogs, it's
> increasing test coverage.

Oh, understand, I have no objection with this patch, just thought it covers
a known bug :) If it's good to you too, let's ACK it.

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > Thanks,
> > > Catherine
> > > > 
> > > >> tests/xfs/019     |  6 ++++++
> > > >> tests/xfs/019.out | 12 +++++++++++-
> > > >> 2 files changed, 17 insertions(+), 1 deletion(-)
> > > >> 
> > > >> diff --git a/tests/xfs/019 b/tests/xfs/019
> > > >> index 3dfd5408..535b7af1 100755
> > > >> --- a/tests/xfs/019
> > > >> +++ b/tests/xfs/019
> > > >> @@ -73,6 +73,10 @@ $
> > > >> setuid -u-666 0 0 $tempfile
> > > >> setgid --g666 0 0 $tempfile
> > > >> setugid -ug666 0 0 $tempfile
> > > >> +directory_setgid d-g755 3 2
> > > >> +file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5 ---755 3 1 $tempfile
> > > >> +$
> > > >> +: back in the root
> > > >> block_device b--012 3 1 161 162 
> > > >> char_device c--345 3 1 177 178
> > > >> pipe p--670 0 0
> > > >> @@ -114,6 +118,8 @@ _verify_fs()
> > > >> 		| xargs $here/src/lstat64 | _filter_stat)
> > > >> 	diff -q $SCRATCH_MNT/bigfile $tempfile.2 \
> > > >> 		|| _fail "bigfile corrupted"
> > > >> +	diff -q $SCRATCH_MNT/symlink $tempfile.2 \
> > > >> +		|| _fail "symlink broken"
> > > >> 
> > > >> 	echo "*** unmount FS"
> > > >> 	_full "umount"
> > > >> diff --git a/tests/xfs/019.out b/tests/xfs/019.out
> > > >> index 19614d9d..8584f593 100644
> > > >> --- a/tests/xfs/019.out
> > > >> +++ b/tests/xfs/019.out
> > > >> @@ -7,7 +7,7 @@ Wrote 2048.00Kb (value 0x2c)
> > > >>  File: "."
> > > >>  Size: <DSIZE> Filetype: Directory
> > > >>  Mode: (0777/drwxrwxrwx) Uid: (3) Gid: (1)
> > > >> -Device: <DEVICE> Inode: <INODE> Links: 3 
> > > >> +Device: <DEVICE> Inode: <INODE> Links: 4 
> > > >> 
> > > >>  File: "./bigfile"
> > > >>  Size: 2097152 Filetype: Regular File
> > > >> @@ -54,6 +54,16 @@ Device: <DEVICE> Inode: <INODE> Links: 1
> > > >>  Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > >> Device: <DEVICE> Inode: <INODE> Links: 1 
> > > >> 
> > > >> + File: "./directory_setgid"
> > > >> + Size: <DSIZE> Filetype: Directory
> > > >> + Mode: (2755/drwxr-sr-x) Uid: (3) Gid: (2)
> > > >> +Device: <DEVICE> Inode: <INODE> Links: 2 
> > > >> +
> > > >> + File: "./directory_setgid/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5"
> > > >> + Size: 5 Filetype: Regular File
> > > >> + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (2)
> > > >> +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > >> +
> > > >>  File: "./pipe"
> > > >>  Size: 0 Filetype: Fifo File
> > > >>  Mode: (0670/frw-rwx---) Uid: (0) Gid: (0)
> > > >> -- 
> > > >> 2.25.1
> > > >> 
> > > > 
> > > 
> > 
> 

