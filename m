Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pANFpVTf222233 for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 09:51:31 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37BAA5721FC
	for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 07:51:29 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	oZAJ3VQ5hczDDiDL for <xfs@oss.sgi.com>;
	Wed, 23 Nov 2011 07:51:29 -0800 (PST)
Date: Wed, 23 Nov 2011 10:51:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: EFSCORRUPTED on mount?
Message-ID: <20111123155128.GA16436@infradead.org>
References: <CAF3hT9B8-ou-4RhfCkfFWTwwB_tb7nWSP-5pgP3G6oTE+1gAvA@mail.gmail.com>
	<CAF3hT9AurrVi7xosauVmhQcsbqJgLsxkNYm6dWDNCpB+GR69=w@mail.gmail.com>
	<20111122014114.GJ2386@dastard>
	<CAF3hT9Cu+56WJqzHVu+fMgquddwoMsfW-WC8CvRRBtC4PA3uHw@mail.gmail.com>
	<4ECBEF83.5020607@sandeen.net>
	<CAF3hT9CA23aDfYTF__mVEM7jRq=ZEgqhfX49hK9kcBqM_+h0CQ@mail.gmail.com>
	<4ECC19C3.5070905@sandeen.net>
	<CAF3hT9D1hGh0sj-v4S5tjZBAiztO3OwddSK2dgt8QVLkcWP77A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAF3hT9D1hGh0sj-v4S5tjZBAiztO3OwddSK2dgt8QVLkcWP77A@mail.gmail.com>
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
To: Gregory Farnum <gregory.farnum@dreamhost.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Nov 22, 2011 at 04:03:15PM -0800, Gregory Farnum wrote:
> We're going to look into this in more detail very shortly. Right now
> all I can tell you is that none of the drives ever actually lost
> power, so unless something is explicitly telling them to clear their
> caches I don't know how the drives could have lost their cache to
> cause a problem like this.
> But for now I'll just see what I can get by zeroing out the log, and
> we'll get back to you again if we manage to reproduce this in a
> situation where we can tell you more definitively about the caching
> and barriers.

I would be very interested in that.  The situation you have is fairly
easy to pinpoint down - we do log recovery and find and EFI record
in the log - that is one that logs the intent to free extents.

We haven't found the corresponing EFD record, which cancels it out
as part of the transaction doing the actual freeing.  I'd love to
see a log dump of a fs iff this can be reproduced as that would
shows us if we had some sort of bug in recovery.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
