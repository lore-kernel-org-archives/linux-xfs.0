Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BB0C67CA0
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 05:10:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7BEAB304043
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 03:10:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nV4dFWSdzLZ4jUy6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Jul 2016 03:10:47 -0700 (PDT)
Date: Mon, 18 Jul 2016 12:10:41 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: mkfs.xfs -d su=XXX,sw=YYY and future volume resize
Message-ID: <20160718101041.GA3788@redhat.com>
References: <CACNifpVsOMKQyshHk8B7WrmsbGAN_fOz6qpHLBTc_N=K1xY0Dw@mail.gmail.com>
	<20160715094647.GD3608@redhat.com> <20160715230725.GV1922@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160715230725.GV1922@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Marcin Sura <mailing-lists@sura.pl>, xfs@oss.sgi.com

On Sat, Jul 16, 2016 at 09:07:25AM +1000, Dave Chinner wrote:
> On Fri, Jul 15, 2016 at 11:46:47AM +0200, Carlos Maiolino wrote:
> > On Thu, Jul 14, 2016 at 10:19:02PM +0200, Marcin Sura wrote:
> > >    Hi,
> > >    When I create filesystem I can specify su and sw paramteres which match
> > >    underlying storage device.
> > >    So for example, If I have raid 6 volume made of 6 + 2 disks with stripe
> > >    size of 256k I create xfs with:
> > >    mkfs.xfs -d su=256k,sw=6 <disk>
> > >    But what if I will extend original volume by 2 disks. sw will 8. Will
> > >    be there a performance panelty compared to filesystem created from
> > >    scratch with correct sw parameter?
> > >    BR
> > >    Marcin
> > 
> > Complementing Dave's answer, you can also mount the filesystem with new
> > alignment configuration.
> > 
> > You can use: sunit=value and swidth=value for mounting the FS with the new
> > settings. man xfs for more info.
> 
> That doesn't change the fact that everything that already existed in
> the filesystem would now be misaligned and hence have performance
> issues on read and/or overwrite. Only newly written data will be
> aligned to the new stripe width.
> 
> Also, keep in mind that stripw width cahnges are an alignment change
> you generally canot make through the mount options. Static metadata
> such as allocation group headers are laid out according to the
> physical geometry of the filesystem, and that cannot be changed.
> hence the mount options can only change the stripe unit/width when
> they don't change the alignment constraints. e.g. doubling of the
> stripe width will work because the alignemtn of the stripe units is
> still the same. However, changing from 6 disks to 8 won't work
> because it is a different physical alignment...
> 

Thanks for the detailed info, it was my bad to have not predicted such details


> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
