Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 929067F3F
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2014 05:05:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4ABB18F8033
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2014 03:05:00 -0700 (PDT)
Received: from mail-la0-f49.google.com (mail-la0-f49.google.com
	[209.85.215.49]) by cuda.sgi.com with ESMTP id G22gXskEzwcW8lD0
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Aug 2014 03:04:54 -0700 (PDT)
Received: by mail-la0-f49.google.com with SMTP id hz20so14489866lab.22
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2014 03:04:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140826023754.GH20518@dastard>
References: <CAKEtwsWxZseS8M+O7vSR2FRXr4gjVQ0RDO8ok+jMPWq-8jPEeA@mail.gmail.com>
	<20140825051801.GY26465@dastard>
	<CAKEtwsXiVKTWAW+YszjNnFnD4_Ld7g2qXEvw48A-SitYSGyXHA@mail.gmail.com>
	<20140825090843.GE20518@dastard>
	<CAKEtwsU4gywG7fVVMVU1Y_TG9Pgg_-sFV0=SPg_7Ob5EV6FTew@mail.gmail.com>
	<20140825222657.GF20518@dastard>
	<CAGpXXZL2=ynv4x6hhBSsBPZmBG9Ac8mPOgE-Ekjs3tLvQO9Uaw@mail.gmail.com>
	<20140826023754.GH20518@dastard>
Date: Tue, 26 Aug 2014 18:04:52 +0800
Message-ID: <CAKEtwsW=6Wh3rdaNvmNbiOq1iUm+=xAwL0FsNhcmpKwkQrN9Ww@mail.gmail.com>
Subject: Re: bad performance on touch/cp file on XFS system
From: Zhang Qiang <zhangqiang.buaa@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5467159692674856613=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, xfs-oss <xfs@oss.sgi.com>

--===============5467159692674856613==
Content-Type: multipart/alternative; boundary=001a1133b07047794b0501856f4a

--001a1133b07047794b0501856f4a
Content-Type: text/plain; charset=UTF-8

Thanks Dave/Greg for your analysis and suggestions.

I can summarize what I should do next:

- backup my data using xfsdump
- rebuilt filesystem using mkfs with options: agcount=32 for 2T disk
- mount filesystem with option inode64,nobarrier
- applied patches about adding free list inode on disk structure

As we have about ~100 servers need back up, so that will take much effort,
do you have any other suggestion?

What I am testing (ongoing):
 - created a new 2T partition filesystem
 - try to create small files and fill whole spaces then remove some of them
randomly
 - check the performance of touch/cp files
 - apply patches and verify it.

I have got more data from server:

1) flush all cache(echo 3 > /proc/sys/vm/drop_caches), and umount filesystem
2) mount filesystem and testing with touch command
  * The first touch new file command take about ~23s
  * second touch command take about ~0.1s.

Here's the perf data:
First touch command:

Events: 435  cycles
+   7.51%  touch  [xfs]              [k] xfs_inobt_get_rec
+   5.61%  touch  [xfs]              [k] xfs_btree_get_block
+   5.38%  touch  [xfs]              [k] xfs_btree_increment
+   4.26%  touch  [xfs]              [k] xfs_btree_get_rec
+   3.73%  touch  [kernel.kallsyms]  [k] find_busiest_group
+   3.43%  touch  [xfs]              [k] _xfs_buf_find
+   2.72%  touch  [xfs]              [k] xfs_btree_readahead
+   2.38%  touch  [xfs]              [k] xfs_trans_buf_item_match
+   2.34%  touch  [xfs]              [k] xfs_dialloc
+   2.32%  touch  [kernel.kallsyms]  [k] generic_make_request
+   2.09%  touch  [xfs]              [k] xfs_btree_rec_offset
+   1.75%  touch  [kernel.kallsyms]  [k] kmem_cache_alloc
+   1.63%  touch  [kernel.kallsyms]  [k] cpumask_next_and
+   1.41%  touch  [sd_mod]           [k] sd_prep_fn
+   1.41%  touch  [kernel.kallsyms]  [k] get_page_from_freelist
+   1.38%  touch  [kernel.kallsyms]  [k] __alloc_pages_nodemask
+   1.27%  touch  [kernel.kallsyms]  [k] scsi_request_fn
+   1.22%  touch  [kernel.kallsyms]  [k] blk_queue_bounce
+   1.20%  touch  [kernel.kallsyms]  [k] cfq_should_idle
+   1.10%  touch  [xfs]              [k] xfs_btree_rec_addr
+   1.03%  touch  [kernel.kallsyms]  [k] cfq_dispatch_requests+   1.00%
 touch  [kernel.kallsyms]  [k] _spin_lock_irqsave+   0.94%  touch
 [kernel.kallsyms]  [k] memcpy+   0.86%  touch  [kernel.kallsyms]  [k]
