Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7299C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 03:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiKCDdI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Nov 2022 23:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKCDdH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 23:33:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797A315FDD
        for <linux-xfs@vger.kernel.org>; Wed,  2 Nov 2022 20:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667446329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RoCJ4YpZUlayKjwSuLFeKOt+e0GWBKn2EWrKiuhsagY=;
        b=QBY/V/FNsAch/oz0vnFKa8uBb/DK4VtS3w8mboo3FUH0muilz73XZl2SxiBhtHyXZ2rAs8
        7VAypDrXhlNrEOrDlkdGzBgvQmrCfcnJIPpoEnWOsQxCLUENQSNFtyeNFPlvgqdzpfNa6P
        +P7Z15CUkk0KcEXOBniwkKdtjysDdwU=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-206-bTP7ICogNJWJauW9YDvjKA-1; Wed, 02 Nov 2022 23:32:08 -0400
X-MC-Unique: bTP7ICogNJWJauW9YDvjKA-1
Received: by mail-qk1-f198.google.com with SMTP id i11-20020a05620a404b00b006eeb0791c1aso927218qko.10
        for <linux-xfs@vger.kernel.org>; Wed, 02 Nov 2022 20:32:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RoCJ4YpZUlayKjwSuLFeKOt+e0GWBKn2EWrKiuhsagY=;
        b=2vmM7SwihT8KDa8wWNj8TPslVTKsD5fHBlJDjG4oSTEbtNPQw+QAzdQX8mjNpO+cwp
         sWkgrwovm9gbgNI24hKXsnz3rYa214AGyknVF6nxNZiSpyK5Dabfs5Inq+qA97Xb4q0B
         JYbhH9tRVD9FscA0zU/0PmtbagvVdcRXYzdKy60CWLufjUvvAx5z8sQKRwk77pvuAPIU
         kdk+vjiwSDg5haGw8N5QTDBPjGx10ToD00ubqlSOMA/2T18lqTaPMiWDJSd/f5hnnD4X
         VCPzWZkD3VMV+17laNvXKGEzRs/LVPD3y2cFsouBBdUrEgXAeJ1GFzRIhGQgUGUhNOhy
         WLyA==
X-Gm-Message-State: ACrzQf1h5paHz0GWnkjf3Af71KvdrXb6Xh2oRc3yH4V6ltvdx52+WzH4
        OoFRZm+NAVRDtaPCZYQvIXawm/SnmxL//o+yERff1DSvDivOxMLRuRwr1KvV0Vz0/L9l0nBNco5
        6d8ZiUTYZzAyN9XohN4kO
X-Received: by 2002:a05:6214:27ec:b0:4bb:9dd4:3d67 with SMTP id jt12-20020a05621427ec00b004bb9dd43d67mr24119372qvb.12.1667446327663;
        Wed, 02 Nov 2022 20:32:07 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4YLOBNzIFqvGvflArT7HV2DPn0WS2fMtQh0VP+JLT7hW4EatKDM/8MulxzBocZEpOqqvD0IA==
X-Received: by 2002:a05:6214:27ec:b0:4bb:9dd4:3d67 with SMTP id jt12-20020a05621427ec00b004bb9dd43d67mr24119355qvb.12.1667446327335;
        Wed, 02 Nov 2022 20:32:07 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q21-20020a05620a0d9500b006eec09eed39sm9919269qkl.40.2022.11.02.20.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 20:32:06 -0700 (PDT)
Date:   Thu, 3 Nov 2022 11:32:02 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] xfs: add parent pointer test
Message-ID: <20221103033202.t2hyrqdiyc7mzy37@zlang-mailbox>
References: <20221028215605.17973-1-catherine.hoang@oracle.com>
 <20221028215605.17973-3-catherine.hoang@oracle.com>
 <20221101062332.n2dzuzo2l762dxjx@zlang-mailbox>
 <64C0A63F-3440-4896-9E42-80DC1BB59809@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <64C0A63F-3440-4896-9E42-80DC1BB59809@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 02, 2022 at 11:11:30PM +0000, Catherine Hoang wrote:
