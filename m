Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5THb2vj125897 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 12:37:03 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F4401673745
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 10:37:01 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	0GCTSDZerTPuTDVe for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 10:37:01 -0700 (PDT)
Date: Wed, 29 Jun 2011 13:36:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Message-ID: <20110629173648.GA22293@infradead.org>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<1309275199-10801-5-git-send-email-josef@redhat.com>
	<20110629065306.GC1026@dastard>
	<20110629074021.GA26086@infradead.org>
	<4E0B019E.8080800@draigBrady.com> <4E0B60DE.50908@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E0B60DE.50908@oracle.com>
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
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, P?draig Brady <P@draigBrady.com>, Josef Bacik <josef@redhat.com>

On Wed, Jun 29, 2011 at 10:29:02AM -0700, Sunil Mushran wrote:
> I'm not too sure about that. Atleast not enabled by default. Most users
> use cp to backup data. Not empty space. In this case, this empty extent
> may not even be de-dupable.
> 
> Frankly I'd be happier of cp started to exploited fallocate() to create larger
> extents before copying data into them. Atleast for the large files.

That's what delayed allocation is for.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
