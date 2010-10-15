Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9FBiC3i125963 for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 06:44:12 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 338B8F07CAD
	for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 04:59:52 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	ZUnVuCilRD2DRqt8 for <xfs@oss.sgi.com>;
	Fri, 15 Oct 2010 04:59:52 -0700 (PDT)
Date: Fri, 15 Oct 2010 22:45:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH 0/2] xfs: dynamic speculative preallocation for
	delalloc
Message-ID: <20101015114508.GI4681@dastard>
References: <C8DCC927.48D3%ivan.novick@emc.com>
 <201010150914.55604@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201010150914.55604@zmi.at>
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
Cc: Ivan.Novick@emc.com, aelder@sgi.com, xfs@oss.sgi.com

On Fri, Oct 15, 2010 at 09:14:54AM +0200, Michael Monnerie wrote:
> On Donnerstag, 14. Oktober 2010 Ivan.Novick@emc.com wrote:
> > I have seen ~50% performance improvement in read rate when changing
> > from small extents to large extents with XFS. Essentially going from
> > not using allocsize to setting 1gb allocsize.  Also GB/s class
> > filesystem.
> 
> In case of a database, I'd say 1GB allocsize seems fine. But when you're 
> at /var/log/, it could be a penalty, as when you have 50 open log files 
> which get permanently appended, you have 50GB preallocated which almost 
> surely won't be needed before the log is rotated anyway.

Don't put your high performance database on the same filesystem as
your system log files. Or don't use tunings for databases on your
root filesystem.

> The question is: what is a good value for preallocation?

If you can't answer that, use the defaults.

> I'd guess for a database 1GB seems reasonable,

depends on  your database. If it does direct IO, then allocsize is
completely meaningless....

> for /var/log one full 
> stripe (nr-data-disks * stripe size),

IIRC, that is the default behaviour for _physical_ extent allocation
on files larger than one stripe unit (i.e stripe aligned and sized
allocation). That is very different from speculative allocation done
at delayed allocation time, which is purely in-memory until physical
allocation occurs.

> for webserver/ftp data too, as 
> well as a fileserver (storing office documents) and mailserver (storing 
> each mail as a separate file or into one flat file).
> Or, when you have an app that writes files of specific size, use the 
> "normal maximum" file size. We have a special server storing files of 
> normally 50M-1G size, there I set allocsize=1024k, so that files will be 
> in one junk on disk. When sometimes a file is bigger, then it will be 
> fragmented but at reasonable sizes so it won't matter too much.
> 
> Is that reasonable?

What is reasonable is that the default behaviour does the right
thing. :)

Nobody should need to use the allocsize mount option except in
extreme corner cases, and that is what my patchset attempts to
achieve.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
