Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE3D27F4E
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 10:07:27 -0500 (CDT)
Date: Tue, 23 Jul 2013 10:07:24 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfs: di_flushiter considered harmful
Message-ID: <20130723150724.GH3111@sgi.com>
References: <1374488304-13044-1-git-send-email-david@fromorbit.com>
	<20130722110732.GA365@x4> <51ED4471.7050708@sgi.com>
	<20130722151542.GB365@x4> <51ED8C73.50306@sgi.com>
	<20130723104259.GB360@x4>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130723104259.GB360@x4>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Dave Chinner <dchinner@redhat.com>, Mark Tinguely <tinguely@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Hi Markus,

On Tue, Jul 23, 2013 at 12:42:59PM +0200, Markus Trippelsdorf wrote:
> On 2013.07.22 at 14:48 -0500, Mark Tinguely wrote:
> > On 07/22/13 10:15, Markus Trippelsdorf wrote:
> > > On 2013.07.22 at 09:40 -0500, Mark Tinguely wrote:
> > >> On 07/22/13 06:07, Markus Trippelsdorf wrote:
> > >>> On 2013.07.22 at 20:18 +1000, Dave Chinner wrote:
> > >> It seems to me that since we cannot fix this for inode 1/2, then besides
> > >> this patch we have to revert patch cca9f93a52d and make it inode 3+ /
> > >> superblock 5+ (crc) dependent.
> > >
> > > Which is exactly what the hunk I've posted does.
> > >
> > > Here's the combined patch:
> > 
> > Following Dave's instruction to recreate this problem, your patch works 
> > with an inode 2 and inode 3 (once I remembered to load the module before 
> > recovery). Dave's patch was successful on inode 3 - again after I 
> > remembered to load the module before recovery.
> > 
> > Whomever makes the formal patch, consider it reviewed-by me.
> 
> To get this patch to Linus ASAP, here's the combined patch again. 
> Please apply.
> Thanks.

I'd prefer to have Dave take another look at the combined patch before pulling
this in.  Even so, we shouldn't have any trouble getting this into -rc3.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
