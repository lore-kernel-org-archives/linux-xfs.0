Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4ID3QU2245992 for <xfs@oss.sgi.com>; Mon, 18 May 2009 08:03:26 -0500
Received: from padma.gslab.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 45800FC4E34
	for <xfs@oss.sgi.com>; Mon, 18 May 2009 06:08:41 -0700 (PDT)
Received: from padma.gslab.com (padma.gslab.com [59.163.66.102]) by
	cuda.sgi.com with SMTP id 9wbF3MLEofBhSp3T for
	<xfs@oss.sgi.com>; Mon, 18 May 2009 06:08:41 -0700 (PDT)
Subject: Re: EXT vs XFS at 80% filled filesystem
From: Milind <milind@gslab.com>
In-Reply-To: <20090430183450.GB19276@mit.edu>
References: <49F9565E.40804@gslab.com>  <20090430183450.GB19276@mit.edu>
Date: Mon, 18 May 2009 18:33:28 +0530
Message-Id: <1242651808.3339.28.camel@alhena>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Theodore Tso <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Hi Theodore,

I am facing some weird problem of cross compiling libuuid sources. I
downloaded e2fsprogs and cross-compiled them but when I do "make
install-libs" it doesn't really install libuuid.so but installs
libuuid.a.

Can I have some pointers to build libuuid.so to have it in my toolchain
libraries.

I have crawled through web but couldn't get any nice solution to this.

Thanks in Advance
-Miline

On Thu, 2009-04-30 at 14:34 -0400, Theodore Tso wrote:
> On Thu, Apr 30, 2009 at 01:12:22PM +0530, Milind Dumbare wrote:
> > Hi,
> >
> > I have heard of XFS's performance is not good as compared to EXT3 when  
> > the filesystem(disk) is 80% filled with data. Is it true? I have went  
> > through lots of performance documents of both XFS and EXT3 but could not  
> > find such performance benchmarking (for 80% full filesystems).
> 
> I've not heard of any such performance metrics, and I suspect it would
> very much depend on how the filesystem was "aged".  A filesystem that
> has been in use for a few years and is at 80% capacity will behave
> very different from a brand-new filesystem which was freshly formatted
> and then filled with a few large files until said filesystem was 80%
> full.
> 
> 							- Ted
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
