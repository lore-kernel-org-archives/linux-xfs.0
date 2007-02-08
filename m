Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Feb 2007 12:38:53 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l18Kckm7024463
	for <xfs@oss.sgi.com>; Thu, 8 Feb 2007 12:38:47 -0800
Message-ID: <45CB8A61.6060902@redhat.com>
Date: Thu, 08 Feb 2007 14:38:57 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] don't special-case 32MB machines
References: <45CA7D7B.3060307@redhat.com> <20070208192712.GA1461@infradead.org>
In-Reply-To: <20070208192712.GA1461@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Wed, Feb 07, 2007 at 07:31:39PM -0600, Eric Sandeen wrote:
>> This one may be a bit silly, but:
>>
>> All the special cases for 32MB machines probably aren't so useful anymore...
>>
>> Or maybe this points to the need to bump up the scaling points & sizes a 
>> bit?
>>
>> Also remove duplicate, unused XFS_MAX_RW_NBMAPS definitions in linux 
>> subdirs.
> 
> Sounds good.  Any chance you could kill off xfs_physmem completely?
> 

Hm, why out of curiosity?  Because you think xfs should never be looking
at system memory, or because you don't like the name, or ...?

-Eric
