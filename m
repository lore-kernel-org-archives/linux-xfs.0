Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 76CFD7CA0
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 05:50:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DDFB0AC005
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 03:49:56 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	E8yPeLgtgxFbjzbH for <xfs@oss.sgi.com>;
	Fri, 05 Aug 2016 03:49:53 -0700 (PDT)
Date: Fri, 5 Aug 2016 20:49:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 00/47] xfs: add reverse mapping support
Message-ID: <20160805104950.GF16044@dastard>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<20160803194536.GJ5316@wotan.suse.de>
	<20160803205520.GQ8590@birch.djwong.org>
	<20160804005843.GJ8593@birch.djwong.org>
	<20160804021852.GK5316@wotan.suse.de>
	<20160804154845.GV8590@birch.djwong.org>
	<20160804235015.GC16044@dastard>
	<1470380474.2311.71.camel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470380474.2311.71.camel@gmail.com>
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
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Mark Fasheh <mfasheh@suse.de>, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Fri, Aug 05, 2016 at 10:01:14AM +0300, Artem Bityutskiy wrote:
> On Fri, 2016-08-05 at 09:50 +1000, Dave Chinner wrote:
> > I'd much prefer that fiemap gives exact information about shared
> > extents. FIEMAP is a diagnostic tool and as such we need it to
> > accurately reflect the exact extent map of the inode being queried
> > so we aren't mislead about the layout of the file during trouble
> > shooting.
> =

> Hi Dave, you are right, and here is a side note: =A0we were using FIEMAP
> for optimizing image deployment in production, so it is a diagnostic
> tool and more.

Yay, data corruption ahoy!

Hasn't /anyone/ listened to the repeated statements from fs
developers that FIEMAP is not a safe method of optimising data
copying?

-Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
