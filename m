Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C894F7F53
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 04:03:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 50271AC003
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 02:03:55 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id mCZiXqeQyDFIk19g (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Feb 2014 02:03:53 -0800 (PST)
Date: Thu, 6 Feb 2014 11:03:48 +0100
From: David Disseldorp <ddiss@suse.de>
Subject: Re: [PATCH 1/2] btrfs: add small program for clone testing
Message-ID: <20140206110348.10c44bae@plati.site>
In-Reply-To: <20140205230936.GI13997@dastard>
References: <1391599009-2402-1-git-send-email-ddiss@suse.de>
	<1391599009-2402-2-git-send-email-ddiss@suse.de>
	<20140205230936.GI13997@dastard>
Mime-Version: 1.0
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
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Hi Dave,

On Thu, 6 Feb 2014 10:09:36 +1100, Dave Chinner wrote:

> On Wed, Feb 05, 2014 at 12:16:48PM +0100, David Disseldorp wrote:
> > The cloner program is capable of cloning files using the BTRFS_IOC_CLONE
> > and BTRFS_IOC_CLONE_RANGE ioctls.
> > 
> > Signed-off-by: David Disseldorp <ddiss@suse.de>
> 
> Hi Dave - long time since I've seen your head pop up around here ;)

Indeed, it's been a while. Thanks for the review :)

> 
> A few comments below.
> 
> > +struct btrfs_ioctl_clone_range_args {
> > +	int64_t src_fd;
> > +	uint64_t src_offset;
> > +	uint64_t src_length;
> > +	uint64_t dest_offset;
> > +};
> > +
> > +#define BTRFS_IOCTL_MAGIC 0x94
> > +#define BTRFS_IOC_CLONE       _IOW(BTRFS_IOCTL_MAGIC, 9, int)
> > +#define BTRFS_IOC_CLONE_RANGE _IOW(BTRFS_IOCTL_MAGIC, 13, \
> > +				   struct btrfs_ioctl_clone_range_args)
> 
> Is there some published header file that these belong to? i.e.
> somewhere in the include/linux/uapi/ kernel directory? Normally the
> way to handle this sort of thing is by autoconf - if the header file
> exists, then we include it, otherwise we use the manual definitions.
> This just means that if the public api ever changes, we'll pick it
> up automatically in future...

I'd wanted to avoid the addition of another xfsqa prereq, but I guess
it'll work with the fall-back.
I'll add the autoconf logic to the next round, along with changes
addressing your other remarks.

Cheers, David

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
