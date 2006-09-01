Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 Aug 2006 23:35:43 -0700 (PDT)
Received: from e1.ny.us.ibm.com (e1.ny.us.ibm.com [32.97.182.141])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k816ZODW019835
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 23:35:25 -0700
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k816YnTh016318
	for <xfs@oss.sgi.com>; Fri, 1 Sep 2006 02:34:49 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k816YlCZ273914
	for <xfs@oss.sgi.com>; Fri, 1 Sep 2006 02:34:49 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k816Ylhp025402
	for <xfs@oss.sgi.com>; Fri, 1 Sep 2006 02:34:47 -0400
Message-ID: <44F7D47E.7020906@cn.ibm.com>
Date: Fri, 01 Sep 2006 14:34:38 +0800
From: Yao Fei Zhu <walkinair@cn.ibm.com>
Reply-To: walkinair@cn.ibm.com
MIME-Version: 1.0
Subject: Re: kernel BUG in __xfs_get_blocks at fs/xfs/linux-2.6/xfs_aops.c:1293!
References: <44F67847.6030307@cn.ibm.com> <20060831074742.GD807830@melbourne.sgi.com> <44F6979C.4070309@cn.ibm.com> <20060831081726.GV5737019@melbourne.sgi.com>
In-Reply-To: <20060831081726.GV5737019@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

David Chinner wrote:

>But that might be a good place to start. Can you see if you can
>reproduce the problem without this config option set?
>  
>
No, I can't reproduce this prlblem without the CONFIG_PPC_64K_PAGES
config option set, the fsstress testcase works fine.
