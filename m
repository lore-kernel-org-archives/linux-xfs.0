Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B54A97FAB
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 19:05:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45213AC002
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 17:05:26 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Wz35rZ7gl10I4UaN for <xfs@oss.sgi.com>;
	Mon, 17 Feb 2014 17:05:24 -0800 (PST)
Date: Tue, 18 Feb 2014 12:05:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests: test for atime-related mount options
Message-ID: <20140218010503.GF13997@dastard>
References: <1392668720-6135-1-git-send-email-koen.de.wit@oracle.com>
	<530273CD.3090303@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530273CD.3090303@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Koen De Wit <koen.de.wit@oracle.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Feb 17, 2014 at 02:40:45PM -0600, Eric Sandeen wrote:
> On 2/17/14, 2:25 PM, Koen De Wit wrote:
> > Tests the noatime, relatime, strictatime and nodiratime mount options.
> > 
> > There is an extra check for Btrfs to ensure that the access time is
> > never updated on read-only subvolumes. (Regression test for bug fixed
> > with commit 93fd63c2f001ca6797c6b15b696a484b165b4800)
> 
> I think this looks ok.  Only little nit is that _require_relatime
> now implicitly requires scratch, but *shrug* it was Dave's idea.  ;)

There's a _require_scratch call in there, so it's all good. ;)
Thanks Koen!

> Thanks!
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

And thanks for the reivew, Eric ;)

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
