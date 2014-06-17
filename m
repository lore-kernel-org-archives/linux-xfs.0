Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 39D877F3F
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 17:47:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BA1D0AC005
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 15:47:05 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	NRF1aHZLF1ZecFDR for <xfs@oss.sgi.com>;
	Tue, 17 Jun 2014 15:47:02 -0700 (PDT)
Date: Wed, 18 Jun 2014 08:46:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: V5 format and man mkfs.xfs
Message-ID: <20140617224658.GJ9508@dastard>
References: <20140617082651.GA27971@citd.de> <20140617123738.GH9508@dastard>
	<20140617152917.GA17378@citd.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140617152917.GA17378@citd.de>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

On Tue, Jun 17, 2014 at 05:29:17PM +0200, Matthias Schniedermeyer wrote:
> On 17.06.2014 22:37, Dave Chinner wrote:
> > On Tue, Jun 17, 2014 at 10:26:51AM +0200, Matthias Schniedermeyer wrote:
> > > Hi
> > > 
> > > How seriously meant is "V5 isn't experimental anymore"?
> > 
> > "Fully supported" isn't a clear enough statement?
> 
> I guess that was a "selective memory"-bug on my side.
> 
> > > I ask because the man-page only mentions the syntax to enable it by 
> > > accident. A.k.a. the backport of ftype to V4.
> > > (man-page of xfsprogs 3.2.0 in Debian-SID)
> > 
> > That's intentional. V5 superblocks are an implementation detail that
> > most users don't even need to know about. They care about the name
> > of the features they are enabling at mkfs time, not the details of
> > the on-disk implementation of those features.
> 
> The question still stands.
> 
> The crc-option is only mentioned "by accident".
> Without the ftype backport there would be no mention of the "feature 
> crc".

Ok, so you're not reporting that we don't mention V5 filesystems as
"V5" filesystems. You're reporting that the "-m crc" option is not
documented. That's an oversight, and needs to be fixed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
