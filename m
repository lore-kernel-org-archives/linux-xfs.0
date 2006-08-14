Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Aug 2006 17:24:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7E0NoDW010547
	for <xfs@oss.sgi.com>; Sun, 13 Aug 2006 17:24:01 -0700
Date: Mon, 14 Aug 2006 10:22:58 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: xfs_end_io_direct() with negative size?
Message-ID: <20060814102258.A2698880@wobbly.melbourne.sgi.com>
References: <44DCC1B0.70003@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44DCC1B0.70003@oracle.com>; from zach.brown@oracle.com on Fri, Aug 11, 2006 at 10:43:12AM -0700
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Zach Brown <zach.brown@oracle.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 11, 2006 at 10:43:12AM -0700, Zach Brown wrote:
> 
> So, I was lost in fs/direct-io.c chasing yet another bug when I noticed
> that a recent unrelated change might have changed the semantics of the
> end_io() call.
> 
>    http://www.kernel.org/hg/linux-2.6/?cs=34c151cf341f
> 
> Notice how that changes the aio path to set 'transferred' to -EIO based
> on dio->io_error before calling dio_complete() instead of after, like
> the sync path does with its possibly negative 'ret'.
> 
> So it looks like xfs_end_io_direct() can now get a -ve size if, say,
> someone unplugs a drive part-way through a dio+aio write.  There's an
> ASSERT() in there that makes me wonder if this is something we should be
> worrying about.

Its harmless.  It was written when there was no way a negative byte
count would be coming back at us from the dio code.  We should simply
remove the assert.

cheers.

-- 
Nathan
