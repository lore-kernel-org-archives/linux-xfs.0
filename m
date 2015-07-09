Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8FF2C7F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 03:24:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5E3348F8037
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 01:24:08 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id Xjos82n6RSxvDfF4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 01:24:06 -0700 (PDT)
Date: Thu, 9 Jul 2015 04:24:04 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <25337161.25415401.1436430244635.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150709004543.GD3902@dastard>
References: <1434711726-13092-1-git-send-email-jtulak@redhat.com>
	<1434711726-13092-2-git-send-email-jtulak@redhat.com>
	<20150625193748.GE36162@bfoster.bfoster>
	<413545489.22844725.1435841273912.JavaMail.zimbra@redhat.com>
	<20150702141403.GA61817@bfoster.bfoster>
	<20150702230520.GA22807@dastard>
	<2084199601.25014496.1436372096546.JavaMail.zimbra@redhat.com>
	<20150709004543.GD3902@dastard>
Subject: Re: [PATCH 01/17] xfsprogs: use common code for multi-disk detection
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

OK, thanks for clarifying. :-)

Jan

----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "Jan Tulak" <jtulak@redhat.com>
> Cc: "Brian Foster" <bfoster@redhat.com>, "Dave Chinner" <dchinner@redhat.com>, xfs@oss.sgi.com
> Sent: Thursday, July 9, 2015 2:45:43 AM
> Subject: Re: [PATCH 01/17] xfsprogs: use common code for multi-disk detection
> 
> [Please line wrap your responses at 68-72 columns]
> 
> On Wed, Jul 08, 2015 at 12:14:56PM -0400, Jan Tulak wrote:
> > ----- Original Message -----
> > > From: "Dave Chinner" <david@fromorbit.com>
> > 
> > > At one point during development of this patch set I started writing
> > > an xfstest to validate that mkfs did all the right input validation
> > > things and set parameters appropriately so that we didn't
> > > inadvertently change behaviour. I never really finished it off (like
> > > the patch set), but I've attached it below to give an idea of where
> > > I was going with it. It was based on validating the input and CLI
> > > parameters for the new code, so is guaranteed to fail on an existing
> > > mkfs binary.
> > 
> > I'm using and extending it, but I'm not sure about some tests,
> > whether it is a change from current behaviour, or if it is rather
> > an issue in the test.
> 
> Remember, the point of the patchset was to sanitise and clean up the
> CLI interface, not just the code. i.e. the CLI will change, not just
> the code.
> 
> > > +
> > > +# basic "should fail" options
> > > +# logarithm based options are no longer valid
> > > +do_mkfs_fail -s log=9 $SCRATCH_DEV
> > 
> > There are some changes in logarithm input (mkfs: validate
> > logarithmic parameters sanely), but it is still supported in the
> > patches. Is there some issue, why to remove them?
> 
> They are redundant and almost nobody uses them. The size options are
> what people use, and even they have so many different units that it
> confuses people...
> 
> > Otherwise, it should rather test for (in)valid input for log=xxx, right?
> 
> No, it's indicative of the fact I wanted to remove the log scale
> options for variables.  As I've said before - I didn't ever finish
> the patchset off.
> 
> Essentially, once all the options are in a table, we only want to
> look in one place for things like ag size, fs size, log size, block
> sizes etc. Right now the table has multiple entries or multiple
> global variables for these things and we have to work out which is
> valid and correct and handle conflicts and incompatibilities, etc.
> We don't *need* that complexity to specify sizes of things, so
> getting rid of the rarely used redundant options makes a lot of
> sense as it simplifies the code and the user interface without
> reducing functionality...
> 
> > > +rm -f $fsimg
> > > +$XFS_IO_PROG -f -c "truncate $fssize" $fsimg
> > > +do_mkfs_pass -d file $fsimg
> > > +do_mkfs_pass -d file,name=$fsimg
> > > +rm -f $fsimg
> > > +do_mkfs_pass -d size=$fssize,file $fsimg
> > > +rm -f $fsimg
> > > +do_mkfs_pass -d size=$fssize,file,name=$fsimg
> > > +do_mkfs_pass -d file,name=$fsimg
> > 
> > Should all these inputs really pass?
> 
> Yes, they should, because ....
> 
> > What is the expected
> > behaviour for example on -d file,name=$fsimg if the file exists,
> > and what if there is no such file?
> 
> ....in all cases the file either:
> 
> 	a) exists and is of non-zero size and hence defines the
> 	   size of the filesystem to be created,
> 	b) does not exist but the size of the filesystem to be
> 	   created is specified on the CLI allowing us to create
> 	   the image file correctly.
> 
> We should only fail to create the image file if it doesn't exist
> and we haven't been given enough information to calculate the size
> of the filesystem via CLI parameters.
> 
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
> 

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
