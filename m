Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Feb 2008 00:40:06 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M8e0ZS004334
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 00:40:02 -0800
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E19D694E63
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 00:40:26 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158]) by cuda.sgi.com with ESMTP id UkW55Svu4vRfrUnO for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 00:40:26 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id e12so250296fga.8
        for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 00:40:25 -0800 (PST)
Message-ID: <47BE8A76.5080603@gmail.com>
Date: Fri, 22 Feb 2008 10:40:22 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
MIME-Version: 1.0
Subject: Re: Marking inode dirty latency > 1000 msec on XFS!
References: <47B5DD9C.3080906@gmail.com> <47BE6C5C.2000605@sgi.com> <20080222071608.GT155407@sgi.com>
In-Reply-To: <20080222071608.GT155407@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, Arjan van de Ven <arjan@linux.intel.com>, xfs@oss.sgi.com

David Chinner wrote:
> On Fri, Feb 22, 2008 at 05:31:56PM +1100, Lachlan McIlroy wrote:
>   
>> Török Edwin wrote:
>>     
>>> FWIW, this is a slow laptop hdd (5400 rpm, ST96812AS), but latency of 1
>>> second is still big.
>>>
>>> Are there any settings I can tweak to reduce latency?
>>>       
>> Um, not that I am aware of.
>>     
>
> Try using a filesystem that has lazy-count enabled.

How do I activate lazy-count on an already existing filesystem?
I tried using xfs_db, but AFAICT it cannot activate features2 flags.
I am using 2.9.6-1, should I checkout xfsprogs from CVS?

Thanks,
--Edwin
