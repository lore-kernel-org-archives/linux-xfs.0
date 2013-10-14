Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0F4EB7F37
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 16:23:48 -0500 (CDT)
Date: Mon, 14 Oct 2013 16:23:47 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: projid32bit=1 default in xfsprogs-3.2.0
Message-ID: <20131014212347.GB1935@sgi.com>
References: <525C1C15.7020204@sandeen.net>
 <20131014211659.GI5663@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131014211659.GI5663@dastard>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 15, 2013 at 08:16:59AM +1100, Dave Chinner wrote:
> On Mon, Oct 14, 2013 at 11:30:13AM -0500, Eric Sandeen wrote:
> > The commit:
> > 
> > f3edb66a mkfs.xfs: validate options for CRCs up front.
> > 
> > unintentionally (?) defaulted to projid32bit=1 for all filesystems
> > at mkfs time.
> 
> It wasn't unintentional, I just forgot to document it.
> 
> > Support for 32 bit project IDs has been present since kernel v2.6.37.
> 
> Right, so taking the usual approach to these things, all the
> distro's now ship kernels that support 32 bit project IDs, so there
> is no reason for mkfs.xfs in a new xfsprogs release not to set it
> by default.

I'm not seeing much downside to turning on 32 bit project IDs by default in
3.2.0.  Sounds good to me.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
