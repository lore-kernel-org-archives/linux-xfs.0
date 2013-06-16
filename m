Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D792A29DF8
	for <xfs@oss.sgi.com>; Sat, 15 Jun 2013 19:00:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ADC168F8035
	for <xfs@oss.sgi.com>; Sat, 15 Jun 2013 17:00:55 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	3ohjScznwGBCAu01 for <xfs@oss.sgi.com>;
	Sat, 15 Jun 2013 17:00:53 -0700 (PDT)
Date: Sun, 16 Jun 2013 10:00:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: definitions for /proc/fs/xfs/stat
Message-ID: <20130616000049.GD29338@dastard>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<91017249.1356192.1371248207334.JavaMail.root@redhat.com>
	<CAC2B=ZHYV6d-1PO_=-jXsQidZnYPHVwcVAaQh2mxJt=5K03AEA@mail.gmail.com>
	<504625587.1365681.1371255450937.JavaMail.root@redhat.com>
	<CAC2B=ZF+eMyNLPQmhA_onDPEUqgNfcgCdZVvobNH9pofvioN7Q@mail.gmail.com>
	<20130615020414.GB29338@dastard>
	<CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
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

On Sat, Jun 15, 2013 at 06:35:02AM -0400, Mark Seger wrote:
> Basically everything do it with collectl, a tool I wrote and opensourced
> almost 10 years ago.  it's numbers are very accurate - I've compared with
> iostat on numerous occasions whenever I might have had doubts and they
> always agree.  Since both tools get their data from the same place,
> /proc/diskstats, it's hard for them not to agree AND its numbers also agree
> with /proc/fs/xfs.

Ok, that's all I wanted to know.

> happening?
> 
> To restate what's going on, I have a very simple script that I'm
> duplicating what openstack swift is doing, namely to create a file with
> mkstmp and than running an falloc against it.  The files are being created
> with a size of zero but it seems that xfs is generating a ton of logging
> activity.  I had read your posted back in 2011 about speculative
> preallocation and can't help but wonder if that's what hitting me here.  I
> also saw where system memory can come into play and this box has 192GB and
> 12 hyperthreaded cores.
> 
> I also tried one more run without falloc, this is creating 10000 1K files,
> which should be about 10MB and it looks like it's still doing 140MB of I/O
> which still feels like a lot but at least it's less than the

1k files will still write 4k filesystem blocks, so there's going to
be 40MB/s there at least. 

As it is, I ran a bunch of tests yesterday writing 4k files, and I
got 180MB/s @ 32,000 files/s. That's roughly 130MB/s for data, and
another 50MB/s for log and metadata traffic. But without knowing
your test configuration and using your test script, I can't compare
those results to yours. Can you provide the information in:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F


> If there is anything more I can provide I'll be happy to do so.  Actually I
> should point out I can easily generate graphs and if you'd like to see some
> examples I can provide those too.

PCP generates realtime graphs, which is what I use ;)

> Also, if there is anything I can report
> from /proc/fs/xfs I can relatively easily do that as well and display it
> side by side with the disk I/O.

Let's see if there is something unusual in your setup that might
explain it first...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
