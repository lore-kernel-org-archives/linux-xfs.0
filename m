Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4FD1A7F63
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 20:48:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CCE19AC001
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 18:48:09 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DFWHieiNJpAFiQB9 for <xfs@oss.sgi.com>;
	Mon, 27 Apr 2015 18:48:06 -0700 (PDT)
Date: Tue, 28 Apr 2015 11:42:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Proposal/RFC: new metadata-specific UUID for V5 supers
Message-ID: <20150428014224.GT15810@dastard>
References: <553EB3D1.10602@sandeen.net> <20150427233754.GT21261@dastard>
	<553ED9D8.4050106@sandeen.net> <20150428012003.GS15810@dastard>
	<553EE3FA.9050603@opensuse.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <553EE3FA.9050603@opensuse.org>
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
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Tue, Apr 28, 2015 at 03:35:54AM +0200, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> 
> On 2015-04-28 03:20, Dave Chinner wrote:
> 
> >> Well, it's just the loss of ability to change UUID, which is
> >> something People Used To Do(tm), and now can't.  It does come up.
> >> Honestly if it had been done from day 0, it'd be a no-brainer I
> >> think.  Doing it now, with an incompat flag, might not be a
> >> reasonable tradeoff.
> > 
> > I think that labels are a far better way of dealing with this 
> > problem. Get rid of the UUID mount checking (and hence the nouuid 
> > mount option), and tell people to use by-label instead of by-uuid
> > to identify their filesystems when doing clones and snapshots.
> > Labels make it much easier for humans to identify the filesystem
> > than UUIDs...
> 
> As a plain user, I can say that I have needed to mount both the
> filesystem and its backup image, but Linux refused on the basis of the
> id being the same. Of course, all identifiers are the same, label and
> uuid.

Yes, that's the XFS UUID mount checking refusing to mount without the
"nouuid" mount option because of the duplicate UUID. XFS doesn't care
about whether there are duplicate labels or not, so removing the
UUID checking would solve your problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
