Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1EAF67F61
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 21:03:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AD1C7AC002
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 19:03:36 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	qr7LlYzkp6T6AX1G for <xfs@oss.sgi.com>;
	Sat, 30 Mar 2013 19:03:34 -0700 (PDT)
Date: Sun, 31 Mar 2013 13:03:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs_repair and journalling  --  EXT4 journal replay discussion
Message-ID: <20130331020304.GL6369@dastard>
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<5147E360.10605@sandeen.net> <5148037B.5010706@hardwarefreak.com>
	<201303190924.29362.Martin@lichtvoll.de>
	<51483A7D.9050202@hardwarefreak.com>
	<5156DF72.1090703@hardwarefreak.com> <5157237A.40006@sandeen.net>
	<51573461.8070006@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51573461.8070006@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Subranshu Patel <spatel.ml@gmail.com>, xfs@oss.sgi.com

On Sat, Mar 30, 2013 at 01:52:17PM -0500, Stan Hoeppner wrote:
> On 3/30/2013 12:40 PM, Eric Sandeen wrote:
> > On 3/30/13 7:49 AM, Stan Hoeppner wrote:
> 
> >> Ok, so here's the skinny on the source of our confusion WRT how/when
> >> EXT4 replays journals, and it's rather interesting.  Ted Ts'o explained
> >> the following.
> > 
> > Where was this, out of curiosity?
> 
> Private email exchange with Ted.  I thought it was best from an
> etiquette standpoint not to wholesale paste his two private emails to
> the XFS list, but to summarize.  Maybe it would be ok if I put it on my
> web server for a couple of days then remove it.
> 
> http://www.hardwarefreak.com/ext4-journaling.txt

That again?  I'll just point to this post from Ted in 2004:

http://zork.net/~nick/mail/why-reiserfs-is-teh-sukc

It's the same FUD about XFS journalling and power failures that Ted
has been claiming for the past 10+ years. It's been rebutted so many
times I can now do it in three words: volatile drive caches.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
