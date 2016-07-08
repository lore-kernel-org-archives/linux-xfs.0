Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 78ED17CD5
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 00:48:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3123E30404E
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 22:48:47 -0700 (PDT)
Received: from mail-pf0-f194.google.com (mail-pf0-f194.google.com
	[209.85.192.194]) by cuda.sgi.com with ESMTP id
	QS75NAnZk4v6eQRb (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Jul 2016 22:48:45 -0700 (PDT)
Received: by mail-pf0-f194.google.com with SMTP id i123so4246492pfg.3
	for <xfs@oss.sgi.com>; Thu, 07 Jul 2016 22:48:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160707222829.GG12670@dastard>
References: <CAGeO4WMZtYjaW=L7Hj8CgTd-sO38-xAUMhkZ-x-Z394YjOO7Xg@mail.gmail.com>
	<20160707222829.GG12670@dastard>
From: Kaho Ng <ngkaho1234@gmail.com>
Date: Fri, 8 Jul 2016 13:48:43 +0800
Message-ID: <CAGeO4WN6iYLk7PjjrfU679wgF5NwFgE=1vkowEc_M8nF5W29HQ@mail.gmail.com>
Subject: Re: [QUESTION] about the freelist allocator in XFS
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

Hmm, wouldn't xfs_alloc_ag_vextent_size() first remove the free extent
record, and insert a new extent record into the freespace by-size
btree if the found free extent record is longer than args->maxlen?

On Fri, Jul 8, 2016 at 6:28 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jul 07, 2016 at 07:01:35PM +0800, Kaho Ng wrote:
>> I am trying to investigate how freelist allocator in xfs interacts
>> with freespace B+Tree allocator.
>> First I prepared a patch
>> <https://gist.github.com/22ffca35929e67c08759b057779b7566> on
>> linux-source/fs/xfs/libxfs/xfs_alloc.c to print debugging messages
>> (The kernel version used is linux-3.10.0-327.22.2.el7).
> ......
>> When reading the log output
>> <https://gist.github.com/890076405e1c13c0a952a579e25e6afe> , I
>> realised that there is no B+Tree split
>> triggered by xfs_alloc_fix_freelist() when calling xfs_free_extent().
>> Isn't B+Tree split possible in by-size B+Tree even when truncating a
>> longer freespace record to shorter one? But what I found in the log is
>> only a few tree shrinks... And when reading the source code of
>> freespace allocator I found that a B+Tree growth in this case is
>> impossible at least...
>
> args->isfl doesn't mean what you think it means.
>
> args->isfl is only set when moving blocks from the freespace btree
> to the AGFL, which only occurs when a previous operation allocated a
> new freespace btree block and depleted the current freelist. i.e.
> "AG Free List" != "AG freespace btree" - they are different
> structures on disk...
>
> And when you consider that a freelist refill can only remove records
> from the the freespace btree, it's should be clear that a btree
> split won't occur during a freelist refill...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
