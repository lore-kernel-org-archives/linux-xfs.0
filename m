Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D1E057F89
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 16:59:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F12BAC002
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 14:59:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QnPqlHQhFC1PCT7H for
	<xfs@oss.sgi.com>; Tue, 08 Oct 2013 14:59:56 -0700 (PDT)
Date: Tue, 8 Oct 2013 17:59:47 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: xfs lockdep trace after unlink
Message-ID: <20131008215947.GA8915@redhat.com>
References: <20131008212056.GA7467@redhat.com>
	<20131008213910.GX5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131008213910.GX5790@linux.vnet.ibm.com>
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
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Oct 08, 2013 at 02:39:10PM -0700, Paul E. McKenney wrote:
 > On Tue, Oct 08, 2013 at 05:20:56PM -0400, Dave Jones wrote:
 > > I was deleting a kernel tree, when this happened..
 > > RCU, or xfs ?
 > > 
 > > BUG: MAX_LOCKDEP_CHAINS too low!
 > 
 > I have to ask...  What happens when you bump up MAX_LOCKDEP_CHAINS?
 
We eat up a even more memory I guess.

kernel/lockdep_internals.h:#define MAX_LOCKDEP_CHAINS_BITS	15
kernel/lockdep_internals.h:#define MAX_LOCKDEP_CHAINS	(1UL << MAX_LOCKDEP_CHAINS_BITS)

I had to increase MAX_LOCKDEP_ENTRIES on my local tree already because
I was hitting that limit. 

 > There is a patch to avoid an RCU/scheduler/perf deadlock, which may
 > be found below.  But this stack doesn't look to me to be matching that
 > deadlock.

I'll add that to my tree until it gets mainlined.

thanks,

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
