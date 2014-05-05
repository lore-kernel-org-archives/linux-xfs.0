Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7EBB47F7E
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 08:24:34 -0500 (CDT)
Message-ID: <53679113.8000209@sgi.com>
Date: Mon, 05 May 2014 08:24:35 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: attr cleanups
References: <1399130415-5382-1-git-send-email-hch@lst.de>
	<53651375.9080305@sgi.com> <20140504101623.GA4947@lst.de>
In-Reply-To: <20140504101623.GA4947@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On 05/04/14 05:16, Christoph Hellwig wrote:
> On Sat, May 03, 2014 at 11:04:05AM -0500, Mark Tinguely wrote:
>> Depends on how parent inode pointers are implemented, this folding the
>> internal version of get and set attributes could be undone.
>
> We might have to introduce _locked version at that point.  But I'd like
> to keep the xfs_name removal and other assorted cleanups.
>

locking is only one issue, xfs_attr_(get/set/remove) are asciii only 
whereas the xfs_attr_(get/set/remove)_int versions are more generic. I 
am thinking of not just parent inode pointers but a non-ascii character set.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
