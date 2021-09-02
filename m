Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB9F8C4320A
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 04:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80E90610D0
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 04:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbhIBEvB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 00:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhIBEvA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Sep 2021 00:51:00 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE83FC061575;
        Wed,  1 Sep 2021 21:50:02 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id m11so873318ioo.6;
        Wed, 01 Sep 2021 21:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cNIoMdZYiagy9AIi4B4/ChydBGoTBfUwV+IH70dcMKw=;
        b=YkI4TnMIw9CrokfoR9UYZel9RG5aZUlUn5c9sOwAsqWefJU9tswncZQiwzQ1f8FK7n
         fKdc94ShrgI3Fl2gplWQegsVn16cm2lwH3Ua5L00M3NTc/0R7SikR9gM0wzJl1M/gSh/
         jx7rgUVsXqD2SW7fAiOOfKaKQREsgTACgN9yjAhJmVjaIp67cNp/VVXywNR78QKL2SwJ
         bLqvsZ02vUrdMacEGhIIQ+fPZwanWYHyrUvMhCZjLKMDNTEDMbLKWdw2sIZpjf7ctx0c
         PpMDlmusZgDLMmCsGuXfdv/WJ2tuky+tW4TVCJQtdgOnNQg1plX/4IZp0xi8uxhpjtvX
         bkjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cNIoMdZYiagy9AIi4B4/ChydBGoTBfUwV+IH70dcMKw=;
        b=dTHtpLbPP4O44KtvEP+/cUna8FNcWDxTnJRn0B4AX7kJ57L6VYacN0EBcZrEeJ4SN1
         ik1a8wQu4edyKSAJTqF55uT5NR4ZeNF4GgjmkJsKNHUrpdBadbLWRlr1oskY+/8cQUXH
         9jtxiieZpm2vDMd+Pjvq5o5zPM185fJujl2ECZti13/vo/wHIGnf5G91IsTry+EgEt7p
         B14pActHA523AsUP+4ixVw1Y8odBhpWXptIzo0jfYR1qJPyRD9WvyFt99V6rQhf/k26W
         qGqlBn0bOjXDksEEZ7z69ZyUuncz6/UQZpStWmfsflwc/dM5Ik/3jwjt3TGLjRzF+lmz
         tnDQ==
X-Gm-Message-State: AOAM532MVxjRzw0a4mewqDVlQqu08RmzUyAvw7BEod6U2xgqhZF0fS+7
        /fdfxKEoFujCBCfsmpH9n56IQxEBk+LYZr//EZvtdSJ9o/k=
X-Google-Smtp-Source: ABdhPJyrju3xaeoxyJTkLwqt1a3th4oNhUyH8dSaIHhVc81BwGbuURPThJeS+W8FIRvhjXhyJ4VEpaoFAwGOyqmmEO8=
X-Received: by 2002:a6b:e712:: with SMTP id b18mr1211926ioh.186.1630558202328;
 Wed, 01 Sep 2021 21:50:02 -0700 (PDT)
MIME-Version: 1.0
References: <163045514980.771564.6282165259140399788.stgit@magnolia>
 <163045517173.771564.1524162806861567173.stgit@magnolia> <CAOQ4uxi7205Ae+un1w4C4Dzh9-SykL=ogHQSBH=nnVGDkPfkhw@mail.gmail.com>
 <20210901164311.GB9911@magnolia>
