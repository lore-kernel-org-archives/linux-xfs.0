Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4Q7WggB068508 for <xfs@oss.sgi.com>; Wed, 26 May 2010 02:32:43 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5657A52DCE
	for <xfs@oss.sgi.com>; Wed, 26 May 2010 00:36:48 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id XAYoTjUtJRB3hUgv for
	<xfs@oss.sgi.com>; Wed, 26 May 2010 00:36:48 -0700 (PDT)
Message-ID: <4BFCCF1F.7010701@tlinx.org>
Date: Wed, 26 May 2010 00:34:55 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfsdump -- not enough memory to dump attributes? w/>20G free	--
	how much does it need?
References: <4BF7D787.4020903@tlinx.org> <20100525164244.GB18666@infradead.org>
In-Reply-To: <20100525164244.GB18666@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

 

Christoph Hellwig wrote:
> The error comes directly from the libhandle listing routine, which
> is a straight forward wrapper around the kernel syscall in current
> xfsprogs.
> 
> What xfsprogs version are you using?  I noticed your xfsdump is
> rather old, so making sure you have recent XFS userspace and
> possibly also the kernel would help debugging this.
> 
> Also can you check using strace if the ENOMEM comes directly from
> the attr_list_by_handle ioctl?
---
versions:
xfsprogs/xfsdump both at 3.0.1-2.1 from suse11.2 which would 
likely be 3.0.1 with some patchlevel from suse.
kernel is 2.6.34 (vanilla).

strace would be pretty difficult considering how far it is into a dump
before it is triggered.

Maybe I should try getting updated tools and see
if it "goes away"...

looks like I need to build xfsprogs before xfsdump?

looks like best way to pull current ver is from .git.

will try rebuilding and see if I have any luck...


BTW -- how do you tell the version of the xfs progs from 
the individual progs -- I'm going from the installed rpm
name, but if I build from the git, that won't be helpful.
I don't see a VERSION command in xfsdump/restore?

Is there one with any of the xfs tools? 

tnx,
-linda

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
