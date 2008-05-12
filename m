Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 May 2008 23:46:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4C6kY3O003484
	for <xfs@oss.sgi.com>; Sun, 11 May 2008 23:46:36 -0700
Message-ID: <4827E7F4.7010706@sgi.com>
Date: Mon, 12 May 2008 16:47:16 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: review: log_filter.patch 018,081,082 pv#981362
References: <48227ef3.WIWE0hYubr4nS8cD%tes@sgi.com> <20080512064115.GF155679365@sgi.com>
In-Reply-To: <20080512064115.GF155679365@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

David Chinner wrote:
> On Thu, May 08, 2008 at 02:17:55PM +1000, tes@sgi.com wrote:
>> Due to the changes for default mkfs options where we now have
>> version 2 inodes, we no longer update the di_onlink field.
>> To be consistent with previous output, we filter these values out.
>> Also, as part of changes to the inode generation number which uses
>> a random num generator, we need to filter out the gen# too.
>>
>> --Tim
>>
>>  018.op.irix             |  400 +++++++++++------------
>>  018.op.linux            |  400 +++++++++++------------
>>  018.trans_inode         |  800 +++++++++++++++++++++++------------------------
>>  081.ugquota.trans_inode |  816 ++++++++++++++++++++++++------------------------
>>  082.op.irix             |  400 +++++++++++------------
>>  082.op.linux            |  400 +++++++++++------------
>>  082.trans_inode         |  800 +++++++++++++++++++++++------------------------
>>  common.log              |    3 
>>  8 files changed, 2011 insertions(+), 2008 deletions(-)
> 
> Worth noting is that these tests all still fail on a config that
> corrects a problem with the superblock features2 field on mount.
> 
> Probably not worth bothering about - but I thought I'd mention it
> as updating the tests didn't fix the failure on my machine. Updating
> xfsprogs now....
> 
> Cheers,
> 
> Dave.

:-)
Yeah, I had the same failure until I updated mkfs.
I had an extra SB_UNIT sb buffer transaction at the start of
the log for the features2 correction.
I didn't think it was worth bothering about for that interim scenario.

--Tim
