Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6A8647F3F
	for <xfs@oss.sgi.com>; Sun, 27 Oct 2013 04:11:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EABFCAC008
	for <xfs@oss.sgi.com>; Sun, 27 Oct 2013 02:11:26 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	W55fNvlEXoFcC7OL for <xfs@oss.sgi.com>;
	Sun, 27 Oct 2013 02:11:25 -0700 (PDT)
Date: Sun, 27 Oct 2013 20:11:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstest: fix filtering in 206 for ftype and projid32bit
Message-ID: <20131027091121.GB2797@dastard>
References: <20131024215652.413619467@sgi.com> <20131024221136.GZ2797@dastard>
	<5269A35F.5080500@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5269A35F.5080500@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: XFS Community <xfs@oss.sgi.com>

On Thu, Oct 24, 2013 at 05:46:55PM -0500, Mark Tinguely wrote:
> On 10/24/13 17:11, Dave Chinner wrote:
> >On Thu, Oct 24, 2013 at 04:56:42PM -0500, Mark Tinguely wrote:
> >>xfs/206 displays the output for mkfs.xfs, xfs_growfs and xfs_info.
> >>Change the filtering to hide the new output for the field type
> >>feature.
> >>
> >>While cleaning up the ftype output, also clean up the projid32bit
> >>output in xfs_growfs and xfs_info.
> >
> >What about the _filter_mkfs function that other tests use?
> >
> >Cheers,
> >
> >Dave.
> 
> From what I can tell, it does not need changing.

We really should be exporting the values as shell variables to
stderr for any test that wants to use them. We don't need to output
them to stdout at this point (as that will break all the golden
images), but all the mkfs config values should be accessible from
the filter.

i.e. _filter_mkfs is infrastructure and when new things are added,
the infrastructure needs to be updated as well. IOWs, this should
work after you've added support for ftype to xfstests:

_scratch_mkfs | _mkfs_filter 2> $tmp.mkfs > /dev/null
. $tmp.mkfs

if [ $nftype -eq 1 ]; then
	.....


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
