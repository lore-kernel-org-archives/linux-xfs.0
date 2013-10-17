Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3C4D67F3F
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 18:12:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2B57A8F8040
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 16:12:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id s9DL7JgHA4fGW8Ge for <xfs@oss.sgi.com>;
	Thu, 17 Oct 2013 16:12:45 -0700 (PDT)
Message-ID: <52606EEB.2040908@sandeen.net>
Date: Thu, 17 Oct 2013 18:12:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: avoid segfault if reporting progress early
	in repair
References: <52602358.1050300@redhat.com>
In-Reply-To: <52602358.1050300@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/17/13 12:50 PM, Eric Sandeen wrote:
> For a very large filesystem, zeroing the log may take some time.
> 
> If we ask for progress reports frequently enough that one fires
> before we finish with log zeroing, we try to use a progress format
> which has not yet been set up, and segfault:
> 
> # mkfs.xfs -d size=60t,file,name=fsfile
> # xfs_repair -m 9000 -o ag_stride=32 -t 1 fsfile 
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 1 seconds
> Phase 2 - using internal log
>         - zero log...
> Segmentation fault
> 
> (gdb) bt
> #0  0x0000000000426962 in progress_rpt_thread (p=0x67ad20) at progress.c:234
> #1  0x0000003b98a07851 in start_thread (arg=0x7f19d8e47700) at pthread_create.c:301
> #2  0x0000003b982e767d in ?? ()
> #3  0x0000000000000000 in ?? ()
> (gdb) p msgp
> $1 = (msg_block_t *) 0x67ad20
> (gdb) p msgp->format
> $2 = (progress_rpt_t *) 0x0
> (gdb)
> 
> I suppose we could rig up progress reports for log zeroing, but
> that won't usually take terribly long; for now, be defensive
> and init the message->format to NULL, and just return early
> from the progress thread if we've not yet set up any message.
> 
> (Sure, global_msgs is global, and ->format is already NULL,
> but to me it's worth being explicit since we will test it).
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/repair/progress.c b/repair/progress.c
> index ab320dc..45a412e 100644
> --- a/repair/progress.c
> +++ b/repair/progress.c
> @@ -124,6 +124,7 @@ init_progress_rpt (void)
>  	 */
>  
>  	pthread_mutex_init(&global_msgs.mutex, NULL);
> +	global_msgs.format = NULL;
>  	global_msgs.count = glob_agcount;
>  	global_msgs.interval = report_interval;
>  	global_msgs.done   = prog_rpt_done;
> @@ -169,6 +170,10 @@ progress_rpt_thread (void *p)
>  	msg_block_t *msgp = (msg_block_t *)p;
>  	__uint64_t percent;
>  
> +	/* It's possible to get here very early w/ no progress msg set */
> +	if (!msgp->format)
> +		return NULL;
> +
>  	if ((msgbuf = (char *)malloc(DURATION_BUF_SIZE)) == NULL)
>  		do_error (_("progress_rpt: cannot malloc progress msg buffer\n"));

Dammit:

CID 1107596: Data race condition (MISSING_LOCK)

/repair/progress.c: 127 ( missing_lock)
   124    	 */
   125    
   126    	pthread_mutex_init(&global_msgs.mutex, NULL);
>>> CID 1107596: Data race condition (MISSING_LOCK)
>>> Accessing "global_msgs.format" without holding lock "msg_block_s.mutex". Elsewhere, "global_msgs.format" is accessed with "msg_block_s.mutex" held 2 out of 2 times.
   127    	global_msgs.format = NULL;
   128    	global_msgs.count = glob_agcount;
   129    	global_msgs.interval = report_interval;
   130    	global_msgs.done   = prog_rpt_done;
   131    	global_msgs.total  = &prog_rpt_total;
  
Probably best to just drop the new NULL assignment, since it's a global init'd to 0 anyway, to shut up coverity?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
