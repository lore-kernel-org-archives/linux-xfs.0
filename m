Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 73C987F3F
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2014 05:59:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 513768F8049
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2014 03:59:37 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HC65kLv9fKSuFzIV for <xfs@oss.sgi.com>;
	Tue, 07 Oct 2014 03:59:35 -0700 (PDT)
Date: Tue, 7 Oct 2014 21:59:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Corrupted filesystem: thoughts?
Message-ID: <20141007105933.GP2301@dastard>
References: <20141007093533.66ba8c7b@galadriel.home>
	<20141007095949.2dce6d72@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141007095949.2dce6d72@galadriel.home>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 07, 2014 at 09:59:49AM +0200, Emmanuel Florac wrote:
> Le Tue, 7 Oct 2014 09:35:33 +0200 vous =E9criviez:
> =

> > Kernel is a plain vanilla 3.2.54 amd64. As a precaution I've made a
> > list of the whole filesystem with inode numbers to be able to rename
> > lost files in norecovery mode... Unfortunately I cannot do a metadump
> > because of lack of room elsewhere.
> =

> At end of repair I've got loads of these:
> =

> libxfs_writebufr: write verifer failed on bno 0x10000f348/0x1000
> Metadata corruption detected at block 0x802b2a88/0x1000

Upgrade to 3.2.1 as there were a bunch of fixes for issues that
caused these messages in that release.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
