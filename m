Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 21 Jul 2007 07:58:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6LEwSbm003297
	for <xfs@oss.sgi.com>; Sat, 21 Jul 2007 07:58:29 -0700
Message-ID: <46A21F16.5080601@sandeen.net>
Date: Sat, 21 Jul 2007 09:58:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
References: <4560AB84.9060200@sandeen.net> <48478.193.203.83.22.1184855825.squirrel@colo.loreland.org> <469F8005.3080104@sandeen.net> <73EF8A3A-4768-4717-88B4-57A2E00D4E02@loreland.org>
In-Reply-To: <73EF8A3A-4768-4717-88B4-57A2E00D4E02@loreland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: James Braid <jamesb@loreland.org>
Cc: xfs@oss.sgi.com

James Braid wrote:
> On 19 Jul 2007, at 16:15, Eric Sandeen wrote:
>> That's odd.  You have the module on the server, exporting an xfs
>> filesystem, and you're getting permission denied on the client?
> 
> Yep. And rmmod'ing the updated XFS module and insmod'ing the older  
> module makes it work again.

Interesting - what are the exact versions of "updated" and "older" that
you are using?  I'll look at the diff...

Thanks,
-Eric

> (yeah, in an ideal world we'd just run the latest kernel, but we're  
> stuck on RHEL4 for a bunch of reasons and XFS is so much better than  
> ext3 for our purposes, even with the old crufty version in the RHEL4  
> kernel)
> 
