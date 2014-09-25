Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E76607F78
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 19:50:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 656E1AC004
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 17:50:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id m0GbEEXuYcQfboHY for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 17:50:23 -0700 (PDT)
Message-ID: <542366CF.3040905@sandeen.net>
Date: Wed, 24 Sep 2014 19:50:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Corrupted file system
References: <5839367.DyqsVHbRuQ@myrada> <705802842.F0QjhfVGQR@myrada>
	<54233051.4070709@sandeen.net> <2047180.98c6Ryq0NE@myrada>
In-Reply-To: <2047180.98c6Ryq0NE@myrada>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Diane Trout <diane@caltech.edu>
Cc: xfs-oss <xfs@oss.sgi.com>

On 9/24/14 7:25 PM, Diane Trout wrote:
> Huh.
> =

> I'd managed to make a metadump using the 3.1.7 version of the tools. Then=
 I =

> tried to run xfs_repair on the partition, and now xfs_metadump is segfaul=
ting =

> on the partition.
> =

> Would the older metadata dump be useful?

sure.  Compress it & send me a private note with it attached (or with a loc=
ation
if it's too big to email)

-Eric

> I'd need to rebuild xfsprogs before the stack trace would be useful... de=
bian =

> likes to strip the symbols and they didn't make a -dbg package.
> =

> Diane
> =

> On Wednesday, September 24, 2014 15:57:53 Eric Sandeen wrote:
>> If you want to make a metadata image, compress it, and send it my way I'=
d be
>> glad to look at it - I've been doing some repair work lately.
>>
>> -Eric
>>
>> On 9/24/14 3:38 PM, Diane Trout wrote:
>>> On Wednesday, September 24, 2014 12:08:40 Emmanuel Florac wrote:
>>>> Le Tue, 23 Sep 2014 15:02:57 -0700
>>>>
>>>> Diane Trout <diane@caltech.edu> =E9crivait:
>>>>> I had a raid failure at work that ended up corrupting an xfs
>>>>> filesystem the tail of the xfs_repair command looks like the below. I
>>>>> was able to generate a metadata dump but is there a point to making
>>>>> it available?
>>>>>
>>>>> It does crash repeatedly at the same place
>>>>
>>>> Did you try the very latest xfs_repair?
>>>
>>> I grabbed the one out of debian unstable (3.2.1), verified that it was
>>> your
>>> latest release and used that. I didn't try building the version in git.
>>>
>>> It did get much further than version 3.1.7+b1 (debian stable)
>>>
>>> Diane
>>>
>>> Phase 6 - check inode connectivity...
>>>
>>>         - resetting contents of realtime bitmap and summary inodes
>>>         - traversing filesystem ...
>>>
>>> entry "lymphoblastoid" in dir ino 256 doesn't have a .. entry, will set=
 it
>>> in ino 2051.
>>> bad hash table for directory inode 256 (no data entry): rebuilding
>>> rebuilding directory inode 256
>>> 7f70c79c8700: Badness in key lookup (length)
>>> bp=3D(bno 0x3480, len 4096 bytes) key=3D(bno 0x3480, len 8192 bytes)
>>> Metadata corruption detected at block 0x4000070/0x1000
>>> xfs_da_do_buf(2): XFS_CORRUPTION_ERROR
>>>
>>> fatal error -- can't read block 8388608 for directory inode 259, error =
117
>>>
>>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
