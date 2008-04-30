Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 08:55:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3UFt2bp031669
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 08:55:11 -0700
Received: from tetsuo.zabbo.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C8251604E7E
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 08:55:46 -0700 (PDT)
Received: from tetsuo.zabbo.net (tetsuo.zabbo.net [207.173.201.20]) by cuda.sgi.com with ESMTP id nkXfu28txKzberKg for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 08:55:46 -0700 (PDT)
Message-ID: <48189681.5080504@oracle.com>
Date: Wed, 30 Apr 2008 08:55:45 -0700
From: Zach Brown <zach.brown@oracle.com>
MIME-Version: 1.0
Subject: Re: correct use of vmtruncate()?
References: <20080429100601.GO108924158@sgi.com> <481756A3.20601@oracle.com> <20080430072457.GB7791@skywalker>
In-Reply-To: <20080430072457.GB7791@skywalker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Chinner <dgc@sgi.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, xfs-oss <xfs@oss.sgi.com>


>> This paragraph in particular reminds me of an outstanding bug with
>> O_DIRECT and ext*.  It isn't truncating partial allocations when a dio
>> fails with ENOSPC.  This was noticed by a user who saw that fsck found
>> bocks outside i_size in the file that saw ENOSPC if they tried to
>> unmount and check the volume after the failed write.
> 
> This patch should be the fix I guess
> 	http://lkml.org/lkml/2006/12/18/103

That's the thread related to the bug, yes, but that isn't the right fix
as David's later messages in the thread indicate.

- z
