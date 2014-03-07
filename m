Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E57A97F50
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 22:19:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B860830407F
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 20:19:35 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	v6uZx4Zu26Yv2HGR for <xfs@oss.sgi.com>;
	Thu, 06 Mar 2014 20:19:33 -0800 (PST)
Date: Fri, 7 Mar 2014 15:19:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Hello, I have a question about XFS File System
Message-ID: <20140307041917.GP6851@dastard>
References: <195DE8C60CE24A62A71911FDE0B0DC97@gmail.com>
	<20140306225947.GM6851@dastard> <53192DAA.1040305@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53192DAA.1040305@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Yongmin <dev.yongmin@gmail.com>, xfs@oss.sgi.com

On Fri, Mar 07, 2014 at 10:23:38AM +0800, Jeff Liu wrote:
> 
> 
> On 03/07 2014 06:59 AM, Dave Chinner wrote:
> > On Thu, Mar 06, 2014 at 06:15:27PM +0900, Yongmin wrote:
> >>
> >> Hello.
> >>
> >> My name is Yongmin Park and I am a graduated student in Ajou University (Korea).
> >> My research area is Digital Forensics.
> >> And this time i tried to understand the structure of XFS file system, because XFS is one of the famous huge file system in these days.
> >>
> >> I already founded and read 'XFS Filesystem Structure 2nd Edition Revision 1' on the Internet, which was written by Silicon Graphics Inc in 2006 and it is really well written to understand.
> >>
> >> But the concentrated part of mine is "Deleted File Recovery", so the Journaling part is really important for me,, but regretfully there are no specific guide line about Journaling part...
> >> Also next version(maybe the 3re Edition) is not exsist for more than a 5 years.
> >>
> >> So is there no guide line for journaling part in XFS?
> >> How can i get them,, have I to buy them? or Is Analysing Source Cord only way to study?
> > 
> > There is some documentation about some of the logging concepts and
> > design. eg:
> > 
> > http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-documentation.git;a=blob;f=design/xfs-delayed-logging-design.asciidoc
> 
> Not sure if someone else also think that XFS journal design is the stumbling-block
> to get involved into the development...but I once heard of "I'm really confused by
> the design of delayed logging, I have to give up after reading the document for about
> 2 or 3 weeks..." from 2 Chinese developers in the past year, though nothing can help
> someone out without taking infinite patience.

Let me put it this way: it took me *5 years* of working deep in the
XFS code to really understand how the XFS transaction and
journalling subsystems are supposed to function. Delayed logging
took me 3 failed design attempts over 3 years before I had learnt
enough to come up with a design that worked.  It's by far the most
complex part of XFS - expecting to understand how it works by
spending a couple of weeks reading the code is unrealistic.

Fundamentally, understanding delayed logging means you have to first
understand why relogging is necessary in the XFS journal. To
understand why relogging is necessary, you first need to understand
the transaction subsystem, the log space reservation subsystem, log
recovery constraints, how tail pushing works, the physical log
interface code, the on-disk log format, etc andhow they all
interact.

IOWs, delayed logging is the last thing in the journalling layer
that anyone should try to understand because understanding it fully
requires a high level of knoweldge about the XFS metadata and
logging subsystem architecture and fundamental principles....

> > But the only way to learn about the actual structure of the log is to
> > read the code and use xfs_logprint to study the contents of the log.
> 
> To Yongmin,
> 
> For your information only.
> 
> I'm trying to understand XFS journal via the following steps:
> 
> 1) Download Linux-2.6.34 source, read the journal code.
> Understand the original design as there is no delayed-logging support at that time.

Delayed logging changes neither the journal nor the transaction
layer code or design. If you can't understand the fundamental
principles behind those subsystems from the current code, then
looking at the older code won't make it any clearer because it is
exactly the same...

> FYI, two obsoleted documents could be found at,
> http://oss.sgi.com/projects/xfs/design_docs/xfsdocs93_pdf/log_mgr-overview.pdf
> http://oss.sgi.com/projects/xfs/design_docs/xfsdocs93_pdf/log_mgr.pdf

The first of those really doesn't contain much useful information.

The second really only documents the physical log format. That might
be useful as a first step, but it doesn't document any of the
alogorithms that the log uses, and that is where all the complexity
lies.

Reading code will only get you so far - the only way to continue the
learning process is by trying to modify the code and fixing what you
break, along with asking questions about things you don't understand
on the list so that people who do understand them can teach you
things that aren't obvious from the code and aren't documented
anywhere other than the code.

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
