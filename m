Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D21C803D
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 10:33:43 -0600 (CST)
Date: Mon, 4 Mar 2013 10:33:40 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/9] xfs: metadata CRCs, kernel, first batch
Message-ID: <20130304163340.GG22182@sgi.com>
References: <1358774760-21841-1-git-send-email-david@fromorbit.com>
	<20130222151931.GU22182@sgi.com> <20130222231217.GA26081@dastard>
	<20130222235029.GA30652@sgi.com> <20130223023818.GJ26081@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130223023818.GJ26081@dastard>
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
Cc: xfs@oss.sgi.com

Hi Dave,

On Sat, Feb 23, 2013 at 01:38:18PM +1100, Dave Chinner wrote:
> On Fri, Feb 22, 2013 at 05:50:29PM -0600, Ben Myers wrote:
> > On Sat, Feb 23, 2013 at 10:12:17AM +1100, Dave Chinner wrote:
> > > On Fri, Feb 22, 2013 at 09:19:31AM -0600, Ben Myers wrote:
> > > This is mentioned in the patch zero description:
> > > 
> > > "This series makes is through to 001-092 in xfstests - there is a
> > > problem in the dquot verifier that causes log recovery of dquot
> > > buffers to follow a NULL pointer."
> > >
> > > Basically, mp->m_quotainfo is not initialised until after log
> > > recovery occurs, so this has to be detected in the verify/crc
> > > routines otherwise it goes splat like above. My current patch series
> > > has this fixed.
> > 
> > Cool.  Sorry for the extra noise.
> 
> No, that's fine. It tells me that you're actaully looking at the
> code and seeing what it does ;)
> 
> I'm close to having a new version of the kernel patchset out. I've
> just got to finish debugging the attribute changes I've made and
> move the superblock support patch to the end of the series and I'll
> post it out.
> 
> All I'm aiming for with the next version of the patch set is that
> existing filesystems (i.e. no CRCs) are regression free. I've
> actaully done very little CRC enabled testing while doing all the
> directory and attribute code changes, mainly because I can't test
> them properly until the userspace support is there. However, the
> patch set up to the final patch (i.e. everything but the attribute
> changes) seems to work just fine with the existing toolchain and
> xfstests.
> 
> Put simply, my focus for testing the patch set is currently "no
> regressions for existing users", not "CRCs work perfectly".

Sounds good.  I'll keep that in mind.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
