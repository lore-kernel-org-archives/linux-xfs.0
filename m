Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ILKnEF159300 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 15:20:49 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A069327392F
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 13:23:06 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	vizUaQ7E7iFTEXbr for <xfs@oss.sgi.com>;
	Tue, 18 Jan 2011 13:23:06 -0800 (PST)
Date: Wed, 19 Jan 2011 08:23:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: add fpunch command for hole punching via
	fallocate
Message-ID: <20110118212303.GV28803@dastard>
References: <1295009545-17839-1-git-send-email-josef@redhat.com>
	<20110118125112.GB21440@infradead.org>
	<20110118130603.GA23491@dhcp231-156.rdu.redhat.com>
	<20110118131203.GA4349@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110118131203.GA4349@infradead.org>
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
Cc: Josef Bacik <josef@redhat.com>, xfs@oss.sgi.com

On Tue, Jan 18, 2011 at 08:12:03AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 18, 2011 at 08:06:03AM -0500, Josef Bacik wrote:
> > Sounds good.  So which do we want, a new command or a new flag?  Thanks,
> 
> I'll wait for dave to chime in.  I think we should absolutely expose
> it as a fallocate flag, but if there's a good reason we can also expose
> it as a separate command.

My reasoning was that:

	a) it is consistent with other xfs_io allocation manipulation
	   command structures such as resvsp/unresvsp
	b) "punch" is less to type than "fallocate -p"
	c) self documenting in scripts e.g. -c "punch 4k 4k" is much
	   more obvious than -c "fallocate -p 4k 4k" and saves a man
	   page lookup when reading the script.
	d) punch as a top level command will show up in the "xfs_io
	   -c help", not require you to know it is a suboption of the
	   "falloc" command to find out how to use it.
	e) the xfs_io command does not have to have the same name
	   and structure as the underlying API that implements the
	   functionality the commands execute.


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
