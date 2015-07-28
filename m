Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ADD027FFA
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 09:09:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2DE61AC006
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 07:09:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AqoFaVGWMMXTBqjk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Jul 2015 07:08:59 -0700 (PDT)
Date: Tue, 28 Jul 2015 10:08:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: FYI: questionable xfsdump code
Message-ID: <20150728140857.GE38784@bfoster.bfoster>
References: <20150728063246.GA2510@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150728063246.GA2510@schmorp.de>
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
To: Marc Lehmann <schmorp@schmorp.de>
Cc: xfs@oss.sgi.com

On Tue, Jul 28, 2015 at 08:33:33AM +0200, Marc Lehmann wrote:
> Hi!
> 
> While causally browsing xfsdump code,I found this, in
> common/getdents.c:getdents_wrap (in xfsdump
> 
>         off64_t last_offset = -1;
> 
>         ...
> 
>         while ((char *)kdp < kbuf + retval) {
>                 ...
> 
>                 if ((sizeof(dp->d_ino) != sizeof(kdp->d_ino))
>                     || (sizeof(dp->d_off) != sizeof(kdp->d_off))) {
>                         /* Overflow.  If there was at least one entry
>                            before this one, return them without error,
>                            otherwise signal overflow.  */
>                         if (last_offset != -1) {
>                                 lseek64(fd, last_offset, SEEK_SET);
>                                 return (char *)dp - buf;
>                         }
>                         errno = EOVERFLOW;
>                         return -1;
>                 }
> 
>                 last_offset = d_off;
> 
>                 ...
>         }
> 
> While not necessarily a bug, this comment is very confused - there is no
> way to reach the code inside the if with last_offset != -1, as the if
> condition is a compiletime constant.
> 

It looks like this changed in:

	b1d6979f remove ancient sys_getdents code paths

It used to look like this:

		if ((sizeof (dp->d_ino) != sizeof (kdp->d_ino)
		     && dp->d_ino != d_ino)
		    || (sizeof (dp->d_off) != sizeof (kdp->d_off)
			&& dp->d_off != d_off))
		{
			...
		}

... which probably made more sense.

Brian


> This might be harmless dead code from some refactorisation gone wrong,
> or indicative of some bug due to some logic error. In any case, I just
> wanted to bring it to your attention.
> 
> And as a side note, memcpy would be more efficient here, especially as it
> is called very often, (and especially so on irix :-):
> 
>                 memmove(dp->d_name, kdp->d_name,
>                         old_reclen - offsetof(struct kernel_dirent64, d_name));
> 
> -- 
>                 The choice of a       Deliantra, the free code+content MORPG
>       -----==-     _GNU_              http://www.deliantra.net
>       ----==-- _       generation
>       ---==---(_)__  __ ____  __      Marc Lehmann
>       --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
>       -=====/_/_//_/\_,_/ /_/\_\
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
