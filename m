Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BADB729DF8
	for <xfs@oss.sgi.com>; Sat, 15 Jun 2013 19:11:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D9E28F804B
	for <xfs@oss.sgi.com>; Sat, 15 Jun 2013 17:11:36 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	rX5flF9gYE9y4Abb for <xfs@oss.sgi.com>;
	Sat, 15 Jun 2013 17:11:31 -0700 (PDT)
Date: Sun, 16 Jun 2013 10:11:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: definitions for /proc/fs/xfs/stat
Message-ID: <20130616001130.GE29338@dastard>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<91017249.1356192.1371248207334.JavaMail.root@redhat.com>
	<CAC2B=ZHYV6d-1PO_=-jXsQidZnYPHVwcVAaQh2mxJt=5K03AEA@mail.gmail.com>
	<504625587.1365681.1371255450937.JavaMail.root@redhat.com>
	<CAC2B=ZF+eMyNLPQmhA_onDPEUqgNfcgCdZVvobNH9pofvioN7Q@mail.gmail.com>
	<20130615020414.GB29338@dastard>
	<CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
	<CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
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
To: Mark Seger <mjseger@gmail.com>
Cc: Nathan Scott <nathans@redhat.com>, xfs@oss.sgi.com

On Sat, Jun 15, 2013 at 12:22:35PM -0400, Mark Seger wrote:
> I was thinking a little color commentary might be helpful from a
> perspective of what the functionally is that's driving the need for
> fallocate.  I think I mentioned somewhere in this thread that the
> application is OpenStack Swift, which is  a highly scalable cloud object
> store.

I'm familiar with it and the problems it causes filesystems. What
application am I talking about here, for example?

http://oss.sgi.com/pipermail/xfs/2013-June/027159.html

Basically, Swift is trying to emulate Direct IO because python
does't support Direct IO. Hence Swift is hacking around that problem
and causing secondary issues that would never have occurred if
Direct IO was used in the first place.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
