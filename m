Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 638427FCB
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 09:30:39 -0500 (CDT)
Date: Tue, 20 Aug 2013 09:30:35 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: [PATCH 48/49] xfs: Add read-only support for dirent filetype field
Message-ID: <20130820143035.GB21663@sgi.com>
References: <520A53E8.6030604@sgi.com> <20130814075042.GE6023@dastard>
	<20130814184729.GA4604@sgi.com> <520C6E39.7030501@redhat.com>
	<20130815180400.GF3783@sgi.com> <520D4B1B.4080602@redhat.com>
	<20130816140811.GA30422@sgi.com> <20130819052813.GA6023@dastard>
	<20130819184815.GA24096@sgi.com> <20130820022325.GC6023@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130820022325.GC6023@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Tue, Aug 20, 2013 at 12:23:25PM +1000, Dave Chinner wrote:
| Indeed, you can't have it both ways, Geoffrey. The only thing that
| gives you any weight in this discussion is that you are speaking on
| behalf of SGI as the maintainer. You're not an active community
| participant so if you are not speaking as an SGI XFS maintainer, then
| you have no standing to make (unfounded) accusations of bias and
| double standards.

What makes one an active community participant?  Are only those who
submit code considered active community participants?  Who is the
community?

All this time I thought that as user of Linux, occasional contributor
(including source), occasional participant on the mailing list, I was
a member of the community.  I agree, I am not a full time participant.
I have other responsibilities with my job and a life outside my job.
XFS is only part of my responsibilities.  Now I am being told that unless
I participate full time, I don't have any standing in the community and am
not allowed to participate even when there is an issue of interest to me.

| Indeed, with all the roles SGI has split the XFS maintainership up
| into, there is only one way to refer to the maintainer as a whole:
| SGI is the maintainer. I have no idea how to separate what anyone
| from SGI says as a personal opinion of that of the maintainer, and
| that is a large part of the problem we have here. Nobody can tell if
| someone from SGI is speaking as a maintainer or giving an opinion as
| a SGI employee. So, you end up being tarred with the same brush.

Ben is the maintainer.  No one else at SGI speaks for Ben.  Ben does
receive a paycheck from SGI, but his primary interest as maintainer is
not in the interests of SGI.  SGI has its own source trees where the SGI
open source version of XFS is maintained.  Ben's maintainership role is
for the community XFS, not the SGI XFS.

| Now that I think about it, that is probably the underlying source of
| all the issues here. The "maintainer" is making conflicting
| decisions based on how each change impacts SGI's internal products,
| not what is in the best interests of the XFS community. The more I
| consider this, the more it explains the problems that we've been
| having.

The problem is that the maintainer (Ben) listens to all interested parties
and does not take direction exclusively from you, Red Hat, SuSE, SGI, IBM,
Oracle, or anyone else.  He is caught in the middle.  Let's be open here.
The current conflict is the result of me insisting that your plan and
vision on a specific feature is not in the best interest of the community
and you do not like the direction I have presented.  It is great that
you have a vision, but not everyone agrees with your vision.  You are
definitely the most significant current contributor of code to XFS.
Of your recent patch set, 49 of 50 patches were accepted.  And the one
patch that was not accepted, I asked for you to rework.  You refused.
Mark agreed to rework your patch, and because of this Ben is accused
of making conflicting decisions based on how each change impacts SGI's
internal products, not what is in the best interests of the XFS community.
Last time I checked, SGI was an active member of the XFS community even
by your definition.  Even so, I believe that the change I am requesting
will benefit the entire XFS community, not just SGI.  The problem I see
here is that you are unwilling to compromise on your vision or on your
interpretation of what is best for the community.

| Perhaps we should all go away for a while and consider this:

Please tell me, whose definition of maintainer is this and where did you
obtain it from?  I've searched for a definition of Maintainer, and
didn't find anything close to this.  Apparently this is your definition
of Maintainer.  While many points are good I don't agree wholesale.  I
must say though, and I think others (non-SGI) people on the list will
agree, that Ben does an excellent job of fulfilling the role you
describe.

| ---
| 
| A Maintainer is the community advocate, shepherd and facilitator.
| 
| Maintainers lead by example - anything they directly want or need
| they write code for, demonstrating best practices in developing that
| code.
| 
| Maintainers show leadership. They communicate their vision for the
| future so that other people can see that vision and so can work
| together to achieve it. Maintainers are open to change, to see the
| bigger picture, to understand the visions communicated by other
| people, how to work those changes into their vision.
| 
| Maintainers interact with other developers and subsystems outside
| their immediate areas of responsibility. They are responsible for
| ensuring that their subsystems integrated effectively into the wider
| community at all points - architectural, code and community levels.
| 
| Maintainers don't make demands on developers or users - they are
| impartial and influence directions through discussion and code. The
| maintainer should not attempt to stop developers from taking
| different directions, but needs to be able to resolve alternate
| opinions in a manner acceptable to all parties.
| 
| Maintainers are among the most active individuals in the community.
| They support their users, triaging problems and providing bug fixes.
| They listen to their users to understand the problems they are
| having and determine what needs to be done to help them. The
| maintainer spends time to educate users, as a knowledgeable user is a
| valuable resource that can help other users. They might even become
| a valuable developer given enough nurturing.
| 
| The maintainer role is to provide and environment that
| benefits the community. A maintainer puts the community first and
| the own interests second. The maintainer wants the community to
| develop and grow and improve, and will place the long term health of
| the community ahead of immediate personal or commercial gain.
| 
| In a commercial open source world, a vibrant community that the
| maintainer can influence and direct is far more valuable to the
| maintainer than a community that is at odds with the maintainer. A
| community that wants to help each other improve and improve quickly
| far outweighs any of the ongoing costs involved in facilitating
| such a community.
| 
| The role of maintainer is not a right - the maintainer is chosen
| through demonstration of the above traits and abilities. It doesn't
| matter what background you have or who you work for - the maintainer
| role is a position that is earned through respect for your
| endeavors, and so is open to anyone of sufficient caliber.
| 
| In the XFS community, we strive to use best practices for our code
| and processes, and all developers should be striving to achieve the
| level of capability that would place them in consideration of the
| maintainer's role.
| 
| ---
| 
| So, as a whole, let's reflect on this for a while before going
| any further.  Reflect on where you think you fit, what you think
| your place is, whether you consider that you are fulfilling your
| place, and how you can improve on what you do and improve your
| contributions to the greater XFS community...
| 
| Cheers,
| 
| Dave.
| -- 
| Dave Chinner
| david@fromorbit.com


-- 
Geoffrey Wehrman
gwehrman@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
