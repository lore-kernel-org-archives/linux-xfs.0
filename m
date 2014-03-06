Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 01CAA7F50
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 17:00:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DD49930408A
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 15:00:02 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vGyP7GgBjBGjAvmX for <xfs@oss.sgi.com>;
	Thu, 06 Mar 2014 15:00:01 -0800 (PST)
Date: Fri, 7 Mar 2014 09:59:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Hello, I have a question about XFS File System
Message-ID: <20140306225947.GM6851@dastard>
References: <195DE8C60CE24A62A71911FDE0B0DC97@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <195DE8C60CE24A62A71911FDE0B0DC97@gmail.com>
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
To: Yongmin <dev.yongmin@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 06, 2014 at 06:15:27PM +0900, Yongmin wrote:
> 
> Hello.
> 
> My name is Yongmin Park and I am a graduated student in Ajou University (Korea).
> My research area is Digital Forensics.
> And this time i tried to understand the structure of XFS file system, because XFS is one of the famous huge file system in these days.
> 
> I already founded and read 'XFS Filesystem Structure 2nd Edition Revision 1' on the Internet, which was written by Silicon Graphics Inc in 2006 and it is really well written to understand.
> 
> But the concentrated part of mine is "Deleted File Recovery", so the Journaling part is really important for me,, but regretfully there are no specific guide line about Journaling part...
> Also next version(maybe the 3re Edition) is not exsist for more than a 5 years.
> 
> So is there no guide line for journaling part in XFS?
> How can i get them,, have I to buy them? or Is Analysing Source Cord only way to study?

There is some documentation about some of the logging concepts and
design. eg:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-documentation.git;a=blob;f=design/xfs-delayed-logging-design.asciidoc

But the only way to learn about the actual structure of the log is to
read the code and use xfs_logprint to study the contents of the log.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
