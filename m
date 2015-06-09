Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B9BF27F37
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2015 18:35:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8A5EA304032
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2015 16:35:48 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	UJGxotONZZH8KKyu for <xfs@oss.sgi.com>;
	Tue, 09 Jun 2015 16:35:45 -0700 (PDT)
Date: Wed, 10 Jun 2015 09:35:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4 V2] xfsprogs: zero out clean log in xfs_metadump
Message-ID: <20150609233543.GS9143@dastard>
References: <5568B7CE.9030709@redhat.com> <5568BB5C.4080400@sandeen.net>
	<5575AF7A.8050306@sandeen.net>
	<20150608182947.GA18211@bfoster.bfoster>
	<5575DFB1.4010004@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5575DFB1.4010004@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Jun 08, 2015 at 01:32:17PM -0500, Eric Sandeen wrote:
> On 6/8/15 1:29 PM, Brian Foster wrote:
> > On Mon, Jun 08, 2015 at 10:06:34AM -0500, Eric Sandeen wrote:
> >> When doing an obfuscated xfs_metadump, if the log is clean, zero
> >> it out for 2 reasons:
> >>
> >>  * It'll make the image more compressible
> >>  * It'll eliminate an un-obfuscated metadata source
> >>
> >> If the log isn't clean, and the user expected obfuscation, warn
> >> that metadata in the log will not be obfuscated.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> V2: If not obfuscating, copy log as-is
> >>
> > 
> > FYI, I think v1 of this was already pulled into the for-next branch.
> > Anyways...
> 
> Yeah, I noticed - I'll ask dave to fix it (that one rebases, right?) :)

Just send a delta patch against what I committed, that way I don't
need to rebase the tree.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
