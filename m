Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 82E737F82
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 17:58:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 60F0D304043
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 15:58:09 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	rViL4lwVa2L2KPTY for <xfs@oss.sgi.com>;
	Wed, 30 Jul 2014 15:58:02 -0700 (PDT)
Date: Thu, 31 Jul 2014 08:57:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Delaylog information enquiry
Message-ID: <20140730225732.GQ20518@dastard>
References: <DUB129-W7B2973281D7E749989D43EEF80@phx.gbl>
	<20140729123815.GA13120@bfoster.bfoster>
	<20140729234151.GJ26465@dastard>
	<CAFLt3phu1kJUjFyP8-+zkRPEsiv8ue=c+W+Ym8PYS1zd3kHyzw@mail.gmail.com>
	<20140730081858.GN26465@dastard>
	<CAFLt3pjdwdSOxVhbTFemReyNr9HnUodA-NL5bND2yRJGX2GBuA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFLt3pjdwdSOxVhbTFemReyNr9HnUodA-NL5bND2yRJGX2GBuA@mail.gmail.com>
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
To: Grozdan <neutrino8@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, "Frank ." <frank_1005@msn.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jul 30, 2014 at 11:18:11PM +0200, Grozdan wrote:
> I don't want to start another thread as this is my last question but
> it's one unrelated to the original question from Frank

You should always start a new thread when you have an unrelated
question. At minimum, you should change the subject line...

> One of my partitions was almost full (there was 5 GB over according to
> df -h). I had about 8 torrents open in the client, all sizes between 4
> and 6 GB (they were all downloaded and got never "released" from the
> client as I was seeding back). When I tried to add a torrent to
> download which was 3 GB, the client reported that there was no more
> space left over on the partition. I suspect this is related to
> speculative preallocation and because the 8 torrents were all "open"
> they still had extra space allocated by the speculative preallocation
> and thus I couldn't add the 3GB torrent even though df says there was
> 5GB over but in reality it was much less. Am I correct on this or is
> there something completely else that happened?

No idea - not enough information. Please start a new thread,
including the information here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

as well as the 'xfs_bmap -vp' output for the torrents in question.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
