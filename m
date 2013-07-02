Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 238B67F58
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 10:51:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1285D8F8089
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 08:51:26 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id q7jtGTfzFEzGHfx8 for
	<xfs@oss.sgi.com>; Tue, 02 Jul 2013 08:51:25 -0700 (PDT)
Subject: Re: [PATCH v3] xfstests: btrfs/316: cross-subvolume sparse copy
References: <51D29D17.3050000@oracle.com> <20130702101539.GC14996@dastard>
	<51D2E33B.1080402@oracle.com>
From: Eric Sandeen <esandeen@redhat.com>
MIME-Version: 1.0
In-Reply-To: <51D2E33B.1080402@oracle.com>
Message-Id: <6B93E4A6-D1C9-4170-8E1C-B94D24F601BB@redhat.com>
Date: Tue, 2 Jul 2013 11:51:21 -0400 (EDT)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Koen De Wit <koen.de.wit@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Jul 2, 2013, at 10:28 AM, Koen De Wit <koen.de.wit@oracle.com> wrote:

> Dave,
> 
> Thanks for the review. I will clean up the commit message and do a full mail-to-myself-and-test-patch round trip to avoid errors like the wrong test numbers in the golden output. I'm sorry for this.
> 
> About cutting out file names from the output. I did this in the first version of the patch:
> 
>       md5sum $TESTDIR1/$F | $AWK_PROG 'END {print $1}'
> 
> but Eric Sandeen suggested to include them in order to provide more context in the output. (See http://oss.sgi.com/archives/xfs/2013-03/msg00231.html and http://oss.sgi.com/archives/xfs/2013-03/msg00220.html) That sounds like a good idea to me, it makes debugging failures easier. Whose opinion should I follow?
> 
Heh sorry.  IMHO maybe a middle ground; not bare md5sum but show only the base name?  In the end up to you; it seems Dave and I have different opinions on this.  :)

Eric

> Koen.
> 
> 
> On 07/02/2013 12:15 PM, Dave Chinner wrote:
> 
>> On Tue, Jul 02, 2013 at 11:27:51AM +0200, Koen De Wit wrote:
>>> This testscript creates reflinks to files on different subvolumes, overwrites the original files and reflinks, and moves reflinked files between subvolumes.
>>> 
>>> Originally submitted as testcase 302, changes are made based on comments from Eric: http://oss.sgi.com/archives/xfs/2013-03/msg00231.html
>>> Two new common/rc functions used in this script (_require_cp_reflink and _verify_reflink) have been submitted recently: http://oss.sgi.com/archives/xfs/2013-05/msg00745.html
>>> Thanks to Eric Sandeen and Dave Chinner for the reviews.
>>> 
>>> Version 3: fixing wrapped patch.
>> 
>> Needs a proper commit message - wrap it at 72 columns,  change log
>> should be placed below the --- devider, not be part of hte commit
>> message.
>> 
>> Test numbers do not need to be unique across all test directories,
>> just unique within the tests/btrfs directory.
>> 
>>> +
>>> +_checksum_files() {
>>> +    for F in file1 file2 file3
>>> +    do
>>> +        for D in $TESTDIR1 $SCRATCH_MNT $SUBVOL2
>>> +        do
>>> +            md5sum $D/$F | _filter_test_dir | _filter_scratch
>> 
>> Just cut the file name out. No need for filtering at that point...
>> 
>>> +        done
>>> +    done
>>> +}
>>> +
>>> +TESTDIR1=$TEST_DIR/test-$seq-1
>>> +TESTDIR2=$TEST_DIR/test-$seq-2
>>> +SUBVOL1=$TEST_DIR/subvol-$seq-1
>>> +SUBVOL2=$TEST_DIR/subvol-$seq-2
>> 
>> ....-316-.....
>> 
>>> +Verify the file contents:
>>> +e09c80c42fda55f9d992e59ca6b3307d  TEST_DIR/test-302-1/file1
>> 
>> which means the golden output is broken, despite the filtering
>> 
>> You should test your patches before posting ;)
>> 
>> FWIW, this is why you should simply cut the filename completely out
>> like we do elsewhere....
>> 
>> Cheers,
>> 
>> Dave.
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
