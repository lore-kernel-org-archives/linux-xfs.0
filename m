Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1E8D47F8D
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 05:04:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 91DABAC005
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 03:04:16 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id C0cvEkPjzvupnGiB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Jul 2013 03:04:15 -0700 (PDT)
Message-ID: <51D3F6CC.2040709@oracle.com>
Date: Wed, 03 Jul 2013 12:02:52 +0200
From: Koen De Wit <koen.de.wit@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfstests: btrfs/316: cross-subvolume sparse copy
References: <51D29D17.3050000@oracle.com> <20130702101539.GC14996@dastard>
	<51D2E33B.1080402@oracle.com>
	<6B93E4A6-D1C9-4170-8E1C-B94D24F601BB@redhat.com>
	<20130703063724.GK14996@dastard>
In-Reply-To: <20130703063724.GK14996@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <esandeen@redhat.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 07/03/2013 08:37 AM, Dave Chinner wrote:

> On Tue, Jul 02, 2013 at 11:51:21AM -0400, Eric Sandeen wrote:
>> On Jul 2, 2013, at 10:28 AM, Koen De Wit <koen.de.wit@oracle.com>
>> wrote:
>>
>>> Dave,
>>>
>>> Thanks for the review. I will clean up the commit message and do
>>> a full mail-to-myself-and-test-patch round trip to avoid errors
>>> like the wrong test numbers in the golden output. I'm sorry for
>>> this.
>>>
>>> About cutting out file names from the output. I did this in the
>>> first version of the patch:
>>>
>>>       md5sum $TESTDIR1/$F | $AWK_PROG 'END {print $1}'
>>>
>>> but Eric Sandeen suggested to include them in order to provide
>>> more context in the output. (See
>>> http://oss.sgi.com/archives/xfs/2013-03/msg00231.html and
>>> http://oss.sgi.com/archives/xfs/2013-03/msg00220.html) That
>>> sounds like a good idea to me, it makes debugging failures
>>> easier. Whose opinion should I follow?
>>>
>> Heh sorry.  IMHO maybe a middle ground; not bare md5sum but show
>> only the base name?  In the end up to you; it seems Dave and I
>> have different opinions on this.  :)
> 
> I was just going by current xfstests convention. i.e, in common/rc:
> 
> # Prints the md5 checksum of a given file
> _md5_checksum()
> {
>         md5sum $1 | cut -d ' ' -f1
> }
> 
> Which is used by all the hole punch tests and generic/311.


That's true, but these tests generate other context information in the
output. They don't just print a bunch of checksums.

For example, the output of generic/255 looks like:

        1. into a hole
   daa100df6e6711906b61c9ab5aa16032
        2. into allocated space
   0: [0..7]: extent
   1: [8..23]: hole
   2: [24..39]: extent
   cc58a7417c2d7763adc45b6fcd3fa024
        3. into unwritten space
   0: [0..7]: extent
   1: [8..23]: hole
   2: [24..39]: extent
   daa100df6e6711906b61c9ab5aa16032
   (...)

The output of generic/311 looks like:

   Running test 1 buffered, normal suspend
   Random seed is 1
   ee6103415276cde95544b11b2675f132
   ee6103415276cde95544b11b2675f132
   Running test 1 direct, normal suspend
   Random seed is 1
   ee6103415276cde95544b11b2675f132
   ee6103415276cde95544b11b2675f132
   (...)

> Make of that what you will, but I'd prefer to see consistency of
> implementation across tests... ;)


Do I agree if I change _checksum_files() to:

   _checksum_files() {
       for F in file1 file2 file3
       do
           echo "$F:"
           for D in $TESTDIR1 $SCRATCH_MNT $SUBVOL2
           do
               _md5_checksum $D/$F
           done
       done
   }

It produces this in the output:

   (...)
   file1:
   00d620f69f30327f0f8946b95c12de44
   e09c80c42fda55f9d992e59ca6b3307d
   e09c80c42fda55f9d992e59ca6b3307d
   file2:
   d7402b46310fbbfbc5e466b1dccb043b
   d7402b46310fbbfbc5e466b1dccb043b
   917619ae44b38bb9968af261c3c45440
   file3:
   5a95800e4c04b11117aa4e4de057721f
   b9f275cd638cb784c9e61def94c622a8
   5a95800e4c04b11117aa4e4de057721f
   (...)


Thanks,
Koen.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
