Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KHDEgW102243 for <xfs@oss.sgi.com>; Fri, 20 May 2011 12:13:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F16B31B8EE0C
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 10:13:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FRPFQfEGqHl8sruW for
	<xfs@oss.sgi.com>; Fri, 20 May 2011 10:13:13 -0700 (PDT)
Date: Fri, 20 May 2011 13:13:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Failure of xfstest 229
Message-ID: <20110520171304.GA20208@infradead.org>
References: <1305852937.7661.369.camel@chandra-lucid.beaverton.ibm.com>
	<20110520025840.GP32466@dastard>
	<1305909303.7661.373.camel@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1305909303.7661.373.camel@chandra-lucid.beaverton.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Fri, May 20, 2011 at 09:35:03AM -0700, Chandra Seetharaman wrote:
> 
> Can it run successfully by fluke sometimes ? I did have a successful run
> on the 20G filesystem yesterday once, but not able to reproduce it again

It doesn't fail on thinly provisioned storage which zeroes out any
blocks it gives to the OS.  Similarly it might not fail if all blocks
that it would normally leak are zeroed underneath for some reason,
but it's rather unlikely that this happens by accident.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
