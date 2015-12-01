Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 434177F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 13:41:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 25BEE8F8033
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 11:41:44 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id heD42n2SAHbLgBN1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2015 11:41:41 -0800 (PST)
Date: Tue, 1 Dec 2015 11:41:39 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151201194139.GA19035@infradead.org>
References: <20151201131114.GA26129@bfoster.bfoster>
	<565DA784.5080003@scylladb.com>
	<20151201145631.GD26129@bfoster.bfoster>
	<565DBB3E.2010308@scylladb.com>
	<20151201160133.GE26129@bfoster.bfoster>
	<565DC613.4090608@scylladb.com>
	<20151201162958.GF26129@bfoster.bfoster>
	<565DD449.5090101@scylladb.com>
	<20151201185113.GG26129@bfoster.bfoster>
	<565DF472.8080101@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565DF472.8080101@scylladb.com>
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
To: Avi Kivity <avi@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, Glauber Costa <glauber@scylladb.com>, xfs@oss.sgi.com

On Tue, Dec 01, 2015 at 09:26:42PM +0200, Avi Kivity wrote:
> It's basically the same thing.  To to this, we'd have get_block either
> return the block's address (if it was in some metadata cache), or, if it was
> not, issue an I/O that fills (part of) that cache, and as its completion
> function, a continuation that reruns __blockdev_direct_IO from the point it
> was stopped so it can submit the data I/O (if the metadata cache was
> completely updated) or issue the next I/O aiming to fill that metadata
> cache, if it was not.

We did something this for blocking reads with great results, and it could be
done similarly for direct I/O I think:

	https://lwn.net/Articles/612483/

Unfortunately Andrew shut it down for odd reasons so it didn't get in.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
