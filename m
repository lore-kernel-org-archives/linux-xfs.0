Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0THfD5o133619
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 11:41:13 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 360541363570
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 09:42:18 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id 9ruP1aw1evNyX07n for <linux-xfs@oss.sgi.com>;
	Fri, 29 Jan 2010 09:42:18 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1NaurI-0000lh-SH
	for linux-xfs@oss.sgi.com; Fri, 29 Jan 2010 18:42:16 +0100
Received: from vm15c-113.broadinstitute.org ([69.173.114.122])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 18:42:16 +0100
Received: from nico by vm15c-113.broadinstitute.org with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 18:42:16 +0100
From: Nicolas Stransky <nico@stransky.cx>
Subject: Re: Filesystem corrupted: "Sorry, could not find valid secondary
	superblock"
Date: Fri, 29 Jan 2010 12:41:53 -0500
Message-ID: <hjv6l0$j2g$1@ger.gmane.org>
References: <hjus58$6oi$1@ger.gmane.org>
	<4B63010D.1080608@sandeen.net>	<hjv12n$r2o$1@ger.gmane.org>
	<4B631704.8080902@sandeen.net>
Mime-Version: 1.0
In-Reply-To: <4B631704.8080902@sandeen.net>
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
To: linux-xfs@oss.sgi.com

OK here is a bunch of new stuff:

# xfs_repair /dev/sda1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ERROR: The filesystem has valuable metadata changes in a log which needs
to be replayed.  Mount the filesystem to replay the log, and unmount it
before re-running xfs_repair.  If you are unable to mount the
filesystem, then use the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a
mount of the filesystem before doing this.

# mount/ dev/sda1
mount: Structure needs cleaning


Is the use of -L the only way to go? I wonder, since it will cause data
loss...


Also here is the output of xfs_db:

# xfs_db /dev/sda1
xfs_db> sb 0
xfs_db> p
magicnum = 0x58465342
blocksize = 4096
dblocks = 366197650
rblocks = 0
rextents = 0
uuid = dab73302-1744-4fc0-89db-5c6670a02aa0
logstart = 134217732
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 16
agblocks = 6866155
agcount = 54
rbmblocks = 0
logblocks = 32768
versionnum = 0x3484
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 23
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 4115008
ifree = 954636
fdblocks = 85242778
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 1
features2 = 0
bad_features2 = 0

Thanks!

On 1/29/10 12:12 PM, Eric Sandeen wrote:
> Nicolas Stransky wrote:
>> On 1/29/10 10:38 AM, Eric Sandeen wrote:
>>> xfs_repair needs to be smarter about this; I at least wish it'd say 
>>> -why- the candidate was not valid.
>>>
>>> Can you include the whole repair output?  Then maybe we can direct 
>>> you to some xfs_db jujitsu to examine the fs.
>>>
>>> Trying newer xfsprogs would not be a -bad- idea...
>>>
>>> -Eric
>>
>> The output is as follows:
>>
>> # xfs_repair /dev/sda
>> Phase 1 - find and verify superblock...
>> bad primary superblock - bad magic number !!!
> 
> xfs_db /dev/sda
> xfs_db> sb 0
> xfs_db> p
> 
> might be interesting to see what's there.
> 
> -Eric
> 
>> attempting to find secondary superblock...
>> ......................
>> found candidate secondary superblock...
>> unable to verify superblock, continuing...
>> ......................
>> found candidate secondary superblock...
>> unable to verify superblock, continuing...
>> ......................
>> [The previous one repeats hundreds of times over many hours]
>> ......................
>> Sorry, could not find valid secondary superblock
>> Exiting now.
>>
>>
>> I am trying right now xfsprogs 3.1.0 from Debian testing, will see what
>> it gives...
>>
>> Thanks!
>> NS
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
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
