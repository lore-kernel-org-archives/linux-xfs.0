Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E33129DFB
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 16:28:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0347C304059
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 14:28:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OaA6q6CRFb0ZwxP6 for <xfs@oss.sgi.com>;
	Mon, 11 May 2015 14:28:39 -0700 (PDT)
Date: Tue, 12 May 2015 07:28:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE, DISCUSS] xfsprogs: libxfs-4.1-update branch created
Message-ID: <20150511212805.GE15721@dastard>
References: <20150511000508.GD16689@dastard>
 <5550C123.8060806@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5550C123.8060806@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Mon, May 11, 2015 at 09:48:03AM -0500, Eric Sandeen wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 5/10/15 7:05 PM, Dave Chinner wrote:
> > Hi folks,
> 
> ...
> 
> > This userspace update work needs to
> > be distributed over the developers making the API and functionality
> > changes, so I'm throwing this out there to see what people think
> > about solving this problem.
> 
> ...
> 
> > So, what do the people I'm asking to do more work so I don't have
> > to spend so much time on time consuming maintenance tasks think?
> 
> I think it makes perfect sense, and I'm happy to do it.  The giant
> sync-ups after the fact have never been ideal from any perspective.
> 
> I'm glad you brought this up; I don't think anyone ever meant to simply
> leave this to the maintainer - it just ended up that way, because the
> rules or best practices weren't necessarily clear.

*nod*

> So; do you envision a 0/8 patch series, 4 of which touch libxfs, to
> now be a 0/12 patch series, with the userspace bits i.e. at the end?
> I'd be perfectly happy with this; once libxfs stays up to date in
> userspace, it should be trivial.

I'd expect separate patch series, because it's kinda hard to do a
git send-email or guilt patchbomb that spans mutltiple
repositories.... :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