> > On Oct 31, 2022, at 11:23 PM, Zorro Lang <zlang@redhat.com> wrote:
> > 
> > On Fri, Oct 28, 2022 at 02:56:03PM -0700, Catherine Hoang wrote:
> >> From: Allison Henderson <allison.henderson@oracle.com>
> >> 
> >> Add a test to verify basic parent pointers operations (create, move, link,
> >> unlink, rename, overwrite).
> >> 
> >> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> >> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> >> ---
> >> doc/group-names.txt |   1 +
> >> tests/xfs/554       | 101 ++++++++++++++++++++++++++++++++++++++++++++
> >> tests/xfs/554.out   |  59 ++++++++++++++++++++++++++
> >> 3 files changed, 161 insertions(+)
> >> create mode 100755 tests/xfs/554
> >> create mode 100644 tests/xfs/554.out
> >> 
> >> diff --git a/doc/group-names.txt b/doc/group-names.txt
> >> index ef411b5e..8e35c699 100644
> >> --- a/doc/group-names.txt
> >> +++ b/doc/group-names.txt
> >> @@ -77,6 +77,7 @@ nfs4_acl		NFSv4 access control lists
> >> nonsamefs		overlayfs layers on different filesystems
> >> online_repair		online repair functionality tests
> >> other			dumping ground, do not add more tests to this group
> >> +parent			Parent pointer tests
> >> pattern			specific IO pattern tests
> >> perms			access control and permission checking
> >> pipe			pipe functionality
> >> diff --git a/tests/xfs/554 b/tests/xfs/554
> > 
> > Hi,
> > 
> > xfs/554 has been taken, please rebase to the lastest for-next branch, or you
> > can a big enough number (e.g. 999) to avoid merging conflict, then I can rename
> > the name after merging.
> 
> Ah ok, I didn’t see that when I was sending out these tests. I’ll rebase this to the
> latest for-next branch
> > 
> >> new file mode 100755
> >> index 00000000..44b77f9d
> >> --- /dev/null
> >> +++ b/tests/xfs/554
> >> @@ -0,0 +1,101 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
> >> +#
> >> +# FS QA Test 554
> >> +#
> >> +# simple parent pointer test
> >> +#
> >> +
> >> +. ./common/preamble
> >> +_begin_fstest auto quick parent
> >> +
> >> +# get standard environment, filters and checks
> >> +. ./common/parent
> >> +
> >> +# Modify as appropriate
> >> +_supported_fs xfs
> >> +_require_scratch
> >> +_require_xfs_sysfs debug/larp
> > 
> > Is debug/larp needed by this case?
> 
> I believe the parent pointer code now turns on larp mode automatically,
> so it’s probably ok to remove this line since we aren’t explicitly turning
> it on in the tests anymore.

Sorry I'm confused about this explanation:) Do you need to read/write the
/sys/fs/xfs/debug/larp in this case? To make sure *parent* feature is 100%
truned on? Can't _require_xfs_parent make sure current system support the
parent feature ?

