Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Aug 2007 16:47:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7JNkvbm020526
	for <xfs@oss.sgi.com>; Sun, 19 Aug 2007 16:47:01 -0700
Message-ID: <46C8D6E8.2080500@sgi.com>
Date: Mon, 20 Aug 2007 09:48:56 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] optimize dmapi event tests w/o dmapi config
References: <46C7DD96.6030001@sandeen.net>
In-Reply-To: <46C7DD96.6030001@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Defining XFS_DM_EVENT* macros to 0 in the absence of 
> CONFIG_XFS_DMAPI allows gcc to optimize away tests that 
> should never be true. Also wrap one hunk of xfs_unmount 
> in #ifdef CONFIG_XFS_DMAPI
>   
Good idea Eric. A few remarks and a question below.
>  
> +#ifdef CONFIG_XFS_DMAPI
>   
CONFIG_XFS_DMAPI is only defined when the DMAPI is statically linked
to the kernel. When DMAPI is configured as a module,  
CONFIG_XFS_DMAPI_MODULE
is defined. The HAVE_DMAPI is defined for both, static and module DMAPI
configurations.
>  /* Defines for determining if an event message should be sent. */
>  #define	DM_EVENT_ENABLED(vfsp, ip, event) ( \
>  	unlikely ((vfsp)->vfs_flag & VFS_DMI) && \
> @@ -78,6 +79,11 @@ typedef enum {
>  		( ((io)->io_dmevmask & (1 << event)) || \
>  		  ((io)->io_mount->m_dmevmask & (1 << event)) ) \
>  	)
> +#else
> +#define DM_EVENT_ENABLED(vfsp, ip, event) (0)
>   
The above should use the new two arguments DM_EVENT_ENABLED macro.
> +#define DM_EVENT_ENABLED_IO(vfsp, io, event) (0)
>   
What is this DM_EVENT_ENABLE_IO macro for?

>  
> +#ifdef CONFIG_XFS_DMAPI

The same, use HAVE_DMAPI instead of CONFIG_XFS_DMAPI.

Otherwise it is looking good.

Regards,
Vlad
