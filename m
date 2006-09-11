Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Sep 2006 05:32:40 -0700 (PDT)
Received: from rapidforum.com (www.rapidforum.com [80.237.244.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8BCWKDW005843
	for <xfs@oss.sgi.com>; Mon, 11 Sep 2006 05:32:21 -0700
Message-ID: <45055717.4090800@rapidforum.com>
Date: Mon, 11 Sep 2006 14:31:19 +0200
From: Christian Schmid <webmaster@rapidforum.com>
MIME-Version: 1.0
Subject: Re: Critical xfs bug in 2.6.17.11?
References: <4504151F.6050704@rapidforum.com> <Pine.LNX.4.64.0609101731150.29937@p34.internal.lan> <45048E1E.6040002@rapidforum.com> <Pine.LNX.4.64.0609101835390.29937@p34.internal.lan> <4504A12C.9090608@rapidforum.com> <20060911010035.GL10950339@melbourne.sgi.com>
In-Reply-To: <20060911010035.GL10950339@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

I am not sure. Its a linux software-raid and as far as I know there is a crc-check in the drives so 
if they cant read the data, they give an error and the raid gets the data from the other drive and 
marks this drive as broken. As far as the log says, the drives are ok.

David Chinner wrote:
> On Mon, Sep 11, 2006 at 01:35:08AM +0200, Christian Schmid wrote:
> 
>>Memory-test with ECC disabled ran through 12 hours without any errors. ECC 
>>is on now of course, so the possibility of a simple hardware problem is 
>>eliminated from my side.
> 
> 
> A _memory error_ can be ruled out, but what about a bad disk, bad
> disk controller, bad PCI bus interface, a bad driver, etc. Memory is
> just one piece of hardware that can result in bad data being read
> from or written to disk. Is there any indication of disk or driver
> errors in your syslog?
> 
> Cheers,
> 
> Dave.
