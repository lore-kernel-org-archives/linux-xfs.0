Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Jul 2007 00:31:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6U7VIbm018395
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2007 00:31:22 -0700
Subject: Re: REVIEW: Make xfs_metadump more robust against bad extents
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <op.tv9flnkx3jf8g2@pc-bnaujok.melbourne.sgi.com> <1185780364.20232.184.camel@localhost.localdomain>
Date: Mon, 30 Jul 2007 17:35:02 +1000
Message-ID: <op.tv9oooyn3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <1185780364.20232.184.camel@localhost.localdomain>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stewart Smith <stewart@flamingspork.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Mon, 30 Jul 2007 17:26:04 +1000, Stewart Smith  
<stewart@flamingspork.com> wrote:

> On Mon, 2007-07-30 at 14:18 +1000, Barry Naujok wrote:
>> @@ -76,9 +77,10 @@ metadump_help(void)
>>  " The 'metadump' command dumps the known metadata to a compact file
>> suitable\n"
>>  " for compressing and sending to an XFS maintainer for corruption
>> analysis \n"
>>  " or xfs_repair failures.\n\n"
>> -" There are 3 options:\n"
>> +" Options:\n"
>>  "   -e -- Ignore read errors and keep going\n"
>>  "   -g -- Display dump progress\n"
>> +"   -m -- Specify max extent size limit to copy for metadata (default
>> = 100)\n"
>
> maybe "max extent size (blocks)" and "default = 100 blocks"?


"   -m -- Specify max extent size in blocks to copy (default = 100  
blocks)\n"
