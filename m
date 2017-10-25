Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:54700 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdJYMTX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2017 08:19:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjWp3khOix__jqfsiyjhNehGtkqXXv1o7EuGB1j3b2moQ@mail.gmail.com>
References: <20171020052943.15104-1-ross.zwisler@linux.intel.com>
 <20171020212556.30816-1-ross.zwisler@linux.intel.com> <CAOQ4uxjWp3khOix__jqfsiyjhNehGtkqXXv1o7EuGB1j3b2moQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 25 Oct 2017 15:19:22 +0300
Message-ID: <CAOQ4uxh25JmAv3DjCp11fAfpHVP=d2sp+=Gk4SxYfBtmOgaUPw@mail.gmail.com>
Subject: Re: [fstests PATCH v2] generic: add test for DAX MAP_SYNC support
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com, linux-nvdimm@lists.01.org, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Sun, Oct 22, 2017 at 9:56 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Sat, Oct 21, 2017 at 12:25 AM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
>> Add a test that exercises DAX's new MAP_SYNC flag.
>>
>> This test creates a file and writes to it via an mmap(), but never syncs
>> via fsync/msync.  This process is tracked via dm-log-writes, then replayed.
>>
>> If MAP_SYNC is working the dm-log-writes replay will show the test file
>> with 1MiB of on-media block allocations.  This is because each allocating
>> page fault included an implicit metadata sync.  If MAP_SYNC isn't working
>> (which you can test by fiddling with the parameters to mmap()) the file
>> will be smaller or missing entirely.
>>
>> Note that dm-log-writes doesn't track the data that we write via the
>> mmap(), so we can't do any data integrity checking.  We can only verify
>> that the metadata writes for the page faults happened.
>>
>> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>>
>> ---
>>
>> Changes since v1:
>>  - Addressed review feedback from Amir.  Thank you for the review!
>
> Looks good.
>
>>
>> ---
>>  .gitignore            |  1 +
>>  common/dmlogwrites    |  1 -
>>  src/Makefile          |  3 +-
>>  src/t_map_sync.c      | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/generic/466     | 76 ++++++++++++++++++++++++++++++++++++++++++
>>  tests/generic/466.out |  3 ++
>>  tests/generic/group   |  1 +
>>  7 files changed, 175 insertions(+), 2 deletions(-)
>>  create mode 100644 src/t_map_sync.c
>>  create mode 100755 tests/generic/466
>>  create mode 100644 tests/generic/466.out
>>
>> diff --git a/.gitignore b/.gitignore
>> index 2014c08..9fc0695 100644
>> --- a/.gitignore
>> +++ b/.gitignore
>> @@ -119,6 +119,7 @@
>>  /src/t_getcwd
>>  /src/t_holes
>>  /src/t_immutable
>> +/src/t_map_sync
>>  /src/t_mmap_cow_race
>>  /src/t_mmap_dio
>>  /src/t_mmap_fallocate
>> diff --git a/common/dmlogwrites b/common/dmlogwrites
>> index 247c744..5b57df9 100644
>> --- a/common/dmlogwrites
>> +++ b/common/dmlogwrites
>> @@ -23,7 +23,6 @@ _require_log_writes()
>>         [ -z "$LOGWRITES_DEV" -o ! -b "$LOGWRITES_DEV" ] && \
>>                 _notrun "This test requires a valid \$LOGWRITES_DEV"
>>
>> -       _exclude_scratch_mount_option dax

Wait. It this really ok to relax no dax from _require_log_writes()?
Shouldn't you check log-write target version or something to verify
that log-writes+dax is really supported?
I think you should.


>>         _require_dm_target log-writes
>>         _require_test_program "log-writes/replay-log"
>>  }
