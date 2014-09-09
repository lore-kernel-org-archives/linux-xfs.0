Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DE2B47F61
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 18:48:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BDF17304048
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 16:48:19 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	duQh2DAxXFWfwFQS for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 16:48:17 -0700 (PDT)
Date: Wed, 10 Sep 2014 09:48:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs_repair: clear bad flgs in process_dinode_int
Message-ID: <20140909234815.GX30012@dastard>
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
	<1410108065-18156-2-git-send-email-sandeen@redhat.com>
	<20140909222856.GA27349@infradead.org>
	<540F803A.9060901@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <540F803A.9060901@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Tue, Sep 09, 2014 at 05:33:30PM -0500, Eric Sandeen wrote:
> On 9/9/14 5:28 PM, Christoph Hellwig wrote:
> >On Sun, Sep 07, 2014 at 11:41:01AM -0500, Eric Sandeen wrote:
> >>process_dinode_int() reports bad flags if
> >>dino->di_flags & ~XFS_DIFLAG_ANY - i.e. if
> >>any flags are set outside the known set.  But
> >>then instead of clearing them, it does
> >>flags &= ~XFS_DIFLAG_ANY which keeps *only*
> >>the bad flags.  This leads to persistent,
> >>unrepairable errors of the form:
> >
> >You know you can use up to 75 characters per line for your commit messages,
> >don't you? :)
> 
> hah, it's not automated at all, I guess my visual perception
> of the window is shrinking.  Dave, feel free to fix on commit if
> inclined :)

I mostly do already - I tend to reflow commit messages to 68
characters (same width I use for email) when I see something like
this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
