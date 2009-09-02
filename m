Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82L1bnX045657 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 16:01:47 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4FFAC15B7BC1
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 14:02:29 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id SD8vEZJ326nRawpc for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 14:02:29 -0700 (PDT)
Date: Wed, 2 Sep 2009 17:02:29 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Structure needs cleaning? (take #2)
In-Reply-To: <4A9ECD20.9090201@sandeen.net>
Message-ID: <alpine.DEB.2.00.0909021659520.9106@p34.internal.lan>
References: <20090902152245.b2969883.rumi_ml@rtfm.hu>
	<4A9E81AD.70003@sandeen.net>
	<20090902213441.470b439c.rumi_ml@rtfm.hu>
	<4A9ECD20.9090201@sandeen.net>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: RUMI Szabolcs <rumi_ml@rtfm.hu>, xfs@oss.sgi.com

Hi RUMI,

1. Have you run memtest86 for a few passes?

2. Have you run a short+long test against the drive?
    smartctl -t short /dev/sda  # wait 10min
    smartctl -t long # wait until its done
    show smartctl -a /dev/sda output <- report this back

3. Is this the first time this has happened?

4. Is your system on a UPS?

5. How do you mount your XFS partition?
    a. Do you use any special parameters?

Justin.


On Wed, 2 Sep 2009, Eric Sandeen wrote:

> RUMI Szabolcs wrote:
>> Hi!
>>
>> Well, what could be the reason? I mean, there was no hardware failure,
>> no crash, no reboot, no errors in the disk's SMART error log, no nothing.
>> What I did was that I've extracted and deleted the rather huge OpenOffice
>> source tree several times (sometimes with overwriting) and finally it
>> ended up with these undeletable files and xfs errors. Is it considered
>> normal for xfs to get messed up like that under such load?
>
> No, not normal.
>
> It found the text "0xAAAA0000,6,0x" on disk in an area where it expected
> to find valid filesystem metadata.
>
> Corruption could come from anywhere - an xfs bug, some other bug, bad
> memory, bad cables, neon death rays from space, writing directly to the
> disk, who knows.  Awfully hard to track down a one-off occurrence like
> this, I'm afraid.
>
>> Thanks,
>> Sab
>>
>>
>>
>> The xfs_repair output and xfs_info output is included below:
>>
>> # xfs_repair -v /dev/sda10
>
> ...
>
>> Phase 6 - check inode connectivity...
>>         - resetting contents of realtime bitmap and summary inodes
>>         - traversing filesystem ...
>>         - agno = 0
>>         - agno = 1
>>         - agno = 2
>>         - agno = 3
>>         - agno = 4
>>         - agno = 5
>>         - agno = 6
>>         - agno = 7
>> leaf block 8388608 for directory inode 4051737 bad header
>> rebuilding directory inode 4051737
>> leaf block 8388608 for directory inode 4053318 bad header
>> rebuilding directory inode 4053318
>
> ...
>
> above is the problem, properly found & repaired.
>
> -Eric
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
