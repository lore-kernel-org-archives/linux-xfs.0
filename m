Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1D92129DF9
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 10:10:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 08101304032
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 08:10:22 -0700 (PDT)
Date: Wed, 30 Apr 2014 08:10:21 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfsprogs: remove unused argument in trans_iput
Message-ID: <20140430151021.GA15162@infradead.org>
References: <20140430134844.924376330@sgi.com>
	<20140430135319.660238697@sgi.com> <53610D16.9040609@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53610D16.9040609@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Wed, Apr 30, 2014 at 09:47:50AM -0500, Eric Sandeen wrote:
> On 4/30/14, 8:48 AM, Mark Tinguely wrote:
> > Remove the unused second argument to xfs_iput() and
> > xfs_trans_iput().
> > 
> > Introduce the define "IRELE()" and use in place of xfs_iput().
> 
> Why do this?  We had been moving away from the upper-case-macro-
> redefined-to-a-function meme... what does this #define gain?
> 
> libxfs_iget/libxfs_iput pairs seem more obvious than
> libxfs_iget/IRELE()...

Mostly to match the kernel that makes it do an iput underneath..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
