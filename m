Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4975329DF8
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:01:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 391AE8F8065
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:01:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id wfo3er9SphqSANYY for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 12:01:28 -0800 (PST)
Message-ID: <52AA160C.7070109@sandeen.net>
Date: Thu, 12 Dec 2013 14:01:16 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_metadump: Make -F (force) optional
References: <52A9F6CF.1070300@redhat.com>
	<20131212183115.GA16378@infradead.org>
In-Reply-To: <20131212183115.GA16378@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 12/12/13, 12:31 PM, Christoph Hellwig wrote:
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
>> xfs_metadump will pass "-F" to xfs_db to carry on even in the face
>> of bad superblock magic. [1]  Depending on what we gave as an input
>> file, we may very well fail quite badly:
>>
>>> xfs_metadump: /root/anaconda.cfg is not a valid XFS filesystem (unexpected SB magic number 0x230a2320)
>>> Floating point exception
>>
>> I don't think it's possible to harden every path through libxfs for
>> non-xfs filesystems as input.  (Even if it's possible, I don't think it's
>> worth the effort).
> 
> Can you add a test to verify that xfs_metadump now correctly rejects
> files that don't have a valid superblock?

ok, can do.

Thanks Christoph,

-Eric

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
