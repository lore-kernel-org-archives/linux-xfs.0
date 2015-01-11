Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 07F767F50
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2015 00:33:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BF4548F8035
	for <xfs@oss.sgi.com>; Sat, 10 Jan 2015 22:33:17 -0800 (PST)
Received: from mail-qg0-f53.google.com (mail-qg0-f53.google.com
	[209.85.192.53]) by cuda.sgi.com with ESMTP id EVFhjtDUZmuMirOD
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 10 Jan 2015 22:33:16 -0800 (PST)
Received: by mail-qg0-f53.google.com with SMTP id l89so14191778qgf.12
	for <xfs@oss.sgi.com>; Sat, 10 Jan 2015 22:33:16 -0800 (PST)
Date: Sun, 11 Jan 2015 01:33:12 -0500
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
Message-ID: <20150111063312.GA3984@htj.dyndns.org>
References: <54B01927.2010506@redhat.com> <54B019F4.8030009@sandeen.net>
	<20150109182310.GA2785@htj.dyndns.org>
	<54B03BCC.7040207@sandeen.net>
	<20150110192852.GD25319@htj.dyndns.org>
	<54B1BE0E.7020302@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54B1BE0E.7020302@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Hello,

On Sat, Jan 10, 2015 at 06:04:30PM -0600, Eric Sandeen wrote:
> > The only reasons that work item would stay there are
> > 
> > * The rescuer is already executing something else from that workqueue
> >   and that one is stuck.
> 
> I'll have to look at that.  I hope I still have access to the core...

Yes, if this is happening, the rescuer worker which has the name of
the workqueue would be stuck somewhere.

> > * The worker pool is still considered to be making forward progress -
> >   there's a worker which isn't blocked and can burn CPU cycles.
> 
> AFAICT, the first thing in the pool is the xffs_end_io blocked waiting for the ilock.
> 
> I assume it's only the first one that matters?

Whatever work item which is executing on that pool on that CPU.
Checking the tasks which are runnable on that CPU should show it.

> > Again, if xfs is using workqueue correctly, that work item shouldn't
> > get stuck at all.  What other workqueues are doing is irrelevant.
> 
> and yet here we are; one of us must be missing something.  It's quite
> possibly me :) but we definitely have this thing wedged, and moving
> the xfsalloc item to the front via high priority did solve it.  Not saying
> it's the right solution, just a data point.

It sure is possible that workqueue is misbehaving but I'm pretty
doubtful that it'd be, especially given that xfs issue has been around
for quite a while, which excludes recent regressions in the rescuer
logic, and that there hasn't been any other case of failed forward
progress guarantee.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
