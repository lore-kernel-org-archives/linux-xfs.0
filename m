Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:34262 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbdIEPPs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 11:15:48 -0400
MIME-Version: 1.0
In-Reply-To: <20170905112234.GE8034@eguan.usersys.redhat.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
 <1504104706-11965-14-git-send-email-amir73il@gmail.com> <20170905112234.GE8034@eguan.usersys.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 5 Sep 2017 18:15:46 +0300
Message-ID: <CAOQ4uxiLViCVw+u5an1w0x7ik2OUFe1YMUZ=Lsd9poTNf612vA@mail.gmail.com>
Subject: Re: [PATCH v2 13/14] fstests: add support for working with
 dm-log-writes target
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Sep 5, 2017 at 2:22 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Wed, Aug 30, 2017 at 05:51:45PM +0300, Amir Goldstein wrote:
>> Cherry-picked the relevant common bits from commit 70d41e17164b
>> in Josef Bacik's fstests tree (https://github.com/josefbacik/fstests).
>> Quoting from Josef's commit message:
>>
>>   This patch adds the supporting code for using the dm-log-writes
>>   target.  The dmlogwrites code is similar to the dmflakey code, it just
>>   gives us functions to build and tear down a dm-log-writes target.  We
>>   add a new LOGWRITES_DEV variable to take in the device we will use as
>>   the log and add checks for that.
>>
>> [Amir:]
>> - Removed unneeded _test_falloc_support
>> - Moved _require_log_writes to dmlogwrites
>> - Document _require_log_writes
>>
>> Cc: Josef Bacik <jbacik@fb.com>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  README                       |  2 ++
>>  common/dmlogwrites           | 84 ++++++++++++++++++++++++++++++++++++++++++++
>>  doc/requirement-checking.txt | 20 +++++++++++
>>  3 files changed, 106 insertions(+)
>>  create mode 100644 common/dmlogwrites
>>
>> diff --git a/README b/README
>> index 9456fa7..4963d28 100644
>> --- a/README
>> +++ b/README
>> @@ -91,6 +91,8 @@ Preparing system for tests:
>>               - set TEST_XFS_SCRUB=1 to have _check_xfs_filesystem run
>>                 xfs_scrub -vd to scrub the filesystem metadata online before
>>                 unmounting to run the offline check.
>> +             - setenv LOGWRITES_DEV to a block device to use for power fail
>> +               testing.
>>
>>          - or add a case to the switch in common/config assigning
>>            these variables based on the hostname of your test
>> diff --git a/common/dmlogwrites b/common/dmlogwrites
>> new file mode 100644
>> index 0000000..a36724d
>> --- /dev/null
>> +++ b/common/dmlogwrites
>> @@ -0,0 +1,84 @@
>> +##/bin/bash
>> +#
>> +# Copyright (c) 2015 Facebook, Inc.  All Rights Reserved.
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#
>> +#
>> +# common functions for setting up and tearing down a dm log-writes device
>
> I think we need to _notrun if testing with dax mount option? Like all
> other dm target tests do.
>
>> +
>> +_require_log_writes()
>> +{
>> +     _require_dm_target log-writes
>> +     _require_test_program "log-writes/replay-log"
>
> As you mentioned before, need to check the existence of LOGWRITES_DEV
> first. And is the size of LOGWRITES_DEV required to be => SCRATCH_DEV?
> I guess so.

Not really. LOGWRITES_DEV just has to be large enough to log all the IOs
in the test. A test may be allocating large files via fallocate so may need
a large SCRATCH_DEV but those fallocs do not translate to large IOs.

>
>> +}
>> +
>> +_init_log_writes()
>
> Seems the function names are not unified in this file, some are in
> vert.-noun. format, some are in noun.-verb. format. Better to use the
> same format across the file, either all prefixed with "_log_writes"
> (except _require_log_writes) or suffixed with it.

Agreed.

>
>> +{
>> +     local BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
>> +     LOGWRITES_NAME=logwrites-test
>
> Not a big deal, but LOGWRITES_DEVNAME seems better to me.

Too confusing :)
we already have LOGWRITES_DMDEV and LOGWRITES_DEV.

>
>> +     LOGWRITES_DMDEV=/dev/mapper/$LOGWRITES_NAME
>> +     LOGWRITES_TABLE="0 $BLK_DEV_SIZE log-writes $SCRATCH_DEV $LOGWRITES_DEV"
>> +     $DMSETUP_PROG create $LOGWRITES_NAME --table "$LOGWRITES_TABLE" || \
>> +             _fatal "failed to create log-writes device"
>
> I think s/_fatal/_fail/g should be OK in this file.
>
>> +     $DMSETUP_PROG mknodes > /dev/null 2>&1
>> +}
>> +
>> +_log_writes_mark()
>> +{
>> +     [ $# -ne 1 ] && _fatal "_log_writes_mark takes one argument"
>> +     $DMSETUP_PROG message $LOGWRITES_NAME 0 mark $1
>> +}
>> +
>> +_log_writes_mkfs()
>> +{
>> +     _scratch_options mkfs
>> +     _mkfs_dev $SCRATCH_OPTIONS $LOGWRITES_DMDEV
>> +     _log_writes_mark mkfs
>> +}
>> +
>> +_mount_log_writes()
>> +{
>> +     mount -t $FSTYP $MOUNT_OPTIONS $* $LOGWRITES_DMDEV $SCRATCH_MNT
>
> $MOUNT_PROG, and I think we can follow _dmerror_mount() for this mount
> function.
>
>> +}
>> +
>> +_unmount_log_writes()
>> +{
>> +     $UMOUNT_PROG $SCRATCH_MNT
>> +}
>> +
>> +# _replay_log <mark>
>
> _replay_log looks like replaying filesystem log/journal, prefixed with
> _log_writes? So I guess we're going the "_log_writes_<verb>" way :)
>
>> +#
>> +# This replays the log contained on $INTEGRITY_DEV onto $SCRATCH_DEV upto the
>                                        ^^^^^^^^^^^^^^ LOGWRITES_DEV
>> +# mark passed in.
>> +_replay_log()
>> +{
>> +     _mark=$1
>> +
>> +     $here/src/log-writes/replay-log --log $LOGWRITES_DEV --replay $SCRATCH_DEV \
>> +             --end-mark $_mark > /dev/null 2>&1
>
> Dump output to $seqres.full for debug purpose?
>

Definitely. Good idea.

Amir.
