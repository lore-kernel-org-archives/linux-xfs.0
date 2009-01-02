Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n02I3qvL019163 for <xfs@oss.sgi.com>; Fri, 2 Jan 2009 12:03:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A17BB1BFA1F9
	for <xfs@oss.sgi.com>; Fri,  2 Jan 2009 10:03:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id eivplr97bIU4HsLK for
	<xfs@oss.sgi.com>; Fri, 02 Jan 2009 10:03:51 -0800 (PST)
Date: Fri, 2 Jan 2009 13:03:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests Makepkgs framework, builds rpms
Message-ID: <20090102180320.GD29506@infradead.org>
References: <495D42CE.6060806@sandeen.net> <495D8E64.5070206@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <495D8E64.5070206@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Jan 01, 2009 at 09:47:48PM -0600, Eric Sandeen wrote:
> With the install target in place, this lets us do Makepkgs:
> 
> == dist, log is Logs/dist
> Wrote: /root/src/xfstests-dev.work/build/xfstests-1.0.0.src.tar.gz
> Wrote: /root/src/xfstests-dev.work/build/tar/xfstests-1.0.0.tar.gz
> Wrote: /root/src/xfstests-dev.work/build/rpm/xfstests-1.0.0-1.src.rpm
> Wrote: /root/src/xfstests-dev.work/build/rpm/xfstests-1.0.0-1.x86_64.rpm
> 
> It's all largely cut & pasted from the xfsprogs framework.
> I'll let the debian elves do the things they do for debian 
> packaging if they're interested...
> 
> xfstests could use more work to make it package-friendly but this
> is a good start at least.

You missed the Debian packaging :)  I'll give it a try.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
