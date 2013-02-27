Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BC1BA7F37
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 15:10:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A9A6D8F8040
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 13:10:19 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 9hKBPa2da0IBBTBD for <xfs@oss.sgi.com>;
	Wed, 27 Feb 2013 13:10:18 -0800 (PST)
Message-ID: <512E7639.20205@sandeen.net>
Date: Wed, 27 Feb 2013 15:10:17 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Read corruption on ARM
References: <CA+AKrqBQ=VG0oVsai+agywDKRgO9cG9AvT6mCTSZxKO3Si5Aiw@mail.gmail.com>
	<512D3856.5050305@sandeen.net>
	<CA+AKrqC+6nXuCxdY08MBLsjv1fOPJ6=1ruTHsfGqxosQmCi_jQ@mail.gmail.com>
	<512D49E2.40003@sandeen.net>
	<CA+AKrqCrphO-eKy0n=70O9hmB3mXttOsKmTdfRnPxgJM3_PAkQ@mail.gmail.com>
	<512E3BB2.6060407@sandeen.net>
	<CA+AKrqDq5xCNQo1X=MeRBq54ka0FGJEV5Rn6OzwY7eBfJ+8Wkw@mail.gmail.com>
In-Reply-To: <CA+AKrqDq5xCNQo1X=MeRBq54ka0FGJEV5Rn6OzwY7eBfJ+8Wkw@mail.gmail.com>
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
To: Jason Detring <detringj@gmail.com>
Cc: xfs@oss.sgi.com

On 2/27/13 12:15 PM, Jason Detring wrote:
> On 2/27/13, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 2/27/13 10:28 AM, Jason Detring wrote:
>>>             find-502   [000]   207.983594: xfs_da_btree_corrupt: dev 7:0
>>> bno 0x5a4f8 nblks 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES caller
>>> xfs_dir2_leaf_readbuf
>>
>> Was this on the same image as you sent earlier?
> 
> Yes, sorry, I should have said that.  I'm now using the demo image
> with the RasPi exclusively for testing.
> 
> 
>> Ok, so this tells us that it was trying to read sector nr. 0x5a4f8 (369912),
>> or fsblock 46239
>>
>> What's really on disk there?
>>
>> $ xfs_db problemimage.xfs
>> xfs_db> blockget -n
>> xfs_db> daddr 369912
>> xfs_db> blockuse
>> block 49152 (3/0) type sb
>> xfs_db> type text
>> xfs_db> p
>> 000:  58 46 53 42 00 00 10 00 00 00 00 00 00 00 f0 d3  XFSB............
>> ...
>>
>> So it really did have a superblock location that it was reading
>> at that point - the backup SB in the 3rd allocation group, to be exact.
>> But it shouldn't have been trying to read a superblock at this point
>> in the code...
>>
>> Hm, maybe I should have had you enable all xfs tracepoints to get
>> more info about where we thought we were on disk when we were doing this.
>> If you used trace-cmd you can do "trace-cmd record -e xfs*" IIRC.
>> You can do similar echo 1 > /<blah>/xfs*/enable I think for the sysfs
>> route.
>>
>> Can you identify which directory it was that tripped the above error?
> 
> # modprobe xfs-O1-g
> # mount -o loop,ro /xfsdebug/problemimage.xfs /loop
> # find /loop -type d -print0 > list.txt
> # umount /loop
> # rmmod xfs
> # modprobe xfs-O2-g
> # mount -o loop,ro /xfsdebug/problemimage.xfs /loop
> # cat list.txt | xargs -0 -P1 -n1 -I{} sh -c '(dir="{}" ; ls "${dir}"
>> /dev/null ; sleep 0.1 ; dmesg | tail -n1 | grep Corruption && echo
> "${dir} is causing problems")'
> ls: reading directory /loop/ruby/1.9.1: Structure needs cleaning
> [35689.975822] XFS (loop0): Corruption detected. Unmount and run xfs_repair
> /loop/ruby/1.9.1 is causing problems
> ...
> 
> OK, I now have a name.  Rebooting to get a clean slate.

Ok, and an inode number:

134 test/ruby/1.9.1

xfs_db> inode 134
xfs_db> p
core.format = 2 (extents)
...
core.aformat = 2 (extents)
...
u.bmx[0-1] = [startoff,startblock,blockcount,extentflag] 0:[0,53675,1,0] 1:[8388608,60304,1,0]

so those are the blocks it should live in.

Or, if you prefer:

# xfs_bmap -vv test/ruby/1.9.1
test/ruby/1.9.1:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..7]:          406096..406103    3 (36184..36191)       8

Here's the relevant part of the trace, from the readdir of that inode:

   ls-520   xfs_readdir:          ino 0x86
   ls-520   xfs_perag_get:        agno 3 refcount 2 caller _xfs_buf_find
   ls-520   xfs_perag_put:        agno 3 refcount 1 caller _xfs_buf_find
   ls-520   xfs_buf_init:         bno 0x5a4f8 nblks 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_get_map

by here we're already looking for the block which isn't related to the dir.

   ls-520   xfs_perag_get:        agno 3 refcount 2 caller _xfs_buf_find
   ls-520   xfs_buf_get:          bno 0x5a4f8 len 0x1000 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map
   ls-520   xfs_buf_read:         bno 0x5a4f8 len 0x1000 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map
   ls-520   xfs_buf_iorequest:    bno 0x5a4f8 nblks 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES caller _xfs_buf_read
   ls-520   xfs_buf_hold:         bno 0x5a4f8 nblks 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES caller xfs_buf_iorequest
   ls-520   xfs_buf_rele:         bno 0x5a4f8 nblks 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES caller xfs_buf_iorequest
   ls-520   xfs_buf_iowait:       bno 0x5a4f8 nblks 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES caller _xfs_buf_read
loop0-514   xfs_buf_ioerror:      bno 0x5a4f8 len 0x1000 hold 1 pincount 0 lock 0 error 0 flags READ|PAGES caller xfs_buf_bio_end_io
loop0-514   xfs_buf_iodone:       bno 0x5a4f8 nblks 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES caller _xfs_buf_ioend
   ls-520   xfs_buf_iowait_done:  bno 0x5a4f8 nblks 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES caller _xfs_buf_read
   ls-520   xfs_da_btree_corrupt: bno 0x5a4f8 nblks 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES caller xfs_dir2_leaf_readbuf

and here's where we notice that fact I think.

   ls-520   xfs_buf_unlock:       bno 0x5a4f8 nblks 0x8 hold 1 pincount 0 lock 1 flags DONE|PAGES caller xfs_trans_brelse
   ls-520   xfs_buf_rele:         bno 0x5a4f8 nblks 0x8 hold 1 pincount 0 lock 1 flags DONE|PAGES caller xfs_trans_brelse

Not yet sure what's up here.  I'd probably need to get a cross-compiled xfs.ko going on my rpi to do more debugging...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
