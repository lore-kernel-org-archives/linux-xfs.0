Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0E8AA7F66
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 16:02:35 -0600 (CST)
Date: Tue, 28 Jan 2014 16:02:30 -0600
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: [RFC 00/17] RFC parent inode pointers.
Message-ID: <20140128220230.GF13953@sgi.com>
References: <20140115220012.624438534@sgi.com> <20140116055607.GR3431@dastard>
	<52D99FD2.6000601@sgi.com> <20140118031247.GE18112@dastard>
	<52E6B67B.6070001@sgi.com> <20140128030040.GG2212@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140128030040.GG2212@dastard>
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Tue, Jan 28, 2014 at 02:00:40PM +1100, Dave Chinner wrote:
| On Mon, Jan 27, 2014 at 01:41:47PM -0600, Mark Tinguely wrote:
| > 2) Add the filename to EA. Not a fan, but I will ask but if DMF needs it
| >    for performance then it has to be done. My point was this assumes
| >    that we can keep all the links' EA entries inline in the inode. A
| >    couple 255 character files or several links of modest sized filenames
| >    would negate that assumption. I tried to minimize the EA entries to
| >    keep them inline in the inode. I will talk to the DMF group.
| 
| Actually, I made the point about DMF needing them inline performance
| because that's an argument SGI might find persuasive. What I didn't
| say just then is that *I* need them inline, too, as online directory
| tree scrubbing needs to be able to do bulks scans, as does
| xfs_repair. However, I have idefinitely said this before in previous
| parent poitner discussions, so it should be no surprise here...

I appologize in advance for my ignorance.  What is "online directory
tree scrubbing" and how does it benefit from parent inode pointers?


-- 
Geoffrey Wehrman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
