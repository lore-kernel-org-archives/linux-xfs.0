Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Apr 2008 16:45:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3QNjYPD013981
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 16:45:34 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DEAF215EE70D
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 16:46:13 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157]) by cuda.sgi.com with ESMTP id mWBaSuPUlRL85MTF for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 16:46:13 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id e12so3677652fga.8
        for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 16:46:13 -0700 (PDT)
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Date: Sun, 27 Apr 2008 01:45:11 +0200
References: <200804261651.02078.vda.linux@googlemail.com> <20080426200347.GA21021@infradead.org>
In-Reply-To: <20080426200347.GA21021@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804270145.11632.vda.linux@googlemail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

On Saturday 26 April 2008 22:03, Christoph Hellwig wrote:
> On Sat, Apr 26, 2008 at 04:51:02PM +0200, Denys Vlasenko wrote:
> > Hi David,
> > 
> > This patch reduces xfs_bmap_btalloc() stack usage by 50 bytes
> > by moving part of its body into a helper function.
> > 
> > This results in some variables not taking stack space in
> > xfs_bmap_btalloc() anymore.
> 
> I think this is a good idea, although I'd rather split the function at
> a local boundary.  The patch below (which passes xfsqa) does that
> by splitting out the handling of the most complicated nullfb case
> out.  It probably won't help reducing stack useage as much as yours,
> but it helps beeing able to read the code a little better.

It saves only 16 bytes of stack.
--
vda
