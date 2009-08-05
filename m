Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n754EfRD214768 for <xfs@oss.sgi.com>; Tue, 4 Aug 2009 23:14:41 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C3DB1454A90
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2009 21:15:31 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 1dDZtJSLgUgeA6sV for
	<xfs@oss.sgi.com>; Tue, 04 Aug 2009 21:15:31 -0700 (PDT)
Message-ID: <4A790762.3010207@sandeen.net>
Date: Tue, 04 Aug 2009 23:15:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] XFS: xfs_iformat realtime device target pointer check
References: <1249329808.7686.26.camel@logos>	
	<20090803214929.GB3167@infradead.org>
	<1249351241.7513.18.camel@logos>	 <4A786110.8090404@sandeen.net>
	<1249411898.7576.19.camel@logos>	
	<4A7887CE.2060300@sandeen.net> <1249444550.7372.23.camel@logos>
In-Reply-To: <1249444550.7372.23.camel@logos>
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
To: Ramon de Carvalho Valle <ramon@risesecurity.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, mszeredi@novell.com, hch@lst.de, xfs@oss.sgi.com

Ramon de Carvalho Valle wrote:
> On Tue, 2009-08-04 at 14:11 -0500, Eric Sandeen wrote:
>> Ramon de Carvalho Valle wrote:
>>> The xfs_iformat function does not check if the realtime device target pointer
>>> is valid when the XFS_DIFLAG_REALTIME flag is set on the ondisk inode
>>> structure.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@infradead.org>
>>> Signed-off-by: Ramon de Carvalho Valle <ramon@risesecurity.org>
>>> Cc: stable <stable@kernel.org>
>>> ---
>>>  fs/xfs/xfs_inode.c |   23 +++++++++++++++++------
>>>  1 files changed, 17 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>>> index 1f22d65..37d3ee5 100644
>>> --- a/fs/xfs/xfs_inode.c
>>> +++ b/fs/xfs/xfs_inode.c
>>> @@ -343,13 +343,24 @@ xfs_iformat(
>>>  		return XFS_ERROR(EFSCORRUPTED);
>>>  	}
>>>  
>>> +	if (unlikely((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) &&
>>> +			!ip->i_mount->m_rtdev_targp)) {
>>> +		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
>>> +			"corrupt dinode %Lu, flags = 0x%x.",
>>> +			(unsigned long long)ip->i_ino,
>>> +			ip->i_d.di_flags);
>>> +		XFS_CORRUPTION_ERROR("xfs_iformat(3)", XFS_ERRLEVEL_LOW,
>>> +				     ip->i_mount, dip);
>> I think I'd rather not change all the corruption text tag ordering;
>> it'll make it harder to track down any common occurrences of
>> "xfs_iformat(X)" corruption in the future if they get renumbered now.
>>
>> I'd either make this xfs_iformat(2.1) ;) or just leave it as Christoph
>> had.  "realtime" is a lot more informative than "3" anyway.
> 
> I don't think this is a bad decision, because the corruption errors can
> be easily identified by the output of xfs_fs_repair_cmn_err and the
> source line. I think this is a reasonable change that will keep the code
> clean and consistent.

Until you wind up looking at a problem from some old kernel, or modified
vendor kernel, and you realize that now you really don't know which
error "xfs_iformat(6)" is anymore, and you either have to go digging
through trees that aren't handy, or you just give up and don't bother to
help because now it's too much of a pain.  ;)

But I can leave it up to the folks @ sgi, I can see both sides of the
argument, and I won't care too much either way.

Thanks,
-Eric

> -Ramon
> 
>> -Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
