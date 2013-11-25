Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CD9897F4E
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 15:37:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57D08AC002
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 13:37:56 -0800 (PST)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id 4JrZCQvPnzAmfqrc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 13:37:55 -0800 (PST)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 195BB9A06AF
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 14:37:54 -0700 (MST)
Date: Mon, 25 Nov 2013 16:37:51 -0500
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH 1/2] xfstests: add generic/321 to test fsync() on
	directories V2
Message-ID: <20131125213751.GA3949@localhost.localdomain>
References: <1384538464-7384-1-git-send-email-jbacik@fusionio.com>
	<20131125161216.GA5085@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131125161216.GA5085@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com

On Mon, Nov 25, 2013 at 08:12:16AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 15, 2013 at 01:01:03PM -0500, Josef Bacik wrote:
> > Btrfs had some issues with fsync()'ing directories and fsync()'ing after
> > renames.  These three new tests cover the 3 different issues we were seeing.
> > This breaks out the dmflakey stuff into a common helper to be shared between
> > generic/311 and generic/321. Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> 
> This doesn't seem to actually create the common/dmflakey file.

Eek sorry about that, I'll resend.

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
