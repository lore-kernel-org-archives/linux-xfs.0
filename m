Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E7367F54
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 10:56:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88A7A304077
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 08:56:19 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id LDzOSRNCFVJ849UV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Jul 2013 08:56:17 -0700 (PDT)
Date: Tue, 23 Jul 2013 17:56:15 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH v2] xfs: di_flushiter considered harmful
Message-ID: <20130723155615.GC360@x4>
References: <1374488304-13044-1-git-send-email-david@fromorbit.com>
	<20130722110732.GA365@x4> <51ED4471.7050708@sgi.com>
	<20130722151542.GB365@x4> <51ED8C73.50306@sgi.com>
	<20130723104259.GB360@x4> <20130723150724.GH3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130723150724.GH3111@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Dave Chinner <dchinner@redhat.com>, Mark Tinguely <tinguely@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On 2013.07.23 at 10:07 -0500, Ben Myers wrote:
> Hi Markus,
> 
> On Tue, Jul 23, 2013 at 12:42:59PM +0200, Markus Trippelsdorf wrote:
> > On 2013.07.22 at 14:48 -0500, Mark Tinguely wrote:
> > > On 07/22/13 10:15, Markus Trippelsdorf wrote:
> > > > On 2013.07.22 at 09:40 -0500, Mark Tinguely wrote:
> > > >> On 07/22/13 06:07, Markus Trippelsdorf wrote:
> > > >>> On 2013.07.22 at 20:18 +1000, Dave Chinner wrote:
> > > >> It seems to me that since we cannot fix this for inode 1/2, then besides
> > > >> this patch we have to revert patch cca9f93a52d and make it inode 3+ /
> > > >> superblock 5+ (crc) dependent.
> > > >
> > > > Which is exactly what the hunk I've posted does.
> > > >
> > > > Here's the combined patch:
> > > 
> > > Following Dave's instruction to recreate this problem, your patch works 
> > > with an inode 2 and inode 3 (once I remembered to load the module before 
> > > recovery). Dave's patch was successful on inode 3 - again after I 
> > > remembered to load the module before recovery.
> > > 
> > > Whomever makes the formal patch, consider it reviewed-by me.
> > 
> > To get this patch to Linus ASAP, here's the combined patch again. 
> > Please apply.
> > Thanks.
> 
> I'd prefer to have Dave take another look at the combined patch before pulling
> this in.  Even so, we shouldn't have any trouble getting this into -rc3.

Ok, understood. I'll let Dave handle the rest. 

BTW the comment above xfs_iread() probably needs an update, too.

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
