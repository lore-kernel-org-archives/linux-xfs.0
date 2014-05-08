Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4F2E37F52
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 01:31:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 54A70304053
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 23:31:51 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id qFftWyFHt1W7ciln (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 May 2014 23:31:46 -0700 (PDT)
Date: Thu, 8 May 2014 14:31:38 +0800
From: Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [PATCH] btrfs/035: update clone test to expect EOPNOTSUPP
Message-ID: <20140508063136.GC3407@localhost.localdomain>
References: <1399465998-26545-1-git-send-email-ddiss@suse.de>
	<20140508041123.GB3407@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140508041123.GB3407@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
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
To: David Disseldorp <ddiss@suse.de>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, May 08, 2014 at 12:11:24PM +0800, Liu Bo wrote:
> On Wed, May 07, 2014 at 02:33:18PM +0200, David Disseldorp wrote:
> > With kernel commit 00fdf13a2e9f313a044288aa59d3b8ec29ff904a, the first
> > clone-range overwrite attempt now fails with EOPNOTSUPP, rather than
> > tripping a Btrfs BUG_ON().
> > 
> > This test now trips a new Btrfs bug, in which EIO is returned for
> > subsequent reads following the second clone range ioctl.
> > 
> 
> Hi David,
> 
> Something different here, I didn't get EI on 3.15.0-rc4.

s/EI/EIO/g

-liubo

> 
> thanks,
> -liubo
> 
> > Signed-off-by: David Disseldorp <ddiss@suse.de>
> > ---
> >  tests/btrfs/035     | 11 +++++++++++
> >  tests/btrfs/035.out |  5 +++++
> >  2 files changed, 16 insertions(+)
> > 
> > diff --git a/tests/btrfs/035 b/tests/btrfs/035
> > index 6808179..c9530f6 100755
> > --- a/tests/btrfs/035
> > +++ b/tests/btrfs/035
> > @@ -57,21 +57,32 @@ src_str="aaaaaaaaaa"
> >  echo -n "$src_str" > $SCRATCH_MNT/src
> >  
> >  $CLONER_PROG $SCRATCH_MNT/src  $SCRATCH_MNT/src.clone1
> > +cat $SCRATCH_MNT/src.clone1
> > +echo
> >  
> >  src_str="bbbbbbbbbbcccccccccc"
> >  
> >  echo -n "$src_str" > $SCRATCH_MNT/src
> >  
> >  $CLONER_PROG $SCRATCH_MNT/src $SCRATCH_MNT/src.clone2
> > +cat $SCRATCH_MNT/src.clone2
> > +echo
> >  
> > +# Prior to kernel commit 00fdf13a2e9f313a044288aa59d3b8ec29ff904a, this clone
> > +# resulted in a BUG_ON in __btrfs_drop_extents(). The kernel now returns
> > +# EOPNOTSUPP up to userspace.
> >  snap_src_sz=`ls -lah $SCRATCH_MNT/src.clone1 | awk '{print $5}'`
> >  echo "attempting ioctl (src.clone1 src)"
> >  $CLONER_PROG -s 0 -d 0 -l ${snap_src_sz} \
> >  	$SCRATCH_MNT/src.clone1 $SCRATCH_MNT/src
> > +cat $SCRATCH_MNT/src
> > +echo
> >  
> >  snap_src_sz=`ls -lah $SCRATCH_MNT/src.clone2 | awk '{print $5}'`
> >  echo "attempting ioctl (src.clone2 src)"
> >  $CLONER_PROG -s 0 -d 0 -l ${snap_src_sz} \
> >  	$SCRATCH_MNT/src.clone2 $SCRATCH_MNT/src
> > +# BUG: subsequent access attempts currently result in EIO...
> > +cat $SCRATCH_MNT/src
> >  
> >  status=0 ; exit
> > diff --git a/tests/btrfs/035.out b/tests/btrfs/035.out
> > index f86cadf..0ea2c4f 100644
> > --- a/tests/btrfs/035.out
> > +++ b/tests/btrfs/035.out
> > @@ -1,3 +1,8 @@
> >  QA output created by 035
> > +aaaaaaaaaa
> > +bbbbbbbbbbcccccccccc
> >  attempting ioctl (src.clone1 src)
> > +clone failed: Operation not supported
> > +bbbbbbbbbbcccccccccc
> >  attempting ioctl (src.clone2 src)
> > +bbbbbbbbbbcccccccccc
> > -- 
> > 1.8.4.5
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
