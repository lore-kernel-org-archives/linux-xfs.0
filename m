Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q15GagGf052520 for <xfs@oss.sgi.com>; Sun, 5 Feb 2012 10:36:43 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AoWPBHdHHVGybGxz for
	<xfs@oss.sgi.com>; Sun, 05 Feb 2012 08:36:41 -0800 (PST)
Message-ID: <4F2EB017.5090006@redhat.com>
Date: Sun, 05 Feb 2012 10:36:39 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
References: <4F2D8F30.3090802@redhat.com>
	<201202050933.q159XQpB026380@helium.internal.tigress.co.uk>
In-Reply-To: <201202050933.q159XQpB026380@helium.internal.tigress.co.uk>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ron Yorston <rmy@tigress.co.uk>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 2/5/12 3:33 AM, Ron Yorston wrote:
> Eric Sandeen wrote:
> 
>> Now that ext4, xfs, & ocfs2 can support punch hole, a tool to
>> "re-sparsify" a file by punching out ranges of 0s might be in order.
>>
>> I'll see if util-linux wants it after it gets beat into shape.
>> (or did a tool like this already exist and I missed it?)
> 
> Way ahead of you.  I wrote my sparsify utility for ext2 in 2004:
> 
>    http://intgat.tigress.co.uk/rmy/uml/sparsify.html

Cool, I had not known about that one.  But that one is a bit less generic -
ext2-specific and requiring an unmounted fs, right?

> It's mostly of historical interest now, I suppose.  The sparsify utility
> doesn't work on ext4 and I long since gave up maintaining the kernel
> patch.  I still use the zerofree utility, though.
> 
> It would be nice to have a modern version of sparsify.  I'll try it out.

Thanks!

Matthias' suggestion of adding SEEK_HOLE/SEEK_DATA makes very good sense too.
I should also untie the read/zero buffer size from the minimum hole size,
we should do optimal IO sizes regardless of the minimum hole size desired...

-Eric
 
> Ron

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
