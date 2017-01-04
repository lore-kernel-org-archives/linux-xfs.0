Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35273 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935051AbdADKgb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 05:36:31 -0500
MIME-Version: 1.0
In-Reply-To: <20170103203602.GA14034@birch.djwong.org>
References: <1482689376-23553-1-git-send-email-amir73il@gmail.com>
 <1482689376-23553-2-git-send-email-amir73il@gmail.com> <20170103203602.GA14034@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 4 Jan 2017 12:36:24 +0200
Message-ID: <CAOQ4uxhWj2aS95E2OXG0+9n8DRy7Uz2KEJ9cpX6gXQHWO7DvWg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] xfs/348: test handling of invalid inode modes
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <eguan@redhat.com>, Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, fstests <fstests@vger.kernel.org>, linux-xfs@vger.kernel.org

On Tue, Jan 3, 2017 at 10:36 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Sun, Dec 25, 2016 at 08:09:34PM +0200, Amir Goldstein wrote:
>> Set all possible file type values for different types of files
>> and verify that xfs_repair detects the correct errors.
>>
>> When setting invalid file type values (e.g. core.mode = 0170644),
>> all files are expected to have been junked by xfs_repair.
>>
>> When setting valid file type values to non matching file types,
>> xfs_repair would either detect wrong format and junk the file, e.g.:
>>   would have junked entry "FILE" in directory PARENT_INO
>> or detect a ftype mismatch error, e.g.:
>>   would fix ftype mismatch (5/3) in directory/child PARENT_INO/FIFO_INO
>>
>> If ftype feature is enabled, when setting file type to one of the
>> special types (i.e. FIFO(1), CHRDEV(2),BLKDEV(6),SOCKET(14)),
>> xfs_repair is expected to detect ftype mismatch error. Otherewise,
>
> "Otherwise"
>

thanks

> I would also like to see a second test that scrambles the ftype field in
> the directory entry (instead of changing the inode core.mode) but xfs_db
> can't write to dir3 blocks because it doesn't know how to set the dir
> block CRC.
>
> I'm going to send a patch to add that as part of my xfsprogs 4.11
> patchbomb (hopefully next week, but after the xfsprogs 4.9 release) so
> that test can wait.
>

Sure, I'll beef up the test when that code arrives.

>> +     # If ftype feature is enabled, when setting file type to one of the
>> +     # special types (i.e. FIFO(1), CHRDEV(2),BLKDEV(6),SOCKET(14)),
>> +     # xfs_repair is expected to detect ftype mismatch error. Otherewise,
>> +     # xfs_repair is not expected to detect ftype mismatch error.
>> +     if [ "$FTYPE_FEATURE" = 1 ] && (echo ':1:2:6:14:' | grep -q ":$dt:"); then
>> +             _scratch_xfs_repair -n 2>&1 | grep -q "^would fix ftype mismatch" || \
>> +                     _fail "xfs_repair should fix ftype mismatch"
>> +     else
>> +             _scratch_xfs_repair -n 2>&1 | grep -q -v "^would fix ftype mismatch" || \
>> +                     _fail "xfs_repair should not fix ftype mismatch"
>
> Just FYI the whole test will stop as soon as we hit a _fail.  Please
> consider simply echoing a complaint to stdout so that the golden output
> diff will catch this, and we can see all the failing cases.
>

Will do.

Can you please reply to v2 patch series.
It contain 2 more patches beyond this one with additional testing of access
to mounted fs with the malformed inodes.

My question is what to do WRT patch 3/3 which triggers an XFS Assert in the
kernel (readdir of a phony directory that is really a regular file or symlink).
http://www.spinics.net/lists/linux-xfs/msg03059.html

Is this something of concern to you? Can you instruct me whether the assertion
should be fixed or propose a fix yourself?
Or is it just a non issue and we should not add patch 3/3 to this test.

Amir.