> > 
> >> +_require_xfs_parent
> >> +_require_xfs_io_command "parent"
> >> +
> >> +# real QA test starts here
> >> +
> >> +# Create a directory tree using a protofile and
> >> +# make sure all inodes created have parent pointers
> >> +
> >> +protofile=$tmp.proto
> >> +
> >> +cat >$protofile <<EOF
> >> +DUMMY1
> >> +0 0
> >> +: root directory
> >> +d--777 3 1
> >> +: a directory
> >> +testfolder1 d--755 3 1
> >> +file1 ---755 3 1 /dev/null
> >> +$
> >> +: back in the root
> >> +testfolder2 d--755 3 1
> >> +file2 ---755 3 1 /dev/null
> >> +: done
> >> +$
> >> +EOF
> >> +
> >> +_scratch_mkfs -f -n parent=1 -p $protofile >>$seqres.full 2>&1 \
> >> +	|| _fail "mkfs failed"
> >> +_check_scratch_fs
> >> +
> >> +_scratch_mount >>$seqres.full 2>&1 \
> >> +	|| _fail "mount failed"
> > 
> > _scratch_mount calls _fail() inside.
> 
> Ok, will remove this _fail call. Thanks!
> > 
> > Thanks,
> > Zorro
> > 
> >> +
> >> +testfolder1="testfolder1"
> >> +testfolder2="testfolder2"
> >> +file1="file1"
> >> +file2="file2"
> >> +file3="file3"
> >> +file1_ln="file1_link"
> >> +
> >> +echo ""
> >> +# Create parent pointer test
> >> +_verify_parent "$testfolder1" "$file1" "$testfolder1/$file1"
> >> +
> >> +echo ""
> >> +# Move parent pointer test
> >> +mv $SCRATCH_MNT/$testfolder1/$file1 $SCRATCH_MNT/$testfolder2/$file1
> >> +_verify_parent "$testfolder2" "$file1" "$testfolder2/$file1"
> >> +
> >> +echo ""
> >> +# Hard link parent pointer test
> >> +ln $SCRATCH_MNT/$testfolder2/$file1 $SCRATCH_MNT/$testfolder1/$file1_ln
> >> +_verify_parent "$testfolder1" "$file1_ln" "$testfolder1/$file1_ln"
> >> +_verify_parent "$testfolder1" "$file1_ln" "$testfolder2/$file1"
> >> +_verify_parent "$testfolder2" "$file1"    "$testfolder1/$file1_ln"
> >> +_verify_parent "$testfolder2" "$file1"    "$testfolder2/$file1"
> >> +
> >> +echo ""
> >> +# Remove hard link parent pointer test
> >> +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file1)"
> >> +rm $SCRATCH_MNT/$testfolder2/$file1
> >> +_verify_parent "$testfolder1" "$file1_ln" "$testfolder1/$file1_ln"
> >> +_verify_no_parent "$file1" "$ino" "$testfolder1/$file1_ln"
> >> +
> >> +echo ""
> >> +# Rename parent pointer test
> >> +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder1/$file1_ln)"
> >> +mv $SCRATCH_MNT/$testfolder1/$file1_ln $SCRATCH_MNT/$testfolder1/$file2
> >> +_verify_parent "$testfolder1" "$file2" "$testfolder1/$file2"
> >> +_verify_no_parent "$file1_ln" "$ino" "$testfolder1/$file2"
> >> +
> >> +echo ""
> >> +# Over write parent pointer test
> >> +touch $SCRATCH_MNT/$testfolder2/$file3
> >> +_verify_parent "$testfolder2" "$file3" "$testfolder2/$file3"
> >> +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file3)"
> >> +mv -f $SCRATCH_MNT/$testfolder2/$file3 $SCRATCH_MNT/$testfolder1/$file2
> >> +_verify_parent "$testfolder1" "$file2" "$testfolder1/$file2"
> >> +
> >> +# success, all done
> >> +status=0
> >> +exit
> >> diff --git a/tests/xfs/554.out b/tests/xfs/554.out
> >> new file mode 100644
> >> index 00000000..67ea9f2b
> >> --- /dev/null
> >> +++ b/tests/xfs/554.out
> >> @@ -0,0 +1,59 @@
> >> +QA output created by 554
> >> +
> >> +*** testfolder1 OK
> >> +*** testfolder1/file1 OK
> >> +*** testfolder1/file1 OK
> >> +*** Verified parent pointer: name:file1, namelen:5
> >> +*** Parent pointer OK for child testfolder1/file1
> >> +
> >> +*** testfolder2 OK
> >> +*** testfolder2/file1 OK
> >> +*** testfolder2/file1 OK
> >> +*** Verified parent pointer: name:file1, namelen:5
> >> +*** Parent pointer OK for child testfolder2/file1
> >> +
> >> +*** testfolder1 OK
> >> +*** testfolder1/file1_link OK
> >> +*** testfolder1/file1_link OK
> >> +*** Verified parent pointer: name:file1_link, namelen:10
> >> +*** Parent pointer OK for child testfolder1/file1_link
> >> +*** testfolder1 OK
> >> +*** testfolder2/file1 OK
> >> +*** testfolder1/file1_link OK
> >> +*** Verified parent pointer: name:file1_link, namelen:10
> >> +*** Parent pointer OK for child testfolder2/file1
> >> +*** testfolder2 OK
> >> +*** testfolder1/file1_link OK
> >> +*** testfolder2/file1 OK
> >> +*** Verified parent pointer: name:file1, namelen:5
> >> +*** Parent pointer OK for child testfolder1/file1_link
> >> +*** testfolder2 OK
> >> +*** testfolder2/file1 OK
> >> +*** testfolder2/file1 OK
> >> +*** Verified parent pointer: name:file1, namelen:5
> >> +*** Parent pointer OK for child testfolder2/file1
> >> +
> >> +*** testfolder1 OK
> >> +*** testfolder1/file1_link OK
> >> +*** testfolder1/file1_link OK
> >> +*** Verified parent pointer: name:file1_link, namelen:10
> >> +*** Parent pointer OK for child testfolder1/file1_link
> >> +*** testfolder1/file1_link OK
> >> +
> >> +*** testfolder1 OK
> >> +*** testfolder1/file2 OK
> >> +*** testfolder1/file2 OK
> >> +*** Verified parent pointer: name:file2, namelen:5
> >> +*** Parent pointer OK for child testfolder1/file2
> >> +*** testfolder1/file2 OK
> >> +
> >> +*** testfolder2 OK
> >> +*** testfolder2/file3 OK
> >> +*** testfolder2/file3 OK
> >> +*** Verified parent pointer: name:file3, namelen:5
> >> +*** Parent pointer OK for child testfolder2/file3
> >> +*** testfolder1 OK
> >> +*** testfolder1/file2 OK
> >> +*** testfolder1/file2 OK
> >> +*** Verified parent pointer: name:file2, namelen:5
> >> +*** Parent pointer OK for child testfolder1/file2
> >> -- 
> >> 2.25.1
> >> 
> > 
> 

