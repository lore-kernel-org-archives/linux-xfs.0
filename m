Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9625F7F3F
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 11:29:50 -0600 (CST)
Date: Tue, 17 Dec 2013 11:29:47 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: =?utf-8?B?5Zue5aSN77yaIOOAkHhmc19tZXRh?=
	=?utf-8?Q?dump___xfs=5Fmdrestore__xfsdump__xfsrestore=E3=80=91?=
Message-ID: <20131217172946.GU1935@sgi.com>
References: <tencent_316F3CDD1B9D21DF326147BD@qq.com>
	<52AFFC69.7010007@oracle.com>
	<tencent_6B75C6A662E0CF4579F66B91@qq.com>
	<52B005A6.9050704@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52B005A6.9050704@oracle.com>
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
To: Stor?? <289471341@qq.com>, Jeff Liu <jeff.liu@oracle.com>
Cc: xfs <xfs@oss.sgi.com>

Hey,

On Tue, Dec 17, 2013 at 04:04:54PM +0800, Jeff Liu wrote:
> On 12/17 2013 15:45 PM, Stor?? wrote:
> >  
> >  thank you.
> > 1.  XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1676 of file
> > fs/xfs/xfs_alloc.c.  Caller 0xffffffffa023496d

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=blob;f=fs/xfs/xfs_alloc.c;h=1956f83489f1b8378f4459844e422547d421e0ec;hb=1f4c79cdb3fd856edde28af25576bcd8341eef78#l1676

We were trying to remove an entry in the by-size freespace btree and found that
the entry to the right was not there as expected.

> > Pid: 7579, comm: smbd Tainted: G          2.6.27.19-5-default #7
> > Call Trace:
> >  [<ffffffff8020d899>] show_trace_log_lvl+0x41/0x58
> >  [<ffffffff8020deff>] dump_stack+0x69/0x6f
> >  [<ffffffffa023308f>] xfs_free_ag_extent+0x45a/0x6bb [xfs]
> >  [<ffffffffa023496d>] xfs_free_extent+0xa9/0xc9 [xfs]
> >  [<ffffffffa023d446>] xfs_bmap_finish+0xee/0x15f [xfs]
> >  [<ffffffffa025d647>] xfs_itruncate_finish+0x190/0x2ba [xfs]
> >  [<ffffffffa027626d>] xfs_inactive+0x216/0x450 [xfs]
> >  [<ffffffffa0280e01>] xfs_fs_clear_inode+0xb0/0xf4 [xfs]
> >  [<ffffffff802bca41>] clear_inode+0x75/0xcc
> >  [<ffffffff802bcbb5>] generic_delete_inode+0xd6/0x14e
> >  [<ffffffff802b476f>] do_unlinkat+0xda/0x14d
> >  [<ffffffff8020befb>] system_call_fastpath+0x16/0x1b
> >  [<00007f6af6256b77>] 0x7f6af6256b77
> > xfs_force_shutdown(dm-1,0x8) called from line 4269 of file
> > fs/xfs/xfs_bmap.c.  Return address = 0xffffffffa023d47b
> > Filesystem "dm-1": Corruption of in-memory data detected.  Shutting down
> > filesystem: dm-1
> > Please umount the filesystem, and rectify the problem(s)
> > Filesystem "dm-1": xfs_log_force: error 5 returned.
> > Filesystem "dm-1": xfs_log_force: error 5 returned.
> > Filesystem "dm-1": xfs_log_force: error 5 returned.
> > Filesystem "dm-1": xfs_log_force: error 5 returned.
> > Filesystem "dm-1": xfs_log_force: error 5 returned.
> > Filesystem "dm-1": xfs_log_force: error 5 returned.
> > Filesystem "dm-1": xfs_log_force: error 5 returned.
> > Filesystem "dm-1": xfs_log_force: error 5 returned.
> >  
> > Why is this so,
> > In order to protect the data.Which command with the backup file system.
> > xfs_dump or xfs_metadump.
> xfsdump.  This looks like an internal corruptions, maybe run xfs_repair
> -n can give more hints.

In addition to the xfs_repair -n output, a metadump might also be helpful.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
