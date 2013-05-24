Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8B7957F37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 22:03:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 15D31AC005
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 20:03:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yQSp8HGDNLBK1EVa for
	<xfs@oss.sgi.com>; Thu, 23 May 2013 20:03:07 -0700 (PDT)
Date: Thu, 23 May 2013 23:03:00 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130524030300.GA30760@redhat.com>
References: <20130522041521.GA1837@redhat.com> <20130522051243.GH29466@dastard>
	<20130522052938.GA2573@redhat.com> <20130522055147.GI29466@dastard>
	<20130522215454.GL29466@dastard>
	<20130523184948.GA11151@redhat.com>
	<20130523223038.GB24543@dastard>
	<20130524004906.GA21171@redhat.com>
	<20130524012625.GH24543@dastard>
	<20130524015219.GA28486@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130524015219.GA28486@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, May 23, 2013 at 09:52:19PM -0400, Dave Jones wrote:
 > On Fri, May 24, 2013 at 11:26:25AM +1000, Dave Chinner wrote:
 >  
 >  > You want to print the debug output if the masked value != 0.
 > 
 > XFS (sda2): xfs_setattr_size: mask 0xaa69, masked 0x801 ii 0xffff8802129e98c0, d 0xffff88021757d970 path /davej/src/trinity/tmp/tmp.5/

ah, sneaky. There's some unprintable characters there that didn't show up in my terminal when I cut-n-pasted.
They made it to the logs though..

XFS (sda2): xfs_setattr_size: mask 0xaa69, masked 0x801 ii 0xffff8802129e98c0, d 0xffff88021757d970 path /davej/src/trinity/tmp/tmp.5/

Hexdump: of that part.. 706d 352e 012f 0a01 
So filename is 0x01 0x01

Don't know if that's relevant to the bug or not..

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
