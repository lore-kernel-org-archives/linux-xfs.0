Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD5627F98
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 16:34:25 -0500 (CDT)
Date: Tue, 13 Aug 2013 16:34:25 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: free bp in xlog_find_zeroed() error path
Message-ID: <20130813213425.GF12719@sgi.com>
References: <51F9BAAE.2000709@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51F9BAAE.2000709@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Jul 31, 2013 at 08:32:30PM -0500, Eric Sandeen wrote:
> xlog_find_zeroed() currently leaks a bp on one error path.
> 
> Using the bp_err: target resolves this.
> 
> Found by Coverity.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
