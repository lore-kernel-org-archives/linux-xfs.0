Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2SNvKLC192831 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 18:57:21 -0500
Received: from mga03.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B778A1DFA70B
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 17:00:28 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [143.182.124.21]) by
	cuda.sgi.com with ESMTP id 2oQ9sLTPwPhudkgS for
	<xfs@oss.sgi.com>; Mon, 28 Mar 2011 17:00:28 -0700 (PDT)
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Very aggressive memory reclaim
References: <AANLkTinFqqmE+fTMTLVU-_CwPE+LQv7CpXSQ5+CdAKLK@mail.gmail.com>
	<20110328215344.GC3008@dastard>
Date: Mon, 28 Mar 2011 16:58:50 -0700
In-Reply-To: <20110328215344.GC3008@dastard> (Dave Chinner's message of "Tue,
	29 Mar 2011 08:53:44 +1100")
Message-ID: <m2bp0u23wl.fsf@firstfloor.org>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, John Lepikhin <johnlepikhin@gmail.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Dave Chinner <david@fromorbit.com> writes:
>
> First it would be useful to determine why the VM is reclaiming so
> much memory. If it is somewhat predictable when the excessive
> reclaim is going to happen, it might be worth capturing an event

Often it's to get pages of a higher order. Just tracing alloc_pages
should tell you that.

There are a few other cases (like memory failure handling), but they're
more obscure.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
