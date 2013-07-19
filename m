Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CE42C7F55
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 22:37:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E87EAC00E
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 20:37:21 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	8tjgrDe6kUY4fUCQ for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 20:37:19 -0700 (PDT)
Date: Fri, 19 Jul 2013 13:37:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs
	cleaning
Message-ID: <20130719033715.GR11674@dastard>
References: <20130718110437.GA8090@EIS> <20130718111306.GB13468@dastard>
	<20130718112938.GB8090@EIS> <20130718124511.GC13468@dastard>
	<20130718165103.Horde.2fnDfu2TMCHHT7990c6Vqw2@webmail.df.eu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130718165103.Horde.2fnDfu2TMCHHT7990c6Vqw2@webmail.df.eu>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas.Klauer@metamorpher.de
Cc: xfs@oss.sgi.com

On Thu, Jul 18, 2013 at 04:51:03PM +0200, Andreas.Klauer@metamorpher.de wrote:
> Quoting Dave Chinner <david@fromorbit.com>:
> >Have you recently upgraded from an older kernel (i.e. older than 3.9)?
> 
> Sorry, I think I missed this question.
> 
> I update about once a month to latest stable from kernel.org.

Ok, so the verifiers have been there for a while. Next question
-when was the last time you tried to grow the filesystem?

> 3.8.5 (April) -> 3.9.0 (May) -> 3.9.4 (June) -> 3.10.0 (July 1st) ->
> 3.10.1 (July 15th)
> 
> So no "older" kernels really. In case something really goes south I
> have good backups...

I happy to hear someone say that ;)

As it is, can you do an XFS event trace trace when you attempt to
grow the filesystem and send the output of the trace to me? See
here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

for where to get trace-cmd and how to run it to gather the event
trace.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
