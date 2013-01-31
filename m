Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36D6F7F4E
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 20:11:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 11C9E304059
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 18:11:26 -0800 (PST)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [119.145.14.65])
	by cuda.sgi.com with ESMTP id FgOywGMS5TUHRFID for
	<xfs@oss.sgi.com>; Wed, 30 Jan 2013 18:11:22 -0800 (PST)
Message-ID: <5109D289.1050708@huawei.com>
Date: Thu, 31 Jan 2013 10:10:17 +0800
From: Li Zefan <lizefan@huawei.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/4 v2] Fix possible use after free with AIO
References: <1359502081-20240-1-git-send-email-jack@suse.cz>
	<20130130144535.GK4503@ZenIV.linux.org.uk>
In-Reply-To: <20130130144535.GK4503@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On 2013/1/30 22:45, Al Viro wrote:
> On Wed, Jan 30, 2013 at 12:27:57AM +0100, Jan Kara wrote:
>>
>>   Hi,
>>
>>   since nobody seem to have picked up any of the patches (at least
>> nobody told me so), I've added acks I received to the patches and I'm
>> sending them to Al for merging. Al, can you please merge these? Thanks.
> 
> VFS part (4/4) picked; IMO at least ext* and xfs should go through the
> filesystem trees.  If ocfs2 folks don't pick fs/ocfs2 part, I'll grab
> it as well - not sure how active their tree is these days...

I would say just grab it.

We've been sending bug fixes to ocfs2 mailing list since Aug 2012, but none
was pushed into upstream.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
