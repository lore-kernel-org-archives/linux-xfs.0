Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EFDBB7F51
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 18:06:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D7EA8304039
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 16:06:30 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZqC9KcVxLXjXVq49 for <xfs@oss.sgi.com>;
	Tue, 17 Jun 2014 16:06:28 -0700 (PDT)
Date: Wed, 18 Jun 2014 09:06:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests, weird looking code in src/resvtest.c
Message-ID: <20140617230627.GL9508@dastard>
References: <20140617162044.GL29459@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140617162044.GL29459@beardog.cce.hp.com>
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
To: scameron@beardog.cce.hp.com
Cc: xfs@oss.sgi.com

On Tue, Jun 17, 2014 at 11:20:44AM -0500, scameron@beardog.cce.hp.com wrote:
> 
> This code in xfstests src/resvtest.c looks pretty strange:
> 
> ...
>  32         char            *readbuffer, *writebuffer;
> ...
>  70         readbuffer = memalign(psize, bsize);
>  71         writebuffer = memalign(psize, bsize);
>  72         if (!readbuffer || !writebuffer) {
>  73                 perror("open");
>  74                 exit(1);
>  75         }
>  76         memset(writebuffer, 'A', sizeof(writebuffer));
> 
> ^^^ writebuffer is a pointer, so using sizeof(writebuffer) here is
> odd. Is it intentional to put either 4 or 8 A's into writebuffer
> depending on sizeof a pointer?  Seems unlikely.
> 
> 110         while (++n < iterations) {
> 111                 char *p;
> 112                 int numerrors;
> 113 
> 114                 if (write(writefd, writebuffer, sizeof(writebuffer)) < 0) {
> 115                         perror("write");
> 116                         exit(1);
> 117                 }
> 
> So that write will write sizeof a pointer's worth of whatever's in writebuffer.
> Intentional?  Again, seems unlikely.
> 
> This seems like maybe somebody initially declared writebuffer as an array, but
> later went back and changed it to a pointer, but forgot to fixup everywhere that
> referred to sizeof(writebuffer).
> 
> I would have sent a patch but I'm not sure what this code is trying to do.
> 
> gcc 4.4.7 (what comes with RHEL6u5) doesn't warn about this, but 4.8.3 does.

There's a recent patch on the fstests list (fstests@vger.kernel.org)
that fixes this that I haven't picked up yet.

For actual test harness issues, you should use
fstests@vger.kernel.org now, not xfs@oss.sgi.com...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
