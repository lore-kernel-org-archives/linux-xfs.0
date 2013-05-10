Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2577E29DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 23:56:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 044268F8033
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 21:56:39 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	CSfmvaT4dI1L6Dix for <xfs@oss.sgi.com>;
	Thu, 09 May 2013 21:56:38 -0700 (PDT)
Date: Fri, 10 May 2013 14:55:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: regression test for ext4 resize with
	non-extent files
Message-ID: <20130510045544.GQ23072@dastard>
References: <518C1D08.4080309@redhat.com>
	<CA+dCu8_DtrqMy97u9NfHwCC8_-z9uSrF1oR3B=ej15gL6C=W+Q@mail.gmail.com>
	<518C6414.20800@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <518C6414.20800@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, guaneryu@gmail.com, xfs-oss <xfs@oss.sgi.com>

On Thu, May 09, 2013 at 10:05:56PM -0500, Eric Sandeen wrote:
> On 5/9/13 10:03 PM, Eryu Guan wrote:
> > On Fri, May 10, 2013 at 6:02 AM, Eric Sandeen <sandeen@redhat.com <mailto:sandeen@redhat.com>> wrote:
> > 
> 
> ...
> 
> >     index 53af708..4c3e2f4 100644
> >     --- a/tests/ext4/group
> >     +++ b/tests/ext4/group
> >     @@ -9,3 +9,4 @@
> >      303 aio dangerous ioctl rw stress
> >      304 aio dangerous ioctl rw stress
> >      305 auto
> >     +306 dangerous rw resize quick
> > 
> > 
> > I'm wondering why it's not in auto group :)
> 
> 
> because I forgot about auto! :)
> 
> But it's also somewhat dangerous; it could oops or hang, so perhaps
> auto is not a good idea.

If the bug has already been fixed, then auto rather than dangerous
should be used. If the hang/panic cannot be fixed, or is going to
take some time to be fixed, that's when dangerous should be used.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
