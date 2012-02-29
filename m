Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1TAMwEh004663 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 04:22:58 -0600
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id 2ANgcDrjo4pbxEKo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Feb 2012 02:22:57 -0800 (PST)
Message-ID: <4F4DD203.5090705@oracle.com>
Date: Wed, 29 Feb 2012 15:21:39 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: Question about project quota with container
References: <4F4D8413.4050709@oracle.com>
	<20120229083633.GA14241@infradead.org>
In-Reply-To: <20120229083633.GA14241@infradead.org>
Reply-To: jeff.liu@oracle.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hi Christoph,

Thanks for you prompt response!

On 02/29/2012 04:36 PM, Christoph Hellwig wrote:

>> I was wondering if other file system will also implement project quota
>> based on these two configuration files in the future? In other words, is
>> it a standard?
> 
> The have been a few attempts at roughly similar quotas for ext4, but
> they were incompatible enough to not reuse any infrastructure like this.

> 
>>
>> Alternatively, maybe the project path and ID can be setup at cgroup
>> control files too, the following things could be implemented like
>> "xfsprogs/quota/edit.c", but I would put aside this idea for now.
> 
> Assigning the project IDs in the cgroups code sounds fine to me.

Ok, I'll try it first.

> To make peoples life's easier it might be good idea to keep the
> /etc/projects and /etc/projid files uptodate even from that code.

To update these two files at cgroup is also fine to me.

Thanks,
-Jeff

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
