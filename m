Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDB7C00140
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 15:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbiHJPKJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Aug 2022 11:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbiHJPJq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Aug 2022 11:09:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A9676472
        for <linux-xfs@vger.kernel.org>; Wed, 10 Aug 2022 08:09:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC385B81C97
        for <linux-xfs@vger.kernel.org>; Wed, 10 Aug 2022 15:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C876C433D6;
        Wed, 10 Aug 2022 15:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660144180;
        bh=DOe6V6AXfiDAGr6E+kid1NNyl91fXmUOnrlUxvtJf3c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r7KVB4erGRr13D3pQi2ZQfHZqXlE5eGwYdN/kLMutwbn+ZcTH+T2HgyewD/wUDNfH
         kgkL9/2sd13UhatKpx2zWxir6eIqsZg6v96JxCN9KT6pEn7zGKxsPvXC//u6JFYN1U
         2OueHDGPAgsNE2akeGJJPbE5YBKLSzvZUZjkO+4fn6p7PTJqiRs52ZoEquZ2ti5DR7
         /lEmqCHzq4RyTrgfA6rS91AS58brkEeXze/V6yUfI2+nNoC44Uz+c7SY7so9vUGVVW
         pLgneZPTGBjRSTsaPlzzPX3xMk6vFJ/APusYVcg3dGTQ/4vrzv6wnXqQW3ppwXpJXH
         0rOvRL463UW/g==
Date:   Wed, 10 Aug 2022 08:09:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Rename worker threads from xfsdump's documentation
Message-ID: <YvPKM49c3tW/6qtB@magnolia>
References: <166012867440.10085.15666482309699207253.stgit@orion>
 <166012881358.10085.7894829376842264679.stgit@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166012881358.10085.7894829376842264679.stgit@orion>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 10, 2022 at 12:53:33PM +0200, Carlos Maiolino wrote:
> While we've already removed the word 'slave' from the code, the
> documentation should still be updated.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  doc/xfsdump.html |   38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/doc/xfsdump.html b/doc/xfsdump.html
> index e37e362..2faa65e 100644
> --- a/doc/xfsdump.html
> +++ b/doc/xfsdump.html
> @@ -286,7 +286,7 @@ of a dump/restore session to multiple drives.
>  	   |      |      |
>  4.	   O      O      O	ring buffers common/ring.[ch]
>             |      |      |
> -5.	 slave  slave   slave	ring_create(... ring_slave_entry ...)
> +5.	worker  worker  worker	ring_create(... ring_worker_entry ...)
>  	thread  thread  thread
>  	   |      |      |
>  6.	 drive  drive   drive	physical drives
> @@ -306,7 +306,7 @@ The process hierachy is shown above. main() first initialises
>  the drive managers with calls to the drive_init functions. In
>  addition to choosing and assigning drive strategies and ops for each
>  drive object, the drive managers intialise a ring buffer and (for
> -devices other than simple UNIX files) sproc off a slave thread that
> +devices other than simple UNIX files) sproc off a worker thread that
>  that handles IO to the tape device. This initialisation happens in the
>  drive_manager code and is not directly visible from main().
>  <p>
> @@ -316,31 +316,31 @@ sprocs. Each child begins execution in childmain(), runs either
>  content_stream_dump or content_stream_restore and exits with the
>  return code from these functions.
>  <p>
> -Both the stream manager processes and the drive manager slaves
> +Both the stream manager processes and the drive manager workers
>  set their signal disposition to ignore HUP, INT, QUIT, PIPE,
>  ALRM, CLD (and for the stream manager TERM as well).
>  <p>
> -The drive manager slave processes are much simpler, and are
> +The drive manager worker processes are much simpler, and are
>  initialised with a call to ring_create, and begin execution in
> -ring_slave_func. The ring structure must also be initialised with
> +ring_worker_func. The ring structure must also be initialised with
>  two ops that are called by the spawned thread: a ring read op, and a write op.
>  The stream manager communicates with the tape manager across this ring
>  structure using Ring_put's and Ring_get's.
>  <p>
> -The slave thread sits in a loop processing messages that come across
> +The worker thread sits in a loop processing messages that come across
>  the ring buffer. It ignores signals and does not terminate until it
>  receives a RING_OP_DIE message. It then exits 0.
>  <p>
>  The main process sleeps waiting for any of its children to die
>  (ie. waiting for a SIGCLD). All children that it cares about (stream
> -managers and ring buffer slaves) are registered through the child
> +managers and ring buffer workers) are registered through the child
>  manager abstraction. When a child dies wait status and other info is
>  stored with its entry in the child manager. main() ignores the deaths
>  of children (and grandchildren) that are not registered through the child
>  manager. The return status of these subprocesses is checked
>  and in the case of an error is used to determine the overall exit code.
>  <p>
> -We do not expect slave threads to ever die unexpectedly: they ignore
> +We do not expect worker threads to ever die unexpectedly: they ignore
>  most signals and only exit when they receive a RING_OP_DIE at which
>  point they drop out of the message processing loop and always signal success.
>  <p>
> @@ -1680,35 +1680,35 @@ If xfsdump/xfsrestore is running single-threaded (-Z option)
>  or is running on Linux (which is not multi-threaded) then
>  records are read/written straight to the tape. If it is running
>  multi-threaded then a circular buffer is used as an intermediary
> -between the client and slave threads.
> +between the client and worker threads.
>  <p>
>  Initially <i>drive_init1()</i> calls <i>ds_instantiate()</i> which
>  if dump/restore is running multi-threaded,
>  creates the ring buffer with <i>ring_create</i> which initialises
> -the state to RING_STAT_INIT and sets up the slave thread with
> -ring_slave_entry.
> +the state to RING_STAT_INIT and sets up the worker thread with
> +ring_worker_entry.
>  <pre>
>  ds_instantiate()
>    ring_create(...,ring_read, ring_write,...)
>      - allocate and init buffers
>      - set rm_stat = RING_STAT_INIT
> -    start up slave thread with ring_slave_entry
> +    start up worker thread with ring_worker_entry
>  </pre>
> -The slave spends its time in a loop getting items from the
> +The worker spends its time in a loop getting items from the
>  active queue, doing the read or write operation and placing the result
>  back on the ready queue.
>  <pre>
> -slave
> +worker
>  ======
> -ring_slave_entry()
> +ring_worker_entry()
>    loop
> -    ring_slave_get() - get from active queue
> +    ring_worker_get() - get from active queue
>      case rm_op
>        RING_OP_READ -> ringp->r_readfunc
>        RING_OP_WRITE -> ringp->r_writefunc
>        ..
>      endcase
> -    ring_slave_put() - puts on ready queue
> +    ring_worker_put() - puts on ready queue
>    endloop
>  </pre>
>  
> @@ -1778,7 +1778,7 @@ prepare_drive()
>  <p>
>  For each <i>do_read</i> call in the multi-threaded case,
>  we have two sides to the story: the client which is coming
> -from code in <i>content.c</i> and the slave which is a simple
> +from code in <i>content.c</i> and the worker which is a simple
>  thread just satisfying I/O requests.
>  From the point of view of the ring buffer, these are the steps
>  which happen for reading:
> @@ -1786,7 +1786,7 @@ which happen for reading:
>  <li>client removes msg from ready queue
>  <li>client wants to read, so sets op field to READ (RING_OP_READ)
>     and puts on active queue
> -<li>slave removes msg from active queue,
> +<li>worker removes msg from active queue,
>     invokes client read function,
>     sets status field: OK/ERROR,
>     puts msg on ready queue
> 
> 
