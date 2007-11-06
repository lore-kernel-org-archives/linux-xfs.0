Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 14:38:48 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA6McbiH026277
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 14:38:41 -0800
Subject: Re: TAKE 972756 - Implement fallocate.
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20071106204100.GW995458@sgi.com>
References: <20071102024314.9BF3458C38F7@chook.melbourne.sgi.com>
	 <cc7060690711051042h5c39c540mf60f95e2f67c7bd7@mail.gmail.com>
	 <20071106001223.GY66820511@sgi.com>
	 <cc7060690711060927n1ea8a489n9f02029a11b73b00@mail.gmail.com>
	 <20071106204100.GW995458@sgi.com>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 09:38:53 +1100
Message-Id: <1194388733.3862.206.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>, David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, 2007-11-07 at 07:41 +1100, David Chinner wrote:
> >  Preallocation happened from 1k to 256k. Now, it looks to me that we
> have
> > un-written extents from 4k to 256k. There is no guarantee that data
> from 1k
> > to 4k is all zero'es. 

That guarantee does exist - when the initial 1K block write is done, the
end of the block is zeroed (by the kernel write path).  This is always
done (guaranteed) and is required independently to unwritten extents.

cheers.

-- 
Nathan
