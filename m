Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8920B7F37
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 20:10:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6B5DB304032
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 18:10:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4l99EI8TpQFJ2iWd for <xfs@oss.sgi.com>;
	Wed, 28 Aug 2013 18:10:44 -0700 (PDT)
Received: from [10.5.235.7] (mobile-198-228-232-070.mycingular.net
	[198.228.232.70]) (using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 463AA65AEF04
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 20:10:43 -0500 (CDT)
Subject: Re: Anyone grok pf_batch_read() in xfs_repair?
References: <521D048F.2040604@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <521D048F.2040604@sandeen.net>
Message-Id: <8FA58B5C-6B2B-415A-88A1-9937E60906BF@sandeen.net>
Date: Wed, 28 Aug 2013 20:10:40 -0500
Mime-Version: 1.0 (1.0)
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
To: xfs-oss <xfs@oss.sgi.com>

On Aug 27, 2013, at 2:57 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> There's a pretty clear buffer overflow in pf_batch_read() but I'm having
> a hard time wrapping my head around what it's supposed to be doing:
> 

Head wrapped sufficiently now, I'll send a patch to fix it tomorrow.

-Eric

> <snip>
>                num = 0;
>                if (which == PF_SECONDARY) {
>                        bplist[0] = btree_find(args->io_queue, 0, &fsbno);
>                        max_fsbno = MIN(fsbno + pf_max_fsbs,
>                                                        args->last_bno_read);
>                } else {
>                        bplist[0] = btree_find(args->io_queue,
>                                                args->last_bno_read, &fsbno);
>                        max_fsbno = fsbno + pf_max_fsbs;
>                }
>                while (bplist[num] && num < MAX_BUFS && fsbno < max_fsbno) {
>                        if (which != PF_META_ONLY ||
>                            !B_IS_INODE(XFS_BUF_PRIORITY(bplist[num])))
>                                num++;
>                        bplist[num] = btree_lookup_next(args->io_queue, &fsbno);
>                }
> <snip>
> 
> That while loop is busted; we can increase num from (MAX_BUFS-1) to MAX_BUFS,
> and then index the bplist array with MAX_BUFS, which is 1 past its end -
> this corrupts memory.  Derp!
> 
> But I'm just not grokking what this is supposed to be doing.
> 
> If we come in w/ (which == PF_META_ONLY) we'll immediately overwrite
> bplist[0] set in the if/else case above.  It all seems weird.
> Anybody understand this offhand or should I just keep digging?
> 
> -Eric
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
