Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A6F3F7F4E
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2015 14:47:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F8D9AC001
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2015 12:47:18 -0800 (PST)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id 8nwi2GjLOIIebbKV for <xfs@oss.sgi.com>;
	Fri, 06 Mar 2015 12:47:16 -0800 (PST)
Date: Fri, 6 Mar 2015 15:47:15 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150306204715.GA27257@fieldses.org>
References: <20150304222709.GI1627@fieldses.org>
	<20150304224557.GY4251@dastard> <54F78BE5.1020608@sandeen.net>
	<20150304225623.GZ4251@dastard>
	<20150305040849.GJ1627@fieldses.org>
	<20150305131731.GA16235@lst.de>
	<20150305150138.GA15674@fieldses.org>
	<20150305170217.GC15674@fieldses.org>
	<20150305204749.GA17934@fieldses.org>
	<20150305205922.GF18360@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150305205922.GF18360@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-nfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Mar 06, 2015 at 07:59:22AM +1100, Dave Chinner wrote:
> On Thu, Mar 05, 2015 at 03:47:49PM -0500, J. Bruce Fields wrote:
> > On Thu, Mar 05, 2015 at 12:02:17PM -0500, J. Bruce Fields wrote:
> > > On Thu, Mar 05, 2015 at 10:01:38AM -0500, J. Bruce Fields wrote:
> > > > On Thu, Mar 05, 2015 at 02:17:31PM +0100, Christoph Hellwig wrote:
> > > > > On Wed, Mar 04, 2015 at 11:08:49PM -0500, J. Bruce Fields wrote:
> > > > > > Ah-hah:
> > > > > > 
> > > > > > 	static void
> > > > > > 	nfsd4_cb_layout_fail(struct nfs4_layout_stateid *ls)
> > > > > > 	{
> > > > > > 		...
> > > > > > 		nfsd4_cb_layout_fail(ls);
> > > > > > 
> > > > > > That'd do it!
> > > > > > 
> > > > > > Haven't tried to figure out why exactly that's getting called, and why
> > > > > > only rarely.  Some intermittent problem with the callback path, I guess.
> > > > > > 
> > > > > > Anyway, I think that solves most of the mystery....
> > > > > 
> > > > > Ooops, that was a nasty git merge error in the last rebase, see the fix
> > > > > below.
> > > > 
> > > > Thanks!
> > > 
> > > And with that fix things look good.
> > > 
> > > I'm still curious why the callbacks are failling.  It's also logging
> > > "nfsd: client 192.168.122.32 failed to respond to layout recall".
> > 
> > I spoke too soon, I'm still not getting through my usual test run--the most
> > recent run is hanging in generic/247 with the following in the server logs.
> > 
> > But I probably still won't get a chance to look at this any closer till after
> > vault.
> > 
> > --b.
> > 
> > nfsd: client 192.168.122.32 failed to respond to layout recall.   Fencing..
> > nfsd: fence failed for client 192.168.122.32: -2!
> > nfsd: client 192.168.122.32 failed to respond to layout recall.   Fencing..
> > nfsd: fence failed for client 192.168.122.32: -2!
> > receive_cb_reply: Got unrecognized reply: calldir 0x1 xpt_bc_xprt ffff88005639a000 xid c21abd62
> > kswapd0: page allocation failure: order:0, mode:0x120
> 
> [snip network driver memory allocation failure]
> 
> > active_anon:7053 inactive_anon:2435 isolated_anon:0
> >  active_file:88743 inactive_file:89505 isolated_file:32
> >  unevictable:0 dirty:9786 writeback:0 unstable:0
> >  free:3571 slab_reclaimable:227807 slab_unreclaimable:75772
> >  mapped:21010 shmem:380 pagetables:1567 bounce:0
> >  free_cma:0
> 
> Looks like there should be heaps of reclaimable memory...
> 
> > nfsd: client 192.168.122.32 failed to respond to layout recall.   Fencing..
> 
> So there's a layout recall pending...
> 
> > nfsd: fence failed for client 192.168.122.32: -2!
> > receive_cb_reply: Got unrecognized reply: calldir 0x1 xpt_bc_xprt ffff880051dfc000 xid 8ff02aaf
> > INFO: task nfsd:17653 blocked for more than 120 seconds.
> >       Not tainted 4.0.0-rc2-09922-g26cbcc7 #89
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > nfsd            D ffff8800753a7848 11720 17653      2 0x00000000
> >  ffff8800753a7848 0000000000000001 0000000000000001 ffffffff82210580
> >  ffff88004e9bcb50 0000000000000006 ffffffff8119d9f0 ffff8800753a7848
> >  ffff8800753a7fd8 ffff88002e5e3d70 0000000000000246 ffff88004e9bcb50
> > Call Trace:
> >  [<ffffffff8119d9f0>] ? new_sync_read+0xb0/0xb0
> >  [<ffffffff8119d9f0>] ? new_sync_read+0xb0/0xb0
> >  [<ffffffff81a95737>] schedule+0x37/0x90
> >  [<ffffffff81a95ac8>] schedule_preempt_disabled+0x18/0x30
> >  [<ffffffff81a97756>] mutex_lock_nested+0x156/0x400
> >  [<ffffffff813a0d5a>] ? xfs_file_buffered_aio_write.isra.9+0x6a/0x2a0
> >  [<ffffffff8119d9f0>] ? new_sync_read+0xb0/0xb0
> >  [<ffffffff813a0d5a>] xfs_file_buffered_aio_write.isra.9+0x6a/0x2a0
> >  [<ffffffff8119d9f0>] ? new_sync_read+0xb0/0xb0
> >  [<ffffffff813a1016>] xfs_file_write_iter+0x86/0x130
> >  [<ffffffff8119db05>] do_iter_readv_writev+0x65/0xa0
> 
> and the nfsd got hung up on the inode mutex during  a write.
> 
> Which means there's some other process blocked holding the i_mutex.
> sysrq-w and sysrq-t is probably going to tell us more here.
> 
> I suspect we'll have another write stuck in break_layout().....

Yup!  There's a bunch of threads similarly stuck in write, and then:

# cat /proc/17765/stack 
[<ffffffff811edb18>] __break_lease+0x278/0x510
[<ffffffff813cd4d4>] xfs_break_layouts+0x94/0xf0
[<ffffffff813a0903>] xfs_file_aio_write_checks+0x53/0x100
[<ffffffff813a0d7b>] xfs_file_buffered_aio_write.isra.9+0x8b/0x2a0
[<ffffffff813a1016>] xfs_file_write_iter+0x86/0x130
[<ffffffff8119db05>] do_iter_readv_writev+0x65/0xa0
[<ffffffff8119f0b2>] do_readv_writev+0xe2/0x280
[<ffffffff8119f2d9>] vfs_writev+0x39/0x50
[<ffffffffa00ab861>] nfsd_vfs_write.isra.11+0xa1/0x350 [nfsd]
[<ffffffffa00aecee>] nfsd_write+0x8e/0x100 [nfsd]
[<ffffffffa00b97f5>] nfsd4_write+0x185/0x1e0 [nfsd]
[<ffffffffa00bbe37>] nfsd4_proc_compound+0x3c7/0x6f0 [nfsd]
[<ffffffffa00a7463>] nfsd_dispatch+0xc3/0x220 [nfsd]
[<ffffffffa001314f>] svc_process_common+0x43f/0x650 [sunrpc]
[<ffffffffa00134a3>] svc_process+0x143/0x260 [sunrpc]
[<ffffffffa00a6cc7>] nfsd+0x167/0x1e0 [nfsd]
[<ffffffff81093a2f>] kthread+0xef/0x110
[<ffffffff81a9b5ac>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

I'm worried by the blocking break_lease in xfs_break_layouts.  There's a
circular dependency: blocking in break_lease ties up an nfsd thread, but
we'll need an nfsd thread to process the client's layout return.

But in the worst case I'd still expect that to be cleaned up if the
client doesn't return the layout within a lease period (20 seconds on my
server).

In addition to fencing the client, surely we should be forcibly revoking
the layout at that point?

-b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
