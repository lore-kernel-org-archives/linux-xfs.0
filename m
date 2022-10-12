Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E156C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Oct 2022 03:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiJLDLG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 23:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiJLDLD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2022 23:11:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C613FEDA
        for <linux-xfs@vger.kernel.org>; Tue, 11 Oct 2022 20:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665544261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ft5ybHEXjDNUczSsyMupXtbyKnhaOU7h6c3dCBq36+g=;
        b=fBhjGT7uQY5Wvc9oz1+LkGxjqUuR5kYIkK75SGquyIvukVtrtAyrQ940wYD4zDHOdymdeV
        w3bkIW7IiyLV1zJQPORBsCneFhVpT+cuhcKfMBu1Sn2WIVDMQwvz9/Pn3DZmmLNySFNQD1
        D6A5cdrvdYxaXdeud0IMWe8hZdt8Oho=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-388-DiZVZJ1fNZWz_m9UFIoqhw-1; Tue, 11 Oct 2022 23:10:59 -0400
X-MC-Unique: DiZVZJ1fNZWz_m9UFIoqhw-1
Received: by mail-qk1-f199.google.com with SMTP id u6-20020a05620a430600b006e47fa02576so13347401qko.22
        for <linux-xfs@vger.kernel.org>; Tue, 11 Oct 2022 20:10:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ft5ybHEXjDNUczSsyMupXtbyKnhaOU7h6c3dCBq36+g=;
        b=REaLmImbWPvrkBA5co2U12+HXD1lQeZ3ndIpI0PY1b3WxshYFVDEM3QLfzimT/Bi9W
         mAML5hopegUrayglU32VZ/vNQa2IdZ+8z6nA9QAQdtkNFibQU3mirVkSVVKR24XTa9mz
         KTgniRQ82TSLShx2Z1N5LuLbx6qJEap7U358Kfjx7N3OSQzaw79N4UYI1KoaxtTwvg4o
         qQOCfDOBLAd9aGUW/L+iyfwl+hTcAtpSDf2oaItdwj1Q0rmqgmIJhIg3KSJqubPxLk0h
         k863G0nH3qL0J4F33Rs2kJ7188mUPuJJNKKI8IXAZ1GaYbQeJtHRGNFXVvw8+UvFmGW1
         wNqA==
X-Gm-Message-State: ACrzQf0mGRcx8XozTuPppj3VEqlrBgikJYKPAPvXnbuN2q8yoe3tTPGr
        wUcBZSDM8xmGk2M1aYKVtOkBNZ04zm0Il96/nBJFbnkZlfFG/RGoupXDkIDdvLrEaCPMjXQJ8up
        9fBPANVgFzW7fcKoG3CwI
X-Received: by 2002:ac8:7d0f:0:b0:398:3029:3328 with SMTP id g15-20020ac87d0f000000b0039830293328mr15554883qtb.99.1665544258886;
        Tue, 11 Oct 2022 20:10:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7V13cqDuwk1BP/HzRJF3DbLqXlZuvXZGBf2gUJ3oISpP4CpUxas04xYwImm8UyYupi9wW6hg==
X-Received: by 2002:ac8:7d0f:0:b0:398:3029:3328 with SMTP id g15-20020ac87d0f000000b0039830293328mr15554874qtb.99.1665544258612;
        Tue, 11 Oct 2022 20:10:58 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ff13-20020a05622a4d8d00b0035d420c4ba7sm11985676qtb.54.2022.10.11.20.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 20:10:58 -0700 (PDT)
Date:   Wed, 12 Oct 2022 11:10:53 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2 2/4] xfs: add parent pointer test
Message-ID: <20221012031053.ied3kipypzdlwv4w@zlang-mailbox>
References: <20221012013812.82161-1-catherine.hoang@oracle.com>
 <20221012013812.82161-3-catherine.hoang@oracle.com>
 <20221012030220.ng5xra7deoeutb77@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012030220.ng5xra7deoeutb77@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 12, 2022 at 11:02:20AM +0800, Zorro Lang wrote:
