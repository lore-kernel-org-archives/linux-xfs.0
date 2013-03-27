Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D3F617F50
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 06:39:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 88FE28F8040
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 04:39:25 -0700 (PDT)
Received: from mail-pa0-f51.google.com (mail-pa0-f51.google.com
	[209.85.220.51]) by cuda.sgi.com with ESMTP id rqn9KXStf1aYl7TB
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 27 Mar 2013 04:39:24 -0700 (PDT)
Received: by mail-pa0-f51.google.com with SMTP id jh10so1465285pab.24
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 04:39:24 -0700 (PDT)
Date: Wed, 27 Mar 2013 19:55:02 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2] xfstests 299-305: remove fio config files after
	finished test
Message-ID: <20130327115502.GA23236@gmail.com>
References: <1364127266-13325-1-git-send-email-wenqing.lz@taobao.com>
	<20130327020532.GP6369@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130327020532.GP6369@dastard>
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
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On Wed, Mar 27, 2013 at 01:05:33PM +1100, Dave Chinner wrote:
> On Sun, Mar 24, 2013 at 08:14:26PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > After finished test, temporarily fio config file should be removed.
> > Meanwhile in #305 poweron_scratch_dev is removed because no one uses
> > it.
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > Cc: Eric Sandeen <sandeen@sandeen.net>
> > Cc: Dave Chinner <david@fromorbit.com>
> > ---
> >  299 |  9 +++++----
> >  300 |  9 +++++----
> >  301 |  9 +++++----
> >  302 |  9 +++++----
> >  303 |  9 +++++----
> >  304 |  9 +++++----
> >  305 | 11 ++++++-----
> >  7 files changed, 36 insertions(+), 29 deletions(-)
> >  mode change 100644 => 100755 299
> >  mode change 100644 => 100755 300
> >  mode change 100644 => 100755 301
> >  mode change 100644 => 100755 302
> >  mode change 100644 => 100755 303
> >  mode change 100644 => 100755 304
> >  mode change 100644 => 100755 305
> 
> Mode changes should be in a separate patch. And if you are going to
> do this, please change all the tests that need this to be done in
> one sweep.

Hi Dave,

Thanks for pointing it out.  I will send a latest version.  Meanwhile I
notice that now test cases have been moved into tests dir and splitted
into different parts.  So I will rebase my patch aginst latest xfstests.

Thanks,
                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
