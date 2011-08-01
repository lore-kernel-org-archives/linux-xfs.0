Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p71IX2DZ019696 for <xfs@oss.sgi.com>; Mon, 1 Aug 2011 13:33:03 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC2B215F8E39
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2011 11:33:38 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	FD5G8ViCJKavAp2F for <xfs@oss.sgi.com>;
	Mon, 01 Aug 2011 11:33:38 -0700 (PDT)
Date: Mon, 1 Aug 2011 14:32:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] jfs: flush journal completely before releasing metadata
	inodes
Message-ID: <20110801183255.GA30985@infradead.org>
References: <20110729155039.GA28306@infradead.org>
	<4E32D9EB.9020406@oracle.com> <4E36F086.4070900@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E36F086.4070900@oracle.com>
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
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, jfs-discussion@lists.sourceforge.net, xfs@oss.sgi.com

On Mon, Aug 01, 2011 at 01:29:26PM -0500, Dave Kleikamp wrote:
> On 07/29/2011 11:03 AM, Dave Kleikamp wrote:
> > On 07/29/2011 10:50 AM, Christoph Hellwig wrote:
> >> The patch below adds basic jfs support to xfstests.  Unfortunately it
> >> doesn't get very far, as test 001 already blows up with a kernel crash,
> >> as do 011 and 013 as other random picks.
> > 
> > Great :-)
> > 
> > Seems to be a good idea to support jfs. I'll carve out some time to
> > reproduce and debug the crashes.
> 
> This fixes a race during unmount. We need to not only make sure that
> the journal is completely written, but that the metadata changes make
> it to disk before releasing ipimap and ipbmap.

Looks sensible.  How far does a ./check -g auto get now?  Any other
failures?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
