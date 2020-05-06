Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BTC_ID,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF11FC28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 23:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3A6B20659
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 23:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgEFXVT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 19:21:19 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42983 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgEFXVS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 19:21:18 -0400
X-Originating-IP: 84.65.30.46
Received: from storm.broadband (unknown [84.65.30.46])
        (Authenticated sender: edwin@etorok.net)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 7646A60003;
        Wed,  6 May 2020 23:20:51 +0000 (UTC)
Message-ID: <788538c79fc331f09d335d7526f5e79484403c59.camel@etorok.net>
Subject: Re: PROBLEM: XFS in-memory corruption with reflinks and duperemove:
 XFS (dm-4): Internal error xfs_trans_cancel at line 1048 of file
 fs/xfs/xfs_trans.c.  Caller xfs_reflink_remap_extent+0x100/0x560
From:   Edwin =?ISO-8859-1?Q?T=F6r=F6k?= <edwin@etorok.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 07 May 2020 00:20:51 +0100
In-Reply-To: <20200506224749.GA6730@magnolia>
References: <f6c749739dc135ebd7a9321195a616b15c772082.camel@etorok.net>
         <20200421171616.GH6749@magnolia>
         <acc12ecd2c183c93f8af770b2302498cb30e83f4.camel@etorok.net>
         <20200504152135.GA13811@magnolia>
         <583e618512f15f10b3dee8857a92235950c862e7.camel@etorok.net>
         <20200505005811.GC5716@magnolia>
         <124EB800-8712-4C36-8B35-41363A558269@etorok.net>
         <20200506224749.GA6730@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2020-05-06 at 15:47 -0700, Darrick J. Wong wrote:
