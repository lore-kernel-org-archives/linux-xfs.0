Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6UM4Hrx096247 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 17:04:17 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	23jXhjESSZ4XYqpK for <xfs@oss.sgi.com>;
	Mon, 30 Jul 2012 15:04:16 -0700 (PDT)
Date: Tue, 31 Jul 2012 08:04:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: Change fstrim behaviour to be consistent with
	upstream version
Message-ID: <20120730220413.GI2877@dastard>
References: <1343649963-14079-1-git-send-email-tracek@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1343649963-14079-1-git-send-email-tracek@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On Mon, Jul 30, 2012 at 02:06:03PM +0200, Tomas Racek wrote:
> Rename fstrim option from "-s" to "-o" and change output message when
> verbose option is set.

Why modify a local utility program like this?  There's little point
in trying to match some other utilities' command line parameters
just for the sake of it...

If we have duplicate code (i.e. a copy of the upstream utility) or
the local tool can be completely replaced by the upstream tool,
then we should use upstream and remove the local copy completely.
Distros have been shipping fstrim for long enough now that most
people running testing on upstream kernels will have it installed...

Adding a _require_fstrim() function that checks for the upstream
version of fstrim to be installed for each test that requires it
would go along with this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
