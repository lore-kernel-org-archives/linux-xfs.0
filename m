Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 24AFB7F3F
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 14:51:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 084068F8050
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:51:03 -0800 (PST)
Received: from mail-qg0-f49.google.com (mail-qg0-f49.google.com
	[209.85.192.49]) by cuda.sgi.com with ESMTP id ytx0AWA3WY0QKxXk
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:51:00 -0800 (PST)
Received: by mail-qg0-f49.google.com with SMTP id f51so4102744qge.8
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:51:00 -0800 (PST)
Date: Tue, 13 Jan 2015 15:50:56 -0500
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
Message-ID: <20150113205056.GD9489@htj.dyndns.org>
References: <54B01927.2010506@redhat.com> <54B019F4.8030009@sandeen.net>
	<20150109182310.GA2785@htj.dyndns.org>
	<20150109232815.GL31508@dastard>
	<20150110174133.GC25319@htj.dyndns.org>
	<20150112033015.GB29484@destitution>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150112033015.GB29484@destitution>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

Hello, Dave.

On Mon, Jan 12, 2015 at 02:30:15PM +1100, Dave Chinner wrote:
> So lock/wq ordering dependencies are:
> 
> m_data_workqueue -> i_lock
> m_unwritten_workqueue -> i_lock -> xfs_alloc_wq -> m_buf_workqueue
> syscall -> i_lock -> xfs_alloc_wq -> m_buf_workqueue
> 
> The issue we see is:
> 
> process A:	write(2) -> i_lock -> xfs_allow_wq
> kworkers:	m_data_workqueue -> i_lock
> 		(blocked on process A work completion)
> 
> Queued work:  m_data_workqueue work, xfs_allow_wq work
> 
> Queued work does not appear to be dispatched for some reason, wq
> concurrency depth does not appear to be exhausted and rescuer
> threads do not appear to be active. Something has gone wrong for
> the queued work to be stalled like this.

Yeah, this actually looks like a bug in the rescuer or manager
arbitration logic.  I'm gonna see what's going on once Eric posts more
dumps.

Sorry about the trouble.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
