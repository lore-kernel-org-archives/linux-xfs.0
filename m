Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA8H27bR134270 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 11:02:08 -0600
Date: Tue, 8 Nov 2011 18:01:48 +0100
From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 6/9] xfstests: add a new test that runs fsstress under
	ENOSPC conditions
Message-ID: <20111108170146.GR12759@twin.jikos.cz>
References: <1320342953-7973-1-git-send-email-dmonakhov@openvz.org>
	<1320342953-7973-6-git-send-email-dmonakhov@openvz.org>
	<20111107132533.GP12759@twin.jikos.cz> <87sjm0kqjk.fsf@dmbot.sw.ru>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87sjm0kqjk.fsf@dmbot.sw.ru>
Reply-To: dave@jikos.cz
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: tytso@mit.edu, xfs@oss.sgi.com, dave@jikos.cz, aelder@sgi.com, linux-fsdevel@vger.kernel.org, hch@lst.de

On Mon, Nov 07, 2011 at 05:31:11PM +0400, Dmitry Monakhov wrote:
> > 269      [failed, exit status 1] - output mismatch (see 269.out.bad)
> > --- 269.out     2011-11-07 13:26:23.000000000 +0100
> > +++ 269.out.bad 2011-11-07 14:07:44.000000000 +0100
> > @@ -3,3 +3,4 @@
> >  Run fsstress
> > 
> >  Run dd writers in parallel
> > +./269: line 60: kill: (9754) - No such process
> > 
> > > +	wait $pid
> > > +}
> > 
> > and the test is reported to fail. Seems that the dd commands finish in less 2
> > seconds.
> Have you recompile fsstress via make?

That was it, thanks.

david

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
