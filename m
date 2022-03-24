Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA64BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 19:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346245AbiCXT1p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 15:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237199AbiCXT1o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 15:27:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9EEDB918C
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 12:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648149971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MejE84XwLal/X1oU3O5zl6iC0YKyh4ySmhw81quvhFY=;
        b=PShNP6Rhp899g2DhvsIAL4Ky2W0oKHo+H62Tqj8Br7mvTWvH3dM0D+1bJboYNIbgaIeF53
        k79x++mk0MS7Gl2vIHgo7thHMovSbs78sIczK8NuTqITc3TIElQg8/fKNOpl7RJGfp2vAc
        cb+MIVqf0d+6oMsZsgyJsiXIF71Ko4M=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-OpWqBP6-M2yrtsuH0zS35w-1; Thu, 24 Mar 2022 15:26:08 -0400
X-MC-Unique: OpWqBP6-M2yrtsuH0zS35w-1
Received: by mail-qt1-f199.google.com with SMTP id k1-20020ac85fc1000000b002e1c5930386so4452016qta.3
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 12:26:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=MejE84XwLal/X1oU3O5zl6iC0YKyh4ySmhw81quvhFY=;
        b=rFFfv1EVc5CIAzy2XlDdSkC+7PmJT8nPHCIlc9pF1WB5cfG1deh/bUPcNY9egRsoS/
         z7DqDWg5T4z9OHyR+dbYnjOtjxso56pFQoEPKZ3S4jlFMxgZiV+NGU8VTYcq7Z87Hnh6
         HwQznml3d8SSg/ssJgXiRTp58YkSryFB6Nw2Z5B/LjlNGX1ISn+7dvyEPBg6eC/xrP2Z
         11ybzvQDYytgTaj40SWz4jzqqpNTC7OyFPvcDVZsVFy8C0OD+gGNTMT3mtQj0DkwbS98
         MBgkc+E/URcSXWE/tEAoxqlqyj8Vc5GGnpEpWRlj6hEP3o5Whojjg6jigWZN0GQCnKL/
         /6Pw==
X-Gm-Message-State: AOAM5333y4NM5CfBfgYCI7nK6ghGp0JUoVLQEYuZbkisxPTeU4sNh3GJ
        MkDrXNkFPKSECBk79Yxuq88ZxqHdPLZCXYJ50vmc2NRDUIBdrKxUKz6coCGpHOag9F+2IYEbjlJ
        fsAHGsoiISLcawRrdu6/I
X-Received: by 2002:ac8:5a0f:0:b0:2e1:a907:62ee with SMTP id n15-20020ac85a0f000000b002e1a90762eemr5895624qta.582.1648149967583;
        Thu, 24 Mar 2022 12:26:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxra4iLO+Km26gxDHJaY6DF8/ahLCOomXqzOHhKCLZRdfrhmXHkcEqsn+02+JRXDl1HmBmsqw==
X-Received: by 2002:ac8:5a0f:0:b0:2e1:a907:62ee with SMTP id n15-20020ac85a0f000000b002e1a90762eemr5895610qta.582.1648149967295;
        Thu, 24 Mar 2022 12:26:07 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d21-20020a05622a101500b002e07151139fsm3356810qte.17.2022.03.24.12.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 12:26:06 -0700 (PDT)
Date:   Fri, 25 Mar 2022 03:26:00 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v1] xfs/019: extend protofile test
Message-ID: <20220324192600.5dx3vkmrl6z3snu5@zlang-mailbox>
Mail-Followup-To: Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
References: <20220317232408.202636-1-catherine.hoang@oracle.com>
 <20220323013653.46d432ybh2zpdhhs@zlang-mailbox>
 <641873A3-0E40-4099-9804-35D1D6792CFA@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <641873A3-0E40-4099-9804-35D1D6792CFA@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 24, 2022 at 03:44:00PM +0000, Catherine Hoang wrote:
