Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P66ban165799 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 01:06:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF4541924296
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 23:06:34 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	oE8ARB8qnY4tB15P for <xfs@oss.sgi.com>;
	Wed, 24 Aug 2011 23:06:34 -0700 (PDT)
Date: Thu, 25 Aug 2011 02:06:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Message-ID: <20110825060632.GA9933@infradead.org>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<1309275199-10801-5-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309275199-10801-5-git-send-email-josef@redhat.com>
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
To: Josef Bacik <josef@redhat.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, viro@ZenIV.linux.org.uk, dchinner@redhat.com, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue, Jun 28, 2011 at 11:33:19AM -0400, Josef Bacik wrote:
> This is a test to make sure seek_data/seek_hole is acting like it does on
> Solaris.  It will check to see if the fs supports finding a hole or not and will
> adjust as necessary.

Can you resend this with any updates that happened in the meantime?

Dave also still had some comments about semantics, so it might be worth
to incorporate that as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
