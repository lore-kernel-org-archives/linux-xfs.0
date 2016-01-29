Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C5C1B7CA2
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 02:02:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B60848F8039
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 00:02:00 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id WxopbIoB74MSEeCh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 29 Jan 2016 00:01:58 -0800 (PST)
Date: Fri, 29 Jan 2016 09:01:57 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: stop using ioends for direct write completions
Message-ID: <20160129080157.GA30986@lst.de>
References: <1452766237-2314-1-git-send-email-hch@lst.de>
	<20160128131656.GB14876@infradead.org>
	<20160128205333.GF20038@birch.djwong.org>
	<20160128211056.GA27287@lst.de>
	<20160128215853.GC6431@birch.djwong.org>
	<20160128220255.GA28202@lst.de>
	<20160128223131.GD6431@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160128223131.GD6431@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 28, 2016 at 02:31:31PM -0800, Darrick J. Wong wrote:
> As for the generic/154... the code on github is sadly not very bisectable,
> other than to say that until yesterday I was still tacking new code onto
> the end of the patchset.
> 
> That said, I was seeing occasional hangs in generic/154 (I needed to roll
> the transactions between key parts of wrapping up a CoW) and they seem to
> have gone away, so it's possible that I've fixed it already.

I'm seeing them with a HEAD of 9628553acf5ff4225e047d580094ffab64605f50,
but only when using NFS.  If you've got something newer feel free
to push it out, otherwise I'll have to spend some more time
trying to figure out what's going on with this version.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
