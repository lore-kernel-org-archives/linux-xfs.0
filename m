Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q39ELcLw143908 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 09:21:38 -0500
Date: Mon, 9 Apr 2012 09:21:34 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
Message-ID: <20120409142134.GC21431@sgi.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F7F7C25.8040605@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Stefan Ring <stefanrin@gmail.com>, Linux fs XFS <xfs@oss.sgi.com>

On Fri, Apr 06, 2012 at 06:28:37PM -0500, Stan Hoeppner wrote:
| So while the XFS AG architecture may not be perfectly suited to your
| single 6 drive RAID6 array, it still gives rather remarkable performance
| given that the same architecture can scale pretty linearly to the
| heights above, and far beyond.  Something EXTx and others could never
| dream of.  Some of the SGI guys might be able to confirm deployed single
| XFS filesystems spanning 1000+ drives in the past.  Today we'd probably
| only see that scale with CXFS.

With an SGI IS16000 array which supports up to 1,200 drives, filesystems
with large numbers of drives isn't difficult.  Most configurations
using the IS16000 have 8+2 RAID6 luns.  I've seen sustained 15 GB/s to
a single filesystem on one of the arrays with a 600 drive configuration.
The scalability of XFS is impressive.


-- 
Geoffrey Wehrman
SGI Building 10                             Office: (651)683-5496
2750 Blue Water Road                           Fax: (651)683-5098
Eagan, MN 55121                             E-mail: gwehrman@sgi.com
	  http://www.sgi.com/products/storage/software/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
