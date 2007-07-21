Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Jul 2007 20:35:29 -0700 (PDT)
Received: from waldorf.loreland.org (ip186.digipost.co.nz [203.110.30.186] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6L3ZPbm006455
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2007 20:35:26 -0700
In-Reply-To: <469F8005.3080104@sandeen.net>
References: <4560AB84.9060200@sandeen.net> <48478.193.203.83.22.1184855825.squirrel@colo.loreland.org> <469F8005.3080104@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <73EF8A3A-4768-4717-88B4-57A2E00D4E02@loreland.org>
Content-Transfer-Encoding: 7bit
From: James Braid <jamesb@loreland.org>
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
Date: Sat, 21 Jul 2007 04:34:32 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 19 Jul 2007, at 16:15, Eric Sandeen wrote:
> That's odd.  You have the module on the server, exporting an xfs
> filesystem, and you're getting permission denied on the client?

Yep. And rmmod'ing the updated XFS module and insmod'ing the older  
module makes it work again.

(yeah, in an ideal world we'd just run the latest kernel, but we're  
stuck on RHEL4 for a bunch of reasons and XFS is so much better than  
ext3 for our purposes, even with the old crufty version in the RHEL4  
kernel)
