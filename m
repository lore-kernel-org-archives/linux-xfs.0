Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 48FAC7CBF
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 15:17:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 293018F8033
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 13:17:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KusK1Kx1WNgTc7lR for
	<xfs@oss.sgi.com>; Fri, 24 May 2013 13:17:04 -0700 (PDT)
Date: Fri, 24 May 2013 16:16:55 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130524201655.GA23086@redhat.com>
References: <20130522052938.GA2573@redhat.com> <20130522055147.GI29466@dastard>
	<20130522215454.GL29466@dastard>
	<20130523184948.GA11151@redhat.com>
	<20130523223038.GB24543@dastard>
	<20130524004906.GA21171@redhat.com>
	<20130524012625.GH24543@dastard>
	<20130524015219.GA28486@redhat.com>
	<20130524030300.GA30760@redhat.com>
	<20130524080300.GI24543@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130524080300.GI24543@dastard>
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
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, May 24, 2013 at 06:03:00PM +1000, Dave Chinner wrote:

 > xfstest generic/193 is *supposed* to test behaviour of suid/sgid bits
 > and clearing them is various situations.
 > 
 > You know what I'm about to say, don't you? The test doesn't test
 > what it thinks it is testing. it puts the destination file in root
 > directory of the xfstests harness, not in the filesystems being
 > tested.

awesome, two bugs for the price of one!

 > So, on all my machines, it runs on ext3 filesystems, never on the
 > ext4, btrfs, xfs, etc filesystems that I'm actually testing.
 > 
 > That's beside the point, because it doesn't test truncate behaviour.
 > But at least I know now why my attempts to reproduce the problem
 > didn't work...
 > 
 > Right, patch below should fix the problem.

Haven't seen anything out of the ordinary since I applied that,
so I'd call it good.
 
 > What a frustrating bug. Now, where's my bottle of scotch?

heh, enjoy the weekend.

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
