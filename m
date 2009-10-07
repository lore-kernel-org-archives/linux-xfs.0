Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n97BSgY6187229 for <xfs@oss.sgi.com>; Wed, 7 Oct 2009 06:28:43 -0500
Received: from zen.pimp.org.za (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6EB304AA266
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2009 04:30:07 -0700 (PDT)
Received: from zen.pimp.org.za (zen.pimp.org.za [70.85.31.111]) by
	cuda.sgi.com with ESMTP id ity9uV2DQA6fomPH for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2009 04:30:07 -0700 (PDT)
Date: Wed, 7 Oct 2009 12:29:59 +0100
From: Michael-John Turner <mj@mjturner.net>
Subject: Re: XFS/driver bug or bad drive?
Message-ID: <20091007112959.GA17132@aurora.pimp.org.za>
References: <20091001232759.GA12832@opus.istwok.net>
	<4AC54BDA.20806@sandeen.net>
	<20091002165704.GA17558@opus.istwok.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091002165704.GA17558@opus.istwok.net>
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
To: David Engel <david@istwok.net>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, Oct 02, 2009 at 11:57:04AM -0500, David Engel wrote:
> I agree it shouldn't be an xfs bug.  I thought it was strange, though,
> that the problem only seemed to show up with xfs on 2.6.30.x.  IO
> pattern sensitivity wouldn't surprise me, but I wanted to check all my
> bases before giving up on the drive.

Rather curiously, I had exactly the same issue with the same model drive
this past weekend. Debian-patched 2.6.26 kernel, however, though also with
XFS (on top of md/LVM). Interestingly, there were no SMART errors and a
full SMART test passed. The error was triggered by doing a cvs update on my
working copy of the NetBSD source tree - not a large copy, but a
disk-intensive activity.

-mj
-- 
 Michael-John Turner
 mj@mjturner.net      <>     http://mjturner.net/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
