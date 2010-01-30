Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0UJ8S66231021 for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 13:08:29 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 326F419E18A
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 11:09:35 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lXk6RdUhuAzD2Cnj for
	<xfs@oss.sgi.com>; Sat, 30 Jan 2010 11:09:35 -0800 (PST)
Date: Sat, 30 Jan 2010 14:09:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: 223 - test file alignment on stripe geometry
Message-ID: <20100130190935.GB10181@infradead.org>
References: <4B621529.20708@sandeen.net> <20100130105236.GA18286@infradead.org>
	<4B645AB9.8050508@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B645AB9.8050508@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

> didn't break anything for me; I wanted to be able to see the mkfs
> results w/ geometry, is all.  Will re-double-check but it was fine AFAIK.

Yeah, doesn't seem to cause any problems with a full xfsqa run for me.

> > This is a bit misnamed as it's not a generic fibmap tool but rather
> > a specific tool comparing the bmap to the sunit alignment.
> > 
> 
> good point .. how about making it more generic, something like:
> 
> fibmap -o <file offset> -l <length> -s <stripe alignment> <filename>
> 
> hmm though I hate to reqwrite filefrag ... :)
> 
> I suppose something like this could go into xfs_io as well, but that
> makes this test unavailable to the masses until another release, at least.

I'd just leave it as is but call it t_stripealign or similar.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
