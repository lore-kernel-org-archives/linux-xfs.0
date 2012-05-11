Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4BEk48r039942
	for <linux-xfs@oss.sgi.com>; Fri, 11 May 2012 09:46:04 -0500
Received: from merlin.infradead.org (merlin.infradead.org [205.233.59.134]) by
	cuda.sgi.com with ESMTP id yES08eVGwaNPodS2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Fri, 11 May 2012 07:46:03 -0700 (PDT)
Message-ID: <4FAD261D.80102@kernel.dk>
Date: Fri, 11 May 2012 16:45:49 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] bio allocation failure due to bio_get_nr_vecs()
References: <jognqm$o21$1@dough.gmane.org>
	<4FABF01E.7080303@itwm.fraunhofer.de>
	<4FAD18D4.3090102@itwm.fraunhofer.de> <4FAD23F7.2080605@kernel.dk>
	<4FAD25B3.3050802@itwm.fraunhofer.de>
In-Reply-To: <4FAD25B3.3050802@itwm.fraunhofer.de>
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
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-xfs@oss.sgi.com, Tejun Heo <tj@kernel.org>, sandeen@sandeen.net, Kent Overstreet <kent.overstreet@gmail.com>

On 05/11/2012 04:44 PM, Bernd Schubert wrote:
> On 05/11/2012 04:36 PM, Jens Axboe wrote:
>> On 05/11/2012 03:49 PM, Bernd Schubert wrote:
>>> The number of bio_get_nr_vecs() is passed down via bio_alloc() to
>>> bvec_alloc_bs(), which fails the bio allocation if
>>> nr_iovecs>  BIO_MAX_PAGES. For the underlying caller this causes an
>>> unexpected bio allocation failure.
>>> Limiting to queue_max_segments() is not sufficient, as max_segments
>>> also might be very large.
>>>
>>> bvec_alloc_bs(gfp_mask, nr_iovecs, ) =>  NULL when nr_iovecs>  BIO_MAX_PAGES
>>> bio_alloc_bioset(gfp_mask, nr_iovecs, ...)
>>> bio_alloc(GFP_NOIO, nvecs)
>>> xfs_alloc_ioend_bio()
>>
>> Thanks, looks sane. Applied.
>>
> 
> Great, thanks! Should we CC linux-stable for commit
> 5abebfdd02450fa1349daacf242e70b3736581e3 and this one, as I got a hard
> kernel panic?

Yes, that's a good idea. I've ammended the commit now to include stable.

-- 
Jens Axboe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
