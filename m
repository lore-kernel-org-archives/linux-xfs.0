Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p76NdKA8195056 for <xfs@oss.sgi.com>; Sat, 6 Aug 2011 18:39:21 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2ADAB1747A4E
	for <xfs@oss.sgi.com>; Sat,  6 Aug 2011 16:39:17 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FEZY97IW98YdAH0t for <xfs@oss.sgi.com>;
	Sat, 06 Aug 2011 16:39:17 -0700 (PDT)
Date: Sun, 7 Aug 2011 09:39:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair 3.1.4/3.1.5: fatal error -- couldn't malloc dir2
	buffer data
Message-ID: <20110806233913.GH3162@dastard>
References: <20110806121728.GA20341@schmorp.de> <20110806141241.GF3162@dastard>
	<20110806175428.GA1900@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110806175428.GA1900@schmorp.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Marc Lehmann <schmorp@schmorp.de>
Cc: xfs@oss.sgi.com

On Sat, Aug 06, 2011 at 07:54:28PM +0200, Marc Lehmann wrote:
> On Sun, Aug 07, 2011 at 12:12:41AM +1000, Dave Chinner <david@fromorbit.com> wrote:
> > > this is 3.1.5 - 3.1.4 simply segfaults. using ltrace shows this as
> > > last call to malloc:
> > > 
> > >    malloc(18446744073708732928)                                  = NULL
> > > 
> > > I think thats a bit unreasonable of xfs_repair :)
> > 
> > Can you share a metadump of the image in question?
> 
> I can, but unfortunately, it's fixed itself in the meantime:
> 
> I wanted to make a copy of the image, and mounted it read-write. I stat'ed
> all files inside (which worked) and then rsynced all files out.
> 
> Then I unmounmted it and re-ran xfs_repair
> (http://ue.tst.eu/3cbc07150eb6b69c63361937c6c3044f.txt) which got much
> farther, but failed with the same error.

Looks lke corrupt directory blocks are causing it.

> Then I re-ran xfs_repair one last time, which ran through without any "error"
> messages.
> 
> An xfs_metadata -o is here (gzipped):
> http://data.plan9.de/smoker-chroot.bin.gz

I'll have a look at it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
