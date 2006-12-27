Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Dec 2006 07:42:30 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBRFgKqw002977
	for <linux-xfs@oss.sgi.com>; Wed, 27 Dec 2006 07:42:22 -0800
Message-ID: <4592942C.5000306@sandeen.net>
Date: Wed, 27 Dec 2006 09:41:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Possible performance problem introduced between kernel 2.6.15
 and 2.6.17 on xfs code
References: <458D4845.2010803@emaze.net> <458D4EEB.3060501@sandeen.net> <458DCB8D.3040804@emaze.net>
In-Reply-To: <458DCB8D.3040804@emaze.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: fdegrassi <francesco.degrassi@emaze.net>
Cc: linux-xfs@oss.sgi.com

fdegrassi wrote:
> The specific problem is related to gnome point-n-click only.
> Anyway, I could be wrong, but i don't think it is a bug in gnome because:
> 1. it affects specifically local XFS filesystems only
> 2. the problem is not present on kernel 2.6.15 (I tested 2.6.17 and 
> 2.6.15, both on ubuntu 6.10)
> 3. the problem does not manifest if i disable the call to 
> gnome_vfs_forget_cache, that, for what i understand, simply calls 
> fadvice POSIX_FADV_DONTNEED.
> 
> More info can be found on gnome bugzilla entry.
> Francesco Degrassi
> 

Thanks.  I didn't mean to suggest that it was necessarily a gnome bug, 
just wanted to narrow down the problem.  Do you have any idea if other 
filesystems on 2.6.17 also show this slowdown?

-Eric