> On Wed, May 06, 2020 at 12:07:12AM +0100, Edwin Török wrote:
> > 
> > On 5 May 2020 01:58:11 BST, "Darrick J. Wong" <
> > darrick.wong@oracle.com> wrote:
> > > On Mon, May 04, 2020 at 11:54:05PM +0100, Edwin Török wrote:
> > > > On Mon, 2020-05-04 at 08:21 -0700, Darrick J. Wong wrote:
> > > > > On Mon, Apr 27, 2020 at 10:15:57AM +0100, Edwin Török wrote:
> > > > > > On Tue, 2020-04-21 at 10:16 -0700, Darrick J. Wong wrote:
> > > > > > > On Sat, Apr 18, 2020 at 11:19:03AM +0100, Edwin Török
> > > > > > > wrote:
> > > > > > > > [1.] One line summary of the problem:
> > > > > > > > 
> > > > > > > > I 100% reproducibly get XFS in-memory data corruption
> > > > > > > > when
> > > > > > > > running
> > > > > > > > duperemove on an XFS filesystem with reflinks, even
> > > > > > > > after
> > > > > > > > running
> > > > > > > > xfs_repair and repeating the operation.
> > > > > > > > 
> > > > > > > > [2.] Full description of the problem/report:
> > > > > > > > Ubuntu bugreport here: 
> > > > > > > > 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1873555
> > > > > > > 
> > > > > > > Hmm.  I recently fixed an uninitialized variable error in
> > > > > > > xfs_reflink_remap_extent.
> > > > > > > 
> > > > > > > Does applying that patch to the ubuntu kernel (or running
> > > > > > > the
> > > > > > > same
> > > > > > > workload on the 5.7-rc2 ubuntu mainline kernel) fix this?
> > > > > > > 
> > > > > > > https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.7-rc2/
> > > > > > 
> > > > > > [...]
> > > > > 
> > > > > A smaller testcase would help.
> > > > 
> > > > Found it! I don't think it is corruption at all, more like the
> > > function
> > > > caller not handling an expected error condition, see below:
> > > > 
> > > > I wasn't able to create a testcase that doesn't also need all
> > > > my
> > > data,
> > > > but I found a faster repro which takes only a few minutes:
> > > > 
> > > > 
> > > > sudo lvconvert --merge /dev/mapper/storage-storage--snapshot
> > > > sudo lvcreate -L 32G -s -n storage-snapshot
> > > /dev/mapper/storage-backup
> > > > sudo mount -o noatime /dev/mapper/storage-backup /mnt/storage
> > > > sudo duperemove -d --hashfile hashes /mnt/storage/from-
> > > > 
> > > restic/04683ed4/tmp/fast/c14-sd-92016-2-home/2017-06-07-
> > > 233355/2017-06-
> > > > 07-233355/edwin/.mu/xapian/postlist.DB /mnt/storage/from-
> > > > 
> > > restic/0fcf01c9/tmp/fast/c14-sd-92016-2-home/2017-05-23-
> > > 233346/2017-05-
> > > > 23-233346/edwin/.mu/xapian/postlist.DB /mnt/storage/from-
> > > > 
> > > restic/10350278/tmp/fast/c14-sd-92016-2-home/2017-06-17-
> > > 233341/2017-06-
> > > > 17-233341/edwin/.mu/xapian/postlist.DB
> > > > sudo umount /mnt/storage
> > > > 
> > > > 
> > > > > Or... if you have bpftrace handy, using kretprobes to figure
> > > > > out
> > > > > which
> > > > > function starts the -EIO return that ultimately causes the
> > > > > remap to
> > > > > fail.
> > > > > 
> > > > > (Or failing that, 'trace-cmd -e xfs_buf_ioerr' to see if it
> > > uncovers
> > > > > anything.)
> > > > 
> > > > With this xfs.bt:
> > > > 
> > > > kprobe:xfs_iread_extents,
> > > > kprobe:xfs_bmap_add_extent_unwritten_real,
> > > > kprobe:xfs_bmap_del_extent_delay,
> > > > kprobe:xfs_bmap_del_extent_real,
> > > > kprobe:xfs_bmap_extents_to_btree,
> > > > kprobe:xfs_bmap_btree_to_extents,
> > > > kprobe:__xfs_bunmapi,
> > > > kprobe:xfs_defer_finish
> > > > {
> > > >     @st[tid] = kstack();
> > > >     @has[tid] = 1;
> > > > }
> > > > 
> > > > kretprobe:xfs_iread_extents,
> > > > kretprobe:xfs_bmap_add_extent_unwritten_real,
> > > > kretprobe:xfs_bmap_del_extent_delay,
> > > > kretprobe:xfs_bmap_del_extent_real,
> > > > kretprobe:xfs_bmap_extents_to_btree,
> > > > kretprobe:xfs_bmap_btree_to_extents,
> > > > kretprobe:__xfs_bunmapi,
> > > > kretprobe:xfs_defer_finish
> > > > /(retval!=0) && (@has[tid])/ {
> > > >     // kstack does not work here
> > > >     @errors[(int32)retval, probe, @st[tid]] = count();
> > > >     delete(@st[tid]);
> > > >     delete(@has[tid]);
> > > > }
> > > > 
> > > > BEGIN { printf("START\n"); }
> > > > END { print(@errors); }
> > > > 
> > > > I got this:
> > > > @errors[-28, kretprobe:xfs_bmap_del_extent_real, 
> > > >     xfs_bmap_del_extent_real+1
> > > >     kretprobe_trampoline+0
> > > >     xfs_reflink_remap_blocks+286
> > > >     xfs_file_remap_range+272
> > > >     vfs_dedupe_file_range_one+301
> > > >     vfs_dedupe_file_range+342
> > > >     do_vfs_ioctl+832
> > > >     ksys_ioctl+103
> > > >     __x64_sys_ioctl+26
> > > >     do_syscall_64+87
> > > >     entry_SYSCALL_64_after_hwframe+68
> > > > ]: 1
> > > > 
> > > > -28 is ENOSPC, but I have more than 1TiB free (and plenty of
> > > > free
> > > > inodes too).
> > > > 
> > > > Poking around in that code I found this block of code:
> > > >   >       /*
> > > >   >        * If it's the case where the directory code is
> > > > running
> > > with
> > > > no block
> > > >   >        * reservation, and the deleted block is in the
> > > > middle of
> > > its
> > > > extent,
> > > >   >        * and the resulting insert of an extent would cause
> > > > transformation to
> > > >   >        * btree format, then reject it.  The calling code
> > > > will
> > > then
> > > > swap blocks
> > > >   >        * around instead.  We have to do this now, rather
> > > > than
> > > > waiting for the
> > > >   >        * conversion to btree format, since the transaction
> > > > will
> > > be
> > > > dirty then.
> > > >   >        */
> > > >   >       if (tp->t_blk_res == 0 &&
> > > >   >           XFS_IFORK_FORMAT(ip, whichfork) ==
> > > XFS_DINODE_FMT_EXTENTS
> > > > &&
> > > >   >           XFS_IFORK_NEXTENTS(ip, whichfork) >=
> > > >   >       >       >       XFS_IFORK_MAXEXT(ip, whichfork) &&
> > > >   >           del->br_startoff > got.br_startoff && del_endoff
> > > > <
> > > > got_endoff) {
> > > >                   xfs_warn(mp, "returning ENOSPC in %s",
> > > > __func__);
> > > >   >       >       return -ENOSPC;
> > > >               }
> > > 
> > > Aww, gross, that's some weird thing that exists for directory
> > > code. :/
> > > 
> > > I bet the problem here is that the remap transaction is running
> > > out of
> > > block reservation.  Looking at xfs_reflink_remap_extent it looks
> > > like
> > > we
> > > reserve one extent mapping's worth of blocks for the whole
> > > operation.
> > > I don't think is correct, since we're removing a whole mapping
> > > and
> > > inserting another mapping, but only allowing for one bmbt split.
> > > 
> > > Hmm, if you find the chunk of xfs_reflink_remap_extent:
> > > 
> > > 	/* Start a rolling transaction to switch the mappings */
> > > 	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
> > > 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
> > > 0, &tp);
> > > 
> > > and then change the resblks= line to read:
> > > 
> > > 	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK) *
> > > 2;
> > > 
> > > Does that make the crash go away?
> > 
> > No, the smallest multiplier that works for this file is 14, perhaps
> > the formula here needs some of the other space macros? I don't see
> > why
> > 14 would be the answer.  I'll let it run on the other files to see
> > if
> > that's enough in general.
> 
> Ok.  14 also confirms my suspicions that we're running out of block
> reservation, probably because of the length of the transaction chain.

