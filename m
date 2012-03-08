Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28NCjsa092569 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 17:12:46 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	hgH43RHhvrsXImyQ for <xfs@oss.sgi.com>;
	Thu, 08 Mar 2012 15:12:43 -0800 (PST)
Date: Fri, 9 Mar 2012 10:11:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V3] xfstests 279: test mkfs with various sector sizes &
	alignments
Message-ID: <20120308231158.GT3592@dastard>
References: <4F5005D1.6040208@redhat.com> <4F50479B.2050609@sandeen.net>
	<4F50FC24.3060908@sandeen.net> <4F5931BF.8010503@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F5931BF.8010503@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Mar 08, 2012 at 04:25:03PM -0600, Eric Sandeen wrote:
> On 3/2/12 10:58 AM, Eric Sandeen wrote:
> > This test uses the scsi_debug module to test mkfs against
> > various physical & logical sector sizes, and with aligned
> > and unaligned devices.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 
> > Dave, I think this implements all your suggestions (in one way or
> > another...) except the non-modular scsi_debug.  I don't know
> > how to manipulate things like offset if it's built in, but
> > if you want to look... I don't see it.
> > 
> > V3: remove a couple stray/extra "tee" commands
> > 
> > I looked into doing a generic version of this but I think without
> > the sector size checking unique to xfs it's a little pointless.
> 
> Dave, think this is ok now?

Yup.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
