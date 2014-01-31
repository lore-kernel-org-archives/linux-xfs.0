Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 31E877F62
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 02:55:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 041958F8050
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 00:54:59 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 2GJbx7rPD2PX934Y (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 31 Jan 2014 00:54:59 -0800 (PST)
Message-ID: <52EB64DC.4020603@oracle.com>
Date: Fri, 31 Jan 2014 16:54:52 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: Extended attributes limit in Linux
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>
In-Reply-To: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Sun_Blood <sblood@gmail.com>, xfs@oss.sgi.com

Hello,

On 01/31 2014 15:40 PM, Sun_Blood wrote:
> Hello,
> 
> If I understands it correctly XFS don't have a limit to the size of
> extended attributes(EA) but Linux impose a limit at 64k.
> What I am trying to do is build a backup server that our Apple computers
> will use together with rsync to backup files to. The problem I face is
> that Apple HFS+ don't have a limit to EA so it has files with more then
> 64k of EA in it.
> 
> The Linux Kernel has a limit imposed to it in include/linux/limits.h
> 
>     #defineXATTR_SIZE_MAX 65536   /* size of an extended attribute value
>     (64k) */
> 
>     #defineXATTR_LIST_MAX 65536   /* size of extended attribute namelist
>     (64k) */
> 

Yes, 64k is the VFS limit per EA value size.
> Changing this values feels unsafe because they will be system wide.
> 
> Is the any possibility to combine Linux + XFS to make a backup that
> works with EA or is this more a question for kernel.org <http://kernel.org>?

So if an EA value size on HFS+ is larger than 64k, I suspect it would failed to preserve
on Linux+XFS... But if a file has multiple EAs, and each EA's value size is <= 64K, it
would be works IMO.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