> On Tue, Oct 11, 2022 at 06:38:10PM -0700, Catherine Hoang wrote:
> > From: Allison Henderson <allison.henderson@oracle.com>
> > 
> > Add a test to verify basic parent pointers operations (create, move, link,
> > unlink, rename, overwrite).
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > ---
> >  doc/group-names.txt |   1 +
> >  tests/xfs/554       | 125 ++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/554.out   |  59 +++++++++++++++++++++
> >  3 files changed, 185 insertions(+)
> >  create mode 100755 tests/xfs/554
> >  create mode 100644 tests/xfs/554.out
> > 
> > diff --git a/doc/group-names.txt b/doc/group-names.txt
> > index ef411b5e..8e35c699 100644
> > --- a/doc/group-names.txt
> > +++ b/doc/group-names.txt
> > @@ -77,6 +77,7 @@ nfs4_acl		NFSv4 access control lists
> >  nonsamefs		overlayfs layers on different filesystems
> >  online_repair		online repair functionality tests
> >  other			dumping ground, do not add more tests to this group
> > +parent			Parent pointer tests
> >  pattern			specific IO pattern tests
> >  perms			access control and permission checking
> >  pipe			pipe functionality
> > diff --git a/tests/xfs/554 b/tests/xfs/554
> > new file mode 100755
> > index 00000000..26914e4c
> > --- /dev/null
> > +++ b/tests/xfs/554
> > @@ -0,0 +1,125 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# FS QA Test 554
> > +#
> > +# simple parent pointer test
> > +#
> > +
> > +. ./common/preamble
> > +_begin_fstest auto quick parent
> > +
> > +cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> 
> This's same with common cleanup function, you can remove this function.

Same for patch 3 and 4.

> 
> > +
> > +full()
> > +{
> > +    echo ""            >>$seqres.full
> > +    echo "*** $* ***"  >>$seqres.full
> > +    echo ""            >>$seqres.full
> > +}
> 
> What's this function for? I didn't see this function is called in this case.
> Am I missing something?

Same question for patch 3 and 4.

> 
> > +
> > +# get standard environment, filters and checks
> > +. ./common/filter
> > +. ./common/reflink
> > +. ./common/inject
> > +. ./common/parent
> > +
> > +# Modify as appropriate
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_sysfs debug/larp
> > +_require_xfs_io_error_injection "larp"

And does this case really do error injection? I didn't find that. If not, please
remove this requirement and above common/inject. Same question for patch 4.

Thanks,
Zorro

