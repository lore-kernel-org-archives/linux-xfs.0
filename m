Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AJUcxQ202590 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 14:30:39 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id P1ySxb08TBbb1V3m
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 12:30:38 -0700 (PDT)
Message-ID: <4F848A5F.2050809@hardwarefreak.com>
Date: Tue, 10 Apr 2012 14:30:39 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
	<20120409142134.GC21431@sgi.com>
In-Reply-To: <20120409142134.GC21431@sgi.com>
Reply-To: stan@hardwarefreak.com
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
To: Geoffrey Wehrman <gwehrman@sgi.com>
Cc: Stefan Ring <stefanrin@gmail.com>, Linux fs XFS <xfs@oss.sgi.com>

On 4/9/2012 9:21 AM, Geoffrey Wehrman wrote:
> On Fri, Apr 06, 2012 at 06:28:37PM -0500, Stan Hoeppner wrote:
> | So while the XFS AG architecture may not be perfectly suited to your
> | single 6 drive RAID6 array, it still gives rather remarkable performance
> | given that the same architecture can scale pretty linearly to the
> | heights above, and far beyond.  Something EXTx and others could never
> | dream of.  Some of the SGI guys might be able to confirm deployed single
> | XFS filesystems spanning 1000+ drives in the past.  Today we'd probably
> | only see that scale with CXFS.

Good to hear from you Geoffrey.

> With an SGI IS16000 array which supports up to 1,200 drives, filesystems
> with large numbers of drives isn't difficult.  Most configurations
> using the IS16000 have 8+2 RAID6 luns.  

Is the concatenation of all these RAID6 LUNs performed within the
IS16000, or with md/lvm, or?

> I've seen sustained 15 GB/s to
> a single filesystem on one of the arrays with a 600 drive configuration.

To be clear, this is a single Linux XFS filesystem on a single host, not
multiple CXFS clients, correct?  If so, out of curiosity, is the host in
this case an old Itanium Altix or the newer Xeon based Altix UV?  And
finally, is this example system using FC or Infiniband connectivity?
How many ports?

> The scalability of XFS is impressive.

Quite impressive.  And there's nothing in XFS itself preventing
scalability of a single filesystem over 4 IS16000s w/4800 total drives,
although one might run into some limitations when attempting to
concatenate that many LUNs.  I've never attempted that scale with md or
lvm, and I've never had my hands on an IS16000.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
