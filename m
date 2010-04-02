Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o32N7YJq255413 for <xfs@oss.sgi.com>; Fri, 2 Apr 2010 18:07:34 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 794EE29608C
	for <xfs@oss.sgi.com>; Fri,  2 Apr 2010 16:09:20 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	ua8OidRlIVwI1wzk for <xfs@oss.sgi.com>;
	Fri, 02 Apr 2010 16:09:20 -0700 (PDT)
Date: Sat, 3 Apr 2010 10:09:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look
	please!...)
Message-ID: <20100402230905.GW3335@dastard>
References: <03ca01cacb92$195adf50$0400a8c0@dcccs>
	<2375c9f91003242029p1efbbea1v8e313e460b118f14@mail.gmail.com>
	<20100325153110.6be9a3df.kamezawa.hiroyu@jp.fujitsu.com>
	<02c101cacbf8$d21d1650$0400a8c0@dcccs>
	<179901cad182$5f87f620$0400a8c0@dcccs>
	<t2h2375c9f91004010337p618c4d5yc739fa25b5f842fa@mail.gmail.com>
	<1fe901cad2b0$d39d0300$0400a8c0@dcccs>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1fe901cad2b0$d39d0300$0400a8c0@dcccs>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Janos Haar <janos.haar@netcenter.hu>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

On Sat, Apr 03, 2010 at 12:07:00AM +0200, Janos Haar wrote:
> Hello,
> =

> ----- Original Message ----- From: "Am=E9rico Wang"
> <xiyou.wangcong@gmail.com>
> To: "Janos Haar" <janos.haar@netcenter.hu>
> Cc: <linux-kernel@vger.kernel.org>; "KAMEZAWA Hiroyuki"
> <kamezawa.hiroyu@jp.fujitsu.com>; <linux-mm@kvack.org>;
> <xfs@oss.sgi.com>; "Jens Axboe" <axboe@kernel.dk>
> Sent: Thursday, April 01, 2010 12:37 PM
> Subject: Re: Somebody take a look please! (some kind of kernel bug?)
> =

> =

> >On Thu, Apr 1, 2010 at 6:01 PM, Janos Haar
> ><janos.haar@netcenter.hu> wrote:
> >>Hello,
> >>
> >
> >Hi,
> >This is a totally different bug from the previous one reported by you. :)
> =

> Today i have got this again, exactly the same. (if somebody wants
> the log, just ask)
> There is a cut:

Small hint - please put the subsytemthe bug occurred in in the
subject line. I missed this in the firehose of lkml traffic because
there wasnothing to indicate to me it was in XFS. Soemthing like:

"Kernel crash in xfs_iflush_cluster"

Won't get missed quite so easily....

This may be a fixed problem - what kernel are you running?

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
