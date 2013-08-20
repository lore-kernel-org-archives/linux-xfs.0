Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1DB0A7F82
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 21:23:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B3B96AC002
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 19:23:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WcGDk1JxEQsnDFJr for <xfs@oss.sgi.com>;
	Mon, 19 Aug 2013 19:23:31 -0700 (PDT)
Date: Tue, 20 Aug 2013 12:23:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 48/49] xfs: Add read-only support for dirent filetype field
Message-ID: <20130820022325.GC6023@dastard>
References: <20130813005024.GS12779@dastard> <520A53E8.6030604@sgi.com>
	<20130814075042.GE6023@dastard> <20130814184729.GA4604@sgi.com>
	<520C6E39.7030501@redhat.com> <20130815180400.GF3783@sgi.com>
	<520D4B1B.4080602@redhat.com> <20130816140811.GA30422@sgi.com>
	<20130819052813.GA6023@dastard> <20130819184815.GA24096@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130819184815.GA24096@sgi.com>
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
To: Geoffrey Wehrman <gwehrman@sgi.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Mon, Aug 19, 2013 at 01:48:15PM -0500, Geoffrey Wehrman wrote:
> On Mon, Aug 19, 2013 at 03:28:13PM +1000, Dave Chinner wrote:
> | Participation requires being open about what you are doing. Posting
> | designs and ideas for comment, communicating your vision for the
> | future, posting code early and often, etc. That enables others to
> | participate at every stage and means that problems/issues are caught
> | early and rejection/acceptance occurs long before final code is
> | written. That's the way open source software is developed and most
> | of the XFS developer community understand that.
> 
> This is a statement we can all agree on.
> 
> | Except, it appears, the maintainers.
> 
> Don't blame the maintainer.  I am not the maintainer.  Send your insults
> my way, not to the maintainer.

No insult, just an observation based on statements made by people
from SGI.

Indeed, you can't have it both ways, Geoffrey. The only thing that
gives you any weight in this discussion is that you are speaking on
behalf of SGI as the maintainer. You're not an active community
participant so if you are not speaking as an SGI XFS maintiner, then
you have no standing to make (unfounded) accusations of bias and
double standards.

Indeed, with all the roles SGI has split the XFS maintainership up
into, there is only one way to refer to the maintainer as a whole:
SGI is the maintainer. I have no idea how to separate what anyone
from SGI says as a personal opinion of that of the maintainer, and
that is a large part of the problem we have here. Nobody can tell if
someone from SGI is speaking as a maintainer or giving an opinion as
a SGI employee. So, you end up being tarred with the same brush.

Now that I think about it, that is probably the underlying source of
all the issues here. The "maintainer" is making conflicting
decisions based on how each change impacts SGI's internal products,
not what is in the best interests of the XFS community. The more I
consider this, the more it explains the problems that we've been
having.

Perhaps we should all go away for a while and consider this:

---

A Maintainer is the community advocate, shepherd and facilitator.

Maintainers lead by example - anything they directly want or need
they write code for, demonstrating best practises in developing that
code.

Maintainers show leadership. They communicate their vision for the
future so that other people can see that vision and so can work
together to acheive it. Maintainers are open to change, to see the
bigger picture, to understand the visions communicated by other
people, how to work those changes into their vision.

Maintainers interact with other developers and subsystems outside
their immediate areas of responsibility. They are responsible for
ensuring that their subsystems integrated effectively into the wider
community at all points - architectural, code and community levels.

Maintainers don't make demands on developers or users - they are
impartial and influence directions through discussion and code. The
maintainer should not attempt to stop developers from taking
different directions, but needs to be able to resolve alternate
opinions in a manner acceptible to all parties.

Maintainers are among the most active individuals in the community.
They support their users, triaging problems and providing bug fixes.
They listen to their users to understand the problems they are
having and determine what needs to be done to help them. The
maintainer spends time to educate users, as a knowledgable user is a
valuable resource that can help other users. They might even become
a valuable developer given enough nuturing.

The maintainer role is to provide and environment that
benefits the community. A maintainer puts the community first and
the own interests second. The maintainer wants the community to
develop and grow and improve, and will place the long term health of
the community ahead of immediate personal or commercial gain.

In a commercial open source world, a vibrant community that the
maintainer can influence and direct is far more valuable to the
maintainer than a community that is at odds with the maintainer. A
community that wants to help each other improve and improve quickly
far outweighs any of the ongoing costs involved in facilitating
such a community.

The role of maintainer is not a right - the maintainer is chosen
through demonstration of the above traits and abilities. It doesn't
matter what background you have or who you work for - the maintainer
role is a position that is earnt through respect for your
endeavours, and so is open to anyone of sufficient calibre.

In the XFS community, we strive to use best practices for our code
and processes, and all developers should be striving to acheive the
level of capability that would place them in consideration of the
maintainer's role.

---

So, as a whole, let's reflect on this for a while before going
any further.  Reflect on where you think you fit, what you think
your place is, whether you consider that you are fulfilling your
place, and how you can improve on what you do and improve your
contributions to the greater XFS community...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
