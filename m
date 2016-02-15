Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EEE627CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 13:28:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9F416AC003
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 11:28:39 -0800 (PST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com
	[74.125.82.46]) by cuda.sgi.com with ESMTP id aZVVD0BVe7EbLNDv
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Feb 2016 11:28:37 -0800 (PST)
Received: by mail-wm0-f46.google.com with SMTP id g62so162093121wme.0
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 11:28:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56C219F0.3050002@sandeen.net>
References: <CAJkH1p6LU=d5oLh3A+j_GQ70uoCYMjR=a5yS1w8p5d5ZXz6fwg@mail.gmail.com>
	<56C219F0.3050002@sandeen.net>
Date: Mon, 15 Feb 2016 14:28:36 -0500
Message-ID: <CAJkH1p5ZP-Wg=UgwBZKz6rZS=_5-o625HZPAosW7tt-zpaNDOg@mail.gmail.com>
Subject: Re: XFS fiemap issue with Linux 3.10.0-327.el7.x86_64 (CentOS 7)
From: Jim Wilcoxson <prirun@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Thanks Eric.

I ran xfs_bmap -v and it returned extents 0-19999, alternating data
with holes.  The holes and data were various sizes, I suppose for xfs
alignment reasons, but everything was there.

Running fiemap again after xfs_bmap still returned 1364 extents.
Fiemap only returns data extents, with holes implied, and comparing
this to a seek_data/seek_hole map, they are identical as far as they
go.  The fiemap just poops out early, around the 5GB mark as I recall,
but the file is 41GB.  It appears broken to me.

I appreciate the advice about things changing after the fiemap call.
That's true of any backup that isn't of a snapshot, so it's usually a
crap shoot in that regard.

Jim

On 2/15/16, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 2/15/16 11:26 AM, Jim Wilcoxson wrote:
>> I'm developing a backup program, HashBackup, and recently added sparse
>> "hole skipping" using fiemap.
>
> That is probably not safe.  Mapping can change immediately after fiemap
> returns, and you could miss data.  cp went down that path a few years ago,
> and it caused pain.
>
> SEEK_HOLE/SEEK_DATA would be a better choice.
>
>> Today I ran into a weird issue with xfs
>> on Linux 3.10.
>>
>> A test program creates a sparse file with 10000*(4K data, 4M hole).
>> HB calls fiemap with start=0, length=0xFFFF...FFFF, mapped_extents=0
>> to get the number of extents.    Fiemap is coming back with
>> mapped_extents=1364 instead of 10000.
>
> Take a look at xfs_bmap -v output to get a clear picture of what
> is actually on disk.  It's possible that some combination of
> speculative preallocation or other things has merged extents.
>
> In general, the kernel has plenty of leeway in terms of how it
> chooses to lay out a file.  "seek/write" doesn't necessarily
> guarantee a hole.
>
>> The fiemap.txt file says:
>>
>> "If fm_extent_count is zero, then the fm_extents[] array is ignored
>> (no extents will be returned), and the fm_mapped_extents count will
>> hold the number of extents needed in fm_extents[] to hold the file's
>> current mapping."
>>
>> It doesn't say the filesystem can choose to return fewer extents if it
>> wants, but maybe xfs interprets it this way and fiemap has to be
>> called in a loop until the extent_last flag is set.  If that's the
>> case, fiemap.txt should be updated.
>
> It's not clear that it is returning fewer extents.  See what xfs_bmap
> says, and compare.
>
> But also, don't use fiemap results for anything that requires
> data integrity...
>
> -Eric
>
>> Thanks,
>> Jim
>> (not on the xfs mailing list)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
