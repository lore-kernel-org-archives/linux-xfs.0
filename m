Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7BHlaN4149213 for <xfs@oss.sgi.com>; Tue, 11 Aug 2009 12:47:46 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 817B03BE84A
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2009 10:47:58 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 67x0XEkfAKTQGjlt for <xfs@oss.sgi.com>;
	Tue, 11 Aug 2009 10:47:58 -0700 (PDT)
Message-ID: <4A81AEC3.1060200@sandeen.net>
Date: Tue, 11 Aug 2009 12:47:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Best design docs for XFS
References: <4A808FC7.2020800@jquigley.com> <4A80A597.6050806@sandeen.net>
	<20090811025356.GA28108@infradead.org>
	<4A81A9F9.4030509@jquigley.com>
In-Reply-To: <4A81A9F9.4030509@jquigley.com>
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
To: John Quigley <jquigley@jquigley.com>
Cc: Christoph Hellwig <hch@infradead.org>, XFS Development <xfs@oss.sgi.com>

John Quigley wrote:
> Christoph Hellwig wrote:

...

>> Is there anything specific you're looking for?
> 
> In my work, I've just begun to use XFS as the interface into a very
> large, virtual storage system, to great effect.  It's my first direct
> interaction with the file system, and I've been hugely impressed with
> its power, speed and versatility.
> 
> The only unresolved problem that we're experiencing has to do with
> file system corruption in a failover scenario, and my immediate need
> in understanding some of the internals is to wrap my hands around
> this problem (I may email this list with details if I can
> sufficiently explain myself).

Any failover you're doing would need to be handled outside the
filesystem, of course; STONITH etc?  I don't know that reading xfs
internals will be all that relevant.

But I suppose the details may help if you think it is an xfs-related
problem.

> A more long-term need we have is for clustering support.  I've read
> lightly about CXFS, though it appears to be inactive, or at least not
> open source.  Has clustering support been discussed with the members
> here?  If so, I'd like to take part in those conversations if there's
> sufficient interest to engage in that way.

CXFS is and probably will be the only direct clustering mechanism for
xfs... it is still active, though as you note it is not (and probably
will never be?) open source.

block-layer failover should be as possible on xfs as any other
filesystem, though.

-Eric

> Thanks very much again.
> 
> John Quigley jquigley.com
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
