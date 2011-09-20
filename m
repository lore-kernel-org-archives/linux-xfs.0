Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KGuEnt071629 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 11:56:14 -0500
Subject: Re: [PATCH] xfsdump: enable dump header checksums
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4E77DBB9.7060400@sgi.com>
References: <1314654106-28548-1-git-send-email-wkendall@sgi.com>
	<1316463141.2941.75.camel@doink>  <4E77DBB9.7060400@sgi.com>
Date: Tue, 20 Sep 2011 11:55:40 -0500
Message-ID: <1316537740.2912.25.camel@doink>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-09-19 at 19:18 -0500, Bill Kendall wrote:
> On 09/19/2011 03:12 PM, Alex Elder wrote:
. . .
> > The theory in doing this unconditionally is that we might as
> > well record it, even if the restore program chooses to ignore
> > it, right?
> 
> Right. (You probably noticed this also changes restore to
> unconditionally verify the checksum, provided the flags
> indicate the checksum was recorded.)

It *might* be nice to have an option to ignore the
checksum on restore.  I don't know though.  I was
thinking it might be useful if whatever dumped the
data did a buggy checksum but, well, we have no
evidence that xfsdump has ever done that.

. . .
> > I know it's fairly obvious on these simple functions, but it
> > might be nice to state in the header that the number of bytes
> > used in the checksum is a multiple of 4, and that endp marks
> > a point *beyond* the last byte used.
> 
> I've changed this to be more conventional and take a length
> argument rather than an end pointer. Also added a comment
> about the length restriction.

I was going to suggest using length, so that sounds good
to me.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
