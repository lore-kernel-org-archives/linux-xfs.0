Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9JBGSEO180922 for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 06:16:29 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA4A21C9A92A
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 04:16:25 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id BPIc4yMDVrFwRUug
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 04:16:25 -0700 (PDT)
Message-ID: <4E9EB187.40306@profihost.ag>
Date: Wed, 19 Oct 2011 13:16:23 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] xfs: revert to using a kthread for AIL pushing
References: <20111006183257.036884724@bombadil.infradead.org>
	<20111006183549.770414484@bombadil.infradead.org>
	<20111010014509.GT3159@dastard>
	<20111010055546.GA1641@x4.trippels.de>
In-Reply-To: <20111010055546.GA1641@x4.trippels.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>, xfs@oss.sgi.com

> On 2011.10.10 at 12:45 +1100, Dave Chinner wrote:
>> On Thu, Oct 06, 2011 at 02:33:00PM -0400, Christoph Hellwig wrote:
>>> Currently we have a few issues with the way the workqueue code is used to
>>> implement AIL pushing:
>>>
>>>   - it accidentally uses the same workqueue as the syncer action, and thus
>>>     can be prevented from running if there are enough sync actions active
>>>     in the system.
>>>   - it doesn't use the HIGHPRI flag to queue at the head of the queue of
>>>     work items
>>>
>>> At this point I'm not confident enough in getting all the workqueue flags and
>>> tweaks right to provide a perfectly reliable execution context for AIL
>>> pushing, which is the most important piece in XFS to make forward progress
>>> when the log fills.
>>>
>>> Revert back to use a kthread per filesystem which fixes all the above issues
>>> at the cost of having a task struct and stack around for each mounted
>>> filesystem.  In addition this also gives us much better ways to diagnose
>>> any issues involving hung AIL pushing and removes a small amount of code.
>>>
>>> Signed-off-by: Christoph Hellwig<hch@lst.de>
>>> Reported-by: Stefan Priebe<s.priebe@profihost.ag>
>>> Tested-by: Stefan Priebe<s.priebe@profihost.ag>
>>
>> I'd much prefer to fix the problems with the workqueue usage than
>> revert back to using a thread, but seeing as I cannot reproduce the
>> hangs I can't really track down whatever problem there is. So,
>> a bit reluctantly:

Any news on this problem? What happens with the next long term stable 
kernel 3.0.X? How do you proceed with this bug?

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
