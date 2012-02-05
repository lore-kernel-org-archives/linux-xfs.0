Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q15GtWu6054979 for <xfs@oss.sgi.com>; Sun, 5 Feb 2012 10:55:32 -0600
Received: from mail.shawcable.com (shawmail.shawcable.com [64.59.128.220]) by
	cuda.sgi.com with ESMTP id lVBeuNfRJfWchcuZ for
	<xfs@oss.sgi.com>; Sun, 05 Feb 2012 08:55:31 -0800 (PST)
References: <4F2D8F30.3090802@redhat.com>
	<201202050933.q159XQpB026380@helium.internal.tigress.co.uk>
	<4F2EB017.5090006@redhat.com>
In-Reply-To: <4F2EB017.5090006@redhat.com>
Mime-Version: 1.0 (1.0)
Message-Id: <9C5B5C07-B0E4-4D13-BCFE-7F35162DF5E8@dilger.ca>
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Date: Sun, 5 Feb 2012 09:55:54 -0700
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Ron Yorston <rmy@tigress.co.uk>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 2012-02-05, at 9:36, Eric Sandeen <sandeen@redhat.com> wrote:
> On 2/5/12 3:33 AM, Ron Yorston wrote:
>> Eric Sandeen wrote:
>>> Now that ext4, xfs, & ocfs2 can support punch hole, a tool to
>>> "re-sparsify" a file by punching out ranges of 0s might be in order.
>>> 
>>> I'll see if util-linux wants it after it gets beat into shape.
>>> (or did a tool like this already exist and I missed it?)
> 
> Matthias' suggestion of adding SEEK_HOLE/SEEK_DATA makes very good sense too.

I thought about this, but if SEEK_HOLE/SEEK_DATA (or FIEMAP) worked, then the file would already be sparse, so I don't think that will help in this case...

> I should also untie the read/zero buffer size from the minimum hole size,
> we should do optimal IO sizes regardless of the minimum hole size desired...

Definitely. 4kB IO is a killer for large files.

Cheers, Andreas
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
