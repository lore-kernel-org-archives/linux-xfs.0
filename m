Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p079IuWh022055 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 03:18:56 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74C9815396B6
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 01:21:04 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	rgCAuRqH6JBoCeLf for <xfs@oss.sgi.com>;
	Fri, 07 Jan 2011 01:21:04 -0800 (PST)
Date: Fri, 7 Jan 2011 20:20:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/8] xfs: factor common write setup code
Message-ID: <20110107092058.GL8322@dastard>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
	<1294116518-14908-8-git-send-email-david@fromorbit.com>
	<20110107085357.GB10829@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110107085357.GB10829@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Jan 07, 2011 at 03:53:57AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 04, 2011 at 03:48:37PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The buffered IO and direct Io write paths share a common set of
> > checks and limiting code prior to issuing the write. Factor that
> > into a common helper function.
> 
> Wouldn't it be better to create the helper before duplicating the code,
> aka move it before the buffer/direct splits in the series?

Maybe, but at this I'd prefer not to move it as it would mean having
to rework several other patches in the series as well.  Moving it
doesn't change the end result at all, so unless you feel really
strongly about this I'm going to say no this time because we're
now under time pressure to get this tested and finished for 2.6.38.

> > +	/*
> > +	 * If we're writing the file then make sure to clear the setuid and
> > +	 * setgid bits if the process is not being run by root.  This keeps
> > +	 * people from modifying setuid and setgid binaries.
> > +	 */
> > +	error = file_remove_suid(file);
> > +	return error;
> 
> just
> 
> 	return file_remove_suid(file);

Yup, will fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
