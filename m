Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8D1oLYJ090891 for <xfs@oss.sgi.com>; Wed, 12 Sep 2012 20:50:21 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Reei4iSlWRUmENfr for
	<xfs@oss.sgi.com>; Wed, 12 Sep 2012 18:51:26 -0700 (PDT)
Message-ID: <50513C1A.9020504@redhat.com>
Date: Wed, 12 Sep 2012 20:51:22 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: Ubuntu Ext4 regression testing
References: <50511241.2090603@canonical.com> <5051142D.1050603@redhat.com>
	<5051177E.6000903@canonical.com> <505126D4.5030106@redhat.com>
	<50512BB1.5010605@canonical.com>
In-Reply-To: <50512BB1.5010605@canonical.com>
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
To: Brad Figg <brad.figg@canonical.com>
Cc: linux-ext4@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

On 9/12/12 7:41 PM, Brad Figg wrote:

> Eric,
> 
> Thanks for taking the time to point this out. We will adjust our testing accordingly.
> We initially tried to run xfstest against ext2, ext3, ext4, xfs and btrfs. We are also
> trying to get these tests to run on several different kernel versions as you can
> see from our test results. We were running into issues on different kernels and various
> file-systems while getting our act together, we did this as a band-aid.

I see.

> I accept that we have some things to learn w.r.t. running this test suite. We will work
> to run the xfstests "as is" without any outside "intelligence". We do recognise that
> is a dynamic set of tests that people are adding to regularly.
> 
> I am not attempting to get just a series of "pass" results. If that were my goal
> I could accomplish it much easier and would not have engaged with the community
> on the mailing list. We want to help where we can and will accept constructive
> criticism.

Sorry, it sounds like I came across too strong there - it was just a little worrying to see failing or problematic tests disabled or otherwise artificially restricted.

I'm actually very excited to see you setting up ongoing, public testing using xfstests, I think it'll be a great benefit, especially if there's a way to see a particular test's results across several kernel versions and/or filesystems and/or architectures, so that patterns of failure can emerge.

If you find that xfstests is missing some feature or behavior which would facilitate testing in the automated environment, please do let us know what you need - or send patches.  :)

Thanks,
-Eric

> Brad
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