swiotlb_map_sg_attrs+   0.84%  touch  [kernel.kallsyms]  [k]
alloc_pages_current
+   0.82%  touch  [kernel.kallsyms]  [k] submit_bio
+   0.81%  touch  [megaraid_sas]     [k] megasas_build_and_issue_cmd_fusion
+   0.77%  touch  [kernel.kallsyms]  [k] blk_peek_request
+   0.73%  touch  [xfs]              [k] xfs_btree_setbuf
+   0.73%  touch  [megaraid_sas]     [k] MR_GetPhyParams
+   0.73%  touch  [kernel.kallsyms]  [k] run_timer_softirq
+   0.71%  touch  [kernel.kallsyms]  [k] pick_next_task_rt
+   0.71%  touch  [kernel.kallsyms]  [k] init_request_from_bio
+   0.70%  touch  [kernel.kallsyms]  [k] thread_return
+   0.69%  touch  [kernel.kallsyms]  [k] cfq_set_request
+   0.67%  touch  [kernel.kallsyms]  [k] mempool_alloc
+   0.66%  touch  [xfs]              [k] xfs_buf_hold
+   0.66%  touch  [kernel.kallsyms]  [k] find_next_bit
+   0.62%  touch  [kernel.kallsyms]  [k] cfq_insert_request
+   0.61%  touch  [kernel.kallsyms]  [k] scsi_init_io
+   0.60%  touch  [megaraid_sas]     [k] MR_BuildRaidContext
+   0.59%  touch  [kernel.kallsyms]  [k] policy_zonelist
+   0.59%  touch  [kernel.kallsyms]  [k] elv_insert
+   0.58%  touch  [xfs]              [k] xfs_buf_allocate_memory


Second perf command:


Events: 105  cycles
+  20.92%  touch  [xfs]              [k] xfs_inobt_get_rec
+  14.27%  touch  [xfs]              [k] xfs_btree_get_rec
+  12.21%  touch  [xfs]              [k] xfs_btree_get_block
+  12.12%  touch  [xfs]              [k] xfs_btree_increment
+   9.86%  touch  [xfs]              [k] xfs_btree_readahead
+   7.87%  touch  [xfs]              [k] _xfs_buf_find
+   4.93%  touch  [xfs]              [k] xfs_btree_rec_addr
+   4.12%  touch  [xfs]              [k] xfs_dialloc
+   3.03%  touch  [kernel.kallsyms]  [k] clear_page_c
+   2.96%  touch  [xfs]              [k] xfs_btree_rec_offset
+   1.31%  touch  [kernel.kallsyms]  [k] kmem_cache_free
+   1.03%  touch  [xfs]              [k] xfs_trans_buf_item_match
+   0.99%  touch  [kernel.kallsyms]  [k] _atomic_dec_and_lock
+   0.99%  touch  [xfs]              [k] xfs_inobt_get_maxrecs
+   0.99%  touch  [xfs]              [k] xfs_buf_unlock
+   0.99%  touch  [xfs]              [k] kmem_zone_alloc
+   0.98%  touch  [kernel.kallsyms]  [k] kmem_cache_alloc
+   0.28%  touch  [kernel.kallsyms]  [k] pgd_alloc
+   0.17%  touch  [kernel.kallsyms]  [k] page_fault
+   0.01%  touch  [kernel.kallsyms]  [k] native_write_msr_safe

I have compared the memory used, it seems that xfs try to load inode bmap
block for the first time, which take much time, is that the reason to take
so much time for the first touch operation?

