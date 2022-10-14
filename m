Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586B6C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 01:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJNBYq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 21:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiJNBYp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 21:24:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D76219B
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 18:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665710683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vagzotfo2211TyowG/v91idIfQddn6OCRkazSePc4+g=;
        b=SoAabbOI9KpyPm8JrWEBrMVUEaAsHdoc5C3ZzZ/4SbPOo6QLAa3dF0YQsMMr4HcZp0bJM4
        xutGebf6grx4HUU1NgxTnQwPbQkowQUNPUbHkEAPf3MC/9/DLr/A4nrN6ssvggFmXHmijw
        ndmumJ0Q/6WddwPkWF76qsstOj7oSVs=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-594-BZh33vzXPpyHAOmSROtUUQ-1; Thu, 13 Oct 2022 21:24:41 -0400
X-MC-Unique: BZh33vzXPpyHAOmSROtUUQ-1
Received: by mail-pj1-f71.google.com with SMTP id y9-20020a17090a390900b0020d478b0b68so1875456pjb.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 18:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vagzotfo2211TyowG/v91idIfQddn6OCRkazSePc4+g=;
        b=CYQz3V0rsdWEeQBO5hd9IhupeiDd5x8FwRe5OreJyuZ4VtqxQgwTIn/OgO56D1TsMZ
         ihy+bWcyKGZZ9w8u/LUq4o+44akbxHf2Ua38yrwelWP2Pytcva3D2XNcFNvAKTjSpQCN
         S89bT718vvPu8lvSqI9zmju5CDWuAz7P4bWz/mnN5ypyU+JDVlfC8QY/UbpfOQ8JFXrz
         YppVO6tjrVveoAhST0OviSzm1XdP8GRqqM7xzWr2o/1JyD7ovC6HaVauLS3vR9wyCUEC
         In6cc5HKLUIz53WI8gufjKVbcWuGRQs9VDQvP+v41+c62SVNGwcgXFggN5tmqzfPFVF2
         cICw==
X-Gm-Message-State: ACrzQf2tB6zQGOPdBo72nmhyr5yl8osvJZGnlkFpnPir+Ic2T+mM+Jjd
        uh8lORg1uJDPX6sHqjN4o1hDOZSTEnRbszUKtz4lcpmkufGtxM/jOU+uA5mm9UrS+s9IuVer+aQ
        5AqHPKPhTPvV1QhhTWtcc
X-Received: by 2002:aa7:9614:0:b0:562:b07b:ad62 with SMTP id q20-20020aa79614000000b00562b07bad62mr2588876pfg.79.1665710680529;
        Thu, 13 Oct 2022 18:24:40 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7HQEaTQRW578xpkQ7qIWtlSFydO32ASWqGe1q+zngXPubTCXLmMUIKKPkdps6a1mMDtxTCpg==
X-Received: by 2002:aa7:9614:0:b0:562:b07b:ad62 with SMTP id q20-20020aa79614000000b00562b07bad62mr2588863pfg.79.1665710680229;
        Thu, 13 Oct 2022 18:24:40 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r26-20020aa7989a000000b00565d35cd658sm306201pfl.217.2022.10.13.18.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 18:24:39 -0700 (PDT)
Date:   Fri, 14 Oct 2022 09:24:35 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] xfs: add parent pointer test
Message-ID: <20221014012435.tjtfd2nwic5k64tj@zlang-mailbox>
References: <20221012013812.82161-1-catherine.hoang@oracle.com>
 <20221012013812.82161-3-catherine.hoang@oracle.com>
 <20221012030220.ng5xra7deoeutb77@zlang-mailbox>
 <20221012031053.ied3kipypzdlwv4w@zlang-mailbox>
 <5a9cbf00f1545b7578f4e099e83b5fe89360f4d7.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5a9cbf00f1545b7578f4e099e83b5fe89360f4d7.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 13, 2022 at 07:55:42PM +0000, Allison Henderson wrote:
