Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q292Ho6E113136 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 20:17:50 -0600
Date: Thu, 8 Mar 2012 20:17:56 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 1/1] xfstests: update inode softlimit output in 050
Message-ID: <20120309021756.GB8545@sgi.com>
References: <20120222182713.040087240@sgi.com>
	<20120222182832.076759206@sgi.com> <4F5935BC.4050104@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F5935BC.4050104@sandeen.net>
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
Cc: xfs@oss.sgi.com, Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>, Christoph Hellwig <hch@lst.de>, Mark Tinguely <tinguely@sgi.com>

Hey Eric,

On Thu, Mar 08, 2012 at 04:42:04PM -0600, Eric Sandeen wrote:
> On 2/22/12 12:27 PM, Ben Myers wrote:
> 
> > With Mitsuo Hayasaka's kernel patch "xfs: change available ranges of softlimit
> > and hardlimit in quota check", xfs quota behavior is slightly different.
> > 
> > This needs to be reflected in test 050.  The new behavior is that we only start
> > the timer when we're above soft inode quota, and we don't start the timer when
> > we're at or below.
> > 
> > Signed-off-by: Ben Myers <bpm@sgi.com>
> > Index: xfstests/050.out
> > ===================================================================
> > --- xfstests.orig/050.out
> > +++ xfstests/050.out
> > @@ -20,7 +20,7 @@ realtime =RDEV extsz=XXX blocks=XXX, rte
> >  
> >  *** push past the soft block limit
> >  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> > -[NAME] 140 100 500 00 [7 days] 4 4 10 00 [7 days] 0 0 0 00 [--------]
> > +[NAME] 140 100 500 00 [7 days] 4 4 10 00 [--------] 0 0 0 00 [--------]
> 
> ...
> 
> 
> Hm, but now old kernels would fail.

Sure, but Mitsuo did fix a genuine off-by-one bug...  ;)

> Maybe it's better to go 1 past the limit in the test, rather than meet it, and then it'd fail on both old & new kernels?

It is of low severity, so this seems like a reasonable middle ground.
I'll be happy to respin this patch, unless you'd prefer to.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
