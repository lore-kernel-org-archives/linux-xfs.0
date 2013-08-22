Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 893507FA1
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 13:19:14 -0500 (CDT)
Date: Thu, 22 Aug 2013 13:19:10 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 51/50] xfs: add xfs sb v4 support for dirent filetype field
Message-ID: <20130822181910.GP5262@sgi.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<20130819201940.516942026@sgi.com> <5212AA1D.3000809@sandeen.net>
	<52137D3D.8060205@sgi.com> <20130821000624.GO6023@dastard>
	<20130821170336.GJ5262@sgi.com> <20130822020226.GR6023@dastard>
	<20130822161456.GB23510@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130822161456.GB23510@sgi.com>
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
To: Geoffrey Wehrman <gwehrman@sgi.com>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>, Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

Gents,

On Thu, Aug 22, 2013 at 11:14:56AM -0500, Geoffrey Wehrman wrote:
> On Thu, Aug 22, 2013 at 12:02:26PM +1000, Dave Chinner wrote:
> | I'm very, very, very unhappy about how this situation is unfolding.
> 
> As am I.

Mark provided some mkfs code to test the v4 feature bit with, and it
worked fine for me.

Given that we are protected by a feature bit, I feel that pulling in the
v4 feature is considerably less risky than what we did in 3.10, with
Dave still cleaning up his mess in -rc6, so go ahead and call me
reckless:  I've pulled in both v4 and v5 versions of this code.

Mark, please post your mkfs code ASAP, even though Dave hasn't reposted
his userspace series yet.

Everybody gets his code in and nobody is happy.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
