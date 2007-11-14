Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Nov 2007 05:20:41 -0800 (PST)
Received: from fieldses.org (mail.fieldses.org [66.93.2.214])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAEDKK1N013703
	for <linux-xfs@oss.sgi.com>; Wed, 14 Nov 2007 05:20:21 -0800
Date: Wed, 14 Nov 2007 07:59:07 -0500
Subject: Re: 2.6.24-rc2 XFS nfsd hang
Message-ID: <20071114125907.GB4010@fieldses.org>
References: <20071114070400.GA25708@puku.stupidest.org> <473AA72C.6020308@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473AA72C.6020308@panasas.com>
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Benny Halevy <bhalevy@panasas.com>
Cc: Chris Wedgwood <cw@f00f.org>, linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>, Christian Kujau <lists@nerdbynature.de>

On Wed, Nov 14, 2007 at 09:43:40AM +0200, Benny Halevy wrote:
> I wonder if this is a similar hang to what Christian was seeing here:
> http://lkml.org/lkml/2007/11/13/319

Ah, thanks for noticing that.  Christian Kujau, is /data an xfs
partition?  There are a bunch of xfs commits in

^92d15c2ccbb3e31a3fc71ad28fdb55e1319383c0
^291702f017efdfe556cb87b8530eb7d1ff08cbae
^1d677a6dfaac1d1cf51a7f58847077240985faf2
^fba956c46a72f9e7503fd464ffee43c632307e31
^bbf25010f1a6b761914430f5fca081ec8c7accd1
6e800af233e0bdf108efb7bd23c11ea6fa34cdeb
7b1915a989ea4d426d0fd98974ab80f30ef1d779
c223701cf6c706f42840631c1ca919a18e6e2800
f77bf01425b11947eeb3b5b54685212c302741b8 

which was the range remaining for him to bisect.

--b.

