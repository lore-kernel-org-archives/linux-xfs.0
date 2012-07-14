Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6E57poj233202 for <xfs@oss.sgi.com>; Sat, 14 Jul 2012 00:07:51 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id 1PcN0YaH867ecTlT
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Jul 2012 22:07:50 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so8218076pbb.26
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 22:07:49 -0700 (PDT)
Date: Fri, 13 Jul 2012 22:07:41 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/6] workqueue: introduce NR_WORKER_POOLS and
	for_each_worker_pool()
Message-ID: <20120714050741.GB7718@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
	<1341859315-17759-6-git-send-email-tj@kernel.org>
	<20120714035538.GB5638@dhcp-172-17-108-109.mtv.corp.google.com>
	<CA+55aFyeauqCqrWsx4U2TB2ENrugZXYj+4vw3Fd0kGaeWBP3RA@mail.gmail.com>
	<20120714044438.GA7718@dhcp-172-17-108-109.mtv.corp.google.com>
	<CA+55aFyozbYJh4vRLCCkk5j86XEasngvWkKmL4WpBjiCB5050g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFyozbYJh4vRLCCkk5j86XEasngvWkKmL4WpBjiCB5050g@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, gustavo@padovan.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, linux-crypto@vger.kernel.org, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

Hey, Linus.

On Fri, Jul 13, 2012 at 10:00:10PM -0700, Linus Torvalds wrote:
> On Fri, Jul 13, 2012 at 9:44 PM, Tejun Heo <tj@kernel.org> wrote:
> >
> > nr_running is atomic_t (*nr_running)[2].  Ignoring the pointer to
> > array part, it's just returning the address of N'th element of the
> > array.  ARRAY + N == &ARRAY[N].
> 
> None of this matters one whit.
> 
> You did "&(x)[0]".
> 
> That's insane. It's crazy. It doesn't even matter what "x" is in
> between, it's crazy regardless.

Eh, from my previous reply.

| Ah okay, you're looking at the fifth patch in isolation.  Upto this
| point, the index is always 0.  I'm puttin it in as a placeholder for
| the next patch which makes use of non-zero index.  This patch is
| supposed to prepare everything for multiple pools and thus non-zero
| index.

The patch is about converting stuff to handle size-1 array without
introducing any actual behavior change so that the next patch can bump
the array size and just change the index.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
