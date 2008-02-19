Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 16:48:40 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1J0mXpi015338
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 16:48:35 -0800
Message-ID: <47BA2775.1060109@sgi.com>
Date: Tue, 19 Feb 2008 11:48:53 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: tuning, many small files, small blocksize
References: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com>	 <47B6ACC5.3030605@theendofthetunnel.de> <e03b90ae0802160224v600bd94exb2a1007ca7af7b65@mail.gmail.com>
In-Reply-To: <e03b90ae0802160224v600bd94exb2a1007ca7af7b65@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Breidenbach <jeff@jab.org>
Cc: Hannes Dorbath <light@theendofthetunnel.de>, xfs@oss.sgi.com

Jeff Breidenbach wrote:
> the kernel before April is painful but I'll do it if important. Presumably
> there's no simple way to migrate a non-lazy xfs filesytem to a lazy one.
> 

Dave would know that answer.

But on IRIX we used xfs_chver...
>      Using the +c option one can enable a filesystem to use lazy counters.
>      Note that you must run xfs_repair(1M) after setting this option to build
>      the internal state that is required to support this functionality.
> 
>      Using the -c option one can disable lazy counters if it is enabled. Note
>      that you must run xfs_repair(1M) after clearing this option to ensure
>      that the internal state of the filesystem is consistent.

On Linux we have xfs_admin (wrapper around db) and the "version" command in xfs_db.
However, it looks like "version" only does: extflg, v2-logs, attr1, attr2,
but not lazy sb counters.

--Tim
