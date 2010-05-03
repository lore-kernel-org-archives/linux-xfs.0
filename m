Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o43CgTK3154186 for <xfs@oss.sgi.com>; Mon, 3 May 2010 07:42:29 -0500
Received: from anguilla.debian.or.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6603E132E2FD
	for <xfs@oss.sgi.com>; Mon,  3 May 2010 05:44:36 -0700 (PDT)
Received: from anguilla.debian.or.at (anguilla.debian.or.at [86.59.21.37]) by
	cuda.sgi.com with ESMTP id tU7EVqUBBY99X7lI for
	<xfs@oss.sgi.com>; Mon, 03 May 2010 05:44:36 -0700 (PDT)
Date: Mon, 3 May 2010 14:44:36 +0200
From: Peter Palfrader <peter@palfrader.org>
Subject: Re: [regression,bisected] 2.6.32.12: find(1) on xfs causes OOM
Message-ID: <20100503124436.GB16623@anguilla.noreply.org>
References: <20100503115438.GA16623@anguilla.noreply.org>
	<20100503123606.GG2591@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100503123606.GG2591@dastard>
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
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, 03 May 2010, Dave Chinner wrote:

> > Starting in 2.6.32.12 running something like "find | wc -l" on this
> > filesystem's mountpoint causes the OOM killer to kill off most of the
> > system.  (See kern.log[1])
> 
> Knwon problem.

> The fix for this problem only got to mainline a couple of days ago.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9bf729c0af67897ea8498ce17c29b0683f7f2028
> 
> I've got to backport it to the stable kernel tree so the next stable
> kernel should fix this.

Thanks, I'll stay on .11 on that machine for now then.

-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
