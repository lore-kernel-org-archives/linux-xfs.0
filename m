Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n486Qtev001201 for <xfs@oss.sgi.com>; Fri, 8 May 2009 01:26:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 025A22705E9
	for <xfs@oss.sgi.com>; Thu,  7 May 2009 23:26:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Wu8H27zBUvSyipXX for
	<xfs@oss.sgi.com>; Thu, 07 May 2009 23:26:59 -0700 (PDT)
Date: Fri, 8 May 2009 02:26:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 042: point xfs_fsr right at the fragmented file
Message-ID: <20090508062658.GA1689@infradead.org>
References: <4A0386FD.7000108@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A0386FD.7000108@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, May 07, 2009 at 08:12:29PM -0500, Eric Sandeen wrote:
> Somehow 042 as it stands isn't actually defragging the fragmented
> file we created (see 042.full post-run)
> 
> Probably need to look into that as well, but for now this should
> make the call to fsr actually _do_ something.
> 
> This has let 2 fsr bugs slip through qa in the past few months.  :(

Looks good.  Can you open a bugzilla for the problem of fsr not actually
finding the fragmented file so that we don't forget about that one?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
