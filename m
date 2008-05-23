Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 May 2008 17:25:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4N0PhjF013846
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 17:25:44 -0700
Date: Fri, 23 May 2008 10:26:38 +1000
Subject: Re: TAKE streamline init/exit path
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080518130511.GA28501@lst.de> <nccprrg32vr.fsf@sgi.com> <20080521060103.GA25003@lst.de> <nccej7w2l9c.fsf@sgi.com> <20080521072425.GA29889@lst.de> <ncc7ido2i1g.fsf_-_@sgi.com> <20080522155616.GA7682@lst.de>
Content-Transfer-Encoding: 7bit
Message-ID: <op.ubkzio0b3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080522155616.GA7682@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, 23 May 2008 01:56:16 +1000, Christoph Hellwig <hch@lst.de> wrote:

> On Wed, May 21, 2008 at 06:11:23PM +1000, Niv Sardi wrote:
>>
>> Christoph Hellwig <hch@lst.de> writes:
>>
>> > Updated patch below.  There's now split out function to create/destroy
>> > the kmem zones and alloc/free the trace buffers.  I've also changed  
>> the
>> > ktrace allocations to KM_MAYFAIL and handled errors resulting from  
>> that.
>> >
>> > And yes, we really should replace the XFS_*_TRACE ifdefs with a single
>> > XFS_TRACE..
>>
>> Thanks,
>>
>> it's in, forgot to send the TAKE message to oss, here it comes:
>>
>> Subject: TAKE 976035 -  streamline init/exit path
>>
>> Date:  Wed, 21 May 2008 18:02:18 +1000
>> Workarea:  chook.melbourne.sgi.com:/build/xaiki/isms/mangrove-1.3
>> Inspected by:  hch
>
> Well, mangrove was the sles10 NAS tree if I remember correctly.  And it
> indeed hasn't made it to either the CVS or git tree on oss.sgi.com yet.

That's the name of the workarea (and why it's called that... I have
no idea!!)

But, the mod did go to the correct location:

Modid:  xfs-linux-melb:xfs-kern:31210a

But there is a few hour gap going from Melbourne to the US repository
and then to oss.

Barry.
