Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B934D7FBB
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 15:49:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 37F8AAC004
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 13:49:35 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 89IUya93uyQFU0mi for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 13:49:33 -0800 (PST)
Message-ID: <54CAAAEC.1080803@sandeen.net>
Date: Thu, 29 Jan 2015 15:49:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Unable to mount and repair filesystems
References: <D90435AEFF34654AA1122988C66C8678023F0277C9@exchange.tsag.local>
	<54CA9586.1010607@sandeen.net>
	<D90435AEFF34654AA1122988C66C8678023F027956@exchange.tsag.local>
In-Reply-To: <D90435AEFF34654AA1122988C66C8678023F027956@exchange.tsag.local>
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
To: Gerard Beekmans <GBeekmans@tsag.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 1/29/15 3:27 PM, Gerard Beekmans wrote:
>> -----Original Message-----
>> Are you certain that the volume / storage behind dm-9 is in decent shape?
>> (i.e. is it really even an xfs filesystem?)
> 
> The question "is it in decent shape" is probably the million dollar question.

Right, sorry, I just meant: does this seem like an xfs problem or a storage problem
at first glance.
 
> What I do know is this:
> 
> * It's all LVM based
> * The first problem partition is /dev/data/srv which in turn is a symlink to /dev/dm-9
> * The second problem partition is /dev/os/opt which in turn is a symlink to /dev/dm-7
> 
> Both were originally formatted as XFS and /etc/fstab has same. Now I
> can' t be sure if the symlinks were always dm-7 and dm-9.
> 
> Comparing what "lvdisplay" tell in terms of block device major &
> minor numbers and compare to the dm-* symlinks, they all match up. So
> by all accounts it ought to be correct.
> 
> Running xfs_db on those two partitions shows what I understand to be
> the "right stuff" aside from an error when it first runs:

ok, that's a good datapoint, so it's not woefully scrambled.

> # xfs_db /dev/os/opt
> Metadata corruption detected at block 0x4e2001/0x200

so at sector 0x4e2001, length 0x200.

xfs_db> agf 5
xfs_db> daddr
current daddr is 5120001

so it's the 5th AGF which is corrupt.

you could try:

xfs_db> agf 5
xfs_db> print

to see how it looks.

> xfs_db: cannot init perag data (117). Continuing anyway.
> xfs_db> sb 0
> xfs_db> p
> magicnum = 0x58465342

this must not be the one that repair failed on like:

> couldn't verify primary superblock - bad magic number !!!

because that magicnum is valid.  Did this one also fail to
repair?

> blocksize = 4096
> dblocks = 3133440
> rblocks = 0
> rextents = 0
> uuid = b4ab7d1d-d383-4c49-af2c-be120ff967a7
> logstart = 262148
> rootino = 128
> rbmino = 129
> rsumino = 130
> rextsize = 1
> agblocks = 128000
> agcount = 25

25 ags, presumably the fs was grown in the past, but ok...

...

>> A VM crashing definitely should not result in a badly corrupt/unmountable
>> filesystem.
>>
>> Is there any other interesting part of the story? :)
> 
> The full setup is as follows:
> 
> The VM question is a VMware guest running on a vmware cluster. The
> actual files that make up the VM is stored on a SAN that VMware
> accesses via NFS.
> 
> The outage occurred at the SAN level making the NFS storage
> unavailable which in turn turned off all the VMs running on it
> (turned off in the virtual sense).
> 
> ~50 VMs then were brought online and none had any serious issues.
> Most needed a form of fsck to bring things back to consistency. This
> is the only VM that suffered the way it did. Other VMs are a mix of
> Linux, BSD, OpenSolaris and Windows with all their varieties of
> filesystems (ext3, ext4, xfs, ntfs and so on).
> 
> It is possible that it is the vmware VMDK file that belongs to this
> VM that is the issue but it does not appear to be corrupt from a vmdk
> standpoint. Just the data inside of it.

The only thing I can say is that xfs is going to depend on the storage
telling the truth about completed IOs...  If the storage told XFS an IO
was persistent, but it wasn't, and the storage went poof, bad things
can happen.  I don't know the details of your setup, or TBH much
about vmware over nfs ... you weren't mounted with -o nobarrier
were you?

-Eric

> 
> Gerard
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
