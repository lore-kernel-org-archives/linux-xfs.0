Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4HKtGrW246535
	for <linux-xfs@oss.sgi.com>; Thu, 17 May 2012 15:55:16 -0500
Message-ID: <4FB565C6.8080303@canonical.com>
Date: Thu, 17 May 2012 15:55:34 -0500
From: Chris J Arges <chris.j.arges@canonical.com>
MIME-Version: 1.0
Subject: Re: Still seeing hangs in xlog_grant_log_space
References: <20120426224412.GA9541@dastard>
	<CADLDEKs6oMDA-6OhmcFxyRoBVpduKtSput=53TQGn9NCAOXC1Q@mail.gmail.com>
	<20120426230738.GB9541@dastard>
	<CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507171908.GA16881@sgi.com>
	<CADLDEKvgT_FcGhJKoPaQv0mh_Jqdaqu8SYatc9xxU7vOY217YQ@mail.gmail.com>
	<loom.20120510T180646-433@post.gmane.org>
	<20120516184231.GK16099@sgi.com>
In-Reply-To: <20120516184231.GK16099@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-xfs@oss.sgi.com, tinguely@sgi.com

On 05/16/2012 01:42 PM, Ben Myers wrote:
> Hey Chris,
> 
> On Thu, May 10, 2012 at 04:11:27PM +0000, Chris J Arges wrote:
>> <snip>
>>> Canonical attached them to the bug report that they filed yesterday:
>>> http://oss.sgi.com/bugzilla/show_bug.cgi?id=922
>>>
>>> ...Juerg
>>>
>>
>> Hello,
>> I am able to reproduce this bug with the instructions posted in this bug. Let me 
>> know what I can do to help.
> 
> The bug shows:
> 
> |This has been tested on the following kernels which all exhibit the same
> |failures:
> |- 3.2.0-24 (Ubuntu Precise)
> |- 3.4.0-rc4
> |- 3.0.29
> |- 3.1.10
> |- 3.2.15
> |- 3.3.2
> 
> Can you find an older kernel that isn't broken?
> 
Tested with Ubuntu Lucid 2.6.32-38-generic #38 (upstream 2.6.32.52), so
far I am able to run the test for 5 hours, which on the same machine I
have typically been able to reproduce in 2 hours. Will continue to run
this, and on another system to verify.

--chris

> -Ben
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
