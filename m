Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o38GDvV6032388 for <xfs@oss.sgi.com>; Thu, 8 Apr 2010 11:13:57 -0500
Received: from mx1.gb1.humyo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5B0C1AC12A3
	for <xfs@oss.sgi.com>; Thu,  8 Apr 2010 09:15:48 -0700 (PDT)
Received: from mx1.gb1.humyo.com (mx1.gb1.humyo.com [62.44.71.171]) by
	cuda.sgi.com with ESMTP id NBb07IPkjKFoCyDh for
	<xfs@oss.sgi.com>; Thu, 08 Apr 2010 09:15:48 -0700 (PDT)
Message-ID: <4BBE01CB.9020701@humyo.com>
Date: Thu, 08 Apr 2010 17:18:19 +0100
From: John Berthels <john@humyo.com>
MIME-Version: 1.0
Subject: Re: PROBLEM + POSS FIX: kernel stack overflow, xfs, many disks, heavy
	write load, 8k stack, x86-64
References: <4BBC6719.7080304@humyo.com> <20100407140523.GJ11036@dastard>
	<4BBCAB57.3000106@humyo.com> <20100407234341.GK11036@dastard>
	<20100408030347.GM11036@dastard> <4BBDC92D.8060503@humyo.com>
	<4BBDEC9A.9070903@humyo.com>
In-Reply-To: <4BBDEC9A.9070903@humyo.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Gregory <nick@humyo.com>, linux-mm@kvack.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Rob Sanderson <rob@humyo.com>

John Berthels wrote:
> John Berthels wrote:
>> I'll reply again after it's been running long enough to draw 
>> conclusions.
The box with patch+THREAD_ORDER 1+LOCKDEP went down (with no further 
logging retrievable by /var/log/messages or netconsole).

We're loading up a 2.6.33.2 + patch + THREAD_ORDER 2 (no LOCKDEP) to get 
better info as to whether we are still blowing the 8k limit with the 
patch in place.

jb

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
