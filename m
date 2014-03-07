Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DA9AB7F50
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 20:23:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9077FAC005
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 18:23:52 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id dgqBMTuRDv6Hk3o2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Mar 2014 18:23:50 -0800 (PST)
Message-ID: <53192DAA.1040305@oracle.com>
Date: Fri, 07 Mar 2014 10:23:38 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: Hello, I have a question about XFS File System
References: <195DE8C60CE24A62A71911FDE0B0DC97@gmail.com>
	<20140306225947.GM6851@dastard>
In-Reply-To: <20140306225947.GM6851@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Yongmin <dev.yongmin@gmail.com>
Cc: xfs@oss.sgi.com



On 03/07 2014 06:59 AM, Dave Chinner wrote:
> On Thu, Mar 06, 2014 at 06:15:27PM +0900, Yongmin wrote:
>>
>> Hello.
>>
>> My name is Yongmin Park and I am a graduated student in Ajou University (Korea).
>> My research area is Digital Forensics.
>> And this time i tried to understand the structure of XFS file system, because XFS is one of the famous huge file system in these days.
>>
>> I already founded and read 'XFS Filesystem Structure 2nd Edition Revision 1' on the Internet, which was written by Silicon Graphics Inc in 2006 and it is really well written to understand.
>>
>> But the concentrated part of mine is "Deleted File Recovery", so the Journaling part is really important for me,, but regretfully there are no specific guide line about Journaling part...
>> Also next version(maybe the 3re Edition) is not exsist for more than a 5 years.
>>
>> So is there no guide line for journaling part in XFS?
>> How can i get them,, have I to buy them? or Is Analysing Source Cord only way to study?
> 
> There is some documentation about some of the logging concepts and
> design. eg:
> 
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-documentation.git;a=blob;f=design/xfs-delayed-logging-design.asciidoc

Not sure if someone else also think that XFS journal design is the stumbling-block
to get involved into the development...but I once heard of "I'm really confused by
the design of delayed logging, I have to give up after reading the document for about
2 or 3 weeks..." from 2 Chinese developers in the past year, though nothing can help
someone out without taking infinite patience.

> 
> But the only way to learn about the actual structure of the log is to
> read the code and use xfs_logprint to study the contents of the log.

To Yongmin,

For your information only.

I'm trying to understand XFS journal via the following steps:

1) Download Linux-2.6.34 source, read the journal code.
Understand the original design as there is no delayed-logging support at that time.

FYI, two obsoleted documents could be found at,
http://oss.sgi.com/projects/xfs/design_docs/xfsdocs93_pdf/log_mgr-overview.pdf
http://oss.sgi.com/projects/xfs/design_docs/xfsdocs93_pdf/log_mgr.pdf

2) Download Linux-2.6.35 source, read the journal code and delayed-logging-design doc as
per Dave's suggestion because we have this big change in this version.

3) Play with xfs_logprint with the XFS mainline source and read all those threads in XFS
mailing list which are related to journals in the past several years....

4) Nothing, just have fun. :)


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
