Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 187207F5E
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 18:31:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AB1CDAC00C
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 16:31:28 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	rNuNTGutzkznnQF1 for <xfs@oss.sgi.com>;
	Tue, 10 Jun 2014 16:31:23 -0700 (PDT)
Date: Wed, 11 Jun 2014 09:31:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: create a test for xfs log grant head leak
	detection
Message-ID: <20140610233106.GJ9508@dastard>
References: <1402060483-22195-1-git-send-email-bfoster@redhat.com>
	<20140610012149.GH4453@dastard>
	<20140610111750.GA46344@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140610111750.GA46344@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 10, 2014 at 07:17:50AM -0400, Brian Foster wrote:
> On Tue, Jun 10, 2014 at 11:21:49AM +1000, Dave Chinner wrote:
> > On Fri, Jun 06, 2014 at 09:14:43AM -0400, Brian Foster wrote:
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +_supported_os Linux
> > > +
> > > +_require_scratch
> > > +_require_freeze
> > > +
> > > +if [ ! -e /sys/fs/xfs ]
> > > +then
> > > +	_notrun "no kernel support for XFS sysfs attributes"
> > > +fi
> > 
> > _requires_xfs_sysfs
> > 
> 
> I was mulling this over as I think we'll probably end up in a situation
> where a test that depends on sysfs bits will need to check for a
> specific attribute file. E.g., some new test comes along using a new
> attribute file. Checking for /sys/fs/xfs is not sufficient for that test
> once we release a version that so far only exports the log bits.
> 
> I think we could handle that by supporting a parameter to
> _requires_xfs_sysfs that specifies the sub-attribute that must exist
> (similar to what we have for xfs_io commands). We don't need that at the
> moment, but that's good enough for me to create the requires func.

Yup, passing the name and/or sub-path of the paramter set required
sounds fine to me. it would become:

_requires_xfs_sysfs log

in this case, because the presence of the /sys/fs/xfs/<dev>/log
directory would be suficinet to indicate the test should run, yes?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
