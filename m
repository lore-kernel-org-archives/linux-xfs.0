Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:36312 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751036AbdIELwj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 07:52:39 -0400
MIME-Version: 1.0
In-Reply-To: <20170905112842.GF8034@eguan.usersys.redhat.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
 <1504104706-11965-15-git-send-email-amir73il@gmail.com> <20170905112842.GF8034@eguan.usersys.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 5 Sep 2017 14:52:37 +0300
Message-ID: <CAOQ4uxiFrZvo-Vyb48RFx44cMEg6m0mHf28HXpXGmAyQSquvdQ@mail.gmail.com>
Subject: Re: [PATCH v2 14/14] fstests: add crash consistency fsx test using dm-log-writes
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Sep 5, 2017 at 2:28 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Wed, Aug 30, 2017 at 05:51:46PM +0300, Amir Goldstein wrote:
>> DO NOT MERGE!!! this test fails most likely due to test bug.
>>
>> The random seed values in this patch fail the test consistently on ext4
>> always with the same fsck error ((end of extent exceeds allowed value).
>> btrfs also fails, but with slightly different fsck errors each run.
>> xfs fails sometimes on file checksum error.
>>
>> Cherry-picked the test from commit 70d41e17164b
>> in Josef Bacik's fstests tree (https://github.com/josefbacik/fstests).
>> Quoting from Josef's commit message:
>>
>>   The test just runs some ops and exits, then finds all of the good buffers
>>   in the directory we provided and:
>>   - replays up to the mark given
>>   - mounts the file system and compares the md5sum
>>   - unmounts and fsck's to check for metadata integrity
>>
>>   dm-log-writes will pretend to do discard and the replay-log tool will
>>   replay it properly depending on the underlying device, either by writing
>>   0's or actually calling the discard ioctl, so I've enabled discard in the
>>   test for maximum fun.
>>
>> [Amir:]
>> - Removed unneeded _test_falloc_support dynamic FSX_OPTS
>> - Added place holders for using constant random seeds
>> - Add test to new 'replay' group
>
> Perhaps replace it with 'log' group?

Josef's version was in log group. I added replay also to define
a new group for crash consistency tests.
...
>> +
>> +NUM_FILES=4
>> +NUM_OPS=200
>> +FSX_OPTS="-N $NUM_OPS -d -P $SANITY_DIR -i $LOGWRITES_DMDEV"
>> +# Set random seeds for fsx runs (0 for timestamp + pid)
>> +seeds=(- 2885 2886 2887 2888)
>          ^^ meant 0?

The for loops below work on index 1..$NUM_FILES, so seeds[0] is not used
I can change to iterate 0..$((NUMFILES-1)) if that matter.
Anyway, next version is not going to have preset seed values.

>> +# Run fsx for a while
>> +for j in `seq 1 $NUM_FILES`
>> +do
>> +     run_check $here/ltp/fsx $FSX_OPTS -S ${seeds[$j]} -j $j $SCRATCH_MNT/testfile$j &
>> +done
>> +wait
>> +
>> +test_md5=()
>> +test_size=()
>> +for j in `seq 1 $NUM_FILES`
>> +do
>> +     test_md5[$j]=$(md5sum $SCRATCH_MNT/testfile$j | cut -f 1 -d ' ')
>> +     test_size[$j]=$(_ls_l -h $SCRATCH_MNT/testfile$j | awk '{ print $5 }')
>> +done
>> +
