Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6EIRFFO153317 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 13:27:16 -0500
Subject: Re: [PATCH] xfsprogs: don't hard code the shell binary
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110628074137.GA6123@infradead.org>
References: <1309245348-12638-1-git-send-email-david@fromorbit.com>
	<20110628074137.GA6123@infradead.org>
Date: Thu, 14 Jul 2011 13:27:11 -0500
Message-ID: <1310668031.2067.44.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, 2011-06-28 at 03:41 -0400, Christoph Hellwig wrote:
> On Tue, Jun 28, 2011 at 05:15:48PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Recent changes to debian unstable user space have caused the
> > xfsprogs build to break as certain shell functionality is being
> > assumed by libtool and friends.  The configure scripts test and
> > select the correct shell, but the input files ignore this and hard
> > code the shell to use and hence now break.
> > 
> > Fix this by using the shell that the configure scripts decide is the
> > right one to use.
> 
> Looks good.  The same fix should also be applied to xfsdump, xfstests
> and dmapi.

Agree.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
