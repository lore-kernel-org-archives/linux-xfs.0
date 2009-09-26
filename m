Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8QI2O3P256816 for <xfs@oss.sgi.com>; Sat, 26 Sep 2009 13:02:24 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 782A016F1EFA
	for <xfs@oss.sgi.com>; Sat, 26 Sep 2009 11:03:43 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id eT6IbuVrDilWjJn9 for
	<xfs@oss.sgi.com>; Sat, 26 Sep 2009 11:03:43 -0700 (PDT)
Message-ID: <4ABE577E.8060303@sandeen.net>
Date: Sat, 26 Sep 2009 13:03:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] fix readahead calculations in	xfs_dir2_leaf_getdents()
References: <4ABA5192.80509@sandeen.net> <4ABD1D22.2030002@sandeen.net>
	<20090926170423.GA28387@infradead.org>
In-Reply-To: <20090926170423.GA28387@infradead.org>
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
Cc: tobias@lists.yoper.com, xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Fri, Sep 25, 2009 at 02:42:26PM -0500, Eric Sandeen wrote:
>> V2: use min() as suggested by Jeff, it's tidier.
> 
> I disagree with that, with the cast it looks pretty horrible.
> At least use min_t to avoid the case, but what's wrong with:
> 
>> +		/* bufsize may have just been a guess; don't go negative */
>> +		bufsize = min((bufsize - length), (size_t)0);
> 
> 		bufsize = bufsize - length > 0 ? bufsize - length : 0;

ok, that's fine too.

I'll pick one.

> Anyway, takes this as a
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> for any variant.
> 

thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
