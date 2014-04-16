Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D35E37F5F
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 00:14:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B96FC8F8068
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 22:13:49 -0700 (PDT)
Received: from mail-pd0-f181.google.com (mail-pd0-f181.google.com
	[209.85.192.181]) by cuda.sgi.com with ESMTP id
	5TUCLaOuYQAHjro1 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 22:13:48 -0700 (PDT)
Received: by mail-pd0-f181.google.com with SMTP id p10so10249902pdj.40
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 22:13:48 -0700 (PDT)
Message-ID: <1397625226.4222.113.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 10/19] NET: set PF_FSTRANS while holding sk_lock
From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 15 Apr 2014 22:13:46 -0700
In-Reply-To: <20140416040336.10604.96000.stgit@notabene.brown>
References: <20140416033623.10604.69237.stgit@notabene.brown>
	<20140416040336.10604.96000.stgit@notabene.brown>
Mime-Version: 1.0
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
To: NeilBrown <neilb@suse.de>
Cc: linux-mm@kvack.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, 2014-04-16 at 14:03 +1000, NeilBrown wrote:
> sk_lock can be taken while reclaiming memory (in nfsd for loop-back
> NFS mounts, and presumably in nfs), and memory can be allocated while
> holding sk_lock, at least via:
> 
>  inet_listen -> inet_csk_listen_start ->reqsk_queue_alloc
> 
> So to avoid deadlocks, always set PF_FSTRANS while holding sk_lock.
> 
> This deadlock was found by lockdep.

Wow, this is adding expensive stuff in fast path, only for nfsd :(

BTW, why should the current->flags should be saved on a socket field,
and not a current->save_flags. This really looks a thread property, not
a socket one.

Why nfsd could not have PF_FSTRANS in its current->flags ?

For applications handling millions of sockets, this makes a difference.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
