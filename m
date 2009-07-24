Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6ODgHej130733 for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 08:42:17 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFFEB13EF34D
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 06:43:01 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id TuHXF3kM6ZEXWgwl for
	<xfs@oss.sgi.com>; Fri, 24 Jul 2009 06:43:01 -0700 (PDT)
Message-ID: <4A69BA63.4030501@sandeen.net>
Date: Fri, 24 Jul 2009 08:42:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: BUG REPORT: XFS LOG FORWARD COMPATIBILITY PROBLEM
References: <1301281514.948741248423723710.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1301281514.948741248423723710.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
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
To: Lachlan McIlroy <lmcilroy@redhat.com>
Cc: Eddy Zhao <eddy.y.zhao@gmail.com>, xfs@oss.sgi.com

Lachlan McIlroy wrote:
> Hi Eddy,
> 
> CC'ing this to the xfs list.
> 
> ----- "Eddy Zhao" <eddy.y.zhao@gmail.com> wrote:
> 
>> Hello Felix, Lachlan:
>>
>> I find your names in 2.6.30 Changlog as XFS maintainer. Can you kindly
>> take a look at the problem we are facing.
>>
>> Follow the sequence below to reproduce the problem
>> - write data on 2.6.28 system
>> - unplug usb disk while writing
> I don't recommend you pull the usb disk out while the filesystem is still
> mounted (if you can avoid it).
> 

Unless you have write barriers enabled and passing through to the USB
device, or write cache turned off on the USB device, this test may well
just be corrupting the log to an unreplayable state.

Although I can't explain why, w/o further modification, it seems to
mount again on .28 ...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
