Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 21:42:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9O4gKAY006762
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 21:42:20 -0700
Received: from larry.melbourne.sgi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id A14A11B16131
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 19:09:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130]) by cuda.sgi.com with SMTP id m7tbcWR624DjmnUN for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 19:09:41 -0700 (PDT)
Message-ID: <49013C47.4090601@sgi.com>
Date: Fri, 24 Oct 2008 13:08:55 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: deadlock with latest xfs
References: <4900412A.2050802@sgi.com> <20081023205727.GA28490@infradead.org>
In-Reply-To: <20081023205727.GA28490@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Oct 23, 2008 at 07:17:30PM +1000, Lachlan McIlroy wrote:
>> another problem with latest xfs
> 
> Is this with the 2.6.27-based ptools/cvs tree or with the 2.6.28 based
> git tree?  It does looks more like a VM issue than a XFS issue to me.
> 

It's with the 2.6.27-rc8 based ptools tree.  Prior to checking
in these patches:

Can't lock inodes in radix tree preload region
stop using xfs_itobp in xfs_bulkstat
free partially initialized inodes using destroy_inode

I was able to stress a system for about 4 hours before it ran out
of memory.  Now I hit the deadlock within a few minutes.  I need
to roll back to find which patch changed the behaviour.
