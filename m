Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p58CQf4Z092997 for <xfs@oss.sgi.com>; Wed, 8 Jun 2011 07:26:41 -0500
Received: from pyre.virge.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBD8716C599F
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2011 05:26:39 -0700 (PDT)
Received: from pyre.virge.net (24-246-28-70.cable.teksavvy.com [24.246.28.70])
	by cuda.sgi.com with ESMTP id kT7mPHzNIMca4csM for
	<xfs@oss.sgi.com>; Wed, 08 Jun 2011 05:26:39 -0700 (PDT)
Date: Wed, 8 Jun 2011 08:26:38 -0400
From: Norbert Veber <nveber@pyre.virge.net>
Subject: Re: Small files perform much faster on newly formatted fs?
Message-ID: <20110608122638.GQ28625@pyre.virge.net>
References: <20110607163742.GH28625@pyre.virge.net> <201106080911.11286@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201106080911.11286@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Wed, Jun 08, 2011 at 09:11:10AM +0200, Michael Monnerie wrote:
> On Dienstag, 7. Juni 2011 Norbert Veber wrote:
> > 20 seconds vs 3+ minutes?!  The only difference I can see is
> > lazy-count=1 and a larger agcount.  Sunit and swidth were also set
> > automatically by mkfs this time.
> 
> Then retry mounting the old fs with sunit= and swidth= parameters. Are 
> they on the same disks? What are your disks (number, kind)?

Yes its already mounted this way as I mentioned in my original message:
/dev/mapper/vg0-shared on /shared type xfs (rw,noatime,sunit=128,swidth=256)

Both filesystems are on the same MD raid 5 which consists of 3 1 tb WD
Black hard drive.

Thanks,

Norbert

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
