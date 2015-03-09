Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0FD7D7F4E
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 13:51:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CDD9F8F8071
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 11:51:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tTZjfYg48P2dvR07 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 11:51:08 -0700 (PDT)
Date: Mon, 9 Mar 2015 15:50:58 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 4/4] xfs_repair: set *parent if process_dir2_data() fixes
	root inode's parent
Message-ID: <20150309185058.GE18016@hades.maiolino.org>
References: <54F77199.8030708@redhat.com>
 <54F772D2.2030602@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54F772D2.2030602@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Makes sense to me.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Thanks Eric :-)

Cheers,

On Wed, Mar 04, 2015 at 03:02:10PM -0600, Eric Sandeen wrote:
> process_dir2_data() may fix the root dir's parent inode:
> 
> "bad .. entry in root directory inode 6912, was 7159: correcting"
> 
> But we don't update the *parent passed in in that case; this then leads to
> an assert later in process_dir2, because *parent is still the wrong value:
> 
> xfs_repair: dir2.c:2039: process_dir2:
>   Assertion `(ino != mp->m_sb.sb_rootino && ino != *parent) ||
>   (ino == mp->m_sb.sb_rootino && (ino == *parent || need_root_dotdot == 1))'
>   failed.
> 
> Updating the value of *parent when we fix the parent value resolves this
> problem.  Do it whether or not we're in no_modify mode.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index 6b8964d..67cd9d1 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -1468,6 +1468,7 @@ _("bad .. entry in root directory inode %" PRIu64 ", was %" PRIu64 ": "),
>  					} else {
>  						do_warn(_("would correct\n"));
>  					}
> +					*parent = ino;
>  				}
>  			}
>  			/*
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
