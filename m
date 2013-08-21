Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7913D7FB2
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 14:58:49 -0500 (CDT)
Message-ID: <52151BF8.8070506@sgi.com>
Date: Wed, 21 Aug 2013 14:58:48 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: add the lseek() SEEK_DATA/SEEK_HOLE support
References: <20130816205409.976658624@sgi.com> <5213F6AF.8070107@sandeen.net>
	<5214CB5C.4050608@sgi.com> <5214EAAC.80800@sandeen.net>
	<5214F050.7060402@sgi.com> <52150775.1050705@sandeen.net>
	<521512E3.7090301@sgi.com> <5215170F.3050703@sandeen.net>
In-Reply-To: <5215170F.3050703@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 08/21/13 14:37, Eric Sandeen wrote:
> On 8/21/13 2:20 PM, Mark Tinguely wrote:
>> On 08/21/13 13:31, Eric Sandeen wrote:
>
> ...
>
>>>> There are different versions of XFS seek_data and they will
>>>> detect/report the start of data and holes differently so output
>>>> parsing will be a bear. The existing C code sends the 2 different
>>>> value numbers that could be reported.
>>>
>>> are they ... both correct?  If one is a bug, it can just be a bug, right?
>>> I'm sorry I'm not up on the history.
>>
>> Lets say we have a file
>> hole    0-4K
>> data    4K-8K
>> hole    8-12K
>> data    12-16K
>>
>> for data/hole check starting at offset 0, valid response are
>> 0K or 4K for data
>> 0K or 16K or -1 for holes
>>
>> This feature and test was for Jeff fine-tuned seek_data/seek_hole support. The tests would be more specific to that feature and output is specific.
>
> Well, at least the man page says:
>
>> SEEK_DATA
>> Adjust the file offset to the next location in the file greater than
>> or equal to offset containing data. If offset points to data, then
>> the file offset is set to offset.
>
> So above, if we say "SEEK_DATA at offset 0" it seems like 0k is clearly wrong, and 4k is clearly right.

If the implementation can't really detect a hole, then everything is data.

>
>> SEEK_HOLE
>> Adjust the file offset to the next hole in the file greater than or
>> equal to offset. If offset points into the middle of a hole, then the
>> file offset is set to offset. If there is no hole past offset, then
>> the file offset is adjusted to the end of the file (i.e., there is an
>> implicit hole at the end of any file).
>
> and "SEEK_HOLE at offset 0" should pretty clearly return 0, and 16k would be wrong.

probably my bad notation - the data started at 12K ended at 16K-1. Some 
report the hole at the end of the file in bytes (16k), some cases as -1. 
Real fun stuff.

The current seek_data/seek_hole xfstest correct for this in the C code 
by say what values it will accept as being good.

>
> It's not POSIX yet, so I guess there's no gospel, but that's what the man page says.
>
> -Eric

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