In-Reply-To: <20210901164311.GB9911@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 2 Sep 2021 07:49:51 +0300
Message-ID: <CAOQ4uxgJz6OBmV=SD1fp9tkCAfiAhxjdCr+fxGd4ko4Y6NUscA@mail.gmail.com>
Subject: Re: [PATCH 4/5] tools: make sure that test groups are described in
 the documentation
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 1, 2021 at 7:43 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Wed, Sep 01, 2021 at 07:46:01AM +0300, Amir Goldstein wrote:
> > On Wed, Sep 1, 2021 at 3:37 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > From: Darrick J. Wong <djwong@kernel.org>
> > >
> > > Create a file to document the purpose of each test group that is
> > > currently defined in fstests, and add a build script to check that every
> > > group mentioned in the tests is also mentioned in the documentation.
> > >
> >
> > This is awesome and long due.
> > Thanks for doing that!
> >
> > Minor nits about overlayfs groups below...
>
> Heh, yeah, thanks for making corrections. :)
>
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  doc/group-names.txt    |  136 ++++++++++++++++++++++++++++++++++++++++++++++++
> > >  include/buildgrouplist |    1
> > >  tools/check-groups     |   33 ++++++++++++
> > >  3 files changed, 170 insertions(+)
> > >  create mode 100644 doc/group-names.txt
> > >  create mode 100755 tools/check-groups
> > >
> > >
> > > diff --git a/doc/group-names.txt b/doc/group-names.txt
> > > new file mode 100644
> > > index 00000000..ae517328
> > > --- /dev/null
> > > +++ b/doc/group-names.txt
> > > @@ -0,0 +1,136 @@
> > > +======================= =======================================================
> > > +Group Name:            Description:
> > > +======================= =======================================================
> > > +all                    All known tests, automatically generated by ./check at
> > > +                       runtime
> > > +auto                   Tests that should be run automatically.  These should
> > > +                       not require more than ~5 minutes to run.
> > > +quick                  Tests that should run in under 30 seconds.
> > > +deprecated             Old tests that should not be run.
> > > +
> > > +acl                    Access Control Lists
> > > +admin                  xfs_admin functionality
> > > +aio                    general libaio async io tests
> > > +atime                  file access time
> > > +attr                   extended attributes
> > > +attr2                  xfs v2 extended aributes
> > > +balance                        btrfs tree rebalance
> > > +bigtime                        timestamps beyond the year 2038
> > > +blockdev               block device functionality
> > > +broken                 broken tests
> > > +cap                    Linux capabilities
> > > +casefold               directory name casefolding
> > > +ci                     ASCII case-insensitive directory name lookups
> > > +clone                  FICLONE/FICLONERANGE ioctls
> > > +clone_stress           stress testing FICLONE/FICLONERANGE
> > > +collapse               fallocate collapse_range
> > > +compress               file compression
> > > +convert                        btrfs ext[34] conversion tool
> > > +copy                   xfs_copy functionality
> > > +copy_range             copy_file_range syscall
> > > +copyup                 overlayfs copyup support
> >
> > The tests in this group exercise copy up.
> > There is no such thing as overlayfs without "copyup support",
> > so guess my point is - remove the word "support"
>
> OK.
>
> > > +dangerous              dangerous test that can crash the system
> > > +dangerous_bothrepair   fuzzers to evaluate xfs_scrub + xfs_repair repair
> > > +dangerous_fuzzers      fuzzers that can crash your computer
> > > +dangerous_norepair     fuzzers to evaluate kernel metadata verifiers
> > > +dangerous_online_repair        fuzzers to evaluate xfs_scrub online repair
> > > +dangerous_repair       fuzzers to evaluate xfs_repair offline repair
> > > +dangerous_scrub                fuzzers to evaluate xfs_scrub checking
> > > +data                   data loss checkers
> > > +dax                    direct access mode for persistent memory files
> > > +db                     xfs_db functional tests
> > > +dedupe                 FIEDEDUPERANGE ioctl
> > > +defrag                 filesystem defragmenters
> > > +dir                    directory test functions
> > > +dump                   dump and restore utilities
> > > +eio                    IO error reporting
> > > +encrypt                        encrypted file contents
> > > +enospc                 ENOSPC error reporting
> > > +exportfs               file handles
> > > +filestreams            XFS filestreams allocator
> > > +freeze                 filesystem freeze tests
> > > +fsck                   general fsck tests
> > > +fsmap                  FS_IOC_GETFSMAP ioctl
> > > +fsr                    XFS free space reorganizer
> > > +fuzzers                        filesystem fuzz tests
> > > +growfs                 increasing the size of a filesystem
> > > +hardlink               hardlinks
> > > +health                 XFS health reporting
> > > +idmapped               idmapped mount functionality
> > > +inobtcount             XFS inode btree count tests
> > > +insert                 fallocate insert_range
> > > +ioctl                  general ioctl tests
> > > +io_uring               general io_uring async io tests
> > > +label                  filesystem labelling
> > > +limit                  resource limits
> > > +locks                  file locking
> > > +log                    metadata logging
> > > +logprint               xfs_logprint functional tests
> > > +long_rw                        long-soak read write IO path exercisers
> > > +metacopy               overlayfs metadata-only copy-up
> > > +metadata               filesystem metadata update exercisers
> > > +metadump               xfs_metadump/xfs_mdrestore functionality
> > > +mkfs                   filesystem formatting tools
> > > +mount                  mount option and functionality checks
> > > +nested                 nested overlayfs instances
> > > +nfs4_acl               NFSv4 access control lists
> > > +nonsamefs              overlayfs layers on different filesystems
> > > +online_repair          online repair functionality tests
> > > +other                  dumping ground, do not add more tests to this group
> > > +overlay                        using overlayfs on top of FSTYP
> >
> > This description is a bit confusing, because the recommended
> > way to run overlayfs tests as described in README.overlay is
> > to set FSTYP=xfs and run ./check -overlay
> >
> > I'm struggling for a better description but perhaps:
> > "using overlayfs regardless of ./check -overlay flag"?
>
> Hmm.  Since I'm the author of the only test that uses this tag, I guess
> I'm the authority (ha!) on what the name actually means.
>
> That test (generic/631) is a regression test for a XFS whiteout handling
> bug that can only be reproduced by layering overlayfs atop xfs.
> Overlayfs is incidental to reproducing the XFS bug, but AFAIK overlayfs
> is the only in-kernel user of whiteout, which is why it's critical here.
>
> It's not right to make it "_supported_fs overlay" because we're not
> testing overlayfs functionality; we're merely using it as a stick to
> poke another filesystem.

Yes. I know.
Note that while this is the only case of _require_extra_fs overaly
there is another case of _require_extra_fs ext2 (xfs/049)

>
> How about: "regression tests that require the use of overlayfs in a
> targetted configuration" ?
>

TBH, I do not think it is wise to tag the test by the test method
rather than the tested functionality.

What is more likely?
that a tester wants to run all tests that use overlay over FSTYP?
Or that a tester wants to run all tests to verify whiteout related
behavior after changing whiteout related code?

I suggest that you re-tag this test as 'whiteout', which is documented
already.

If you want to be more specific, you can create a group
rename_whiteout, because RENAME_WHITEOUT is the vfs
interface that this test is actually exercising.

Thanks,
Amir.
