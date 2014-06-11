Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D85417F58
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 05:56:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7B61CAC008
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 03:56:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KxL6MqH7sLlDCVo3 for
	<xfs@oss.sgi.com>; Wed, 11 Jun 2014 03:56:07 -0700 (PDT)
Date: Wed, 11 Jun 2014 06:56:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfstests: create a test for xfs log grant head leak
	detection
Message-ID: <20140611105603.GB39345@bfoster.bfoster>
References: <1402060483-22195-1-git-send-email-bfoster@redhat.com>
	<20140610012149.GH4453@dastard>
	<20140610111750.GA46344@bfoster.bfoster>
	<20140610233106.GJ9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140610233106.GJ9508@dastard>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jun 11, 2014 at 09:31:06AM +1000, Dave Chinner wrote:
> On Tue, Jun 10, 2014 at 07:17:50AM -0400, Brian Foster wrote:
> > On Tue, Jun 10, 2014 at 11:21:49AM +1000, Dave Chinner wrote:
> > > On Fri, Jun 06, 2014 at 09:14:43AM -0400, Brian Foster wrote:
> > > > +# real QA test starts here
> > > > +_supported_fs xfs
> > > > +_supported_os Linux
> > > > +
> > > > +_require_scratch
> > > > +_require_freeze
> > > > +
> > > > +if [ ! -e /sys/fs/xfs ]
> > > > +then
> > > > +	_notrun "no kernel support for XFS sysfs attributes"
> > > > +fi
> > > 
> > > _requires_xfs_sysfs
> > > 
> > 
> > I was mulling this over as I think we'll probably end up in a situation
> > where a test that depends on sysfs bits will need to check for a
> > specific attribute file. E.g., some new test comes along using a new
> > attribute file. Checking for /sys/fs/xfs is not sufficient for that test
> > once we release a version that so far only exports the log bits.
> > 
> > I think we could handle that by supporting a parameter to
> > _requires_xfs_sysfs that specifies the sub-attribute that must exist
> > (similar to what we have for xfs_io commands). We don't need that at the
> > moment, but that's good enough for me to create the requires func.
> 
> Yup, passing the name and/or sub-path of the paramter set required
> sounds fine to me. it would become:
> 
> _requires_xfs_sysfs log
> 
> in this case, because the presence of the /sys/fs/xfs/<dev>/log
> directory would be suficinet to indicate the test should run, yes?
> 

Yep, that works. Should any new log attributes come along as a test
dependency, something like the following would be required:

_requires_xfs_sysfs log/logattr

So _requires_xfs_sysfs can basically just test for the existence of the
parameter under the xfs/<dev> path for TEST_DEV. I'll go with that.
Thanks.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
