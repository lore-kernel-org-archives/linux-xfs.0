Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 016817F37
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 19:21:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E1D038F8037
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 17:21:50 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	wc2P53Ku02YD8MlP for <xfs@oss.sgi.com>;
	Sat, 03 May 2014 17:21:49 -0700 (PDT)
Date: Sun, 4 May 2014 10:21:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix Q_XQUOTARM ioctl
Message-ID: <20140504002119.GM26353@dastard>
References: <535580A1.20806@redhat.com> <20140503114816.GA31191@infradead.org>
	<5364FED5.1050203@sandeen.net>
	<20140503151440.GA28608@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140503151440.GA28608@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Sat, May 03, 2014 at 08:14:40AM -0700, Christoph Hellwig wrote:
> On Sat, May 03, 2014 at 09:36:05AM -0500, Eric Sandeen wrote:
> > Whoops, missed reply-all.
> > 
> > Yes, it will fail this way w/o the kernel patch.
> > 
> > User quota gets removed OK because flags accidentally line up;
> > group quota remains, so you'd see exactly this.
> 
> Ok.  Dave, can you pick it up for for-next?

It's in my queue - I've been trying to get everything sorted for a
3.15-rc4 update first before pushing more 3.16 changes into
for-next. That's been going round in circles on the
truncate_setsize() issue, but I think that is sorted now so it'll be
done soon. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
