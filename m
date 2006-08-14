Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Aug 2006 09:59:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7EGxIDW015781
	for <xfs@oss.sgi.com>; Mon, 14 Aug 2006 09:59:20 -0700
Message-ID: <44E09E06.9020400@sandeen.net>
Date: Mon, 14 Aug 2006 11:00:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: review: cleanup xfs_da_node_lookup_int (was Re: [PATCH] XFS:
 possibly uninitialized variable use in fs/xfs/xfs_da_btree.c::xfs_da_node_lookup_int())
References: <200608122334.21901.jesper.juhl@gmail.com> <44DE9B86.90006@sandeen.net> <20060814155609.G2698880@wobbly.melbourne.sgi.com>
In-Reply-To: <20060814155609.G2698880@wobbly.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, xfs@oss.sgi.com

Nathan Scott wrote:
> On Sat, Aug 12, 2006 at 10:24:54PM -0500, Eric Sandeen wrote:
>> ...
>> FWIW seems like there's a lot of unnecessary endian flipping in there too; I 
>> haven't tested this but since it endian-flips the magic into blk->magic seems 
>> like it may as well use it:
> 
> How's this look?

Looks good to me.

(now that I look closer & grok that there are 2 loops in that function 
and the break is in the nested one... oops!)

-Eric
