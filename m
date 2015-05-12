Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B4D0029DFB
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 20:58:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 77E438F804C
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 18:58:33 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	NOw4geOXSFXqibEp for <xfs@oss.sgi.com>;
	Mon, 11 May 2015 18:58:30 -0700 (PDT)
Date: Tue, 12 May 2015 11:58:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: create new metadata UUID field and incompat flag
Message-ID: <20150512015827.GS4327@dastard>
References: <554D1F56.7030209@redhat.com> <554D2110.8030405@sandeen.net>
	<20150511161404.GA54361@bfoster.bfoster>
	<5550DE64.2030907@sandeen.net> <20150511214902.GG15721@dastard>
	<55514028.6010606@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55514028.6010606@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Brian Foster <bfoster@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, May 11, 2015 at 06:50:00PM -0500, Eric Sandeen wrote:
> On 5/11/15 4:49 PM, Dave Chinner wrote:
> > On Mon, May 11, 2015 at 11:52:52AM -0500, Eric Sandeen wrote:
> >> On 5/11/15 11:14 AM, Brian Foster wrote:
> >>> On Fri, May 08, 2015 at 03:48:16PM -0500, Eric Sandeen wrote:
> >>> I suppose I could be convinced otherwise if there's context I'm missing,
> >>> but otherwise this seems a bit confusing to me...
> >>>
> >>> Brian
> >>
> >> Yeah, I'm sympathetic to that argument.  I can look into using sb_meta_uuid
> >> for the log too, if the incompat flag is set.
> > 
> > The log uuid is user facing, like the superblock uuid. i.e. there
> > are tools that identify external log devices by checking that the
> > uuid in the log matches the user facing uuid in the superblock.
> > Hence the log uuid needs to use the uuid that is reported to
> > userspace.
> 
> 
> None that are external to xfsprogs, I think, are there? (1) - but still.
> I'm happy to leave it as it is ... I don't think it really matters either way.
> 
> -Eric
> 
> (1) at one point I wanted to teach blkid to find an external log by UUID,
> but there is no "log superblock" so I gave up on that idea.

Well, we don't know, really, do we? It's best to play it safe and
keep it the same as the user visible filesytem uuid, as that is
what is currently expected by anything poking at block dev UUIDs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