FWIW running duperemove on the rest of the FS triggered the issue again
even with 14 on the exact same file.


> 
> > > Or, send me a metadump and let me bang my head on this tomorrow.
> > > :)
> > 
> > That'll be quite large, is there a way to metadump only a subdir?
> 
> Hm... could you send me a filefrag -v of the files that you're
> feeding
> to duperemove?  That might give me a better idea of the reflinking
> factor of the filesystem.

sudo filefrag -v /mnt/storage/from-restic/04683ed4/tmp/fast/c14-sd-
92016-2-home/2017-06-07-233355/2017-06-07-
233355/edwin/.mu/xapian/postlist.DB /mnt/storage/from-
restic/0fcf01c9/tmp/fast/c14-sd-92016-2-home/2017-05-23-233346/2017-05-
23-233346/edwin/.mu/xapian/postlist.DB /mnt/storage/from-
restic/10350278/tmp/fast/c14-sd-92016-2-home/2017-06-17-233341/2017-06-
17-233341/edwin/.mu/xapian/postlist.DB 
Filesystem type is: 58465342
File size of /mnt/storage/from-restic/04683ed4/tmp/fast/c14-sd-92016-2-
home/2017-06-07-233355/2017-06-07-233355/edwin/.mu/xapian/postlist.DB
is 2255716352 (550712 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected:
flags:
   0:        0..     650:  289205390..
289206040:    651:             shared
   1:      651..     827:  288864297.. 288864473:    177:  289206041:
shared
   2:      828..    1098:  289206041.. 289206311:    271:  288864474:
shared
   3:     1099..    1490:  288947797.. 288948188:    392:  289206312:
shared
   4:     1491..    1928:  289206312.. 289206749:    438:  288948189:
shared
   5:     1929..    3078:  289024844.. 289025993:   1150:  289206750:
shared
   6:     3079..    7504:  289206750.. 289211175:   4426:  289025994:
shared
   7:     7505..   10083:  289030420.. 289032998:   2579:  289211176:
shared
   8:    10084..   11930:  289211176.. 289213022:   1847:  289032999:
shared
   9:    11931..   13072:  289034846.. 289035987:   1142:  289213023:
shared
  10:    13073..   14183:  289213023.. 289214133:   1111:  289035988:
shared
  11:    14184..   15536:  289037099.. 289038451:   1353:  289214134:
shared
  12:    15537..   20897:  289219223.. 289224583:   5361:  289038452:
shared
  13:    20898..   23720:  289043813.. 289046635:   2823:  289224584:
shared
  14:    23721..   24004:  289214134.. 289214417:    284:  289046636:
shared
  15:    24005..   24784:  289046920.. 289047699:    780:  289214418:
shared
  16:    24785..   31903:  289224584.. 289231702:   7119:  289047700:
shared
  17:    31904..   34332:  289096507.. 289098935:   2429:  289231703:
shared
  18:    34333..   35396:  289214898.. 289215961:   1064:  289098936:
shared
  19:    35397..   45075:  289153956.. 289163634:   9679:  289215962:
shared
  20:    45076..  550711:  289336838.. 289842473: 505636:  289163635:
last,shared,eof
/mnt/storage/from-restic/04683ed4/tmp/fast/c14-sd-92016-2-home/2017-06-
07-233355/2017-06-07-233355/edwin/.mu/xapian/postlist.DB: 21 extents
found
File size of /mnt/storage/from-restic/0fcf01c9/tmp/fast/c14-sd-92016-2-
home/2017-05-23-233346/2017-05-23-233346/edwin/.mu/xapian/postlist.DB
is 2255716352 (550712 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected:
flags:
   0:        0..     650:  289205390..
289206040:    651:             shared
   1:      651..     827:  288864297.. 288864473:    177:  289206041:
shared
   2:      828..    1098:  289206041.. 289206311:    271:  288864474:
shared
   3:     1099..    1490:  288947797.. 288948188:    392:  289206312:
shared
   4:     1491..    1928:  289206312.. 289206749:    438:  288948189:
shared
   5:     1929..    3078:  289024844.. 289025993:   1150:  289206750:
shared
   6:     3079..    7504:  289206750.. 289211175:   4426:  289025994:
shared
   7:     7505..   10083:  289030420.. 289032998:   2579:  289211176:
shared
   8:    10084..   11930:  289211176.. 289213022:   1847:  289032999:
shared
   9:    11931..   13072:  289034846.. 289035987:   1142:  289213023:
shared
  10:    13073..   14183:  289213023.. 289214133:   1111:  289035988:
shared
  11:    14184..   15536:  289037099.. 289038451:   1353:  289214134:
shared
  12:    15537..   20897:  289219223.. 289224583:   5361:  289038452:
shared
  13:    20898..   23720:  289043813.. 289046635:   2823:  289224584:
shared
  14:    23721..   24004:  289214134.. 289214417:    284:  289046636:
shared
  15:    24005..   24784:  289046920.. 289047699:    780:  289214418:
shared
  16:    24785..   31903:  289224584.. 289231702:   7119:  289047700:
shared
  17:    31904..   34332:  289096507.. 289098935:   2429:  289231703:
shared
  18:    34333..   35396:  289214898.. 289215961:   1064:  289098936:
shared
  19:    35397..   45075:  289153956.. 289163634:   9679:  289215962:
shared
  20:    45076..  550711:  289336838.. 289842473: 505636:  289163635:
last,shared,eof
/mnt/storage/from-restic/0fcf01c9/tmp/fast/c14-sd-92016-2-home/2017-05-
23-233346/2017-05-23-233346/edwin/.mu/xapian/postlist.DB: 21 extents
found
File size of /mnt/storage/from-restic/10350278/tmp/fast/c14-sd-92016-2-
home/2017-06-17-233341/2017-06-17-233341/edwin/.mu/xapian/postlist.DB
is 2255716352 (550712 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected:
flags:
   0:        0..     650:  289205390..
289206040:    651:             shared
   1:      651..     827:  288864297.. 288864473:    177:  289206041:
shared
   2:      828..    1098:  289206041.. 289206311:    271:  288864474:
shared
   3:     1099..    1490:  288947797.. 288948188:    392:  289206312:
shared
   4:     1491..    1928:  289206312.. 289206749:    438:  288948189:
shared
   5:     1929..    3078:  289024844.. 289025993:   1150:  289206750:
shared
   6:     3079..    7504:  289206750.. 289211175:   4426:  289025994:
shared
   7:     7505..   10083:  289030420.. 289032998:   2579:  289211176:
shared
   8:    10084..   11930:  289211176.. 289213022:   1847:  289032999:
shared
   9:    11931..   13072:  289034846.. 289035987:   1142:  289213023:
shared
  10:    13073..   14183:  289213023.. 289214133:   1111:  289035988:
shared
  11:    14184..   15536:  289037099.. 289038451:   1353:  289214134:
shared
  12:    15537..   20897:  289219223.. 289224583:   5361:  289038452:
shared
  13:    20898..   23720:  289043813.. 289046635:   2823:  289224584:
shared
  14:    23721..   24004:  289214134.. 289214417:    284:  289046636:
shared
  15:    24005..   24784:  289046920.. 289047699:    780:  289214418:
shared
  16:    24785..   31903:  289224584.. 289231702:   7119:  289047700:
shared
  17:    31904..   34332:  289096507.. 289098935:   2429:  289231703:
shared
  18:    34333..   35396:  289214898.. 289215961:   1064:  289098936:
shared
  19:    35397..   45075:  289153956.. 289163634:   9679:  289215962:
shared
  20:    45076..  550711:  289336838.. 289842473: 505636:  289163635:
last,shared,eof
/mnt/storage/from-restic/10350278/tmp/fast/c14-sd-92016-2-home/2017-06-
17-233341/2017-06-17-233341/edwin/.mu/xapian/postlist.DB: 21 extents
found

Looking at duperemove's database there are some files with high reflink
counts:

sqlite> select hex(digest), count(ino) as c from hashes group by digest
order by c desc limit 30;
E47862EAC39A71995587EC6F98C0F77E|120826
603774B45A054235A3EA9973C0326B1A|1146
1155F3DE7E9760BD3774A084F651E734|1126
737B0085639F6182B8975B253673CC0F|1126
1E49066D483DC85F597AA1E311B759C8|852
25F03E77F28B29812EF7BC467E2AB8A3|720
3D1DA8B943984CAA28D8143E57CF2AD2|720
49EDE0A7B5BF869DDF0EC58D97B88CA6|720
514E20541D0F06B15042E7F60D656F6E|720
9D05E927C2CBFF1B95B4CD423CB82683|720
A5630A5CCA0D495679BCDB0E9B118459|720
EE94AF6B4F3E1B53781AC5202297D4CF|720
66952AB2F45AD72E5E4F7F5753C45A42|702
3028010B6254DA58C5A7A83FD57EA5D8|612
8A35D931C2A52EC0BAE0F8499FE9D56B|603
167F01605D23CB6DDA52FD3036CB9925|593
5BC8DAF52583CA428096C2B5046B2329|593
C1A98787EF8CF318311AE2FAECB526EC|593
ABDC9B93518EFB347F6FBD6FE7D2F8FE|421
4DAA7ECCAA161C148624495563211F81|395
4E08DB53E7E602136CB0E5A8886761C7|395
5DFDE0C5AA5CA52429389FF516B69012|395
72E52A135D6DF5C931E3660FA30F5856|395
7D7F1D1345C7E22E211B9253F2A0DC34|395
87B61864CDF325C831B6B2B6B99B9217|395
A191E341458429624A534414547251FD|395
A932C7FD8269F6941A84F9F4DC573E59|395
B0B52DE7472FC02EB92836B875A92A05|395
A84CFAD1E5BCD8CC8DA1FBFEB8BAD520|363
1304E6AF0087B5498184C9532B79207F|358

> 
> (Obviously, a full metadump would be useful for confirming the shape
> of
> the refcount btree, but...first things first let's look at the
> filefrag
> output.)

I'll try to gather one, and find a place to store/share it.

Best regards,
--Edwin

> 
> --D
> 

