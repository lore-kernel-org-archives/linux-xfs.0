Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 887D57CB6
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 16:18:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5CC70304032
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 14:18:16 -0800 (PST)
Received: from mail-yk0-f173.google.com (mail-yk0-f173.google.com
	[209.85.160.173]) by cuda.sgi.com with ESMTP id
	TNu5gSeISkOhQ5uz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 14:18:14 -0800 (PST)
Received: by mail-yk0-f173.google.com with SMTP id z7so13189864yka.3
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 14:18:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160217215420.GK14140@quack.suse.cz>
References: <1455680059-20126-1-git-send-email-ross.zwisler@linux.intel.com>
	<1455680059-20126-7-git-send-email-ross.zwisler@linux.intel.com>
	<20160217215420.GK14140@quack.suse.cz>
Date: Wed, 17 Feb 2016 14:18:13 -0800
Message-ID: <CAPcyv4g3iCL1q7FoeTwKvtqo2mLfA=mfi1K5PdmZVjU+PA-gOA@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] block: use dax_do_io() if blkdev_dax_capable()
From: Dan Williams <dan.j.williams@intel.com>
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
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@poochiereds.net>, Jens Axboe <axboe@fb.com>, Theodore Ts'o <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-block@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Wed, Feb 17, 2016 at 1:54 PM, Jan Kara <jack@suse.cz> wrote:
> On Tue 16-02-16 20:34:19, Ross Zwisler wrote:
>> From: Dan Williams <dan.j.williams@intel.com>
>>
>> Setting S_DAX on an inode requires that the inode participate in the
>> DAX-fsync mechanism which expects to use the pagecache for tracking
>> potentially dirty cpu cachelines.  However, dax_do_io() participates in
>> the standard pagecache sync semantics and arranges for dirty pages to be
>> flushed through the driver when a direct-IO operation accesses the same
>> ranges.
>>
>> It should always be valid to use the dax_do_io() path regardless of
>> whether the block_device inode has S_DAX set.  In either case dirty
>> pages or dirty cachelines are made durable before the direct-IO
>> operation proceeds.
>
> Please no. I agree that going via DAX path for normal likely won't
> introduce new data corruption issues. But I dislike having a special
> case for block devices. Also you have no way of turning DAX off for block
> devices AFAIU and as Dave said, DAX should be opt-in, not opt-out. Note
> that you may actually want to go through the block layer for normal IO e.g.
> because you use IO cgroups to limit processes so using DAX regresses some
> functionality.
>

Sounds good.

As Ross mentioned in the cover letter, I'm fine with dropping this one
for now as we think through how to restore raw device DAX support.  In
the meantime we can still force CONFIG_BLK_DEV_DAX=y for testing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