> 
> Benny
> 
> On Nov. 14, 2007, 9:04 +0200, Chris Wedgwood <cw@f00f.org> wrote:
> > With 2.6.24-rc2 (amd64) I sometimes (usually but perhaps not always)
> > see a hang when accessing some NFS exported XFS filesystems.  Local
> > access to these filesystems ahead of time works without problems.
> > 
> > This does not occur with 2.6.23.1.  The filesystem does not appear to
> > be corrupt.
> > 
> > 
> > The call chain for the wedged process is:
> > 
> >     [ 1462.911256] nfsd          D ffffffff80547840  4760  2966      2
> >     [ 1462.911283]  ffff81010414d4d0 0000000000000046 0000000000000000 ffff81010414d610
> >     [ 1462.911322]  ffff810104cbc6e0 ffff81010414d480 ffffffff80746dc0 ffffffff80746dc0
> >     [ 1462.911360]  ffffffff80744020 ffffffff80746dc0 ffff81010129c140 ffff8101000ad100
> >     [ 1462.911391] Call Trace:
> >     [ 1462.911417]  [<ffffffff8052e638>] __down+0xe9/0x101
> >     [ 1462.911437]  [<ffffffff8022cc80>] default_wake_function+0x0/0xe
> >     [ 1462.911458]  [<ffffffff8052e275>] __down_failed+0x35/0x3a
> >     [ 1462.911480]  [<ffffffff8035ac25>] _xfs_buf_find+0x84/0x24d
> >     [ 1462.911501]  [<ffffffff8035ad34>] _xfs_buf_find+0x193/0x24d
> >     [ 1462.911522]  [<ffffffff803599b1>] xfs_buf_lock+0x43/0x45
> >     [ 1462.911543]  [<ffffffff8035ad5b>] _xfs_buf_find+0x1ba/0x24d
> >     [ 1462.911564]  [<ffffffff8035ae48>] xfs_buf_get_flags+0x5a/0x14b
> >     [ 1462.911586]  [<ffffffff8035b490>] xfs_buf_read_flags+0x12/0x86
> >     [ 1462.911607]  [<ffffffff8034ecf6>] xfs_trans_read_buf+0x4c/0x2cf
> >     [ 1462.911629]  [<ffffffff803292be>] xfs_da_do_buf+0x41b/0x65b
> >     [ 1462.911652]  [<ffffffff80329568>] xfs_da_read_buf+0x24/0x29
> >     [ 1462.911673]  [<ffffffff8032be40>] xfs_dir2_block_lookup_int+0x4d/0x1ab
> >     [ 1462.911694]  [<ffffffff8032be40>] xfs_dir2_block_lookup_int+0x4d/0x1ab
> >     [ 1462.911717]  [<ffffffff8032c718>] xfs_dir2_block_lookup+0x15/0x8e
> >     [ 1462.911738]  [<ffffffff8032b8e1>] xfs_dir_lookup+0xd2/0x12c
> >     [ 1462.911761]  [<ffffffff8036d658>] submit_bio+0x10d/0x114
> >     [ 1462.911781]  [<ffffffff8034fb56>] xfs_dir_lookup_int+0x2c/0xc5
> >     [ 1462.911802]  [<ffffffff802507a2>] lockdep_init_map+0x90/0x495
> >     [ 1462.911823]  [<ffffffff80353436>] xfs_lookup+0x44/0x6f
> >     [ 1462.911843]  [<ffffffff8035e364>] xfs_vn_lookup+0x29/0x60
> >     [ 1462.915246]  [<ffffffff8028856c>] __lookup_hash+0xe5/0x109
> >     [ 1462.915267]  [<ffffffff802893dd>] lookup_one_len+0x41/0x4e
> >     [ 1462.915289]  [<ffffffff80303d05>] compose_entry_fh+0xc1/0x117
> >     [ 1462.915311]  [<ffffffff80303f4c>] encode_entry+0x17c/0x38b
> >     [ 1462.915333]  [<ffffffff80261e4e>] find_or_create_page+0x3f/0xc9
> >     [ 1462.915355]  [<ffffffff8035a2c0>] _xfs_buf_lookup_pages+0x2c1/0x2f6
> >     [ 1462.915377]  [<ffffffff8052ec6b>] _spin_unlock+0x1f/0x49
> >     [ 1462.915399]  [<ffffffff8027e632>] cache_alloc_refill+0x1ba/0x4b9
> >     [ 1462.915424]  [<ffffffff8030415b>] nfs3svc_encode_entry_plus+0x0/0x13
> >     [ 1462.915448]  [<ffffffff8030416b>] nfs3svc_encode_entry_plus+0x10/0x13
> >     [ 1462.915469]  [<ffffffff8032c67c>] xfs_dir2_block_getdents+0x15b/0x1e2
> >     [ 1462.915491]  [<ffffffff8030415b>] nfs3svc_encode_entry_plus+0x0/0x13
> >     [ 1462.915514]  [<ffffffff8030415b>] nfs3svc_encode_entry_plus+0x0/0x13
> >     [ 1462.915534]  [<ffffffff8032b6da>] xfs_readdir+0x91/0xb6
> >     [ 1462.915557]  [<ffffffff8030415b>] nfs3svc_encode_entry_plus+0x0/0x13
> >     [ 1462.915579]  [<ffffffff8035be9d>] xfs_file_readdir+0x31/0x40
> >     [ 1462.915599]  [<ffffffff8028c9f8>] vfs_readdir+0x61/0x93
> >     [ 1462.915619]  [<ffffffff8030415b>] nfs3svc_encode_entry_plus+0x0/0x13
> >     [ 1462.915642]  [<ffffffff802fc78e>] nfsd_readdir+0x6d/0xc5
> >     [ 1462.915663]  [<ffffffff80303158>] nfsd3_proc_readdirplus+0x114/0x204
> >     [ 1462.915686]  [<ffffffff802f8b82>] nfsd_dispatch+0xde/0x1b6
> >     [ 1462.915706]  [<ffffffff805215cd>] svc_process+0x3f8/0x717
> >     [ 1462.915729]  [<ffffffff802f9148>] nfsd+0x1a9/0x2c1
> >     [ 1462.915749]  [<ffffffff8020c648>] child_rip+0xa/0x12
> >     [ 1462.915769]  [<ffffffff80520af8>] __svc_create_thread+0xea/0x1eb
> >     [ 1462.915792]  [<ffffffff802f8f9f>] nfsd+0x0/0x2c1
> >     [ 1462.915812]  [<ffffffff8020c63e>] child_rip+0x0/0x12
> > 
> > Over time other processes pile up beind this.
> > 
> >     [ 1462.910728] nfsd          D ffffffffffffffff  5440  2965      2
> >     [ 1462.910769]  ffff8101040cdd40 0000000000000046 0000000000000001 ffff810103471900
> >     [ 1462.910812]  ffff8101029a72c0 ffff8101040cdcf0 ffffffff80746dc0 ffffffff80746dc0
> >     [ 1462.910852]  ffffffff80744020 ffffffff80746dc0 ffff81010008e0c0 ffff8101012a1040
> >     [ 1462.910882] Call Trace:
> >     [ 1462.910909]  [<ffffffff802fbadf>] nfsd_permission+0x95/0xeb
> >     [ 1462.910931]  [<ffffffff8028c9dd>] vfs_readdir+0x46/0x93
> >     [ 1462.910950]  [<ffffffff8052d729>] mutex_lock_nested+0x165/0x27c
> >     [ 1462.910971]  [<ffffffff8052ec6b>] _spin_unlock+0x1f/0x49
> >     [ 1462.910994]  [<ffffffff8030415b>] nfs3svc_encode_entry_plus+0x0/0x13
> >     [ 1462.911015]  [<ffffffff8028c9dd>] vfs_readdir+0x46/0x93
> >     [ 1462.911037]  [<ffffffff8030415b>] nfs3svc_encode_entry_plus+0x0/0x13
> >     [ 1462.911057]  [<ffffffff802fc78e>] nfsd_readdir+0x6d/0xc5
> >     [ 1462.911079]  [<ffffffff80303158>] nfsd3_proc_readdirplus+0x114/0x204
> >     [ 1462.911102]  [<ffffffff802f8b82>] nfsd_dispatch+0xde/0x1b6
> >     [ 1462.911122]  [<ffffffff805215cd>] svc_process+0x3f8/0x717
> >     [ 1462.911143]  [<ffffffff802f9148>] nfsd+0x1a9/0x2c1
> >     [ 1462.911165]  [<ffffffff8020c648>] child_rip+0xa/0x12
> >     [ 1462.911184]  [<ffffffff80520af8>] __svc_create_thread+0xea/0x1eb
> >     [ 1462.911206]  [<ffffffff802f8f9f>] nfsd+0x0/0x2c1
> >     [ 1462.911225]  [<ffffffff8020c63e>] child_rip+0x0/0x12
> > 
> > 
> > Any suggestions other than to bisect this?  (Bisection might be
> > painful as it crosses the x86-merge.)
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
