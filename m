Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAS2oWHA125370 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 20:50:32 -0600
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VPTUGzrkeMTzwEFY for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 18:52:48 -0800 (PST)
Message-ID: <50B57C7E.40002@sandeen.net>
Date: Tue, 27 Nov 2012 20:52:46 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/3] Print when ENOSPC due to lack of inodes.
References: <cover.1348639531.git.rprabhu@wnohang.net>
	<CAEtq3tN20oZ6NjT37tXo8XYW=N=AFTdsZxWTuD681RPbQeS_iw@mail.gmail.com>
In-Reply-To: <CAEtq3tN20oZ6NjT37tXo8XYW=N=AFTdsZxWTuD681RPbQeS_iw@mail.gmail.com>
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
To: Raghavendra Prabhu <raghu.prabhu13@gmail.com>
Cc: xfs@oss.sgi.com

On 10/24/12 3:56 PM, Raghavendra Prabhu wrote:
> Hi,
> 
> Checking back on this, whether it has been reviewed and if so, any comments.

Please see Dave's comments down-thread, there are apparently still
some unaddressed concerns.  If you'd like to do a V4 I think this
would be nice to get in.

-Eric

> On Wed, Sep 26, 2012 at 12:26 PM,  <raghu.prabhu13@gmail.com> wrote:
>> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
>>
>> Currently, when there are no free inodes left / free space to allocate them (usually
>> without inode64), there is no indication anywhere of this case, making it harder
>> to diagnose this case.
>>
>> Hence, this series prints the causes/reasons to kernel log in a ratelimited
>> manner, when such a situation arises.
>>
>> Regarding why it is printed at callee location instead at caller, it gives
>> greater granularity in expressing the precise reason and give more details, and
>> also some along the path are not ENOSPC (such in xfs_ialloc where ialloc_context is not NULL but
>> ino is) along with the fact that it (xfs_ialloc) is called at multiple sites, so to avoid duplication.
>>
>> Version 1: Initial series.
>> Version 2: Added ratelimited printing to xfs_message and used that.
>> Version 3: Kept the logic intact in few places, fixed the column requirement.
>>
>> Raghavendra D Prabhu (3):
>>   xfs: Add ratelimited printk for different alert levels
>>   xfs: Print error when xfs_ialloc_ag_select fails to find continuous
>>     free space.
>>   xfs: Print error when unable to allocate inodes or out of free
>>     inodes.
>>
>>  fs/xfs/xfs_ialloc.c  | 31 ++++++++++++++++++++++++++++---
>>  fs/xfs/xfs_linux.h   |  1 +
>>  fs/xfs/xfs_message.h | 26 ++++++++++++++++++++++++++
>>  3 files changed, 55 insertions(+), 3 deletions(-)
>>
>> --
>> 1.7.12.1
>>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