Thanks
Qiang
2014-08-26 10:37 GMT+08:00 Dave Chinner <david@fromorbit.com>:

> On Mon, Aug 25, 2014 at 06:46:31PM -0400, Greg Freemyer wrote:
> > On Mon, Aug 25, 2014 at 6:26 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> > > On Mon, Aug 25, 2014 at 06:31:10PM +0800, Zhang Qiang wrote:
> > >> 2014-08-25 17:08 GMT+08:00 Dave Chinner <david@fromorbit.com>:
> > >>
> > >> > On Mon, Aug 25, 2014 at 04:47:39PM +0800, Zhang Qiang wrote:
> > >> > > I have checked icount and ifree, but I found there are about 11.8
> percent
> > >> > > free, so the free inode should not be too few.
> > >> > >
> > >> > > Here's the detail log, any new clue?
> > >> > >
> > >> > > # mount /dev/sda4 /data1/
> > >> > > # xfs_info /data1/
> > >> > > meta-data=/dev/sda4              isize=256    agcount=4,
> agsize=142272384
> > >> >
> > >> > 4 AGs
> > >> >
> > >> Yes.
> > >>
> > >> >
> > >> > > icount = 220619904
> > >> > > ifree = 26202919
> > >> >
> > >> > And 220 million inodes. There's your problem - that's an average
> > >> > of 55 million inodes per AGI btree assuming you are using inode64.
> > >> > If you are using inode32, then the inodes will be in 2 btrees, or
> > >> > maybe even only one.
> > >> >
> > >>
> > >> You are right, all inodes stay on one AG.
> > >>
> > >> BTW, why i allocate 4 AGs, and all inodes stay in one AG for inode32?,
> > >
> > > Because the top addresses in the 2nd AG go over 32 bits, hence only
> > > AG 0 can be used for inodes. Changing to inode64 will give you some
> > > relief, but any time allocation occurs in AG0 is will be slow. i.e.
> > > you'll be trading always slow for "unpredictably slow".
> > >
> > >> > With that many inodes, I'd be considering moving to 32 or 64 AGs to
> > >> > keep the btree size down to a more manageable size. The free inode
> > >>
> > >> btree would also help, but, really, 220M inodes in a 2TB filesystem
> > >> > is really pushing the boundaries of sanity.....
> > >> >
> > >>
> > >> So the better inodes size in one AG is about 5M,
> > >
> > > Not necessarily. But for your storage it's almost certainly going to
> > > minimise the problem you are seeing.
> > >
> > >> is there any documents
> > >> about these options I can learn more?
> > >
> > > http://xfs.org/index.php/XFS_Papers_and_Documentation
> >
> > Given the apparently huge number of small files would he likely see a
> > big performance increase if he replaced that 2TB or rust with SSD.
>
> Doubt it - the profiles showed the allocation being CPU bound
> searching the metadata that indexes all those inodes. Those same
> profiles showed all the signs that it was hitting the buffer
> cache most of the time, too, which is why it was CPU bound....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a1133b07047794b0501856f4a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks=C2=A0<span style=3D"color:rgb(80,0,80)">Dave/</span=
>Greg for your analysis and suggestions.<div><br></div><div>I can summarize=
 what I should do next:</div><div><br></div><div>- backup my data using xfs=
