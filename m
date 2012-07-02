Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q62DFt4s223491 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 08:15:56 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RhR7N75VB9Gsygqz for
	<xfs@oss.sgi.com>; Mon, 02 Jul 2012 06:15:55 -0700 (PDT)
Message-ID: <4FF19EFA.8020109@redhat.com>
Date: Mon, 02 Jul 2012 15:15:38 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
MIME-Version: 1.0
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
References: <4FDF9EBE.2030809@shiftmail.org> <20120619015745.GJ25389@dastard>
	<4FE1BDF3.4080702@shiftmail.org> <20120620225327.GL30705@dastard>
	<20120621174742.GA27837@redhat.com>
	<4FF06480.6030109@redhat.com> <20120702130034.GA785@redhat.com>
In-Reply-To: <20120702130034.GA785@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, "Martin K. Petersen" <martin.petersen@oracle.com>, xfs@oss.sgi.com, hch@infradead.org, device-mapper development <dm-devel@redhat.com>, Spelic <spelic@shiftmail.org>, linux-ext4@vger.kernel.org

Il 02/07/2012 15:00, Mike Snitzer ha scritto:
> On Sun, Jul 01 2012 at 10:53am -0400,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
>> Il 21/06/2012 19:47, Mike Snitzer ha scritto:
>>> Paolo Bonzini fixed blkdev_issue_discard to properly align some time
>>> ago; unfortunately the patches slipped through the cracks (cc'ing Paolo,
>>> Jens, and Christoph).
>>>
>>> Here are references to Paolo's patches:
>>> 0/2 https://lkml.org/lkml/2012/3/14/323
>>> 1/2 https://lkml.org/lkml/2012/3/14/324
>>> 2/2 https://lkml.org/lkml/2012/3/14/325
>>>
>>> Patch 2/2 specifically addresses the case where:
>>>  discard_max_bytes == discard_granularity 
>>>
>>> Paolo, any chance you could resend to Jens (maybe with hch's comments on
>>> patch#2 accounted for)?  Also, please add hch's Reviewed-by when
>>> reposting.
>>
>> Sure, I'll do it this week.  I just need to retest.
> 
> Great, thanks.
> 
> (cc'ing mkp)
> 
> One thing that seemed odd was your adjustment for discard_alignment (in
> patch 1/2).
> 
> I need to better understand how discard_alignment (an offset despite the
> name not saying as much) relates to alignment_offset.

In principle, it doesn't.  All SBC says is:

  The UNMAP GRANULARITY ALIGNMENT field indicates the LBA of the first
  logical block to which the OPTIMAL UNMAP GRANULARITY field applies.
  The unmap granularity alignment is used to calculate an optimal unmap
  request starting LBA as follows:

   optimal unmap request starting LBA = (n * optimal unmap granularity)
      + unmap granularity alignment

and what my patch does is ensure that all requests except the first
start at such an LBA.

In practice, there is a connection between the two, because a sane disk
will make all discard_alignment-aligned sectors also
alignment_offset-aligned, or vice versa, or both (depending on whether
1<<phys_exp is < > or = to discard_granularity).

> Could just be that once a partition tool, or lvm, etc account for
> alignment_offset (which they do now) that discard_alignment is
> automagically accounted for as a side-effect?

Yes, if discard_granularity <= 1<<phys_exp.  In that case, the condition
above simplifies to discard_alignment == alignment_offset %
discard_granularity.  Your partitions will be already aligned to both
alignment_offset and discard_alignment.

It seems more likely that discard_granularity > 1<<phys_exp if they
differ at all, in which case the partition tool will improve the
situation but still not reach an optimal setting.

The optimal positioning of partitions/logical volumes/etc. would be to
align them to lcm(1<<phys_exp, discard_granularity), and "misalign" the
starting sector by max(discard_alignment, alignment_offset).

> (I haven't actually seen discard_alignment != 0 in the wild)

Me neither, but it was easy to account for it in the patch.

Paolo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
