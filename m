Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 119827F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 22:40:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE1C18F8054
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 20:40:14 -0700 (PDT)
Received: from mail-pa0-f50.google.com (mail-pa0-f50.google.com
	[209.85.220.50]) by cuda.sgi.com with ESMTP id Nud8i06jySDMUGRR
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 15 May 2013 20:40:10 -0700 (PDT)
Received: by mail-pa0-f50.google.com with SMTP id fb10so2089126pad.9
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 20:40:10 -0700 (PDT)
Date: Thu, 16 May 2013 11:57:58 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v5] xfstests: add a new test case for ext4 indirect-based
	file
Message-ID: <20130516035758.GA6823@gmail.com>
References: <1368463235-14478-1-git-send-email-wenqing.lz@taobao.com>
	<5193AA69.7050507@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5193AA69.7050507@sandeen.net>
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
Cc: Rich Johnston <rjohnston@sgi.com>, Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On Wed, May 15, 2013 at 10:31:53AM -0500, Eric Sandeen wrote:
> On 5/13/13 11:40 AM, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > After applied this commit (864688d3), xfstests #255 will not test a
> > file system that cannot support fallocate(2), such as a indirect-based
> > file in ext4.  So we need to add a new generic test case to test it.
> > 
> > The difference between #255 and this test case is only to use pwrite to
> > allocate blocks.  Other filesystems should survive in this test case.
> > In the mean time, a new argument '-u' is added into _test_generic_punch
> > not to run unwritten tests.
> > 
> > Meanwhile this commit fixes a minor problem in #255 that testfile should
> > use $seq.$$ as testfile.
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > Cc: Eric Sandeen <sandeen@sandeen.net>
> > Cc: Dave Chinner <david@fromorbit.com>
> > Cc: Rich Johnston <rjohnston@sgi.com>
> > ---
> > changelog:
> >  * rebase against Eric's patch
> >  * remove 'prealloc" from group
> > 
> > Hi Eric,
> > 
> > I take a close look at your patch, and 'xfs_io_opt' has been removed in your
> > patch.  I am not sure whether I need to adjust my patch or not.  Please let me
> > know if I need to change it.  Currently I only remove '-F' argument from test
> > case.
> 
> xfs_io_opt was an option passed to _test_generic_punch used for "-F", as in:
> 
> _test_generic_punch -k falloc fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
> 
> -F is no longer needed, so I just dropped the whole thing.
> 
> I'm sorry this patch has required so much work.  :(
> 
> If you simply replace "$xfs_io_opt " with "" in this patch, it applies
> again with some fuzz.  i.e. in vim I just did:  
> 
> :%s/$xfs_io_opt //g
> 
> to fix up the patch itself.
> 
> There is also still one instance of "-F" in the context of the hunk
> in tests/generic/255 as well which causes a little fuzz.]

Hi Eric,

Thanks for pointing it out.  I have sent a newer version to the mailing
list.  Could you please review this patch?

Thanks,
                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