dump</div>
<div>- rebuilt filesystem using mkfs with options: agcount=3D32 for 2T disk=
</div><div>- mount filesystem with option inode64,nobarrier</div><div>- app=
lied patches about adding free list inode on disk structure</div><div><br>
</div><div>As we have about ~100 servers need back up, so that will take mu=
ch effort, do you have any other suggestion?</div><div><br></div><div>What =
I am testing (ongoing):<br></div><div>=C2=A0- created a new 2T partition fi=
lesystem<br>
</div><div>=C2=A0- try to create small files and fill whole spaces then rem=
ove some of them randomly</div><div>=C2=A0- check the performance of touch/=
cp files</div><div>=C2=A0- apply patches and verify it.</div><div><br></div=
><div>I have got more data from server:<br>
</div><div><br></div><div>1) flush all cache(echo 3 &gt; /proc/sys/vm/drop_=
caches), and umount filesystem</div><div>2) mount filesystem and testing wi=
th touch command</div><div>=C2=A0 * The first touch new file command take a=
bout ~23s</div>
<div>=C2=A0 * second touch command take about ~0.1s.</div><div><br></div><d=
iv>Here&#39;s the perf data:</div><div>First touch command:<br></div><div><=
br></div><div><div>Events: 435 =C2=A0cycles</div><div>+ =C2=A0 7.51% =C2=A0=
touch =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_i=
nobt_get_rec</div>
<div>+ =C2=A0 5.61% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[k] xfs_btree_get_block</div><div>+ =C2=A0 5.38% =C2=A0tou=
ch =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_btre=
e_increment</div><div>+ =C2=A0 4.26% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_btree_get_rec</div><div>+ =C2=A0 =
3.73% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] find_busiest_group</div=
>
<div>+ =C2=A0 3.43% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[k] _xfs_buf_find</div><div>+ =C2=A0 2.72% =C2=A0touch =C2=
=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_btree_read=
ahead</div><div>+ =C2=A0 2.38% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_trans_buf_item_match</div><div>+ =C2=A0=
 2.34% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0[k] xfs_dialloc</div>
