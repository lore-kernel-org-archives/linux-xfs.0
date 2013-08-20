Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4254229E16
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 22:20:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AFE26AC002
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 20:20:33 -0700 (PDT)
Received: from mail-ve0-f175.google.com (mail-ve0-f175.google.com
	[209.85.128.175]) by cuda.sgi.com with ESMTP id
	4O4luQl2d0QM6aDF (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 Aug 2013 20:20:32 -0700 (PDT)
Received: by mail-ve0-f175.google.com with SMTP id oy10so3468325veb.20
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 20:20:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130820022822.GD6023@dastard>
References: <cover.1376679411.git.luto@amacapital.net>
	<a27accc2d9460b7ef194a203f305a18dafe926e8.1376679411.git.luto@amacapital.net>
	<20130820022822.GD6023@dastard>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 19 Aug 2013 20:20:12 -0700
Message-ID: <CALCETrVE2G4x9mL0-o1FDQPfc=qZzw10Cx6AgOdhwphSaCmyzw@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] fs: Add inode_update_time_writable
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>

On Mon, Aug 19, 2013 at 7:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Aug 16, 2013 at 04:22:09PM -0700, Andy Lutomirski wrote:
>> This is like file_update_time, except that it acts on a struct inode *
>> instead of a struct file *.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  fs/inode.c         | 72 ++++++++++++++++++++++++++++++++++++++++++------------
>>  include/linux/fs.h |  1 +
>>  2 files changed, 58 insertions(+), 15 deletions(-)
>>

[...]

>> +
>> +int inode_update_time_writable(struct inode *inode)
>> +{
>> +     struct timespec now;
>> +     int sync_it = prepare_update_cmtime(inode, &now);
>> +     int ret;
>> +
>> +     if (!sync_it)
>> +             return 0;
>> +
>> +     /* sb_start_pagefault and update_time can both sleep. */
>> +     sb_start_pagefault(inode->i_sb);
>> +     ret = update_time(inode, &now, sync_it);
>> +     sb_end_pagefault(inode->i_sb);
>
> This gets called from the writeback path - you can't use
> sb_start_pagefault/sb_end_pagefault in that path.

The race I'm worried about is:

 - mmap
 - write to the mapping
 - remount ro
 - flush_cmtime -> inode_update_time_writable

This may be impossible, in which case I'm okay, but it's nice to have
a sanity check.  I'll see if I can figure out how to do that.

--Andy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
