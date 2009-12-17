Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBH2tp4K110639 for <xfs@oss.sgi.com>; Wed, 16 Dec 2009 20:55:51 -0600
Message-ID: <4B298FC0.8040709@oracle.com>
Date: Wed, 16 Dec 2009 17:56:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.33-rc1
References: <200912162126.nBGLQAbZ012632@stout.americas.sgi.com>
	<20091216135512.2675a0e3.randy.dunlap@oracle.com>
	<20091217002007.GF4850@discord.disaster>
In-Reply-To: <20091217002007.GF4850@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>

Dave Chinner wrote:
> On Wed, Dec 16, 2009 at 01:55:12PM -0800, Randy Dunlap wrote:
>> On Wed, 16 Dec 2009 15:26:10 -0600 Alex Elder wrote:
>>
>>> One more XFS update for -rc1, now that the new XFS tracing code has
>>> been committed.
>> Sorry if I have missed it, but have the printk format warnings
>> on i386 builds been fixed?
> 
> I don't see any here w/ gcc 4.3.4 x86-64 compiling i386 kernels....
> 
> /me hates gcc's warning inconsistencies with a passion.
> 
>> e.g.:
>>
>> In file included from linux-next-20091216/include/trace/ftrace.h:398,
>>                  from linux-next-20091216/include/trace/define_trace.h:69,
>>                  from linux-next-20091216/fs/xfs/linux-2.6/xfs_trace.h:1369,
>>                  from linux-next-20091216/fs/xfs/linux-2.6/xfs_trace.c:75:
>> linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_iomap_enter':
>> linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:830: warning: format '%llx' expects type 'long long unsigned int', but argument 12 has type 'xfs_fsblock_t'
> 
> Patch that should fix this below.

Yes, thanks for that.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
