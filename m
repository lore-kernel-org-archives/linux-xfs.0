Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0ENna7S011007 for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 17:50:05 -0600
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AB5B8C332
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 15:49:30 -0800 (PST)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net
	[203.16.214.57]) by cuda.sgi.com with ESMTP id pPKaDmdRu70aNmaM
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 15:49:30 -0800 (PST)
Date: Thu, 15 Jan 2009 10:30:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS maintainership
Message-ID: <20090114233019.GB8071@disturbed>
References: <200901090619.n096Jp20017008@oss.sgi.com>
	<20090109065935.GA1600@infradead.org>
	<20090109215218.GB10221@sgi.com> <4968E61D.6070505@thebarn.com>
	<20090113131855.GB8396@sgi.com> <20090114012845.GO8071@disturbed>
	<20090114054917.GT8071@disturbed> <20090114055050.GU8071@disturbed>
	<496E1F75.8040300@sandeen.net>
	<21E180C1-1019-4C30-A37C-631C3510583B@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <21E180C1-1019-4C30-A37C-631C3510583B@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Russell Cattelan <cattelan@thebarn.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Jan 14, 2009 at 12:05:01PM -0600, Felix Blyakher wrote:
> 
> On Jan 14, 2009, at 11:23 AM, Eric Sandeen wrote:
> 
> > Dave Chinner wrote:
> >> It seems to me that SGI wants to maintain control without doing any
> >> of the work that having that control requires of them.  i.e. take
> >> without any give....
> >>
> >> Point in case: we have a _critical_ 2.6.28 regression w.r.t.
> >> directory handling. The community triaged the bug, the community
> >> fixed the bug and the community reviewed the fix. It got checked
> >> into the SGI controlled dev tree 4 days ago.  Now we are waiting for
> >> SGI to stop playing "let's all be one happy family la-la-la" games
> >> and get off their backsides and *act as responsible maintainers* by
> >> pushing the fix to Linus ASAP.
> >>
> >> Please, show us that SGI is really going to act as the maintainer of
> >> XFS. The only thing that will convince me right now that SGI should
> >> continue as XFS maintainer is this:
> >>
> >> 	"Gesta non verba"
> >
> > Ooh, bonus points for the Latin!
> >
> > Since 12/10, when Melbourne got erased, there have only been 6 emails
> > from sgi to the list which were not from the short-timer skeleton crew
> > left in Melbourne.  3 of these had something to do with  
> > development.   2
> > were related to this question of maintainership.  1 was a test email.
> 
> OK, we're all here, and listening, and learning, and getting to
> know the process and responsibilities, setting up right environment,
> all that transitional stuff.
> Yes, we're overwhelmed at the moment, but not going to hide in
> the bushes. Just need some time.

Therein lies the problem. SGI is overwhelmed and playing catchup,
while there are some things that the community needs to be done
immediately. That's pretty much the story of the last six months
and the indications you are giving are that it will continue this
way for some time....

> > Meanwhile almost 100 patches have been sent, reviewed, and in many  
> > cases
> > committed by hch & others to the staging trees on kernel.org.
> 
> Hmm, while not actively participating, I've been monitoring
> all xfs channels I know of. I haven't seen 100 patches lately.
> Where they all posted to this list?

$ find incoming/xfs-linux/cur/ -newerct 20081210 -exec grep PATCH {} \; |grep ^Subject |grep -v [Rr]e: | wc -l
100

> >> From my perspective, it certainly appears that much more xfs work is
> > being done outside sgi than inside sgi at this point in time.  This
> > *should* be a good thing for sgi, because one of your flagship storage
> > software offerings is being maintained & moving forward with very few
> > resource requirements from sgi.
> >
> > But if sgi's role is simply to own and to veto and not to communicate,
> > collaborate, facilitate or contribute,
> 
> No, that's definitely not on anybody's mind here.
> I know, community were waiting for our comments on the process,

FWIW, I'm waiting for action, not comments...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