<div>+ =C2=A0 2.32% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] generic_m=
ake_request</div><div>+ =C2=A0 2.09% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_btree_rec_offset</div><div>+ =C2=
=A0 1.75% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] kmem_cache_alloc</d=
iv><div>+ =C2=A0 1.63% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] cpumas=
k_next_and</div>
<div>+ =C2=A0 1.41% =C2=A0touch =C2=A0[sd_mod] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 [k] sd_prep_fn</div><div>+ =C2=A0 1.41% =C2=A0touch =C2=A0[kernel.ka=
llsyms] =C2=A0[k] get_page_from_freelist</div><div>+ =C2=A0 1.38% =C2=A0tou=
ch =C2=A0[kernel.kallsyms] =C2=A0[k] __alloc_pages_nodemask</div><div>+ =C2=
=A0 1.27% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] scsi_request_fn</di=
v>
<div>+ =C2=A0 1.22% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] blk_queue=
_bounce</div><div>+ =C2=A0 1.20% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0=
[k] cfq_should_idle</div><div>+ =C2=A0 1.10% =C2=A0touch =C2=A0[xfs] =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_btree_rec_addr</div><div>=
+ =C2=A0 1.03% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] cfq_dispatch_r=
equests+ =C2=A0 1.00% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] _spin_l=
ock_irqsave+ =C2=A0 0.94% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] mem=
cpy+ =C2=A0 0.86% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] swiotlb_map=
_sg_attrs+ =C2=A0 0.84% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] alloc=
_pages_current</div>
<div>+ =C2=A0 0.82% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] submit_bi=
o</div><div>+ =C2=A0 0.81% =C2=A0touch =C2=A0[megaraid_sas] =C2=A0 =C2=A0 [=
k] megasas_build_and_issue_cmd_fusion</div><div>+ =C2=A0 0.77% =C2=A0touch =
=C2=A0[kernel.kallsyms] =C2=A0[k] blk_peek_request</div><div>
+ =C2=A0 0.73% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0[k] xfs_btree_setbuf</div><div>+ =C2=A0 0.73% =C2=A0touch =C2=
=A0[megaraid_sas] =C2=A0 =C2=A0 [k] MR_GetPhyParams</div><div>+ =C2=A0 0.73=
% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] run_timer_softirq</div><div=
>+ =C2=A0 0.71% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] pick_next_tas=
k_rt</div>
<div>+ =C2=A0 0.71% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] init_requ=
est_from_bio</div><div>+ =C2=A0 0.70% =C2=A0touch =C2=A0[kernel.kallsyms] =
=C2=A0[k] thread_return</div><div>+ =C2=A0 0.69% =C2=A0touch =C2=A0[kernel.=
kallsyms] =C2=A0[k] cfq_set_request</div><div>+ =C2=A0 0.67% =C2=A0touch =
=C2=A0[kernel.kallsyms] =C2=A0[k] mempool_alloc</div>
<div>+ =C2=A0 0.66% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[k] xfs_buf_hold</div><div>+ =C2=A0 0.66% =C2=A0touch =C2=
=A0[kernel.kallsyms] =C2=A0[k] find_next_bit</div><div>+ =C2=A0 0.62% =C2=
=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] cfq_insert_request</div><div>+ =
=C2=A0 0.61% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] scsi_init_io</di=
v>
<div>+ =C2=A0 0.60% =C2=A0touch =C2=A0[megaraid_sas] =C2=A0 =C2=A0 [k] MR_B=
uildRaidContext</div><div>+ =C2=A0 0.59% =C2=A0touch =C2=A0[kernel.kallsyms=
] =C2=A0[k] policy_zonelist</div><div>+ =C2=A0 0.59% =C2=A0touch =C2=A0[ker=
nel.kallsyms] =C2=A0[k] elv_insert</div><div>+ =C2=A0 0.58% =C2=A0touch =C2=
=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_buf_alloca=
te_memory</div>
</div><div><br></div><div><br></div><div>Second perf command:</div><div><br=
></div><div><br></div><div><div>Events: 105 =C2=A0cycles</div><div>+ =C2=A0=
20.92% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0[k] xfs_inobt_get_rec</div><div>+ =C2=A014.27% =C2=A0touch =C2=A0[xfs=
] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_btree_get_rec</di=
v>
<div>+ =C2=A012.21% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[k] xfs_btree_get_block</div><div>+ =C2=A012.12% =C2=A0tou=
ch =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_btre=
e_increment</div><div>+ =C2=A0 9.86% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_btree_readahead</div><div>+ =C2=
=A0 7.87% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0[k] _xfs_buf_find</div>
<div>+ =C2=A0 4.93% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[k] xfs_btree_rec_addr</div><div>+ =C2=A0 4.12% =C2=A0touc=
h =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_diall=
oc</div><div>+ =C2=A0 3.03% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] c=
lear_page_c</div><div>+ =C2=A0 2.96% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_btree_rec_offset</div>
<div>+ =C2=A0 1.31% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] kmem_cach=
e_free</div><div>+ =C2=A0 1.03% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_trans_buf_item_match</div><div>+ =C2=
=A0 0.99% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] _atomic_dec_and_loc=
k</div><div>+ =C2=A0 0.99% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_inobt_get_maxrecs</div>
<div>+ =C2=A0 0.99% =C2=A0touch =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[k] xfs_buf_unlock</div><div>+ =C2=A0 0.99% =C2=A0touch =
=C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] kmem_zone_a=
lloc</div><div>+ =C2=A0 0.98% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k]=
 kmem_cache_alloc</div><div>+ =C2=A0 0.28% =C2=A0touch =C2=A0[kernel.kallsy=
ms] =C2=A0[k] pgd_alloc</div>
<div>+ =C2=A0 0.17% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] page_faul=
t</div><div>+ =C2=A0 0.01% =C2=A0touch =C2=A0[kernel.kallsyms] =C2=A0[k] na=
tive_write_msr_safe</div></div><div><br></div><div>I have compared the memo=
ry used, it seems that xfs try to load inode bmap block for the first time,=
 which take much time, is that the reason to take so much time for the firs=
t touch operation?</div>
<div><br></div><div>Thanks<br></div><div>Qiang</div><div>2014-08-26 10:37 G=
MT+08:00 Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorb=
it.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span>:<br></div><div=
><div>
<div class=3D"gmail_extra"><div class=3D"gmail_quote"><blockquote class=3D"=
gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border=
-left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex"><div=
 class=3D"">
