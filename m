Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q26NpgYa244801 for <xfs@oss.sgi.com>; Tue, 6 Mar 2012 17:51:42 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WjaH8MsLysVk142V for
	<xfs@oss.sgi.com>; Tue, 06 Mar 2012 15:51:41 -0800 (PST)
Message-ID: <4F56A304.8060505@sandeen.net>
Date: Tue, 06 Mar 2012 17:51:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: getbmap!!!!!!!
References: <CACBF2D716C5104BAC48A16827DE5B150A220515A6@NDA-HCLT-EVS04.HCLT.CORP.HCL.IN>
In-Reply-To: <CACBF2D716C5104BAC48A16827DE5B150A220515A6@NDA-HCLT-EVS04.HCLT.CORP.HCL.IN>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Anshul Kundra <anshul.kundra@hcl.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 03/06/2012 11:11 AM, Anshul Kundra wrote:
> To Developers ,
> 
>  
> 
> Please provide me some description regarding the xfs_getbmap what it
> suppose to do , suppose I want to create a fiule and write on it I got
> the inode of file then what fields I will send to the xfs getbmap
> (called via xfs_ioc_getbmapx ) ,

Please see the "XFS_IOC_GETBMAP" section in the xfsctl(3) man page.

-Eric

> -          What fields of getbmapx structure will be initialized  before
> passing in the xfs_ioc_getbmapx ?
> 
> -          What it will do after passing the fields (Function overview
> if possible)
> 
> -          Why the arg+1 is being passed in the xfs_ioc_getbmapx
> 
> I know the reason of formatter
> 
>  
> 
> Xfs_ioc_getbmapx(arguments)
> 
> {
> 
>  
> 
>         Xfs_getbmap();
> 
>         Copy_to_user() ; // why the copying done here as in the function
> itself for every entry it is copying the information into user buffer
> then why outside the function call here it needs the copy again
> 
> }
> 
>  
> 
> Thanks & Best Regards
> 
> Anshul Kundra
> 
> 
> ------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
