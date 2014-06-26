Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 250167F92
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 18:03:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F65A304039
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 16:03:44 -0700 (PDT)
Received: from mail-qg0-f52.google.com (mail-qg0-f52.google.com
	[209.85.192.52]) by cuda.sgi.com with ESMTP id Efu8wAUbU7fkQscz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 Jun 2014 16:03:43 -0700 (PDT)
Received: by mail-qg0-f52.google.com with SMTP id f51so3681492qge.39
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 16:03:43 -0700 (PDT)
From: Jeff Layton <jeff.layton@primarydata.com>
Date: Thu, 26 Jun 2014 19:03:41 -0400
Subject: Re: xfs: possible irq lock inversion dependency detected
Message-ID: <20140626190341.6861553d@tlielax.poochiereds.net>
In-Reply-To: <20140626225857.GT9508@dastard>
References: <20140626142004.31b981dc@tlielax.poochiereds.net>
	<20140626225857.GT9508@dastard>
MIME-Version: 1.0
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
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jeff.layton@primarydata.com>, xfs@oss.sgi.com

On Fri, 27 Jun 2014 08:58:57 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Jun 26, 2014 at 02:20:04PM -0400, Jeff Layton wrote:
> > While testing some knfsd patches on XFS today, I got this lockdep
> > splatter. The kernel is a stock -rc2 kernel with a pile of knfsd
> > patches on top. There are a couple of others in other areas, but
> > nothing that would affect this.
> > 
> > Nothing crashed or seems to be hung, so I'm not sure if it's a real
> > problem or not...
> 
> Known false positive. the problem is that lockdep is too stupid to
> realise you can't mmap a directory inode, but it sees unused
> directory inodes from memory reclaim in page faults (i.e. under the
> mmap_sem) and so therefore thinks that taking a page fault in
> readdir() while holding a directory inode lock on a referenced
> directory inode will deadlock....
> 
> Teaching lockdep the intricacies of locking heirarchies is difficult
> and painful. Fixing this one (and all the other stupidities lockdep
> reports because of this) can't be done through annotations - it
> requires rewriting a bunch of directory code to use different locks.
> And, well, it ain't actually broken right now and there's other more
> important issues to be fixed, so unless someone else beats me to
> rewriting the readdir readahead code, lockdep is going to remain
> unhappy about XFS.
> 
> Cheers,
> 
> Dave.

No problem. Just figured I'd report it in case it were something new.
I'll just keep ignoring it.

Thanks!
-- 
Jeff Layton <jlayton@primarydata.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
