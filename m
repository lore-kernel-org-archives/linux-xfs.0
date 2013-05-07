Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 63EB929DF8
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 19:38:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3F60130406A
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 17:38:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id gL9wJGCbvM5F3euC for <xfs@oss.sgi.com>;
	Mon, 06 May 2013 17:38:24 -0700 (PDT)
Message-ID: <51884CFF.1010208@sandeen.net>
Date: Mon, 06 May 2013 19:38:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Internal error xfs_sb_read_verify at line 726
References: <20130506112717.GA502@x4> <5187E290.8090109@sandeen.net>
	<20130506183020.GA513@x4> <51880121.8000001@sandeen.net>
	<20130506192629.GA503@x4> <5188074F.2090500@sandeen.net>
	<20130506195521.GB503@x4> <51881750.3090309@sandeen.net>
	<51882537.6070904@sandeen.net> <20130507002314.GM19978@dastard>
	<20130507003436.GN19978@dastard>
In-Reply-To: <20130507003436.GN19978@dastard>
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
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

On 5/6/13 7:34 PM, Dave Chinner wrote:
> On Tue, May 07, 2013 at 10:23:14AM +1000, Dave Chinner wrote:
>> On Mon, May 06, 2013 at 04:48:39PM -0500, Eric Sandeen wrote:
>>> On 5/6/13 3:49 PM, Eric Sandeen wrote:
>>> ...
>>>
>>>> Interesting, so [mount] really does try to mount by successive fs types.
>>>>
>>>> I wonder when that behavior changed (my util-linux-ng 2.17 on RHEL6 doesn't do this)
>>>>
>>>> I'll take a look.
>>>
>>> Just to satisfy my curiosity:
>>>
>>> commit c6c98f93f5e4b3fb9a8b51ed2ef9967793df7b1c
>>> Author: Karel Zak <kzak@redhat.com>
>>> Date:   Mon Mar 15 13:46:43 2010 +0100
>>>
>>>     mount: report ambivalent FS detection, improve brute force detection
>>>     
>>>     The ambivalent probing result should be properly reported and user
>>>     should be informed that the problem is possible to bypass by "-t
>>>     <type>" or resolved by wipefs(8).
>>>     
>>>     The mount(8) command uses a brute force stage (calls mount(2) for all
>>>     /{proc,etc}/fylesystems) if there is not any other way how to detect
>>>     the filesystem type. The brute force stage should not be restricted by
>>>     libblkid. It's possible that libblkid is not able to detect slightly
>>>     corrupted filesystem, but kernel is able to mount such filesystem.
>>>     
>>>     Note that the brute force stage should not be used if libblkid returns
>>>     ambivalent probing result. In this case user's intervention is required
>>>     (e.g. mount -t <type>).
>>>     
>>>     Reported-by: Mike Frysinger <vapier@gentoo.org>
>>>     Signed-off-by: Karel Zak <kzak@redhat.com>
>>>
>>> So we're getting into xfs mount with an actual "-t xfs" equivalent,
>>> and not going down the "silent" paths.
>>
>> That's just completely broken mount behaviour. Probing is supposed
>> to be *silent*, and this is just downright obnxious. Here's what I
>> get in my log after doing this:
>>
>> # dd if=/dev/zero of=/dev/vdb bs=512 count=1
>> # blkid -g
>> # mount  /dev/vdb /mnt/scratch/
>> mount: you must specify the filesystem type
>> $ dmesg
>> ......
>> [83182.775467] REISERFS warning (device vdb): sh-2021 reiserfs_fill_super: can not find reiserfs on vdb
>> [83182.778473] EXT3-fs (vdb): error: can't find ext3 filesystem on dev vdb.
>> [83182.781135] EXT2-fs (vdb): error: can't find an ext2 filesystem on dev vdb.
>> [83182.783524] EXT4-fs (vdb): VFS: Can't find ext4 filesystem
> ....
> 
> BTW, strace indicates that MS_SILENT is not being used during brute
> force mounts:
> 
> # strace -vx mount /dev/vdb /mnt/scratch/ 2>&1 |grep ^mount
> mount("/dev/vdb", "/mnt/scratch/", "reiserfs", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
> mount("/dev/vdb", "/mnt/scratch/", "ext3", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
> mount("/dev/vdb", "/mnt/scratch/", "ext2", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
> mount("/dev/vdb", "/mnt/scratch/", "ext4", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
> ....
> 
> So this really looks like a bug in mount, not the filesystem handling
> of slient mounts...

Hm, good point, I forgot that mount could set MS_SILENT. . . 

But still:

Do we really *ever* need this level of info when xfs discovers EWRONGFS?

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
