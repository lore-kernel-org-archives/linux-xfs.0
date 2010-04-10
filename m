Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3A3WaZQ163798 for <xfs@oss.sgi.com>; Fri, 9 Apr 2010 22:32:36 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 753CEFD0083
	for <xfs@oss.sgi.com>; Fri,  9 Apr 2010 20:34:28 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 8qgBPnKFF8NMpiOK for
	<xfs@oss.sgi.com>; Fri, 09 Apr 2010 20:34:28 -0700 (PDT)
Message-ID: <4BBFF1C3.9040000@sandeen.net>
Date: Fri, 09 Apr 2010 22:34:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] enable inode64 by default when possible
References: <4B7309D7.5090800@sandeen.net> <1270850499.7840.25.camel@doink>
	<4BBFE478.3090901@hardwarefreak.com>
In-Reply-To: <4BBFE478.3090901@hardwarefreak.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

Stan Hoeppner wrote:
> Alex Elder put forth on 4/9/2010 5:01 PM:
> 
>> OK, it's been about two months since Eric proposed this, and
>> I'm finally getting around to writing up a response.
>>
>> I discussed this with a few people within SGI, and there were
>> two main concerns that were mentioned:
>> - This may be a problem for some NFS clients
>> - This may be a problem for some backup software
>> We don't believe there are any direct issues with DMF or CXFS
>> in making this change.
>>
>> I understand that the change is only in the default behavior,
>> and that forcing 32-bit inodes will still be an available
>> option.
> 
> Hi Alex,
> 
> How will this change affect those people running 32bit CPUs and kernels, if
> at all?  Or is this change related not to the word width of the hardware/OS
> but to the size of the filesystem and/or number of files/inodes contained
> within?  You mentioned possible issues with NFS.  Are there any issues with
> Samba?

Recent 32-bit kernels can handle 64-bit inodes.

Userspace is a different issue; it -can- certainly cope, but many userspace
apps don't use the 64-bit interfaces, stat64 and friends.

These should get fixed, IMHO, as did the large file problems in years past ...
 
> Intel Atom (32bit x86) CPUs and XFS on multi terabyte disks are popular with
> many folks running Linux based media PCs, streaming their ripped DVDs and
> other large media files from their XFS filesystems.  I don't personally do
> this, but I also have 32bit only systems that won't be replaced with 64bit
> CPUs for some time to come.

Multi-terabyte on a 32-bit atom with 2G memory is -really- pushing it
in terms of ability to run repair - at least depending on the value of
"multi".   Swap helps I guess but massive filesystems on underpowered
boxes is a classic example of enough rope to hang oneself, IMHO.  :)

Note, as Alex said, you can always force the mount to stay in 32 bits.
And for smaller filesystems, no inode would be past 32 bits anyway.

-Eric
 
> Thanks.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
