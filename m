Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13KbN8I243397 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 14:37:24 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D62E01C9EA39
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2010 12:38:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HjUgrfoPZpeYTLE5 for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2010 12:38:33 -0800 (PST)
Date: Wed, 3 Feb 2010 15:38:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: State of XFS on ARM
Message-ID: <20100203203833.GA31908@infradead.org>
References: <13bb8ce11002011924h611099feh4955eedcc6e588a6@mail.gmail.com>
	<20100202112300.GA23809@infradead.org>
	<13bb8ce11002021819l7e17dac4n5f58a9887a16fae2@mail.gmail.com>
	<13bb8ce11002031234t4b02b199g5b8dfd65ea48aa13@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <13bb8ce11002031234t4b02b199g5b8dfd65ea48aa13@mail.gmail.com>
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
To: Daniel Goller <morfic@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 03, 2010 at 02:34:43PM -0600, Daniel Goller wrote:
> Any particular stress test you can suggest, to use once i try git for
> xfs on this Marvell box?
> To try to help bringing up issues faster than through normal use of this box?

The primary use of the large buffers where this matters is the log.
So you just need to cleanly unmount and mount the filesystem again,
and the issues your previously reported should be gone.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
