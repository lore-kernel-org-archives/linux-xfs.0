Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AD2FB7FB8
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 10:55:06 -0500 (CDT)
Date: Thu, 31 Oct 2013 10:55:03 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: fix possible NULL dereference
Message-ID: <20131031155503.GO1935@sgi.com>
References: <5265C03B.50701@sandeen.net> <20131022001732.GI4446@dastard>
	<CAGG-pUTh-PJJ4Nzo0r-f3VDPMc81U2z_NMX+Wcex3KzGs=U8cA@mail.gmail.com>
	<20131022203946.GB2797@dastard> <5266E4BD.8030601@sandeen.net>
	<20131022210300.GC2797@dastard> <5266EBF0.901@sandeen.net>
	<CAGG-pUTtYomspBXn=RE7YFU=vu6rWZ1fU7CBO45Mmodj8DZFiQ@mail.gmail.com>
	<20131023203435.GR1935@sgi.com> <5271672C.7070101@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5271672C.7070101@sandeen.net>
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
To: Geyslan =?iso-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: Alex Elder <elder@kernel.org>, open list <linux-kernel@vger.kernel.org>, XFS FILESYSTEM <xfs@oss.sgi.com>

Hey Geyslan,

On Wed, Oct 30, 2013 at 03:08:12PM -0500, Eric Sandeen wrote:
> On 10/23/13 3:34 PM, Ben Myers wrote:
> 
> > xfs: fix possible NULL dereference in xlog_verify_iclog
> > 
> > In xlog_verify_iclog a debug check of the incore log buffers prints an
> > error if icptr is null and then goes on to dereference the pointer
> > regardless.  Convert this to an assert so that the intention is clear.
> > This was reported by Coverty.
> > 
> > Reported-by: Geyslan G. Bem <geyslan@gmail.com>
> > Signed-off-by: Ben Myers <bpm@sgi.com>
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Applied this.  Many thanks!  ;)

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
