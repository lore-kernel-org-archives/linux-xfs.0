Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KJ1sxn107100 for <xfs@oss.sgi.com>; Fri, 20 May 2011 14:01:55 -0500
Received: from e38.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39C361342773
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 12:01:53 -0700 (PDT)
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159]) by
	cuda.sgi.com with ESMTP id gyQZLrqbmbh5ivh4 for
	<xfs@oss.sgi.com>; Fri, 20 May 2011 12:01:53 -0700 (PDT)
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by e38.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4KIrd0k009524
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 12:53:39 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p4KJ1fP7119380 for <xfs@oss.sgi.com>; Fri, 20 May 2011 13:01:41 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p4KD1eUS026881
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 07:01:40 -0600
Subject: Re: Failure of xfstest 229
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110520171304.GA20208@infradead.org>
References: <1305852937.7661.369.camel@chandra-lucid.beaverton.ibm.com>
	<20110520025840.GP32466@dastard>
	<1305909303.7661.373.camel@chandra-lucid.beaverton.ibm.com>
	<20110520171304.GA20208@infradead.org>
Date: Fri, 20 May 2011 12:01:37 -0700
Message-ID: <1305918097.7661.377.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: XFS Mailing List <xfs@oss.sgi.com>

It is strange then.

It is the same system, and it failed few hours after it succeeded in
2.6.39.

Basically, I saw seeing the failure with 2TB fs. I thought I will try it
with a 20GB fs, and the very first time it succeeded, but after that it
never did even with the same kernel (2.6.39).

On Fri, 2011-05-20 at 13:13 -0400, Christoph Hellwig wrote:
> On Fri, May 20, 2011 at 09:35:03AM -0700, Chandra Seetharaman wrote:
> > 
> > Can it run successfully by fluke sometimes ? I did have a successful run
> > on the 20G filesystem yesterday once, but not able to reproduce it again
> 
> It doesn't fail on thinly provisioned storage which zeroes out any
> blocks it gives to the OS.  Similarly it might not fail if all blocks
> that it would normally leak are zeroed underneath for some reason,
> but it's rather unlikely that this happens by accident.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
