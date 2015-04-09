Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1A5F87F8C
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 05:42:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F1CA304039
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 03:42:40 -0700 (PDT)
Received: from mail.rvx.is (mail.rvx.is [178.19.51.189]) by cuda.sgi.com with
	ESMTP id loZExwxjheLwEJ7P (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Apr 2015 03:42:38 -0700 (PDT)
Date: Thu, 9 Apr 2015 10:42:35 +0000 (GMT)
From: Rui Gomes <rgomes@rvx.is>
Message-ID: <1560667825.678874.1428576155401.JavaMail.zimbra@rvx.is>
In-Reply-To: <1369906732.430278.1426089670705.JavaMail.zimbra@rvx.is>
References: <54FDFEDC.5090106@sandeen.net>
	<1061986380.422955.1426008424991.JavaMail.zimbra@rvx.is>
	<54FF2BBF.7060404@sandeen.net>
	<410959445.428221.1426083973347.JavaMail.zimbra@rvx.is>
	<550054D9.3010602@sandeen.net>
	<1908077521.428877.1426086242030.JavaMail.zimbra@rvx.is>
	<5500636A.3020309@sandeen.net>
	<1369906732.430278.1426089670705.JavaMail.zimbra@rvx.is>
Subject: Re: [PATCH] xfs_repair: junk last entry in sf dir if name starts
	beyond dir size
MIME-Version: 1.0
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
Cc: omar <omar@rvx.is>, xfs <xfs@oss.sgi.com>

Hello Eric, 

Sorry for the late late reply, I didn't had the time to dig in to this earlier.

Actually gdb was lying us, the segfault doesn't happen at:
  for (i = 0; i < be32_to_cpu(btp->count); i++) 

but a bit later at:

if (be32_to_cpu(lep[i].address) == addr &&
        be32_to_cpu(lep[i].hashval) == hash)


And the cause of the segfault is lep[i] 

So I tried:

(gdb) print lep
$1 = (xfs_dir2_leaf_entry_t *) 0xfffffffc9ac12788

p lep[0].address
Cannot access memory at address 0xfffffffc9ac12794

For what I can see the lep[0] struct doesn't exist!

The inode where this happen bellow:

[root@icess8a xfsprogs-dev]# xfs_db -c "inode 620507648" -c "p" /dev/sdb1
Metadata corruption detected at block 0x4ffed6d08/0x1000                                                                                                                                                                                     
xfs_db: cannot init perag data (117). Continuing anyway.                                                                                                                                                                                     
core.magic = 0x494e                                                                                                                                                                                                                          
core.mode = 040755                                                                                                                                                                                                                           
core.version = 2                                                                                                                                                                                                                             
core.format = 2 (extents)
core.nlinkv2 = 3
core.onlink = 0
core.projid_lo = 0
core.projid_hi = 0
core.uid = 0
core.gid = 0
core.flushiter = 2
core.atime.sec = Fri May 16 12:21:52 2014
core.atime.nsec = 779442171
core.mtime.sec = Tue Mar 24 12:03:59 2009
core.mtime.nsec = 000000000
core.ctime.sec = Fri Feb 28 19:54:03 2014
core.ctime.nsec = 736630717
core.size = 4096
core.nblocks = 1
core.extsize = 0
core.nextents = 1
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 3064228498
next_unlinked = null
u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,38781727,1,0]


Regards 

------------------------------- 
Rui Gomes 
CTO 


RVX - Reykjavik Visual Effects 
Seljavegur 2, 
101 Reykjavik 
Iceland 


Tel: + 354 527 3330 
Mob: + 354 663 3360

----- Original Message -----
From: "Rui Gomes" <rgomes@rvx.is>
To: "Eric Sandeen" <sandeen@sandeen.net>
Cc: "omar" <omar@rvx.is>, "xfs" <xfs@oss.sgi.com>
Sent: Wednesday, 11 March, 2015 16:01:10
Subject: Re: [PATCH] xfs_repair: junk last entry in sf dir if name starts beyond dir size

Hi,

Thank you for pointing out where to look, I will try to dissect this a bit further and report back to you. 

Regards 

------------------------------- 
Rui Gomes 
CTO 


RVX - Reykjavik Visual Effects 
Seljavegur 2, 
101 Reykjavik 
Iceland 


Tel: + 354 527 3330 
Mob: + 354 663 3360

----- Original Message -----
From: "Eric Sandeen" <sandeen@sandeen.net>
To: "Rui Gomes" <rgomes@rvx.is>
Cc: "omar" <omar@rvx.is>, "xfs" <xfs@oss.sgi.com>
Sent: Wednesday, 11 March, 2015 15:46:50
Subject: Re: [PATCH] xfs_repair: junk last entry in sf dir if name starts beyond dir size

On 3/11/15 11:04 AM, Rui Gomes wrote:
> Program received signal SIGSEGV, Segmentation fault.
> 0x000000000044dbcd in __xfs_dir3_data_check (dp=dp@entry=0x0, bp=bp@entry=0x1538e810) at xfs_dir2_data.c:148
> 148                             for (i = 0; i < be32_to_cpu(btp->count); i++) {
> (gdb) bt
> #0  0x000000000044dbcd in __xfs_dir3_data_check (dp=dp@entry=0x0, bp=bp@entry=0x1538e810) at xfs_dir2_data.c:148
> #1  0x000000000044b9ea in xfs_dir3_block_verify (bp=bp@entry=0x1538e810) at xfs_dir2_block.c:62

Can you do a little digging around in gdb to sort out more
about why it segfaulted?

We got a xfs_dir2_data_hdr_t from the passed-in bp w/ valid magic:

hdr = bp->b_addr;

and from that got btp:

        switch (hdr->magic) {
        case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
                btp = xfs_dir2_block_tail_p(mp, hdr);

and this just finds an offset from hdr:

                ((char *)hdr + mp->m_dirblksize)) - 1;

but then apparently blew up when we tried to use btp:

for (i = 0; i < be32_to_cpu(btp->count); i++) {

I don't see offhand how the hdr is ok, with good magic, but an
offset from the hdr (btp) is causing a segfault.  Can you dig around
a bit more in gdb?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
