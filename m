Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 11:34:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8EIYQ4p024626
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2007 11:34:27 -0700
Message-ID: <46EAD432.1030704@sandeen.net>
Date: Fri, 14 Sep 2007 13:34:26 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/4] simplify xfs_create/mknod/symlink prototype
References: <20070914163041.GG7110@lst.de> <46EAD364.7060305@sandeen.net>
In-Reply-To: <46EAD364.7060305@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Eric Sandeen wrote:
> Christoph Hellwig wrote:
>> (sorry, go the patch numbering one off)
>>
>> Simplify the prototype for xfs_create/xfs_mkdir/xfs_symlink by not
>> passing down a bhv_vattr_t that just hogs stack space.  Instead pass
>> down the mode in a mode_t and in case of xfs_crate the rdev as a scalar
>> type aswell.
> 
> With this whole patch series, I see these stack reductions on my x86
> box, nice!
> 

> -xfs_symlink [xfs]: 240
> +xfs_symlink [xfs]: 256

Although, that one is a little unfortunate ;)

-eric
