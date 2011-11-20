Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAKIWPsS172217 for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 12:32:26 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3AE4B1D1FB3A
	for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 10:32:24 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	S1JDz4HynNjiQFjA for <xfs@oss.sgi.com>;
	Sun, 20 Nov 2011 10:32:24 -0800 (PST)
Date: Sun, 20 Nov 2011 13:32:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS / xfssyncd lock-ups on 2.6.38-8
Message-ID: <20111120183223.GA19572@infradead.org>
References: <A734D23E-8544-4261-A699-90B689887F46@instagram.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <A734D23E-8544-4261-A699-90B689887F46@instagram.com>
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
To: Mike Krieger <mikeyk@instagram.com>
Cc: xfs@oss.sgi.com

On Sun, Nov 20, 2011 at 08:34:02AM -0800, Mike Krieger wrote:
> Would appreciate any thoughts/pointers to fixes or workarounds if this is a known issue.

This was fixed by:

	xfs: force the log if we encounter pinned buffers in .iop_pushbuf

in Linux 3.1.  I've also backported it to the 3.0-stable issues.  I
would recommend to upgrade to the latest Linux 3.0-stable release, as
I'll plan to backport all important XFS fixes to it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
