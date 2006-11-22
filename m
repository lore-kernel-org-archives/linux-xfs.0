Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Nov 2006 21:03:14 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAM532aG003886
	for <xfs@oss.sgi.com>; Tue, 21 Nov 2006 21:03:04 -0800
Message-ID: <4563D9CC.4030006@melbourne.sgi.com>
Date: Wed, 22 Nov 2006 16:02:04 +1100
From: David Chatterton <chatz@melbourne.sgi.com>
Reply-To: chatz@melbourne.sgi.com
MIME-Version: 1.0
Subject: Re: Review: Fix inverted quiet mount logic
References: <20061122044656.GS37654165@melbourne.sgi.com> <7013720DE121BA0C2CA1A09D@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <7013720DE121BA0C2CA1A09D@timothy-shimmins-power-mac-g5.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

One of the bugs we found on the training course that I had not raised yet...thanks!

Timothy Shimmin wrote:
> Add me to the reviewer list :)
> --Tim
> 
> --On 22 November 2006 3:46:56 PM +1100 David Chinner <dgc@sgi.com> wrote:
> 
>>
>> Simple problem Noticed by Eric Sandeen at about the same time I did
>> - we are not getting error messages in dmesg when certain checks
>> fail during mount.  Turns out the XFS_MFSI_QUIET flag usage is
>> inverted, so we suppress messages when we should be noisy and
>> shout when we should be silent....
>>
>> Cheers,
>>
>> Dave.
>> -- 
>> Dave Chinner
>> Principal Engineer
>> SGI Australian Software Group
>>
>> ---
>>  fs/xfs/xfs_error.h |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: 2.6.x-xfs-new/fs/xfs/xfs_error.h
>> ===================================================================
>> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_error.h    2006-10-17
>> 12:17:25.000000000 +1000
>> +++ 2.6.x-xfs-new/fs/xfs/xfs_error.h    2006-11-16 09:45:03.444451972
>> +1100
>> @@ -180,6 +180,6 @@ extern void xfs_fs_cmn_err(int level, st
>>      xfs_fs_cmn_err(level, mp, fmt "  Unmount and run xfs_repair.", ##
>> args)
>>
>>  #define xfs_fs_mount_cmn_err(f, fmt, args...) \
>> -    ((f & XFS_MFSI_QUIET)? cmn_err(CE_WARN, "XFS: " fmt, ## args) :
>> (void)0)
>> +    ((f & XFS_MFSI_QUIET)? (void)0 : cmn_err(CE_WARN, "XFS: " fmt, ##
>> args))
>>
>>  #endif    /* __XFS_ERROR_H__ */
> 
> 
> 
> 

-- 
David Chatterton
XFS Engineering Manager
SGI Australia
