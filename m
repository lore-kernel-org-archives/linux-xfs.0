Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 15:20:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9CMKADT025523
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 15:20:10 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CF3D4E846F
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 15:21:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id N1jfX7T2ZsiaPEdy for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 15:21:45 -0700 (PDT)
Message-ID: <48F27878.7050303@sandeen.net>
Date: Sun, 12 Oct 2008 17:21:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix remount rw with unrecognized options
References: <20081012123044.GA30272@lst.de> <48F27807.1080702@sandeen.net> <20081012222032.GA19748@lst.de>
In-Reply-To: <20081012222032.GA19748@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Sun, Oct 12, 2008 at 05:19:51PM -0500, Eric Sandeen wrote:
>> Christoph Hellwig wrote:
>>> When we skip unrecognized options in xfs_fs_remount we should just break
>>> out of the switch and not return because otherwise we may skip clearing
>>> the xfs-internal read-only flag.  This will only show up on some
>>> operations like touch because most read-only checks are done by the VFS
>>> which things this filesystem is r/w.  Eventually we should replace the
>>> XFS read-only flag with a helper that always checks the VFS flag to make
>>> sure they can never get out of sync.
>>>
>>> Bug reported and fix verified by Marcel Beister on #xfs.
>> Seems reasonable.
>>
>> I think this is 2.6.27.1 material?
> 
> Yes.
> 
> 

The recent bug on oss.sgi.com is probably the same; I'm updating it now.

-Eric
