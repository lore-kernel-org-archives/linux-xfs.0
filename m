Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9A157F52
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 08:18:13 -0500 (CDT)
Message-ID: <535A6093.8060005@sgi.com>
Date: Fri, 25 Apr 2014 08:18:11 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC] libxfs: adding attribute fork frees xfs_inode ptr
References: <20140423210034.892939354@sgi.com>
	<20140423210445.700477624@sgi.com>
	<20140423222215.GT18672@dastard> <535945DC.6010108@sgi.com>
	<53597B34.9050407@sgi.com> <20140425054021.GA16132@infradead.org>
In-Reply-To: <20140425054021.GA16132@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On 04/25/14 00:40, Christoph Hellwig wrote:
> On Thu, Apr 24, 2014 at 03:59:32PM -0500, Mark Tinguely wrote:
>> PS. I may not have been very clear, the libxfs_trans_roll() and
>>      inode_item_done() also cause a premature libxfs_iput().
>>      Let me do more testing making any changes and target this for
>>      xfsprogs-3.2.1.
>
> You mean you've fixed the way we handle the attachement of inodes to
> transaction in userspace to mirror what we do in kernelspace?  I'd love
> to review this if you have patches as it's a somewhat of a pain point
> to have these work so different in kernel and userspace.
>

Not yet, I made the changes within the existing code so I can continue 
with my project. I agree, the user inode transaction code has to be 
synced with the kernel. I will start looking at it this weekend.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
