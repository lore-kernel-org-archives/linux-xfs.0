Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:41217 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935323AbeFRRpu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jun 2018 13:45:50 -0400
Received: by mail-lf0-f68.google.com with SMTP id d24-v6so25965023lfa.8
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jun 2018 10:45:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180615212140.GE9432@magnolia>
References: <20180615211448.7341-1-mbenatto@redhat.com> <20180615212140.GE9432@magnolia>
From: Marco Benatto <mbenatto@redhat.com>
Date: Mon, 18 Jun 2018 14:45:47 -0300
Message-ID: <CAOGQQ2_DZC809Zffv=nfKTp1cS=o8ADn80-=tcazKQqX-EHA8w@mail.gmail.com>
Subject: Re: [PATCH] xfstests: Teste root inode parent pointer repairing
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Jun 15, 2018 at 6:21 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Fri, Jun 15, 2018 at 06:14:48PM -0300, Marco Benatto wrote:
>> Recently we found out xfs_repair were not repairing
>> root inode parent pointer when root inode is on short-form
>> and parent points to an invalid inode number (refer to:
>> "xfs_repair: Fix root inode's parent when it's bogus for sf
>> directory" on xfs-devel list).
>>
>> This test checks if xfs_repair successfully repair the
>> filesystem in the scenario mentioned before.
>>
>> Signed-off-by: Marco Benatto <mbenatto@redhat.com>
>> ---
>>  tests/xfs/450     | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/450.out |  1 +
>>  tests/xfs/group   |  1 +
>>  3 files changed, 67 insertions(+)
>>  create mode 100755 tests/xfs/450
>>  create mode 100644 tests/xfs/450.out
>>
>> diff --git a/tests/xfs/450 b/tests/xfs/450
>> new file mode 100755
>> index 0000000..7e33431
>> --- /dev/null
>> +++ b/tests/xfs/450
>> @@ -0,0 +1,65 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
>> +#
>> +# FS QA Test 450
>> +#
>> +# Make sure xfs_repair can repair root inode parent's pointer
>> +# when it contains a bogus ino when it's using shot form directory
>> +#
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +
>> +status=1     # failure is the default!
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
>> +_supported_fs xfs
>> +_supported_os Linux
>> +_require_scratch
>> +
>> +
>> +_scratch_mkfs >> /dev/null 2>&1
>> +
>> +# Check on-disk format version
>> +ver=$($XFS_DB_PROG -c 'sb 0' -c 'addr rootino' -c 'p core.version' $SCRATCH_DEV |
>> +             awk '{print$3}')
>> +
>> +case $ver in
>> +     2)
>> +             prefix="u.sfdir2"
>> +             ;;
>> +     3)
>> +             prefix="u3.sfdir3"
>> +             ;;
>> +     *)
>> +             _notrun "can't modify this disk format"
>> +             ;;
>> +esac
>
> Please hoist get_sfdir_prefix out of xfs/278...
>
>> +
>> +_scratch_xfs_db -x -c 'sb 0' \
>> +                                     -c 'addr rootino' \
>> +                                     -c "write ${prefix}.hdr.parent.i4 0" >> /$seqres.full 2>&1 \
>> +                             || _fail "xfs_db command failed"
>
> _scratch_xfs_set_metadata_field
>
>> +
>> +_scratch_xfs_repair >> $seqres.full 2>&1
>> +
>> +_scratch_xfs_repair -n >> $seqres.full 2>&1
>> +
>> +if [ $? -eq 1 ]
>> +then
>> +     _fail "xfs_repair failed to repair filesystem"
>> +else
>
> No need for the 'else'; _fail will exit the test.
>
> --D
>

Thanks for this review. I just sent out new patches covering this points
