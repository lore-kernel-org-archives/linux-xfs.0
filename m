Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2B8B829DF8
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 10:56:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F30B230408C
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 08:56:48 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id oGRh8a2997vFB1re for <xfs@oss.sgi.com>;
	Fri, 07 Feb 2014 08:56:43 -0800 (PST)
Message-ID: <52F5104A.1000701@sandeen.net>
Date: Fri, 07 Feb 2014 10:56:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Troubleshooting log corruption
References: <20140207163921.GA43189@wintermute.home>
In-Reply-To: <20140207163921.GA43189@wintermute.home>
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
To: Mike Roth <mroth@gopivotal.com>, xfs@oss.sgi.com

On 2/7/14, 10:39 AM, Mike Roth wrote:
> I've recently had a few systems experience a hard failure (power
> supply failure) and our XFS file system failed to recover.  The file
> system fails to mount and I need to clear the logs before running
> repair on them.  My understanding is that XFS should be more resilient
> to this kind of issue.
> 
> I'm trying to dive a bit further into why this is happening (meta-data
> corruption) and I'm wondering if anyone can provide some suggestions
> as far as data to collect or tests to run to help understand why this
> corruption is happening on system failures.
> 
> Thank you,
> mike

First off, 

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

But for starters, which kernel are you running, what did the kernel say when mount failed, what is the storage beneath the filesystem, what sort of caching does it have, and what is the status of the barrier mount option for this filesystem?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