> On Wed, 2022-10-12 at 11:10 +0800, Zorro Lang wrote:
> > On Wed, Oct 12, 2022 at 11:02:20AM +0800, Zorro Lang wrote:
> > > On Tue, Oct 11, 2022 at 06:38:10PM -0700, Catherine Hoang wrote:
> > > > From: Allison Henderson <allison.henderson@oracle.com>
> > > > 
> > > > Add a test to verify basic parent pointers operations (create,
> > > > move, link,
> > > > unlink, rename, overwrite).
> > > > 
> > > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > > > ---
> > > >  doc/group-names.txt |   1 +
> > > >  tests/xfs/554       | 125
> > > > ++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/xfs/554.out   |  59 +++++++++++++++++++++
> > > >  3 files changed, 185 insertions(+)
> > > >  create mode 100755 tests/xfs/554
> > > >  create mode 100644 tests/xfs/554.out
> > > > 
> > > > diff --git a/doc/group-names.txt b/doc/group-names.txt
> > > > index ef411b5e..8e35c699 100644
> > > > --- a/doc/group-names.txt
> > > > +++ b/doc/group-names.txt
> > > > @@ -77,6 +77,7 @@ nfs4_acl              NFSv4 access control
> > > > lists
> > > >  nonsamefs              overlayfs layers on different filesystems
> > > >  online_repair          online repair functionality tests
> > > >  other                  dumping ground, do not add more tests to
> > > > this group
> > > > +parent                 Parent pointer tests
> > > >  pattern                        specific IO pattern tests
> > > >  perms                  access control and permission checking
> > > >  pipe                   pipe functionality
> > > > diff --git a/tests/xfs/554 b/tests/xfs/554
> > > > new file mode 100755
> > > > index 00000000..26914e4c
> > > > --- /dev/null
> > > > +++ b/tests/xfs/554
> > > > @@ -0,0 +1,125 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights
> > > > Reserved.
> > > > +#
> > > > +# FS QA Test 554
> > > > +#
> > > > +# simple parent pointer test
> > > > +#
> > > > +
> > > > +. ./common/preamble
> > > > +_begin_fstest auto quick parent
> > > > +
> > > > +cleanup()
> > > > +{
> > > > +       cd /
> > > > +       rm -f $tmp.*
> > > > +}
> > > 
> > > This's same with common cleanup function, you can remove this
> > > function.
> > 
> > Same for patch 3 and 4.
> > 
> > > 
> > > > +
> > > > +full()
> > > > +{
> > > > +    echo ""            >>$seqres.full
> > > > +    echo "*** $* ***"  >>$seqres.full
> > > > +    echo ""            >>$seqres.full
> > > > +}
> > > 
> > > What's this function for? I didn't see this function is called in
> > > this case.
> > > Am I missing something?
> > 
> > Same question for patch 3 and 4.
> Think I answered these in the other patch review...
> 
> > 
> > > 
> > > > +
> > > > +# get standard environment, filters and checks
> > > > +. ./common/filter
> > > > +. ./common/reflink
> > > > +. ./common/inject
> > > > +. ./common/parent
> > > > +
> > > > +# Modify as appropriate
> > > > +_supported_fs xfs
> > > > +_require_scratch
> > > > +_require_xfs_sysfs debug/larp
> > > > +_require_xfs_io_error_injection "larp"
> > 
> > And does this case really do error injection? I didn't find that. If
> > not, please
> > remove this requirement and above common/inject. 
> I think at one point I had all these tests in one file and then later
> separated them into multiple tests.  So I think the requirements for
> injects can be removed from patch 2 and 3

Sure, yes, same for patch 3 not 4. I said wrong below:)

