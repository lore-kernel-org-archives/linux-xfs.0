Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 108F07FB7
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 23:08:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D2478304077
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 21:08:11 -0700 (PDT)
Received: from mail-vc0-f179.google.com (mail-vc0-f179.google.com
	[209.85.220.179]) by cuda.sgi.com with ESMTP id
	rNTXWkUAyalYjrga (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 Aug 2013 21:08:10 -0700 (PDT)
Received: by mail-vc0-f179.google.com with SMTP id ht10so3515592vcb.24
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 21:08:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130820033329.GG6023@dastard>
References: <cover.1376679411.git.luto@amacapital.net>
	<a27accc2d9460b7ef194a203f305a18dafe926e8.1376679411.git.luto@amacapital.net>
	<20130820022822.GD6023@dastard>
	<CALCETrVE2G4x9mL0-o1FDQPfc=qZzw10Cx6AgOdhwphSaCmyzw@mail.gmail.com>
	<20130820033329.GG6023@dastard>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 19 Aug 2013 21:07:49 -0700
Message-ID: <CALCETrVrSiXCt5+2801C+QA6B1jzb0K3VHT6w8sVf_VXrz16Bw@mail.gmail.com>
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

On Mon, Aug 19, 2013 at 8:33 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Aug 19, 2013 at 08:20:12PM -0700, Andy Lutomirski wrote:
>> On Mon, Aug 19, 2013 at 7:28 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Fri, Aug 16, 2013 at 04:22:09PM -0700, Andy Lutomirski wrote:
>> >> This is like file_update_time, except that it acts on a struct inode *
>> >> instead of a struct file *.
>> >>
>> >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> >> ---
>> >>  fs/inode.c         | 72 ++++++++++++++++++++++++++++++++++++++++++------------
>> >>  include/linux/fs.h |  1 +
>> >>  2 files changed, 58 insertions(+), 15 deletions(-)
>> >>
>>
>> [...]
>>
>> >> +
>> >> +int inode_update_time_writable(struct inode *inode)
>> >> +{
>> >> +     struct timespec now;
>> >> +     int sync_it = prepare_update_cmtime(inode, &now);
>> >> +     int ret;
>> >> +
>> >> +     if (!sync_it)
>> >> +             return 0;
>> >> +
>> >> +     /* sb_start_pagefault and update_time can both sleep. */
>> >> +     sb_start_pagefault(inode->i_sb);
>> >> +     ret = update_time(inode, &now, sync_it);
>> >> +     sb_end_pagefault(inode->i_sb);
>> >
>> > This gets called from the writeback path - you can't use
>> > sb_start_pagefault/sb_end_pagefault in that path.
>>
>> The race I'm worried about is:
>>
>>  - mmap
>>  - write to the mapping
>>  - remount ro
>>  - flush_cmtime -> inode_update_time_writable
>
> sb_start_pagefault() is for filesystem freeze protection, not
> remount-ro protection. If you freeze the filesystem, then we stop
> writes and pagefaults by making sb_start_pagefault/sb_start_write
> block, and then run writeback to clean all the pages.  If writeback
> then blocks on sb_start_pagefault(), we've got a deadlock.
>
>> This may be impossible, in which case I'm okay, but it's nice to have
>> a sanity check.  I'll see if I can figure out how to do that.
>
> The process of remount-ro should flush the dirty pages - the inode
> and page has been marked dirty by page_mkwrite(), after all.

Hmm.  We can land in here from writeback, in which case the time
should be updated unconditionally.  We can also land in here from
msync(MS_ASYNC) or munmap.  munmap at least shouldn't block.

The nasty case is if a page is dirtied, then the frozen level is set
to SB_FREEZE_PAGEFAULT, and then userspace calls munmap or msync
*before* writepages gets called.  In this case, blocking until the fs
is unfrozen is probably impolite, and returning without updating the
time is questionable.

Removing the check entirely may add a new race, though: what if
.flush_cmtime has called mapping_test_clear_cmtime but hasn't gotten
to updating the time yet when freezing finishes?  This could be
prevented by changing generic_flush_cmtime to do __sb_start_write(sb,
SB_FREEZE_FS, false) and doing nothing if the fs is already frozen.

--Andy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
