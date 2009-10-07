Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n97DNGGU191479 for <xfs@oss.sgi.com>; Wed, 7 Oct 2009 08:23:17 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1894614C0F5C
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2009 06:24:42 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 2PxEBX2obPf6CLPp for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2009 06:24:42 -0700 (PDT)
Message-ID: <4ACC9699.70900@sandeen.net>
Date: Wed, 07 Oct 2009 08:24:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS/driver bug or bad drive?
References: <20091001232759.GA12832@opus.istwok.net>	<4AC54BDA.20806@sandeen.net>	<20091002165704.GA17558@opus.istwok.net>
	<20091007112959.GA17132@aurora.pimp.org.za>
In-Reply-To: <20091007112959.GA17132@aurora.pimp.org.za>
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
To: Michael-John Turner <mj@mjturner.net>
Cc: David Engel <david@istwok.net>, xfs@oss.sgi.com

Michael-John Turner wrote:
> On Fri, Oct 02, 2009 at 11:57:04AM -0500, David Engel wrote:
>> I agree it shouldn't be an xfs bug.  I thought it was strange, though,
>> that the problem only seemed to show up with xfs on 2.6.30.x.  IO
>> pattern sensitivity wouldn't surprise me, but I wanted to check all my
>> bases before giving up on the drive.
> 
> Rather curiously, I had exactly the same issue with the same model drive
> this past weekend. Debian-patched 2.6.26 kernel, however, though also with
> XFS (on top of md/LVM). Interestingly, there were no SMART errors and a
> full SMART test passed. The error was triggered by doing a cvs update on my
> working copy of the NetBSD source tree - not a large copy, but a
> disk-intensive activity.
> 
> -mj

Firmware bug?  I still think it can't be an xfs problem, and I'm not 
just trying to be protective of our turf ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
