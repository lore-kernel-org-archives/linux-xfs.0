Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C9AEE29DF5
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 15:53:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A872A304039
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 13:53:51 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	KqvGOTyNVqA9VnRH for <xfs@oss.sgi.com>;
	Mon, 21 Dec 2015 13:53:49 -0800 (PST)
Date: Tue, 22 Dec 2015 08:53:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: Use a signed return type for suffix_kstrtoint()
Message-ID: <20151221215335.GX26718@dastard>
References: <5676520D.2060806@users.sourceforge.net>
	<5678468B.1040008@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5678468B.1040008@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Mon, Dec 21, 2015 at 12:35:55PM -0600, Eric Sandeen wrote:
> On 12/20/15 1:00 AM, SF Markus Elfring wrote:
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Sun, 20 Dec 2015 07:56:36 +0100
> > 
> > The return type "unsigned long" was used by the suffix_kstrtoint()
> > function even though it will eventually return a negative error code.
> 
> > Improve this implementation detail by using the type "int" instead.
> > 
> > This issue was detected by using the Coccinelle software.
> 
> > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> 
> yep, looks like an oversight left over from a17164e5
> 
> Harmless, because callers only check for non-zero value, but still
> worth fixing.

Perhaps addressing the actual bug in that code would be a more
appropriate use of our time. i.e. the undetected integer overflow
on left shift....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
