Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6CMAuqo052618 for <xfs@oss.sgi.com>; Mon, 12 Jul 2010 17:10:57 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF519BB8EEB
	for <xfs@oss.sgi.com>; Mon, 12 Jul 2010 15:19:51 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	3Meu0CHJyo5wL7Sx for <xfs@oss.sgi.com>;
	Mon, 12 Jul 2010 15:19:51 -0700 (PDT)
Date: Tue, 13 Jul 2010 08:13:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH xfstests] _qmount: mount w/o selinux xattrs
Message-ID: <20100712221346.GI25335@dastard>
References: <4C2CF34F.7070008@redhat.com>
	<20100702071006.GB30776@infradead.org>
	<4C2E2687.3080700@redhat.com>
	<20100709161232.GA26302@infradead.org>
	<4C3B6D0A.2010708@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C3B6D0A.2010708@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs mailing list <xfs@oss.sgi.com>

On Mon, Jul 12, 2010 at 02:29:14PM -0500, Eric Sandeen wrote:
> On 07/09/2010 11:12 AM, Christoph Hellwig wrote
> > On Fri, Jul 02, 2010 at 12:48:55PM -0500, Eric Sandeen wrote:
> >>> What about just disabling selinux for all filesystems instead of just
> >>> XFS for the general case.
> >>
> >> Well it seems like if we -can- test with it on, that's good.
> >> Certain distros ship with it on by default, so exercising lots
> >> of scenarios with it on seems beneficial...
> > 
> > It seems, but I'd rather do it consistently for all filesystems.
> > 
> 
> except we can't, because xfs actually has such low-level format checking
> that selinux -will- break it badly.
> 
> I guess we could flag which tests can't run w/ extra xattrs,
> and only mount w/ the context for those?

Maybe use a group to define all the tests that can't run with
selinux enabled and check it before running each test? i.e. use
notrun to prevent such tests from running. The attr group isprobably
a good start for the tests that will break w/ selinux enabled....

Cheers.

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
