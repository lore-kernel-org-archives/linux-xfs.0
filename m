Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08I94xe061541 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 12:09:04 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [GIT PULL] XFS update for 2.6.33-rc1
Date: Fri, 8 Jan 2010 12:09:54 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6931@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100108094428.ff03c720.randy.dunlap@oracle.com>
From: "Alex Elder" <aelder@sgi.com>
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
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Randy Dunlap wrote:
> On Wed, 16 Dec 2009 21:41:12 -0600 Alex Elder wrote:
> 
>> Dave Chinner wrote:
>>> On Wed, Dec 16, 2009 at 01:55:12PM -0800, Randy Dunlap wrote:
>>>> On Wed, 16 Dec 2009 15:26:10 -0600 Alex Elder wrote:
>>>> 
>>>>> One more XFS update for -rc1, now that the new XFS tracing code has
>>>>> been committed.
>>>> 
>>>> Sorry if I have missed it, but have the printk format warnings
>>>> on i386 builds been fixed?
>>> 
>>> I don't see any here w/ gcc 4.3.4 x86-64 compiling i386 kernels....
>> 
>> I didn't get them either when I built in my environment.
>> 
>> Dave, your patch looks good to me, and Randy has acked it
>> so I'm going to pull it into our XFS top-of-tree.  I'll
>> hold off sending yet another pull request to Linus for
>> now.  Thanks for addressing it quickly.
>> 
>> 					-Alex
> 
> Hi Alex,
> Dave's patch is now needed in Linus's mainline kernel tree...

Yes, I noticed that.  I forgot I hadn't requested it get pulled.
Sorry.  Working on that today.

					-Alex


>>> /me hates gcc's warning inconsistencies with a passion.
>>> 
>>>> e.g.:
>>>> 
>>>> In file included from linux-next-20091216/include/trace/ftrace.h:398,
>>>>                  from linux-next-20091216/include/trace/define_trace.h:69,
>>>>                  from linux-next-20091216/fs/xfs/linux-2.6/xfs_trace.h:1369,
>>>>                  from linux-next-20091216/fs/xfs/linux-2.6/xfs_trace.c:75:
>>>> linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function
>>>> 'ftrace_raw_output_id_xfs_iomap_enter':
>>>> linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:830: warning: format '%llx' expects type
>>>> 'long long unsigned int', but argument 12 has type 'xfs_fsblock_t'
>>> 
>>> Patch that should fix this below.
>>> 
>>> Cheers,
>>> 
>>> Dave.
> 
> 
> ---
> ~Randy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
