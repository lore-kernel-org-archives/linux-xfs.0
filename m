Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7B20EGU095171 for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 21:00:24 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14ED91478E8F
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 19:00:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id tJ9I1BTf9ykXA1Sh for <xfs@oss.sgi.com>;
	Mon, 10 Aug 2009 19:00:54 -0700 (PDT)
Date: Mon, 10 Aug 2009 21:59:45 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <669295477.1736351249955985378.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20090810160949.GA21948@infradead.org>
Subject: Re: [PATCH] xfstests: 220 - generic quota sanity
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
Cc: Eric Sandeen <sandeen@redhat.com>, ext4 development <linux-ext4@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

----- "Christoph Hellwig" <hch@infradead.org> wrote:

> On Mon, Aug 10, 2009 at 09:05:17AM -0500, Eric Sandeen wrote:
> > Lachlan McIlroy wrote:
> > > This looks good Eric.
> > > 
> > > Is this test just for quota accounting or should it be testing
> quota
> > > enforcement too?
> > 
> > I guess 108 just did accounting; I was going to keep it parallel,
> and do
> > a different one for accounting, but it could be added to this as
> well.
> 
> Yeah, let's use a different one for enforement testing.

Agree, if quota enforcement isn't working correctly then the accounting
is the first thing to check so having seperate tests is a good idea.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
