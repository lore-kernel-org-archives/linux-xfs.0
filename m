Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8F0mguc156972 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 19:48:43 -0500
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9623373EAB
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 17:49:31 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by
	cuda.sgi.com with ESMTP id C3b8ywk8im1M8EfC for
	<xfs@oss.sgi.com>; Tue, 14 Sep 2010 17:49:31 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>) id 1OvgBm-0005Wm-UZ
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 17:49:30 -0700
Message-ID: <29714354.post@talk.nabble.com>
Date: Tue, 14 Sep 2010 17:49:30 -0700 (PDT)
From: pbrunnen <PBrunnen@bccnetworks.net>
Subject: Re: Now: Debian issues, WAS: XFS Filesystem not mounting
In-Reply-To: <4C8FB8D6.6080603@hardwarefreak.com>
MIME-Version: 1.0
References: <29704010.post@talk.nabble.com> <20100914012151.GF411@dastard>
	<29705139.post@talk.nabble.com> <201009140740.14482@zmi.at>
	<20100914082504.4109712d@galadriel.home>
	<29708085.post@talk.nabble.com> <201009141603.24754@zmi.at>
	<4C8F9E29.2000803@hardwarefreak.com>
	<29710491.post@talk.nabble.com>
	<4C8FB8D6.6080603@hardwarefreak.com>
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
To: xfs@oss.sgi.com


Hi Steve,


Stan Hoeppner wrote:
>  I can see how this could be an issue to someone who's been using a menu
> driven package manager for a while.
Call me spoiled... ;-)


Stan Hoeppner wrote:
> > 2) Vendor support is officially non-existant.
>   For Debian?  Not true.  See below.
Ok, I give you that.  Not supported by Our vendor is more
accurate.Unfortunately you could not give me an HP box... Too many bad
experiences.


Stan Hoeppner wrote:
> I've only been using XFS for about a year now, and I've had zeroproblems. 
> One of my favorite features is xfs_fsr.  Dovecot IMAP withmbox storage
> causes serious fragmentation with large mailboxes.  Thereis no ability to
> defrag files online with EXT2/3, Reiser, or JFS, sothis really comes in
> handy.
I hear you there.  We are standardized on it for five years now.  I can't
speak highly enough of it. I like it because its generally the fastest
filesystem overall with all the different kinds of storage we have (size,
heavy file i/o, and databases).  It scales really big and can grow online...
some of our luns are in the 30TB range.  Agreed on the online fragmentation
too... Happy to say this is only the second time ever that I ran
xfs_repair... and the first time was on my old failing laptop drive, so that
really doesn't count for much.

-Cheers, Peter.
-- 
View this message in context: http://old.nabble.com/XFS-Filesystem-not-mounting-tp29704010p29714354.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
