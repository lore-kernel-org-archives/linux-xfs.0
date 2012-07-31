Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6V0fnCT113391 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 19:41:49 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id 5Sa9pvx3E7xrJEq7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Jul 2012 17:41:48 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so13200136pbb.26
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 17:41:47 -0700 (PDT)
Date: Tue, 31 Jul 2012 08:42:57 +0800
From: majianpeng <majianpeng@gmail.com>
Subject: Re: Re: [PATCH 0/8] Set bi_rw when alloc bio before call bio_add_page.
References: <201207301514247032532@gmail.com>,
	<20120730153935.GE4547@phenom.dumpdata.com>
Mime-Version: 1.0
Message-ID: <201207310842549068542@gmail.com>
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
To: "konrad.wilk" <konrad.wilk@oracle.com>
Cc: axboe <axboe@kernel.dk>, shaggy <shaggy@kernel.org>, "chris.mason" <chris.mason@fusionio.com>, elder <elder@kernel.org>, tytso <tytso@mit.edu>, ocfs2-devel <ocfs2-devel@oss.oracle.com>, mfasheh <mfasheh@suse.com>, linux-kernel <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>, bpm <bpm@sgi.com>, "adilger.kernel" <adilger.kernel@dilger.ca>, viro <viro@ZenIV.linux.org.uk>, jfs-discussion <jfs-discussion@lists.sourceforge.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, jlbec <jlbec@evilplan.org>

On 2012-07-30 23:39 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> Wrote:
>On Mon, Jul 30, 2012 at 03:14:28PM +0800, majianpeng wrote:
>> When exec bio_alloc, the bi_rw is zero.But after calling bio_add_page,
>
>What about submit_bio? That sets the bi_rw as well?
>> it will use bi_rw.
>> Fox example, in functiion __bio_add_page,it will call merge_bvec_fn().
>
>function.
>> The merge_bvec_fn of raid456 will use the bi_rw to judge the merge.
>> >> if ((bvm->bi_rw & 1) == WRITE)
>> >> return biovec->bv_len; /* always allow writes to be mergeable */
>
>So what does that mean? Without this patch what happens?
>
Because bio_alloc, the bi_rw is zero default.But in __bio_add_page, it used bi_rw.
For example: if merge_bvce_fn used bi_rw, but the bi_rw is wrong(if bi_rw is not zero).
So the result may be error.
>> 
>> 
>> Jianpeng Ma (8):
>
>Can you collapse all of this in just one patch?
Sorry, I think those files are not a subsystem.So i should send separately.
>
>>   Evalue bio->bi_rw after calling bio_alloc() and before calling
>
>It is 'evaluate'
>>     bio_add_page().
>>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>>     bio_add_page().
>>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>>     bio_add_page().
>>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>>     bio_add_page().
>>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>>     bio_add_page().
>>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>>     bio_add_page().
>>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>>     bio_add_page().
>>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>>     bio_add_page().
>> 
>>  block/blk-lib.c                     |    1 +
>>  drivers/block/xen-blkback/blkback.c |    1 +
>
>I am not really sure if that is correct. Does 'submit_bio' not do the
>job properly?
Before call submit_bio, it call bio_add_page.
>
>>  fs/btrfs/check-integrity.c          |    1 +
>>  fs/direct-io.c                      |    1 +
>>  fs/ext4/page-io.c                   |    1 +
>>  fs/jfs/jfs_metapage.c               |    1 +
>>  fs/ocfs2/cluster/heartbeat.c        |    8 +++++---
>>  fs/xfs/xfs_aops.c                   |    2 ++
>>  fs/xfs/xfs_buf.c                    |    1 +
>>  9 files changed, 14 insertions(+), 3 deletions(-)
>> 
>> -- 
>> 1.7.9.5
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
