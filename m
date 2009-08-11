Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7BHQpcB148333 for <xfs@oss.sgi.com>; Tue, 11 Aug 2009 12:27:01 -0500
Received: from mail.jquigley.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BD7012152EC
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2009 10:27:26 -0700 (PDT)
Received: from mail.jquigley.com (main.jquigley.com [67.23.32.156]) by
	cuda.sgi.com with ESMTP id QnXzx5FwCrGGXAn4 for
	<xfs@oss.sgi.com>; Tue, 11 Aug 2009 10:27:26 -0700 (PDT)
Message-ID: <4A81A9F9.4030509@jquigley.com>
Date: Tue, 11 Aug 2009 12:27:21 -0500
From: John Quigley <jquigley@jquigley.com>
MIME-Version: 1.0
Subject: Re: Best design docs for XFS
References: <4A808FC7.2020800@jquigley.com> <4A80A597.6050806@sandeen.net>
	<20090811025356.GA28108@infradead.org>
In-Reply-To: <20090811025356.GA28108@infradead.org>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, XFS Development <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Mon, Aug 10, 2009 at 05:56:23PM -0500, Eric Sandeen wrote:
>> It's pretty good still, the fundamental design is not substantially
>> changed; you're more likely to find missing bits than "wrong" bits I think.
>>
>> http://oss.sgi.com/projects/xfs/training/index.html
>>
>> has more info as well.
> 
> The fundamental design is mostly unchanged.  What you might now want to
> bother reading of the original documents are:
> 
>  dir_design.pdf - the dir code has been completely replaced
>  threads.pdf - this is totally IRIX specific
>  scaffold.pdf - again mostly IRIX specific
>  message.pdf - no idea what this is at all, I never saw traces of this in XFS

Thanks a lot guys, that helps.

> For all others there's quite a bit of IRIXism in there.

Ack.

> Is there anything specific you're looking for?

In my work, I've just begun to use XFS as the interface into a very large, virtual storage system, to great effect.  It's my first direct interaction with the file system, and I've been hugely impressed with its power, speed and versatility.

The only unresolved problem that we're experiencing has to do with file system corruption in a failover scenario, and my immediate need in understanding some of the internals is to wrap my hands around this problem (I may email this list with details if I can sufficiently explain myself).

A more long-term need we have is for clustering support.  I've read lightly about CXFS, though it appears to be inactive, or at least not open source.  Has clustering support been discussed with the members here?  If so, I'd like to take part in those conversations if there's sufficient interest to engage in that way.

Thanks very much again.

John Quigley
jquigley.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
