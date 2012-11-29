Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qATJ09Tp069431 for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 13:00:10 -0600
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
	cuda.sgi.com with ESMTP id bq8cSt5CPWPM3Gnd for
	<xfs@oss.sgi.com>; Thu, 29 Nov 2012 11:02:25 -0800 (PST)
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC, PATCH 00/19] Numa aware LRU lists and shrinkers
References: <1354058086-27937-1-git-send-email-david@fromorbit.com>
Date: Thu, 29 Nov 2012 11:02:24 -0800
In-Reply-To: <1354058086-27937-1-git-send-email-david@fromorbit.com> (Dave
	Chinner's message of "Wed, 28 Nov 2012 10:14:27 +1100")
Message-ID: <m24nk8grlr.fsf@firstfloor.org>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, glommer@parallels.com

Dave Chinner <david@fromorbit.com> writes:
>
> Comments, thoughts and flames all welcome.

Doing the reclaim per CPU sounds like a big change in the VM balance. 
Doesn't this invalidate some zone reclaim mode settings?
How did you validate all this?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
