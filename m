Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jul 2007 23:00:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6B60Mbm028975
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 23:00:24 -0700
Date: Wed, 11 Jul 2007 16:04:05 +1000
Subject: Re: REVIEW: fix xfs_bmap -vp confusion
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <op.tu954us03jf8g2@pc-bnaujok.melbourne.sgi.com> <20070711055347.GP12413810@sgi.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.tvads3bs3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20070711055347.GP12413810@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Wed, 11 Jul 2007 15:53:47 +1000, David Chinner <dgc@sgi.com> wrote:

> On Wed, Jul 11, 2007 at 01:18:20PM +1000, Barry Naujok wrote:
>> If xfs_bmap -vp is run on a file without unwritten extents
>> and the filesystem does not use sunit/swidth, the FLAGS
>> column is not shown. This leads to some confusion.
>>
>> So, when -vp option is used, it will always print the
>> FLAGS column.
>
> I note that it only prints the legend if a flag is set. I guess
> this is ok, but maybe it would be more consistent to always
> print the legend? Or even to make the legend optional (which
> would make dumping more than one file more compact)?
>
> Cheers,
>
> Dave.

The legend* is only shown with an extra -v option and the FLAGS
column displayed. The updated man pages posted out yesterday
documents this.

* I assume the legend you refer to is:
  FLAG Values:
     010000 Unwritten preallocated extent
     001000 Doesn't begin on stripe unit
     000100 Doesn't end   on stripe unit
     000010 Doesn't begin on stripe width
     000001 Doesn't end   on stripe width
