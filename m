Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 899327FA8
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 13:19:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1A56FAC005
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 11:19:21 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id kvefJn5cTX77fAej (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Aug 2013 11:19:20 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 68C0F7C0444
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 12:19:20 -0600 (MDT)
Date: Thu, 22 Aug 2013 14:19:18 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] xfstests: btrfs/003: stat the dev we're removing to make
	sure its' really gone
Message-ID: <20130822181918.GA29654@localhost.localdomain>
References: <1377101015-3070-1-git-send-email-jbacik@fusionio.com>
	<5214EE7F.8090507@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5214EE7F.8090507@sandeen.net>
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
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com

On Wed, Aug 21, 2013 at 11:44:47AM -0500, Eric Sandeen wrote:
> On 8/21/13 11:03 AM, Josef Bacik wrote:
> > I've been periodically failing btrfs/003 because my box sometimes takes a little
> > longer to unregister the device when we remove it and so the output from btrfs
> > dev show doesn't match what we are wanting since it still sees the device.  To
> > fix this just stat and sleep if we still see the device node and only continue
> > once udev or whatever actually removes the device node so that we don't get
> > random failures.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> >  tests/btrfs/003 |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/tests/btrfs/003 b/tests/btrfs/003
> > index 5c88651..dba1a32 100755
> > --- a/tests/btrfs/003
> > +++ b/tests/btrfs/003
> > @@ -145,6 +145,12 @@ _test_replace()
> >  	_devmgt_remove ${DEVHTL}
> >  	dev_removed=1
> >  
> 
> This should probably go into _devmgt_remove,
> and possibly the reverse in _devmgmt_add as well, with
> a comment explaining what it's doing?
> 
> Otherwise someone else will run into the same problem down the line.

Ok so I went to do this and realized we only send the formatted thing to the
function, ie '0 0 0' for host/target/lun or whatever the numbers line up to.  We
don't have the actual device node to check at this point, so it needs to be done
on a case by case basis.  I looked at the other tests and all they want is the
device removed for kernel stuff, which happens immediately.  We are the weird
ones checking to make sure btrfs fi show actually notices that we've removed the
device, so it's only really specific to this case and not something I can easily
add to the helper.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
