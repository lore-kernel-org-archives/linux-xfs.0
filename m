Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8701E7CE1
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 09:07:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 59EFD30405F
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 07:07:40 -0700 (PDT)
Date: Wed, 23 Mar 2016 10:07:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs trace in 4.4.2 / also in 4.3.3 WARNING
	fs/xfs/xfs_aops.c:1232 xfs_vm_releasepage
Message-ID: <20160323140736.GD43073@bfoster.bfoster>
References: <56C81D94.7090603@profihost.ag>
	<20160220144533.GA36182@bfoster.bfoster>
	<B833B258-1140-464C-94CD-09B840BD4220@profihost.ag>
	<56D9D834.2000303@profihost.ag>
	<20160304191329.GC3758@bfoster.bfoster>
	<56D9E9BE.40101@profihost.ag>
	<20160304210341.GA8035@bfoster.bfoster>
	<20160305224845.GR30721@dastard> <56F299E3.4020703@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56F299E3.4020703@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: linux-fsdevel@vger.kernel.org, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Mar 23, 2016 at 02:28:03PM +0100, Stefan Priebe - Profihost AG wrote:
> sorry new one the last one got mangled. Comments inside.
> 
> Am 05.03.2016 um 23:48 schrieb Dave Chinner:
> > On Fri, Mar 04, 2016 at 04:03:42PM -0500, Brian Foster wrote:
> >> On Fri, Mar 04, 2016 at 09:02:06PM +0100, Stefan Priebe wrote:
> >>> Am 04.03.2016 um 20:13 schrieb Brian Foster:
> >>>> On Fri, Mar 04, 2016 at 07:47:16PM +0100, Stefan Priebe wrote:
> >>>>> Am 20.02.2016 um 19:02 schrieb Stefan Priebe - Profihost AG:
> >>>>>>
> >>>>>>> Am 20.02.2016 um 15:45 schrieb Brian Foster <bfoster@redhat.com>:
> >>>>>>>
> >>>>>>>> On Sat, Feb 20, 2016 at 09:02:28AM +0100, Stefan Priebe wrote:
...
> 
> This has happened again on 8 different hosts in the last 24 hours
> running 4.4.6.
> 
> All of those are KVM / Qemu hosts and are doing NO I/O except the normal
> OS stuff as the VMs have remote storage. So no database, no rsync on
> those hosts - just the OS doing nearly nothing.
> 
> All those show:
> [153360.287040] WARNING: CPU: 0 PID: 109 at fs/xfs/xfs_aops.c:1234
> xfs_vm_releasepage+0xe2/0xf0()
> 

Ok, well at this point the warning isn't telling us anything beyond
you're reproducing the problem. We can't really make progress without
more information. We don't necessarily know what application or
operations caused this by the time it occurs, but perhaps knowing what
file is affected could give us a hint.

We have the xfs_releasepage tracepoint, but that's unconditional and so
might generate a lot of noise by default. Could you enable the
xfs_releasepage tracepoint and hunt for instances where delalloc != 0?
E.g., we could leave a long running 'trace-cmd record -e
"xfs:xfs_releasepage" <cmd>' command on several boxes and wait for the
problem to occur. Alternatively (and maybe easier), run 'trace-cmd start
-e "xfs:xfs_releasepage"' and leave something like 'cat
/sys/kernel/debug/tracing/trace_pipe | grep -v "delalloc 0" >
~/trace.out' running to capture instances.

If we can get a tracepoint hit, it will include the inode number and
something like 'find / -inum <ino>' can point us at the file.

Brian

> Stefan
> 
> > 
> > -Dave.
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
