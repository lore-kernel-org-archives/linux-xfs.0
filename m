Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A96A17F51
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 16:24:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9491C8F806F
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 14:24:24 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Cv06miDP6TdrptJu for <xfs@oss.sgi.com>;
	Fri, 14 Feb 2014 14:24:22 -0800 (PST)
Date: Sat, 15 Feb 2014 09:24:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: test for atime-related mount options
Message-ID: <20140214222418.GT13997@dastard>
References: <1392305016-7424-1-git-send-email-koen.de.wit@oracle.com>
	<52FCF60F.6030703@sandeen.net>
	<20140214163925.GW16073@twin.jikos.cz>
	<52FE472C.8070503@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52FE472C.8070503@sandeen.net>
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
Cc: Koen De Wit <koen.de.wit@oracle.com>, dsterba@suse.cz, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Feb 14, 2014 at 10:41:16AM -0600, Eric Sandeen wrote:
> On 2/14/14, 10:39 AM, David Sterba wrote:
> > On Thu, Feb 13, 2014 at 10:42:55AM -0600, Eric Sandeen wrote:
> >>> +cat /proc/mounts | grep "$SCRATCH_MNT" | grep relatime >> $seqres.full
> >>> +[ $? -ne 0 ] && echo "The relatime mount option should be the default."
> >>
> >> Ok, I guess "relatime" in /proc/mounts is from core vfs code and
> >> should be there for the foreseeable future, so seems ok.
> >>
> >> But - relatime was added in v2.6.20, and made default in 2.6.30.  So
> >> testing older kernels may not go as expected; it'd probably be best to
> >> catch situations where relatime isn't available (< 2.6.20) or not
> >> default (< 2.6.30), by explicitly mounting with relatime, and skipping
> >> relatime/strictatime tests if that fails?
> > 
> > Is there some consensus what's the lowest kernel version to be supported
> > by xfstests? 2.6.32 is the lowest base for kernels in use today, so
> > worrying about anything older does not seem necessary.
> > 
> 
> I don't know that it's been discussed - selfishly, I know our QE uses
> xfstests on RHEL5, which is 2.6.18-based.

Sure, but they can just add the test to a "rhel5-expunged" file and
they don't have to care about tests that won't work on RHEL 5 or
other older kernels. Or to send patches to add "_requires_relatime"
so that it automatically does the right thing for older kernels.

Ultimately, upstream developers can't do all the work necessary to
support distros - that's why the distros have their own engineers
and QE to make sure the upstream code works correctly when they
backport it. xfstests is no different. ;)

IOWs, if someone wants to run a modern test suite on a 7 year old
distro, then they need to make sure that the test suite does the
right thing for their distro. We'll take the patches that make it
work, but we can't expect upstream developers to know what old
distros require, let alone test and make stuff work on them...

Just my 2c worth.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
