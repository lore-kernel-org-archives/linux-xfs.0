Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Feb 2007 21:51:56 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1Q5pmm7018981
	for <xfs@oss.sgi.com>; Sun, 25 Feb 2007 21:51:50 -0800
Date: Mon, 26 Feb 2007 16:52:47 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: RE: xfsdump/xfsrestore question
Message-ID: <3D67095B5C9E951BA3DB9BD5@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070224150933.BFE26200D8@mail.edu.haifa.ac.il>
References: <20070224150933.BFE26200D8@mail.edu.haifa.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Leon Kolchinsky <leonk@construct.haifa.ac.il>, 'Olaf Fr?czyk' <olaf@cbk.poznan.pl>
Cc: xfs@oss.sgi.com



--On 24 February 2007 5:04:33 PM +0200 Leon Kolchinsky <leonk@construct.haifa.ac.il> wrote:

>> (...)
>> > Yes it is meant to handle a changing filesystem - you do see warning
>> msgs sometimes because
>> > it can't see a particular inode anymore, which can happen as we do
>> multiple
>> > scans of the inodes and if they get deleted then it obviously can't do
>> anything
>> > with it anymore or if the inode is reused as a dir instead of a reg-file
>> etc...
>> Hmm,
>> I suppose he asked about something else:
>> Unless you use lvm snapshots (or something alike) you may get incorrect
>> files that are in use. Consider having 20GB file:
>> 1. Dump starts reading the file
>> 2. Dump is at 18th GB
>> 3. You change the data in 1-5 GB region.
>> 4. You have inconsistent data.
>>
>> So after dump you get consistent filesystem but not necessairly
>> consistent data.
>>
>
> Yep, consistent FS is what I care about in the case of disaster.
>
I'm not sure I know exactly what you are getting at.
After the restore you should have a consistent FS because it is _not_
a low level filesystem dumper. It is mostly a high lever dump/restore
program and to the extent that it can generally restore to a foreign filesystem e.g. ext2.
(For example, it does know about file extents but it only uses this info on restore to
preserve holes by seeking and writing.)
So as it is just doing standard system calls on restore, it can't really
violate filesystem consistency.


> Now, when I've tried to make non-interactive xfsdump I'vo got > prompt with
> no action, like this
># xfsdump -f /data/backup2.file -L 'session1' -M 'media1" /
>>
Presumably quoting problem as Donald pointed out - it definitely works otherwise
without extra input.

--Tim
