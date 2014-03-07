Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 176B67F51
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 23:24:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EEA05304062
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 21:24:22 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id jMUuEA1KuKL6VyT6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Mar 2014 21:24:21 -0800 (PST)
Message-ID: <531957E9.50903@oracle.com>
Date: Fri, 07 Mar 2014 13:23:53 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: Hello, I have a question about XFS File System
References: <195DE8C60CE24A62A71911FDE0B0DC97@gmail.com>	<20140306225947.GM6851@dastard>
	<53192DAA.1040305@oracle.com> <20140307041917.GP6851@dastard>
In-Reply-To: <20140307041917.GP6851@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Yongmin <dev.yongmin@gmail.com>, xfs@oss.sgi.com


On 03/07 2014 12:19 PM, Dave Chinner wrote:
> On Fri, Mar 07, 2014 at 10:23:38AM +0800, Jeff Liu wrote:
>>
<snip>
>>>
>>> There is some documentation about some of the logging concepts and
>>> design. eg:
>>>
>>> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-documentation.git;a=blob;f=design/xfs-delayed-logging-design.asciidoc
>>
>> Not sure if someone else also think that XFS journal design is the stumbling-block
>> to get involved into the development...but I once heard of "I'm really confused by
>> the design of delayed logging, I have to give up after reading the document for about
>> 2 or 3 weeks..." from 2 Chinese developers in the past year, though nothing can help
>> someone out without taking infinite patience.
> 
> Let me put it this way: it took me *5 years* of working deep in the
> XFS code to really understand how the XFS transaction and
> journalling subsystems are supposed to function. Delayed logging
> took me 3 failed design attempts over 3 years before I had learnt
> enough to come up with a design that worked.  It's by far the most
> complex part of XFS - expecting to understand how it works by
> spending a couple of weeks reading the code is unrealistic.

Hah, this would help me relax a lot when I felt frustrating to understand
something in XFS :-P.


> Fundamentally, understanding delayed logging means you have to first
> understand why relogging is necessary in the XFS journal. To
> understand why relogging is necessary, you first need to understand
> the transaction subsystem, the log space reservation subsystem, log
> recovery constraints, how tail pushing works, the physical log
> interface code, the on-disk log format, etc andhow they all
> interact.
> 
> IOWs, delayed logging is the last thing in the journalling layer
> that anyone should try to understand because understanding it fully
> requires a high level of knoweldge about the XFS metadata and
> logging subsystem architecture and fundamental principles....

Thanks for the nice guidance.

> 
>>> But the only way to learn about the actual structure of the log is to
>>> read the code and use xfs_logprint to study the contents of the log.
>>
>> To Yongmin,
>>
>> For your information only.
>>
>> I'm trying to understand XFS journal via the following steps:
>>
>> 1) Download Linux-2.6.34 source, read the journal code.
>> Understand the original design as there is no delayed-logging support at that time.
> 
> Delayed logging changes neither the journal nor the transaction
> layer code or design. If you can't understand the fundamental
> principles behind those subsystems from the current code, then
> looking at the older code won't make it any clearer because it is
> exactly the same...
> 
>> FYI, two obsoleted documents could be found at,
>> http://oss.sgi.com/projects/xfs/design_docs/xfsdocs93_pdf/log_mgr-overview.pdf
>> http://oss.sgi.com/projects/xfs/design_docs/xfsdocs93_pdf/log_mgr.pdf
> 
> The first of those really doesn't contain much useful information.
> 
> The second really only documents the physical log format. That might
> be useful as a first step, but it doesn't document any of the
> alogorithms that the log uses, and that is where all the complexity
> lies.

Actually, both documents are only a little useful to me when I began to
understand the semantics of in-core logs.

> 
> Reading code will only get you so far - the only way to continue the
> learning process is by trying to modify the code and fixing what you
> break, along with asking questions about things you don't understand
> on the list so that people who do understand them can teach you
> things that aren't obvious from the code and aren't documented
> anywhere other than the code.


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
