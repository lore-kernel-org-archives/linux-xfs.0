Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Aug 2007 22:20:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7K5Kkbm005538
	for <xfs@oss.sgi.com>; Sun, 19 Aug 2007 22:20:48 -0700
Message-ID: <46C92524.7000207@sgi.com>
Date: Mon, 20 Aug 2007 15:22:44 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] optimize dmapi event tests w/o dmapi config
References: <46C7DD96.6030001@sandeen.net> <46C8D6E8.2080500@sgi.com> <46C90C77.5070502@sandeen.net>
In-Reply-To: <46C90C77.5070502@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

I ran the DMAPI QA with the updated patch and it was working fine.
I will push it in the XFS development tree.
Thanks Eric.

Regards,
Vlad

Eric Sandeen wrote:
> Vlad Apostolov wrote:
>
>   
>> Eric Sandeen wrote:
>>   
>>     
>>> Defining XFS_DM_EVENT* macros to 0 in the absence of 
>>> CONFIG_XFS_DMAPI allows gcc to optimize away tests that 
>>> should never be true. Also wrap one hunk of xfs_unmount 
>>> in #ifdef CONFIG_XFS_DMAPI
>>>   
>>>     
>>>       
>> Good idea Eric. A few remarks and a question below.
>>   
>>     
>>>  
>>> +#ifdef CONFIG_XFS_DMAPI
>>>   
>>>     
>>>       
>> CONFIG_XFS_DMAPI is only defined when the DMAPI is statically linked
>> to the kernel. When DMAPI is configured as a module,  
>> CONFIG_XFS_DMAPI_MODULE
>> is defined. The HAVE_DMAPI is defined for both, static and module DMAPI
>> configurations.
>>   
>>     
> Hmm... ok.  kernel.org doesn't have that so you'll need to take care moving this 
>
> patch to the kernel.org tree I guess.
>
>   
>>>  /* Defines for determining if an event message should be sent. */
>>>  #define	DM_EVENT_ENABLED(vfsp, ip, event) ( \
>>>  	unlikely ((vfsp)->vfs_flag & VFS_DMI) && \
>>> @@ -78,6 +79,11 @@ typedef enum {
>>>  		( ((io)->io_dmevmask & (1 << event)) || \
>>>  		  ((io)->io_mount->m_dmevmask & (1 << event)) ) \
>>>  	)
>>> +#else
>>> +#define DM_EVENT_ENABLED(vfsp, ip, event) (0)
>>>   
>>>     
>>>       
>> The above should use the new two arguments DM_EVENT_ENABLED macro.
>>   
>>     
>>> +#define DM_EVENT_ENABLED_IO(vfsp, io, event) (0)
>>>   
>>>     
>>>       
>> What is this DM_EVENT_ENABLE_IO macro for?
>>   
>>     
> Ah, this is just the differernce between kernel.org & CVS I guess.
> I'm just re-defining existing macros in 2.6.22.1 to no-ops.
>
> DM_EVENT_ENABLE_IO must have been removed from CVS w/o removing from
> kernel.org (yet) - and I guess same goes for the argument count.
>
> Anyway here's a CVS patch, sorry:
>
> ------
>
> Defining XFS_DM_EVENT* macros to 0 in the absence of 
> CONFIG_XFS_DMAPI allows gcc to optimize away tests that 
> should never be true. Also wrap one hunk of xfs_unmount 
> in #ifdef CONFIG_XFS_DMAPI
>
> Stack deltas on x86, gcc 4.1:
>
> xfs_create		-16
> xfs_free_file_space	-4
> xfs_getbmap		+4
> xfs_link		-8
> xfs_mkidr		-20
> xfs_read		-24
> xfs_remove		-12
> xfs_rename		-8
> xfs_rmdir		-16
> xfs_setattr		-20
> xfs_splice_read		-20
> xfs_splice_write	-20
> xfs_unmount		-48
> xfs_write		-20
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>
> Index: linux.orig/fs/xfs/xfs_dmapi.h
> ===================================================================
> --- linux.orig/fs/xfs/xfs_dmapi.h
> +++ linux/fs/xfs/xfs_dmapi.h
> @@ -67,11 +67,15 @@ typedef enum {
>  #define HAVE_DM_RIGHT_T
>  
>  /* Defines for determining if an event message should be sent. */
> +#ifdef HAVE_DMAPI
>  #define	DM_EVENT_ENABLED(ip, event) ( \
>  	unlikely (XFS_MTOVFS((ip)->i_mount)->vfs_flag & VFS_DMI) && \
>  		( ((ip)->i_d.di_dmevmask & (1 << event)) || \
>  		  ((ip)->i_mount->m_dmevmask & (1 << event)) ) \
>  	)
> +#else
> +#define DM_EVENT_ENABLED(ip, event)	(0)
> +#endif
>  
>  #define DM_XFS_VALID_FS_EVENTS		( \
>  	(1 << DM_EVENT_PREUNMOUNT)	| \
> Index: linux.orig/fs/xfs/xfs_vfsops.c
> ===================================================================
> --- linux.orig/fs/xfs/xfs_vfsops.c
> +++ linux/fs/xfs/xfs_vfsops.c
> @@ -572,6 +572,7 @@ xfs_unmount(
>  	rip = mp->m_rootip;
>  	rvp = XFS_ITOV(rip);
>  
> +#ifdef HAVE_DMAPI
>  	if (vfsp->vfs_flag & VFS_DMI) {
>  		error = XFS_SEND_PREUNMOUNT(mp, vfsp,
>  				rvp, DM_RIGHT_NULL, rvp, DM_RIGHT_NULL,
> @@ -584,7 +585,7 @@ xfs_unmount(
>  		unmount_event_flags = (mp->m_dmevmask & (1<<DM_EVENT_UNMOUNT))?
>  					0 : DM_FLAGS_UNWANTED;
>  	}
> -
> +#endif
>  	/*
>  	 * First blow any referenced inode from this file system
>  	 * out of the reference cache, and delete the timer.
>
>
>   
