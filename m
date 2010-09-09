Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o897QjHp090025 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 02:26:45 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19A265B99A
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 00:27:28 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	kkX0MnS35RqSAnDV for <xfs@oss.sgi.com>;
	Thu, 09 Sep 2010 00:27:28 -0700 (PDT)
Date: Thu, 9 Sep 2010 17:27:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs mount/create options (was: XFS status update for August 2010)
Message-ID: <20100909072726.GB7032@dastard>
References: <20100902145959.GA27887@infradead.org> <201009081538.54488@zmi.at>
	<20100908145148.GB705@dastard> <201009090130.22983@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009090130.22983@zmi.at>
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

On Thu, Sep 09, 2010 at 01:30:15AM +0200, Michael Monnerie wrote:
> On Mittwoch, 8. September 2010 Dave Chinner wrote:
> > Dynamically changing the RAID array geometry is a Bad Idea.  Yes,
> > you can do it, but if you've got a filesystem full of data and
> > metadata aligned to the old geometry then after the modification
> > it won't be aligned anymore.
> > 
> > If you want to do this, then either don't bother about geomtry hints
> > in the first place, or dump, rebuild the array, mkfs and restore so
> > everything is properly aligned with the new world order. Hell,
> > dump/mkfs/restore might even be faster than reshaping a large
> > array...
>  
> You're right. But there are some customers who don't want to spend the 
> money for a 2nd array, and can't afford the downtime of backup, rebuild 
> raid (takes 8-48 hours), restore. So an online upgrade is needed. We're 
> not in an ideal world.

If you can't afford downtime, then I'd seriously question using
reshaping to expand storage because it is one of the highest risk
methods of increasing storage capacity you can use. That means
you've still got to do the backup before you reshape your raid
device - if reshaping fails, and then you need to rebuild + restore.

Reshaping is a dangerous operation - you can't go back once it has
started, and failures while reshaping can cause data loss. That is,
the risk of catastrophic failure goes up significantly while a
reshape is in progress. This is the same increase in risk of
failures occuring during rebuild after losing a disk - the next disk
failure is most likely to occur while the rebuild is in progress,
simply because of the sustained inrease in load on the drives.

That is, if you have SATA drives then running them for 3 or 4 days
at 100% duty cycle while a reshape takes place is putting them far
outside their design limits. SATA drives are generally designed for
a 20-30% duty cycle for sustained operation. Put disks that are a
couple of years old under this sort of load....

Of even more concern is that reshaping a multi-terabyte array
requires moving the same order of magnitude of bits around as the
BER of the drives. Hence there's every chance of introducing silent
bit errors into your data by reshaping unless you further slow the
reshape down by having it read back all the data to verify it was
reshaped correctly.

IMO, reshaping is not a practise you should be designing your
capacity upgrade processes around, especially if you have uptime and
perforamnce SLA guarantees. It's a very risky operation, and not
something I would suggest anyone uses in production unless they have
absolutely no other option.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