> 
> > Same question for patch 4.
> Patch 4 does do injects, so the requirement should stay.
> 
> Allison
> 
> > 
> > Thanks,
> > Zorro
> > 
> > > > +_require_xfs_parent
> > > > +_require_xfs_io_command "parent"
> > > > +
> > > > +# real QA test starts here
> > > > +
> > > > +# Create a directory tree using a protofile and
> > > > +# make sure all inodes created have parent pointers
> > > > +
> > > > +protofile=$tmp.proto
> > > > +
> > > > +cat >$protofile <<EOF
> > > > +DUMMY1
> > > > +0 0
> > > > +: root directory
> > > > +d--777 3 1
> > > > +: a directory
> > > > +testfolder1 d--755 3 1
> > > > +file1 ---755 3 1 /dev/null
> > > > +$
> > > > +: back in the root
> > > > +testfolder2 d--755 3 1
> > > > +file2 ---755 3 1 /dev/null
> > > > +: done
> > > > +$
> > > > +EOF
> > > > +
> > > > +if [ $? -ne 0 ]
> > > > +then
> > > > +    _fail "failed to create test protofile"
> > > > +fi
> > > 
> > > It just writes a general file, right? Is there any special reason
> > > might cause
> > > write fail?
> > > 
> > > I think we don't need to check each step's return value. And if we
> > > fail to write
> > > a file, bash helps to output error message to break golden image
> > > too.
> > > 
> > > Thanks,
> > > Zorro
> > > 
> > > > +
> > > > +_scratch_mkfs -f -n parent=1 -p $protofile >>$seqres.full 2>&1 \
> > > > +       || _fail "mkfs failed"
> > > > +_check_scratch_fs
> > > > +
> > > > +_scratch_mount >>$seqres.full 2>&1 \
> > > > +       || _fail "mount failed"
> > > > +
> > > > +testfolder1="testfolder1"
> > > > +testfolder2="testfolder2"
> > > > +file1="file1"
> > > > +file2="file2"
> > > > +file3="file3"
> > > > +file4="file4"
> > > > +file5="file5"
> > > > +file1_ln="file1_link"
> > > > +
> > > > +echo ""
> > > > +# Create parent pointer test
> > > > +_verify_parent "$testfolder1" "$file1" "$testfolder1/$file1"
> > > > +
> > > > +echo ""
> > > > +# Move parent pointer test
> > > > +mv $SCRATCH_MNT/$testfolder1/$file1
> > > > $SCRATCH_MNT/$testfolder2/$file1
> > > > +_verify_parent "$testfolder2" "$file1" "$testfolder2/$file1"
> > > > +
> > > > +echo ""
> > > > +# Hard link parent pointer test
> > > > +ln $SCRATCH_MNT/$testfolder2/$file1
> > > > $SCRATCH_MNT/$testfolder1/$file1_ln
> > > > +_verify_parent "$testfolder1" "$file1_ln"
> > > > "$testfolder1/$file1_ln"
> > > > +_verify_parent "$testfolder1" "$file1_ln" "$testfolder2/$file1"
> > > > +_verify_parent "$testfolder2" "$file1"   
> > > > "$testfolder1/$file1_ln"
> > > > +_verify_parent "$testfolder2" "$file1"    "$testfolder2/$file1"
> > > > +
> > > > +echo ""
> > > > +# Remove hard link parent pointer test
> > > > +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file1)"
> > > > +rm $SCRATCH_MNT/$testfolder2/$file1
> > > > +_verify_parent "$testfolder1" "$file1_ln"
> > > > "$testfolder1/$file1_ln"
> > > > +_verify_no_parent "$file1" "$ino" "$testfolder1/$file1_ln"
> > > > +
> > > > +echo ""
> > > > +# Rename parent pointer test
> > > > +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder1/$file1_ln)"
> > > > +mv $SCRATCH_MNT/$testfolder1/$file1_ln
> > > > $SCRATCH_MNT/$testfolder1/$file2
> > > > +_verify_parent "$testfolder1" "$file2" "$testfolder1/$file2"
> > > > +_verify_no_parent "$file1_ln" "$ino" "$testfolder1/$file2"
> > > > +
> > > > +echo ""
> > > > +# Over write parent pointer test
> > > > +touch $SCRATCH_MNT/$testfolder2/$file3
> > > > +_verify_parent "$testfolder2" "$file3" "$testfolder2/$file3"
> > > > +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file3)"
> > > > +mv -f $SCRATCH_MNT/$testfolder2/$file3
> > > > $SCRATCH_MNT/$testfolder1/$file2
> > > > +_verify_parent "$testfolder1" "$file2" "$testfolder1/$file2"
> > > > +
> > > > +# success, all done
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/xfs/554.out b/tests/xfs/554.out
> > > > new file mode 100644
> > > > index 00000000..67ea9f2b
> > > > --- /dev/null
> > > > +++ b/tests/xfs/554.out
> > > > @@ -0,0 +1,59 @@
> > > > +QA output created by 554
> > > > +
> > > > +*** testfolder1 OK
> > > > +*** testfolder1/file1 OK
> > > > +*** testfolder1/file1 OK
> > > > +*** Verified parent pointer: name:file1, namelen:5
> > > > +*** Parent pointer OK for child testfolder1/file1
> > > > +
> > > > +*** testfolder2 OK
> > > > +*** testfolder2/file1 OK
> > > > +*** testfolder2/file1 OK
> > > > +*** Verified parent pointer: name:file1, namelen:5
> > > > +*** Parent pointer OK for child testfolder2/file1
> > > > +
> > > > +*** testfolder1 OK
> > > > +*** testfolder1/file1_link OK
> > > > +*** testfolder1/file1_link OK
> > > > +*** Verified parent pointer: name:file1_link, namelen:10
> > > > +*** Parent pointer OK for child testfolder1/file1_link
> > > > +*** testfolder1 OK
> > > > +*** testfolder2/file1 OK
> > > > +*** testfolder1/file1_link OK
> > > > +*** Verified parent pointer: name:file1_link, namelen:10
> > > > +*** Parent pointer OK for child testfolder2/file1
> > > > +*** testfolder2 OK
> > > > +*** testfolder1/file1_link OK
> > > > +*** testfolder2/file1 OK
> > > > +*** Verified parent pointer: name:file1, namelen:5
> > > > +*** Parent pointer OK for child testfolder1/file1_link
> > > > +*** testfolder2 OK
> > > > +*** testfolder2/file1 OK
> > > > +*** testfolder2/file1 OK
> > > > +*** Verified parent pointer: name:file1, namelen:5
> > > > +*** Parent pointer OK for child testfolder2/file1
> > > > +
> > > > +*** testfolder1 OK
> > > > +*** testfolder1/file1_link OK
> > > > +*** testfolder1/file1_link OK
> > > > +*** Verified parent pointer: name:file1_link, namelen:10
> > > > +*** Parent pointer OK for child testfolder1/file1_link
> > > > +*** testfolder1/file1_link OK
> > > > +
> > > > +*** testfolder1 OK
> > > > +*** testfolder1/file2 OK
> > > > +*** testfolder1/file2 OK
> > > > +*** Verified parent pointer: name:file2, namelen:5
> > > > +*** Parent pointer OK for child testfolder1/file2
> > > > +*** testfolder1/file2 OK
> > > > +
> > > > +*** testfolder2 OK
> > > > +*** testfolder2/file3 OK
> > > > +*** testfolder2/file3 OK
> > > > +*** Verified parent pointer: name:file3, namelen:5
> > > > +*** Parent pointer OK for child testfolder2/file3
> > > > +*** testfolder1 OK
> > > > +*** testfolder1/file2 OK
> > > > +*** testfolder1/file2 OK
> > > > +*** Verified parent pointer: name:file2, namelen:5
> > > > +*** Parent pointer OK for child testfolder1/file2
> > > > -- 
> > > > 2.25.1
> > > > 
> > 
> 

