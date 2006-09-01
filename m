Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 Aug 2006 21:12:18 -0700 (PDT)
Received: from over.ny.us.ibm.com (over.ny.us.ibm.com [32.97.182.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k814BrDW002022
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 21:11:56 -0700
Received: from e33.co.us.ibm.com ([9.17.249.43])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k813hmoW010094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 23:43:49 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k813hhdm020930
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 23:43:43 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k813hhjt290610
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 21:43:43 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k813hgee019628
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 21:43:42 -0600
Message-ID: <44F7AC65.5050502@cn.ibm.com>
Date: Fri, 01 Sep 2006 11:43:33 +0800
From: Yao Fei Zhu <walkinair@cn.ibm.com>
Reply-To: walkinair@cn.ibm.com
MIME-Version: 1.0
Subject: Re: kernel BUG in __xfs_get_blocks at fs/xfs/linux-2.6/xfs_aops.c:1293!
References: <44F67847.6030307@cn.ibm.com>	<20060831074742.GD807830@melbourne.sgi.com>	<44F6979C.4070309@cn.ibm.com>	<20060831081726.GV5737019@melbourne.sgi.com> <20060831015430.6df0d8ba.akpm@osdl.org>
In-Reply-To: <20060831015430.6df0d8ba.akpm@osdl.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@osdl.org>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, haveblue@us.ibm.com, xfs@oss.sgi.com

Andrew Morton wrote:

>On Thu, 31 Aug 2006 18:17:26 +1000
>David Chinner <dgc@sgi.com> wrote:
>
>  
>
>>>BTW, I have CONFIG_PPC_64K_PAGES enabled.
>>>      
>>>
>>But that might be a good place to start. Can you see if you can
>>reproduce the problem without this config option set?
>>    
>>
>
>It would be useful to compare the compiler warning output for 64k pages
>versus that for smaller-pages.  
>
>Several quite worrisome-looking warnings are emitted from various parts of
>the kernel with 64k pages.  Related to arithmetic on short types.
>  
>
1. the config diff
blade10:/boot # diff config-2.6.18-rc5-ppc64 config-2.6.18-rc5-ppc64.64kp
4c4
< # Thu Aug 31 18:25:42 2006
---
 > # Thu Aug 31 21:18:52 2006
51c51
< CONFIG_LOCALVERSION="-ppc64"
---
 > CONFIG_LOCALVERSION="-ppc64.64kp"
173c173
< CONFIG_FORCE_MAX_ZONEORDER=13
---
 > CONFIG_FORCE_MAX_ZONEORDER=9
204c204
< # CONFIG_PPC_64K_PAGES is not set
---
 > CONFIG_PPC_64K_PAGES=y

2. the compiler warning diff
ltctest:~ # diff 4k.warning 64k.warning
0a1,5
 > kernel/power/pm.c:205: warning: ‘pm_register’ is deprecated 
(declared at kernel/power/pm.c:64)
 > kernel/power/pm.c:205: warning: ‘pm_register’ is deprecated 
(declared at kernel/power/pm.c:64)
 > kernel/power/pm.c:206: warning: ‘pm_send_all’ is deprecated 
(declared at kernel/power/pm.c:180)
 > kernel/power/pm.c:206: warning: ‘pm_send_all’ is deprecated 
(declared at kernel/power/pm.c:180)
 > fs/bio.c:169: warning: ‘idx’ may be used uninitialized in this 
function
8,13d12
< fs/bio.c:169: warning: ‘idx’ may be used uninitialized in this 
function
< kernel/power/pm.c:205: warning: ‘pm_register’ is deprecated 
(declared at kernel/power/pm.c:64)
< kernel/power/pm.c:205: warning: ‘pm_register’ is deprecated 
(declared at kernel/power/pm.c:64)
< kernel/power/pm.c:206: warning: ‘pm_send_all’ is deprecated 
(declared at kernel/power/pm.c:180)
< kernel/power/pm.c:206: warning: ‘pm_send_all’ is deprecated 
(declared at kernel/power/pm.c:180)
< fs/eventpoll.c:500: warning: ‘fd’ may be used uninitialized in 
this function
17a17,27
 > fs/eventpoll.c:500: warning: ‘fd’ may be used uninitialized in 
this function
 > fs/fat/inode.c:1227: warning: comparison is always false due to 
limited range of data type
 > fs/hfs/btree.c:243: warning: comparison is always false due to 
limited range of data type
 > fs/hfsplus/btree.c:235: warning: comparison is always false due to 
limited range of data type
 > fs/ocfs2/vote.c:774: warning: ‘response’ may be used 
uninitialized in this function
 > fs/ocfs2/dlm/dlmdomain.c:70: warning: format ‘%lu’ expects type 
‘long unsigned int’, but argument 7 has type ‘int’
 > fs/ocfs2/dlm/dlmdomain.c:70: warning: format ‘%lu’ expects type 
‘long unsigned int’, but argument 7 has type ‘int’
 > fs/ocfs2/dlm/dlmdomain.c:70: warning: format ‘%lu’ expects type 
‘long unsigned int’, but argument 7 has type ‘int’
 > fs/ocfs2/dlm/dlmdomain.c:918: warning: ‘response’ may be used 
uninitialized in this function
 > fs/udf/balloc.c:751: warning: ‘goal_eloc.logicalBlockNum’ may be 
used uninitialized in this function
 > fs/udf/super.c:1364: warning: ‘ino.partitionReferenceNum’ may be 
used uninitialized in this function
56a67,68
 > drivers/usb/core/devio.c:620: warning: comparison is always false due 
to limited range of data type
 > drivers/net/r8169.c:2131: warning: ‘txd’ may be used 
uninitialized in this function
59d70
< drivers/net/r8169.c:2131: warning: ‘txd’ may be used uninitialized 
in this function
70,73c81
< fs/ocfs2/vote.c:774: warning: ‘response’ may be used uninitialized 
in this function
< fs/ocfs2/dlm/dlmdomain.c:918: warning: ‘response’ may be used 
uninitialized in this function
< fs/udf/balloc.c:751: warning: ‘goal_eloc.logicalBlockNum’ may be 
used uninitialized in this function
< fs/udf/super.c:1364: warning: ‘ino.partitionReferenceNum’ may be 
used uninitialized in this function
---
 > net/key/af_key.c:403: warning: comparison is always false due to 
limited range of data type
