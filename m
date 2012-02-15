Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1FC74cX174241 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 06:07:04 -0600
Received: from smtprelay05.ispgateway.de (smtprelay05.ispgateway.de
	[80.67.31.99]) by cuda.sgi.com with ESMTP id ZmlhH4HAFGAzSj83
	for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 04:07:02 -0800 (PST)
Received: from [62.43.225.238] (helo=[192.168.30.191])
	by smtprelay05.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1RxddV-0003Hl-Ki
	for xfs@oss.sgi.com; Wed, 15 Feb 2012 13:07:01 +0100
Message-ID: <4F3B9FE5.9070407@cape-horn-eng.com>
Date: Wed, 15 Feb 2012 13:07:01 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
References: <4F394116.8080200@cape-horn-eng.com>
	<20120214000924.GF14132@dastard> <4F3A5440.409@cape-horn-eng.com>
	<20120215012753.GJ14132@dastard>
In-Reply-To: <20120215012753.GJ14132@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi Dave, hi list,

On 02/15/2012 02:27 AM, Dave Chinner wrote:
> On Tue, Feb 14, 2012 at 01:32:00PM +0100, Richard Ems wrote:
>> On 02/14/2012 01:09 AM, Dave Chinner wrote:
>>>> I am asking because I am seeing very long times while removing big
>>>> directory trees. I thought on kernels above 3.0 removing dirs and files
>>>> had improved a lot, but I don't see that improvement.
>>>
>>> You won't if the directory traversal is seek bound and that is the
>>> limiting factor for performance.
>>
>> *Seek bound*? *When* is the directory traversal *seek bound*?
> =

> Whenever you are traversing a directory structure that is not alrady
> hot in the cache. IOWS, almost always.

Ok, got that.

> =

>>>> This is a backup system running dirvish, so most files in the dirs I am
>>>> removing are hard links. Almost all of the files do have ACLs set.
>>>
>>> The unlink will have an extra IO to read per inode - the out-of-line
>>> attribute block, so you've just added 11 million IOs to the 800,000
>>> the traversal already takes to the unlink overhead. So it's going to
>>> take roughly ten hours because the unlink is gong to be read IO seek
>>> bound....
>>
>> It took 110 minutes and not 10 hours. All files and dirs there had ACLs =
set.
> =

> I was basing that on you "find dir" time of 100 minutes, which was
> the only number you gave, and making the assumption it didn't read
> the attribute blocks and that it was seeing worse case seek times
> (i.e. avg seek times) for every IO.
> =

> Given the way locality works in XFS, I'd suggest that the typical
> seek time will be much less (a few blocks, not half the disk
> platter) and not necessarily on the same disk (due to RAID) so the
> average seek time for your workload is likely to be much lower. If
> it's at 1ms (closer to track-to-track seek times) instead of the
> 5ms, then that 10hrs becomes 2hrs for that many IOs....

Many thanks for the clarification !!!


>>> Also, for large directories like this (millions of entries) you
>>> should also consider using a larger directory block size (mkfs -n
>>> size=3Dxxxx option) as that can be scaled independently to the
>>> filesystem block size. This will significantly decrease the amount
>>> of IO and fragmentation large directories cause. Peak modification
>>> performance of small directories will be reduced because larger
>>> block size directories consume more CPU to process, but for large
>>> directories performance will be significantly better as they will
>>> spend much less time waiting for IO.
>>
>> This was not ONE directory with that many files, but a directory
>> containing 834591 subdirectories (deeply nested, not all in the same
>> dir!) and 10539154 files.
> =

> So you've got a directory *tree* that indexes 11 million inodes, not
> "one directory with 11 million files and dirs in it" as you
> originally described.  Both Christoph and I have interpreted your
> original description as "one large directory", but there's no need
> to shout at us because it's difficult to understand any given
> configuration from just a few lines of text.  IOWs, details like "one
> directory" vs "one directory tree" might seem insignificant to you,
> but they mean an awful lot us developers and can easily lead us down
> the wrong path.

Sorry, I didn't mean to shout at anyone, sorry for that. I just wanted
to clarify my original description, since I noticed I did it wrong. Now
I know I should have used ** and not uppercase.
As you suggested, I should have written *directory tree* and not only
*directory*, sorry, my fault.
But I didn't mean to shout at anyone, I am very happy for the fast and
extense responses from both you and Christoph! Thanks again!


> =

> FWIW, directory tree traversal is even more read IO latency
> sensitive than a single large directory traversal because we can't
> do readahead across directory boundaries to hide seek latencies as
> much as possible and the locality on individual directories can be
> very different depending on the allocaiton policy the filesystem is
> using. As it is, large directory blocks can also reduce the amount
> of IO needed in this sort of situation and speed up traversals....
> =

> Cheers,
> =

> Dave.


Many thanks!
Richard

-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