> > +_require_xfs_parent
> > +_require_xfs_io_command "parent"
> > +
> > +# real QA test starts here
> > +
> > +# Create a directory tree using a protofile and
> > +# make sure all inodes created have parent pointers
> > +
> > +protofile=$tmp.proto
> > +
> > +cat >$protofile <<EOF
> > +DUMMY1
> > +0 0
> > +: root directory
> > +d--777 3 1
> > +: a directory
> > +testfolder1 d--755 3 1
> > +file1 ---755 3 1 /dev/null
> > +$
> > +: back in the root
> > +testfolder2 d--755 3 1
> > +file2 ---755 3 1 /dev/null
> > +: done
> > +$
> > +EOF
> > +
> > +if [ $? -ne 0 ]
> > +then
> > +    _fail "failed to create test protofile"
> > +fi
> 
> It just writes a general file, right? Is there any special reason might cause
> write fail?
> 
> I think we don't need to check each step's return value. And if we fail to write
> a file, bash helps to output error message to break golden image too.
> 
> Thanks,
> Zorro
> 
> > +
> > +_scratch_mkfs -f -n parent=1 -p $protofile >>$seqres.full 2>&1 \
> > +	|| _fail "mkfs failed"
> > +_check_scratch_fs
> > +
> > +_scratch_mount >>$seqres.full 2>&1 \
> > +	|| _fail "mount failed"
> > +
> > +testfolder1="testfolder1"
> > +testfolder2="testfolder2"
> > +file1="file1"
> > +file2="file2"
> > +file3="file3"
> > +file4="file4"
> > +file5="file5"
> > +file1_ln="file1_link"
> > +
> > +echo ""
> > +# Create parent pointer test
> > +_verify_parent "$testfolder1" "$file1" "$testfolder1/$file1"
> > +
> > +echo ""
> > +# Move parent pointer test
> > +mv $SCRATCH_MNT/$testfolder1/$file1 $SCRATCH_MNT/$testfolder2/$file1
> > +_verify_parent "$testfolder2" "$file1" "$testfolder2/$file1"
> > +
> > +echo ""
> > +# Hard link parent pointer test
> > +ln $SCRATCH_MNT/$testfolder2/$file1 $SCRATCH_MNT/$testfolder1/$file1_ln
> > +_verify_parent "$testfolder1" "$file1_ln" "$testfolder1/$file1_ln"
> > +_verify_parent "$testfolder1" "$file1_ln" "$testfolder2/$file1"
> > +_verify_parent "$testfolder2" "$file1"    "$testfolder1/$file1_ln"
> > +_verify_parent "$testfolder2" "$file1"    "$testfolder2/$file1"
> > +
> > +echo ""
> > +# Remove hard link parent pointer test
> > +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file1)"
> > +rm $SCRATCH_MNT/$testfolder2/$file1
> > +_verify_parent "$testfolder1" "$file1_ln" "$testfolder1/$file1_ln"
> > +_verify_no_parent "$file1" "$ino" "$testfolder1/$file1_ln"
> > +
> > +echo ""
> > +# Rename parent pointer test
> > +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder1/$file1_ln)"
> > +mv $SCRATCH_MNT/$testfolder1/$file1_ln $SCRATCH_MNT/$testfolder1/$file2
> > +_verify_parent "$testfolder1" "$file2" "$testfolder1/$file2"
> > +_verify_no_parent "$file1_ln" "$ino" "$testfolder1/$file2"
> > +
> > +echo ""
> > +# Over write parent pointer test
> > +touch $SCRATCH_MNT/$testfolder2/$file3
> > +_verify_parent "$testfolder2" "$file3" "$testfolder2/$file3"
> > +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file3)"
> > +mv -f $SCRATCH_MNT/$testfolder2/$file3 $SCRATCH_MNT/$testfolder1/$file2
> > +_verify_parent "$testfolder1" "$file2" "$testfolder1/$file2"
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/554.out b/tests/xfs/554.out
> > new file mode 100644
> > index 00000000..67ea9f2b
> > --- /dev/null
> > +++ b/tests/xfs/554.out
> > @@ -0,0 +1,59 @@
> > +QA output created by 554
> > +
> > +*** testfolder1 OK
> > +*** testfolder1/file1 OK
> > +*** testfolder1/file1 OK
> > +*** Verified parent pointer: name:file1, namelen:5
> > +*** Parent pointer OK for child testfolder1/file1
> > +
> > +*** testfolder2 OK
> > +*** testfolder2/file1 OK
> > +*** testfolder2/file1 OK
> > +*** Verified parent pointer: name:file1, namelen:5
> > +*** Parent pointer OK for child testfolder2/file1
> > +
> > +*** testfolder1 OK
> > +*** testfolder1/file1_link OK
> > +*** testfolder1/file1_link OK
> > +*** Verified parent pointer: name:file1_link, namelen:10
> > +*** Parent pointer OK for child testfolder1/file1_link
> > +*** testfolder1 OK
> > +*** testfolder2/file1 OK
> > +*** testfolder1/file1_link OK
> > +*** Verified parent pointer: name:file1_link, namelen:10
> > +*** Parent pointer OK for child testfolder2/file1
> > +*** testfolder2 OK
> > +*** testfolder1/file1_link OK
> > +*** testfolder2/file1 OK
> > +*** Verified parent pointer: name:file1, namelen:5
> > +*** Parent pointer OK for child testfolder1/file1_link
> > +*** testfolder2 OK
> > +*** testfolder2/file1 OK
> > +*** testfolder2/file1 OK
> > +*** Verified parent pointer: name:file1, namelen:5
> > +*** Parent pointer OK for child testfolder2/file1
> > +
> > +*** testfolder1 OK
> > +*** testfolder1/file1_link OK
> > +*** testfolder1/file1_link OK
> > +*** Verified parent pointer: name:file1_link, namelen:10
> > +*** Parent pointer OK for child testfolder1/file1_link
> > +*** testfolder1/file1_link OK
> > +
> > +*** testfolder1 OK
> > +*** testfolder1/file2 OK
> > +*** testfolder1/file2 OK
> > +*** Verified parent pointer: name:file2, namelen:5
> > +*** Parent pointer OK for child testfolder1/file2
> > +*** testfolder1/file2 OK
> > +
> > +*** testfolder2 OK
> > +*** testfolder2/file3 OK
> > +*** testfolder2/file3 OK
> > +*** Verified parent pointer: name:file3, namelen:5
> > +*** Parent pointer OK for child testfolder2/file3
> > +*** testfolder1 OK
> > +*** testfolder1/file2 OK
> > +*** testfolder1/file2 OK
> > +*** Verified parent pointer: name:file2, namelen:5
> > +*** Parent pointer OK for child testfolder1/file2
> > -- 
> > 2.25.1
> > 