<div class=3D"h5">On Mon, Aug 25, 2014 at 06:46:31PM -0400, Greg Freemyer w=
rote:<br>
&gt; On Mon, Aug 25, 2014 at 6:26 PM, Dave Chinner &lt;<a href=3D"mailto:da=
vid@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>
&gt; &gt; On Mon, Aug 25, 2014 at 06:31:10PM +0800, Zhang Qiang wrote:<br>
&gt; &gt;&gt; 2014-08-25 17:08 GMT+08:00 Dave Chinner &lt;<a href=3D"mailto=
:david@fromorbit.com">david@fromorbit.com</a>&gt;:<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; &gt; On Mon, Aug 25, 2014 at 04:47:39PM +0800, Zhang Qiang wr=
ote:<br>
&gt; &gt;&gt; &gt; &gt; I have checked icount and ifree, but I found there =
are about 11.8 percent<br>
&gt; &gt;&gt; &gt; &gt; free, so the free inode should not be too few.<br>
&gt; &gt;&gt; &gt; &gt;<br>
&gt; &gt;&gt; &gt; &gt; Here&#39;s the detail log, any new clue?<br>
&gt; &gt;&gt; &gt; &gt;<br>
&gt; &gt;&gt; &gt; &gt; # mount /dev/sda4 /data1/<br>
&gt; &gt;&gt; &gt; &gt; # xfs_info /data1/<br>
&gt; &gt;&gt; &gt; &gt; meta-data=3D/dev/sda4=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 isize=3D256=C2=A0 =C2=A0 agcount=3D4, agsize=3D1422723=
84<br>
&gt; &gt;&gt; &gt;<br>
&gt; &gt;&gt; &gt; 4 AGs<br>
&gt; &gt;&gt; &gt;<br>
&gt; &gt;&gt; Yes.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; &gt;<br>
&gt; &gt;&gt; &gt; &gt; icount =3D 220619904<br>
&gt; &gt;&gt; &gt; &gt; ifree =3D 26202919<br>
&gt; &gt;&gt; &gt;<br>
&gt; &gt;&gt; &gt; And 220 million inodes. There&#39;s your problem - that&=
#39;s an average<br>
&gt; &gt;&gt; &gt; of 55 million inodes per AGI btree assuming you are usin=
g inode64.<br>
&gt; &gt;&gt; &gt; If you are using inode32, then the inodes will be in 2 b=
trees, or<br>
&gt; &gt;&gt; &gt; maybe even only one.<br>
&gt; &gt;&gt; &gt;<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; You are right, all inodes stay on one AG.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; BTW, why i allocate 4 AGs, and all inodes stay in one AG for =
inode32?,<br>
&gt; &gt;<br>
&gt; &gt; Because the top addresses in the 2nd AG go over 32 bits, hence on=
ly<br>
&gt; &gt; AG 0 can be used for inodes. Changing to inode64 will give you so=
me<br>
&gt; &gt; relief, but any time allocation occurs in AG0 is will be slow. i.=
e.<br>
&gt; &gt; you&#39;ll be trading always slow for &quot;unpredictably slow&qu=
ot;.<br>
&gt; &gt;<br>
&gt; &gt;&gt; &gt; With that many inodes, I&#39;d be considering moving to =
32 or 64 AGs to<br>
&gt; &gt;&gt; &gt; keep the btree size down to a more manageable size. The =
free inode<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; btree would also help, but, really, 220M inodes in a 2TB file=
system<br>
&gt; &gt;&gt; &gt; is really pushing the boundaries of sanity.....<br>
&gt; &gt;&gt; &gt;<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; So the better inodes size in one AG is about 5M,<br>
&gt; &gt;<br>
&gt; &gt; Not necessarily. But for your storage it&#39;s almost certainly g=
oing to<br>
&gt; &gt; minimise the problem you are seeing.<br>
&gt; &gt;<br>
&gt; &gt;&gt; is there any documents<br>
&gt; &gt;&gt; about these options I can learn more?<br>
&gt; &gt;<br>
&gt; &gt; <a href=3D"http://xfs.org/index.php/XFS_Papers_and_Documentation"=
 target=3D"_blank">http://xfs.org/index.php/XFS_Papers_and_Documentation</a=
><br>
&gt;<br>
&gt; Given the apparently huge number of small files would he likely see a<=
br>
&gt; big performance increase if he replaced that 2TB or rust with SSD.<br>
<br>
</div></div>Doubt it - the profiles showed the allocation being CPU bound<b=
r>
searching the metadata that indexes all those inodes. Those same<br>
profiles showed all the signs that it was hitting the buffer<br>
cache most of the time, too, which is why it was CPU bound....<br>
<div class=3D""><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div></div></div></div>

--001a1133b07047794b0501856f4a--


--===============5467159692674856613==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5467159692674856613==--
