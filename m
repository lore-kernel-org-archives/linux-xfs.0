Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 31 Oct 2007 17:32:18 -0700 (PDT)
Received: from waldorf.loreland.org (uk.loreland.org [89.16.172.112])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA10WABo025573
	for <xfs@oss.sgi.com>; Wed, 31 Oct 2007 17:32:14 -0700
In-Reply-To: <20071031154111.GA14956@puku.stupidest.org>
References: <20071029075657.GA84369978@melbourne.sgi.com> <4725FBB4.1010400@sandeen.net> <47267EC7.8000906@sgi.com> <177CA06B-41D3-4E4A-9EA6-5688C952CD63@loreland.org> <20071031154111.GA14956@puku.stupidest.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <7A42DE01-1E92-4BE2-A1D9-BD91D8A7F732@loreland.org>
Content-Transfer-Encoding: 7bit
From: James Braid <jamesb@loreland.org>
Subject: Re: Default mount options (that suck less).
Date: Thu, 1 Nov 2007 00:32:20 +0000
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com

On 31 Oct 2007, at 15:41, Chris Wedgwood wrote:
> On Wed, Oct 31, 2007 at 11:05:09AM +0000, James Braid wrote:
>
>> We have a ~100TB filesystem that was made with the default mkfs.xfs
>> options from memory. The only mount option we use is inode64.
>
> Weta?  Mostly very large files?

Not weta, but another big vfx company

This particular filesystem is used for nearline backups from a bunch  
of NFS servers (which run XFS as well - we love XFS). The average  
file size is only about a megabyte.