> > On Mar 22, 2022, at 6:36 PM, Zorro Lang <zlang@redhat.com> wrote:
> > 
> > On Thu, Mar 17, 2022 at 11:24:08PM +0000, Catherine Hoang wrote:
> >> This test creates an xfs filesystem and verifies that the filesystem
> >> matches what is specified by the protofile.
> >> 
> >> This patch extends the current test to check that a protofile can specify
> >> setgid mode on directories. Also, check that the created symlink isn’t
> >> broken.
> >> 
> >> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> >> ---
> > 
> > Any specific reason to add this test? Likes uncovering some one known
> > bug/fix?
> > 
> > Thanks,
> > Zorro
> 
> Hi Zorro,
> 
> We’ve been exploring alternate uses for protofiles and noticed a few holes
> in the testing.

That's great, but better to show some details in the patch/commit, likes
a commit id of xfsprogs?/kernel? (if there's one) which fix the bug you
metioned, to help others to know what's this change trying to cover.

Thanks,
Zorro

> 
> Thanks,
> Catherine
> > 
> >> tests/xfs/019     |  6 ++++++
> >> tests/xfs/019.out | 12 +++++++++++-
> >> 2 files changed, 17 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/tests/xfs/019 b/tests/xfs/019
> >> index 3dfd5408..535b7af1 100755
> >> --- a/tests/xfs/019
> >> +++ b/tests/xfs/019
> >> @@ -73,6 +73,10 @@ $
> >> setuid -u-666 0 0 $tempfile
> >> setgid --g666 0 0 $tempfile
> >> setugid -ug666 0 0 $tempfile
> >> +directory_setgid d-g755 3 2
> >> +file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5 ---755 3 1 $tempfile
> >> +$
> >> +: back in the root
> >> block_device b--012 3 1 161 162 
> >> char_device c--345 3 1 177 178
> >> pipe p--670 0 0
> >> @@ -114,6 +118,8 @@ _verify_fs()
> >> 		| xargs $here/src/lstat64 | _filter_stat)
> >> 	diff -q $SCRATCH_MNT/bigfile $tempfile.2 \
> >> 		|| _fail "bigfile corrupted"
> >> +	diff -q $SCRATCH_MNT/symlink $tempfile.2 \
> >> +		|| _fail "symlink broken"
> >> 
> >> 	echo "*** unmount FS"
> >> 	_full "umount"
> >> diff --git a/tests/xfs/019.out b/tests/xfs/019.out
> >> index 19614d9d..8584f593 100644
> >> --- a/tests/xfs/019.out
> >> +++ b/tests/xfs/019.out
> >> @@ -7,7 +7,7 @@ Wrote 2048.00Kb (value 0x2c)
> >>  File: "."
> >>  Size: <DSIZE> Filetype: Directory
> >>  Mode: (0777/drwxrwxrwx) Uid: (3) Gid: (1)
> >> -Device: <DEVICE> Inode: <INODE> Links: 3 
> >> +Device: <DEVICE> Inode: <INODE> Links: 4 
> >> 
> >>  File: "./bigfile"
> >>  Size: 2097152 Filetype: Regular File
> >> @@ -54,6 +54,16 @@ Device: <DEVICE> Inode: <INODE> Links: 1
> >>  Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> >> Device: <DEVICE> Inode: <INODE> Links: 1 
> >> 
> >> + File: "./directory_setgid"
> >> + Size: <DSIZE> Filetype: Directory
> >> + Mode: (2755/drwxr-sr-x) Uid: (3) Gid: (2)
> >> +Device: <DEVICE> Inode: <INODE> Links: 2 
> >> +
> >> + File: "./directory_setgid/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5"
> >> + Size: 5 Filetype: Regular File
> >> + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (2)
> >> +Device: <DEVICE> Inode: <INODE> Links: 1 
> >> +
> >>  File: "./pipe"
> >>  Size: 0 Filetype: Fifo File
> >>  Mode: (0670/frw-rwx---) Uid: (0) Gid: (0)
> >> -- 
> >> 2.25.1
> >> 
> > 
> 

