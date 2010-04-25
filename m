Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3PGtZuC023636 for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 11:55:36 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 33E3313261E7
	for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 09:57:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KPEf7Gq6DYrCDvSs for
	<xfs@oss.sgi.com>; Sun, 25 Apr 2010 09:57:38 -0700 (PDT)
Date: Sun, 25 Apr 2010 12:57:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
	[bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100425165734.GA2887@infradead.org>
References: <201004050049.17952.hpj@urpla.net> <20100413091823.GD7544@dastard>
	<201004131142.33518.hpj@urpla.net>
	<201004241844.23482.hpj@urpla.net> <20100425162740.GB19195@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100425162740.GB19195@suse.de>
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
To: Greg KH <gregkh@suse.de>
Cc: Nick Piggin <npiggin@suse.de>, xfs@oss.sgi.com, opensuse-kernel@opensuse.org, linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 09:27:40AM -0700, Greg KH wrote:
> On Sat, Apr 24, 2010 at 06:44:22PM +0200, Hans-Peter Jansen wrote:
> > FYI, 2.6.33.2 is still affected from this issue. 
> 
> Is 2.6.33.3-rc2 affected?  A lot of xfs patches are in there (as are in
> 2.6.32.12-rc2.)

Yes.  It's not even in mainline yet as Nick doesn't like the trivial
core VM fix required to solve this in a clean way.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
