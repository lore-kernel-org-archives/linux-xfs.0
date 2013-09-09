Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1EA3F7F55
	for <linux-xfs@oss.sgi.com>; Mon,  9 Sep 2013 17:08:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AFF1AAC002
	for <linux-xfs@oss.sgi.com>; Mon,  9 Sep 2013 15:08:30 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	l6l8EFBt40l1a8Yw for <linux-xfs@oss.sgi.com>;
	Mon, 09 Sep 2013 15:08:29 -0700 (PDT)
Date: Tue, 10 Sep 2013 08:08:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfs: don't break from growfs ag update loop on error
Message-ID: <20130909220824.GV12779@dastard>
References: <520D1AAC.8090701@redhat.com>
 <522E3142.7090501@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <522E3142.7090501@sandeen.net>
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
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Eric Sandeen <sandeen@redhat.com>

On Mon, Sep 09, 2013 at 03:36:18PM -0500, Eric Sandeen wrote:
> On 8/15/13 1:15 PM, Eric Sandeen wrote:
> > When xfs_growfs_data_private() is updating backup superblocks,
> > it bails out on the first error encountered, whether reading or
> > writing:
> 
> Any thoughts on this one?  W/ the verifiers, we have a higher
> chance of encountering an error, and leaving the rest of the
> supers un-updated.  Repair will then possibly revert the fs to
> it's pre-growfs state, and data loss will ensue...

Sorry, I must have missed this. I remember discussing it with you.
The change looks fine to me, but I haven't tested it at all.

Acked-by: Dave Chinner <david@fromorbit.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
