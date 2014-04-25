Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7BBA97F52
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 02:14:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 06665AC006
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 00:14:43 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id vEXiN6l2KmAHW9Pk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 Apr 2014 00:14:42 -0700 (PDT)
Message-ID: <535A0B46.9040203@oracle.com>
Date: Fri, 25 Apr 2014 15:14:14 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 04/10] xfs: introduce per allocation group inumbers
References: <535078B5.4010700@oracle.com>
	<20140425064333.GA20871@infradead.org>
In-Reply-To: <20140425064333.GA20871@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On 04/25 2014 14:43 PM, Christoph Hellwig wrote:
> On Fri, Apr 18, 2014 at 08:58:29AM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Introduce xfs_perag_inumbers(), it could be used to fetch the inode number
>> tables per allocation group via a new ioctl(2) in the future.  Also, that
>> would be a net win considering the scalability for a file system with huge
>> number of inodes as multiple allocation groups can be scanned in parallel,
>> refactor xfs_inumbers() with it.
> 
> Given that you don't actually introduce a per-ag inumbers interface in
> this series I'd prefer if you just refactor the inumbers code to
> add a helper that operates on an AG with xfs_inumbers moving on to
> the next one, but not adding the xfs_aginumbers structure that just
> makes the move less obvious for now. 

Fair enough, I'll take care of it.


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
