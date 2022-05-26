Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 859D3C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 15:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiEZPB2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 11:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiEZPB1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 11:01:27 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EE720F52
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 08:01:26 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gz24so1989779pjb.2
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 08:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wWfWA/wAF25zLNVeGGZNhHD7+1w1iEpazoZ2RDETjyE=;
        b=OI9zeHAXyU6bJkiTlbL4IY196LhGy1ex20f37C5wHuaz7kvN6RR90zLz5rM3jUXETY
         T7HgRCU/4Hkb2AMFzox/dW+e1Twl0jj3suPHj43l+wZtNQ+bDFrclFViZ+Bt0CObiE/P
         uitAdmuv29QwSvQRrYEaaeVZNw+XsFT9dZmVj8sRlKKlhCK9XcHK40YKbxtOBB/dgfuK
         z6KC6kPmce+tjkndP8Q2miynvE+2tNM77dMDK2ouoG/71A8pYPirR1hH5Zea24dHdJVN
         F6DLfhEiWWKPvko9WgytLDfhhtBfrYpg0N0R6YhQqHX7tBas2A4agc25bIcrlOWtSHC0
         XnIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wWfWA/wAF25zLNVeGGZNhHD7+1w1iEpazoZ2RDETjyE=;
        b=750pl43/ZeQzjrbvYJ+qEy+k9yGkw2HpaUnWY2wXFieN6XZ+4g3COw8PR/vXF2pf/l
         zJ3uNtGhEIlZARpLKhMA2ZQmVvqwExF7CkZqEChj8EhhoKLuSAyMWpv8UlVp+grEERlq
         iwGI9pgdMGPUnN+x9g5tNCW/1RT97o/8Iyebq2GOOyiVnZmjIutmN7idcHKlrnnTh4wd
         wYKt1wkMTj8Gma/sECJb76ncF6KoLn68nxuImOBYYe6votX7j48v86vetGlP3F4gS0XU
         Swb1IV1UcMLF/wr6k59gUo7aEQfk3xodSM/okK1/oWhW5HFe/WXkjcwkygw9d6Qr6UKB
         gavw==
X-Gm-Message-State: AOAM532S4bhMWKTeEpFfxmOoltoCTagX9ttzB3MHQoSzhoNcuNsCZIMU
        5G6V8QQHba3SNLV7zDP+rzc6gR+CXeObwvaQ
X-Google-Smtp-Source: ABdhPJwhNtDJwYiVAo6XoEpTwXyK1GxvB0YmL4maAHyiObqgVySY+4+uD6LXD2b2LYnhd93yNvg5Gw==
X-Received: by 2002:a17:902:d483:b0:161:b6a3:4dba with SMTP id c3-20020a170902d48300b00161b6a34dbamr39121104plg.155.1653577285439;
        Thu, 26 May 2022 08:01:25 -0700 (PDT)
Received: from google.com ([2601:647:4701:18d0:dcfd:4f1e:ed62:169f])
        by smtp.gmail.com with ESMTPSA id 21-20020a17090a19d500b001e0d4169365sm1713847pjj.17.2022.05.26.08.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 08:01:25 -0700 (PDT)
Date:   Thu, 26 May 2022 08:01:22 -0700
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Shirley Ma <shirley.ma@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
Subject: Re: XFS LTS backport cabal
Message-ID: <Yo+WQl3OFsPMUAbl@google.com>
References: <Yo6ePjvpC7nhgek+@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yo6ePjvpC7nhgek+@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 25, 2022 at 02:23:10PM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> 3. fstesting -- new patches proposed for stable branches shouldn't
> introduce new regressions, and ideally there would also be a regression
> test that would now pass.  As Dave and I have stated in the past,
> fstests is a big umbrella of a test suite, which implies that A/B
> testing is the way to go.  I think at least Zorro and I would like to
> improve the tagging in fstests to make it more obvious which tests
> contain enough randomness that they cannot be expected to behave 100%
> reliably.
It would be nice to find an agreement on testing requirements. I have
attached some ideas on configs/number of tests/etc as well as the status
of my work on 5.15 below.


> a> I've been following the recent fstests threads, and it seems to me
> that there are really two classes of users -- sustaining people who want
> fstests to run reliably so they can tell if their backports have broken
> anything; and developers, who want the randomness to try to poke into
> dusty corners of the filesystem.  Can we make it easier to associate
> random bits of data (reliability rates, etc.) with a given fstests
> configuration?  And create a test group^Wtag for the tests that rely on
> RNGs to shake things up?
This would be great!

> 
> 
> Thoughts? Flames?
> 
> --D
This thread had good timing :) I have been working on setting up 
some automated testing. Currently, 5.15.y is our priority so I have 
started working on this branch.

Patches are being selected by simply searching for the “Fixes” 
tag and applying if the commit-to-be-fixed is in the stable branch, 
but AUTOSEL would be nice, so I’ll start playing around with that. 
Amir, it would be nice to sync up the patch selection process. I can 
help share the load, especially for 5.15.

Selecting just the tagged “Fixes” for 5.15.y for patches through 
5.17.2, 15 patches were found and applied - if there are no 
complaints about the testing setup, I can go ahead and send out this 
batch:

c30a0cbd07ec xfs: use kmem_cache_free() for kmem_cache objects
5ca5916b6bc9 xfs: punch out data fork delalloc blocks on COW writeback failure
a1de97fe296c xfs: Fix the free logic of state in xfs_attr_node_hasname
1090427bf18f xfs: remove xfs_inew_wait
089558bc7ba7 xfs: remove all COW fork extents when remounting readonly
7993f1a431bc xfs: only run COW extent recovery when there are no live extents
09654ed8a18c xfs: check sb_meta_uuid for dabuf buffer recovery
f8d92a66e810 xfs: prevent UAF in xfs_log_item_in_current_chkpt
b97cca3ba909 xfs: only bother with sync_filesystem during readonly remount
eba0549bc7d1 xfs: don't generate selinux audit messages for capability testing
e014f37db1a2 xfs: use setattr_copy to set vfs inode attributes
70447e0ad978 xfs: async CIL flushes need pending pushes to be made stable
c8c568259772 xfs: don't include bnobt blocks when reserving free block pool
cd6f79d1fb32 xfs: run callbacks before waking waiters in xlog_state_shutdown_callbacks
919edbadebe1 xfs: drop async cache flushes from CIL commits.

Tests are being run through gce-xfstests with the 5.15 kernel config 
from xfstests-bld 
(https://github.com/tytso/xfstests-bld/blob/master/kernel-configs/x86_
64-config-5.15). The configs being tested are the following:

xfs defaults
quota
quota 1k
v4
pmem and fsdax
realtime
8k directory blocks
external log
realtime and external log devices
realtime with 28k extents, external log devices
overlayfs atop xfs
overlayfs atop ext4
ext4 defaults

The test set will be run for each batch of backports, running each 
test 3 times, and if no new failures are seen compared to the same 
branch without the backports, the batch of patches will be deemed 
good. No regressions were seen for the first set of patches listed 
above when applied to 5.15.33. If new failures are seen during 
testing, a bisect can be run to find the offending commits, remove 
these from the batch, and confirm there are no remaining new 
failures. A bug report can be sent to indicate which commits would 
cause new test failures. The test results can be posted publicly 
after each run. The easiest option would be to send the test results 
to a mailing list, such as a google groups mailing list, similar to 
what syzkaller does, or directly to linux-xfs if it isn’t too 
spammy.


- Leah



