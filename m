Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B9AD7F75
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 01:56:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 099C530404E
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 23:56:09 -0800 (PST)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id DCz4lEFP1CUvCItD for
	<xfs@oss.sgi.com>; Mon, 04 Feb 2013 23:56:05 -0800 (PST)
Date: Tue, 5 Feb 2013 02:56:05 -0500 (EST)
From: Tomas Racek <tracek@redhat.com>
Message-ID: <2102910196.6066385.1360050965047.JavaMail.root@redhat.com>
In-Reply-To: <510E8B66.9040803@sandeen.net>
Subject: Re: [PATCH 2/3] xfstests: Add new standard loop handling functions
MIME-Version: 1.0
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
Cc: lczerner@redhat.com, xfs@oss.sgi.com

----- Original Message -----
> On 2/3/13 4:19 AM, Tomas Racek wrote:
> > Add _create_loop_device and _destroy_loop_device to uniformly
> > handle
> > loopback devices.
> 
> Good idea, small comment below
> 
> > Signed-off-by: Tomas Racek <tracek@redhat.com>
> > ---
> >  common.rc | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/common.rc b/common.rc
> > index 0cccb94..67a5e3a 100644
> > --- a/common.rc
> > +++ b/common.rc
> > @@ -1833,6 +1833,20 @@ _require_dumpe2fs()
> >  	fi
> >  }
> >  
> > +_create_loop_device()
> > +{
> > +	file=$1
> > +	dev=`losetup -f`
> > +	losetup $dev $file || _fail "Cannot associate $file with $dev"
> > +	echo $dev
> 
> In theory this is a little racy, right?  the loop device could become
> used in between.
> 
> I wonder if something like:
> 
> _create_loop_device()
> {
> 	dev=`losetup -f --show $file` || _fail "Cannot associate $file with
> 	$dev"
> 	echo $dev
> }
> 
> would work better?  From the manpage:
> 
>        -f, --find
>               find the first unused loop device. If a file argument
>               is present,
>                use this device. Otherwise, print its name
> 
>        --show print device name if the -f option and a file argument
>        are present.
> 
> So this will set up the first available loop device and print its
> name.

You're right, thanks for the suggestion!

Tom

> 
> Thanks,
> -Eric
> 
> > +}
> > +
> > +_destroy_loop_device()
> > +{
> > +	dev=$1
> > +	losetup -d $dev || _fail "Cannot destroy loop device $dev"
> > +}
> > +
> >  ################################################################################
> >  
> >  if [ "$iam" != new -a "$iam" != bench ]
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
