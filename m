Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E60217F90
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 14:37:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1E3C30407E
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 12:37:53 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id CdbwEIX1AnBIY8ML for <xfs@oss.sgi.com>;
	Wed, 21 Aug 2013 12:37:52 -0700 (PDT)
Message-ID: <5215170F.3050703@sandeen.net>
Date: Wed, 21 Aug 2013 14:37:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: add the lseek() SEEK_DATA/SEEK_HOLE support
References: <20130816205409.976658624@sgi.com> <5213F6AF.8070107@sandeen.net>
	<5214CB5C.4050608@sgi.com> <5214EAAC.80800@sandeen.net>
	<5214F050.7060402@sgi.com> <52150775.1050705@sandeen.net>
	<521512E3.7090301@sgi.com>
In-Reply-To: <521512E3.7090301@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 8/21/13 2:20 PM, Mark Tinguely wrote:
> On 08/21/13 13:31, Eric Sandeen wrote:

...

>>> There are different versions of XFS seek_data and they will
>>> detect/report the start of data and holes differently so output
>>> parsing will be a bear. The existing C code sends the 2 different
>>> value numbers that could be reported.
>>
>> are they ... both correct?  If one is a bug, it can just be a bug, right?
>> I'm sorry I'm not up on the history.
> 
> Lets say we have a file
> hole    0-4K
> data    4K-8K
> hole    8-12K
> data    12-16K
> 
> for data/hole check starting at offset 0, valid response are
> 0K or 4K for data
> 0K or 16K or -1 for holes
> 
> This feature and test was for Jeff fine-tuned seek_data/seek_hole support. The tests would be more specific to that feature and output is specific.

Well, at least the man page says:

> SEEK_DATA
> Adjust the file offset to the next location in the file greater than
> or equal to offset containing data. If offset points to data, then
> the file offset is set to offset.

So above, if we say "SEEK_DATA at offset 0" it seems like 0k is clearly wrong, and 4k is clearly right.
 
> SEEK_HOLE
> Adjust the file offset to the next hole in the file greater than or
> equal to offset. If offset points into the middle of a hole, then the
> file offset is set to offset. If there is no hole past offset, then
> the file offset is adjusted to the end of the file (i.e., there is an
> implicit hole at the end of any file).

and "SEEK_HOLE at offset 0" should pretty clearly return 0, and 16k would be wrong.

It's not POSIX yet, so I guess there's no gospel, but that's what the man page says.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
