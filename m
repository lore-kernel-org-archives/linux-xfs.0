Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB10JI2N077865 for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 18:19:18 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B64B1904B4E
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 16:19:45 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	hxpLm9OWvCroq1HS for <xfs@oss.sgi.com>;
	Mon, 30 Nov 2009 16:19:45 -0800 (PST)
Date: Tue, 1 Dec 2009 11:19:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS & LVM: unexpected cp when issuing mv
Message-ID: <20091201001942.GF30608@discord.disaster>
References: <200911291452.20646@zmi.at>
	<20091129232716.GC30608@discord.disaster>
	<200911301442.20807@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200911301442.20807@zmi.at>
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

On Mon, Nov 30, 2009 at 02:42:20PM +0100, Michael Monnerie wrote:
> On Montag, 30. November 2009 Dave Chinner wrote:
> > > 1) why this happens
> > 
> > It happens if you move from one project directory heirarchy to
> > another - rename is not allowed across project quota boundaries as
> > the moved data has to be correctly attributed to the new project.
> > Hence it causes a mv to do a copy/unlink by returning a EXDEV error
> > to the rename.
> > 
> > > 2) how I can prevent this?
> > 
> > You can't if you are moving from one project to another. If you
> > move within the project heirarchy, then it will be a rename as per
> > normal.
>  
> Shit. So I have to turn project quotas off. I can't accept the extra 
> load for a simple move, as there are tons of data. Maybe the projet code 
> could be redesigned to allow a simple move? Is it that complicated?

IIRC, it was a design decision to make project quotas behave this
way.  Returning EXDEV made the code to handle this very simple -
userspace already handles this error correctly and all the kernel
needs is 3 lines of code to detect differing project IDs on the
inodes and return EXDEV.

To do it without copying is definitely possible - it requires
extending the rename transaction to directly modify the project
quota id of the target inodes and the relevant dquots as well. It
becomes quite complicated because it also has to handle the cases of
source or destination not having quotas at all, the destination
not having enough space (i.e. EDQUOT), etc.

All the nasty corner cases are handled by userspace by returning
EXDEV to force it to copy rather than renaming, so the decision was
made to do the simple (if slow) thing for relatively uncommon
operation of moving data between projects.

> If I change from project to user quota - I guess the same would still 
> happen?

No - the EXDEV error (and therefore the copy) is a feature of project
quotas.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
