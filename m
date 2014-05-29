Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC24229DFE
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 20:45:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B8F178F806F
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 18:45:56 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id cS7mHpFtiXsASuy0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 May 2014 18:45:52 -0700 (PDT)
Message-ID: <53869169.5070203@oracle.com>
Date: Thu, 29 May 2014 09:46:17 +0800
From: Junxiao Bi <junxiao.bi@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: xfs_copy: fix data corruption of target
References: <1401247687-6444-1-git-send-email-junxiao.bi@oracle.com>
	<20140528053241.GC3816@infradead.org>
In-Reply-To: <20140528053241.GC3816@infradead.org>
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
Cc: joe.jin@oracle.com, xfs@oss.sgi.com

On 05/28/2014 01:32 PM, Christoph Hellwig wrote:
> On Wed, May 28, 2014 at 11:28:07AM +0800, Junxiao Bi wrote:
>> The unit of XFS_AGFL_DADDR(mp) is "basic block" whose size is "BBSIZE"
>> (512 bytes), so when "source_sectorsize" is not 512, it will cause the
>> target a corrupted filesystem.
>>
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Looks good.  Any chance you could create a testcase for this as well?
I will try. Thank you for review it.

Thanks,
Junxiao.
>
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
