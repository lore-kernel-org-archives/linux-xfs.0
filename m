Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 17:09:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m42099F6014328
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 17:09:12 -0700
Date: Fri, 02 May 2008 10:13:38 +1000
Subject: Re: REVIEW: ASCII CI support in xfsprogs
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.uagkf9jl3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080501131725.GB7435@infradead.org>
Message-ID: <op.uah2w02l3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080501131725.GB7435@infradead.org>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Thu, 01 May 2008 23:17:25 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Thu, May 01, 2008 at 02:37:11PM +1000, Barry Naujok wrote:
>> I've reworked xfsprogs userspace tools from scratch with ASCII CI  
>> support
>> only. Much simpler than previous patches with Unicode CI.
>>
>> One issue that sort of bugs me a bit is I've maintained the same output  
>> as
>> the original IRIX mkfs.xfs with CI mode:
>> naming   =version 2              bsize=4096   mixed-case=Y|N
>>
>> where "N" = CI enabled and "Y" = normal case-senstive filesystem.
>>
>> Should this be changed to something clearer?
>
> I'd prefer something cleaner.  Like case-insensitive=Y|N.

Yes, I was going to do "ascii-ci=Y|N", got to keep it clear in only
does CI for A-Z.

> Otherwise
> the patch looks fine, but I wonder if you shouldn't better backport the
> xfs_dir* files from the kernel completely instead of applying the
> changes selectively, otherwise we'll get totoally out of sync codebases.

I was thinking of that, but libxfs is pretty out of date anyway from
all the cleanup changes that have occured and would like to sync them
back at some stage in the near future. The sync would bring those other
changes in at that time (Nathan can correct me if I misunderstand the
sync process!)

Barry.
