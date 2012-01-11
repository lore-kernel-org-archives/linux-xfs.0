Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BJsk7s187443 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 13:54:46 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id RqlCYFiuhmvfCVuD for <xfs@oss.sgi.com>;
	Wed, 11 Jan 2012 11:54:44 -0800 (PST)
Message-ID: <4F0DE903.7000305@sandeen.net>
Date: Wed, 11 Jan 2012 13:54:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: query
References: <E6AD0DBC0AAAC1409E664C8543D529CB044E3BAB15@NDA-HCLT-EVS05.HCLT.CORP.HCL.IN>
In-Reply-To: <E6AD0DBC0AAAC1409E664C8543D529CB044E3BAB15@NDA-HCLT-EVS05.HCLT.CORP.HCL.IN>
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

On 1/11/12 9:51 AM, Anshul Kundra wrote:
> To Developers ,
> 
> I have read about the new member named as xfs_extdelta that is passed

Well, that "new" member was added in 2006 ;)

> in different xfs internal routines i.e xfs_bmapi , In the 2.4
> versions instead of using it is just passed as NULL can anyone
> provide info regarding that where to initialize and if I pass it NULl
> then is there any adverse effect of it
> 
> 
> 
> XFS_IOCORE_RT  not been used in 2.6 version , so if instead of this
> flag I will pass XFS_IOCORE_EXCL it will be ok or will cause any
> crash or adverse effects or either there is any alternative present
> to sought out from these two problems
> 

The 2.4 codebase was so long ago, I don't think you're going to be
able to make any direct translation from 2.6 code to 2.4.  Anyone
trying to maintain or modify 2.4-era xfs is going to be largely on
their own, I'm afraid, unless others have more time than I do to go
back and research this stuff...

-Eric

> 
> Regards
> 
> Anshul Kundra
> 
> HCL TECHNOLOGIES
> 
> ERS
> 
> 
> 
> 
> ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
--
>
> 
::DISCLAIMER::
> -----------------------------------------------------------------------------------------------------------------------
>
>  The contents of this e-mail and any attachment(s) are confidential
> and intended for the named recipient(s) only. It shall not attach any
> liability on the originator or HCL or its affiliates. Any views or
> opinions presented in this email are solely those of the author and
> may not necessarily reflect the opinions of HCL or its affiliates. 
> Any form of reproduction, dissemination, copying, disclosure,
> modification, distribution and / or publication of this message
> without the prior written consent of the author of this e-mail is
> strictly prohibited. If you have received this email in error please
> delete it and notify the sender immediately. Before opening any mail
> and attachments please check them for viruses and defect.
> 
> -----------------------------------------------------------------------------------------------------------------------
>
> 
> 
> _______________________________________________ xfs mailing list 
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
