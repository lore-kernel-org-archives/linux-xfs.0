Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p986URNe031470 for <xfs@oss.sgi.com>; Sat, 8 Oct 2011 01:30:28 -0500
Received: from nm7.bullet.mail.ac4.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id EB5961B7E5D
	for <xfs@oss.sgi.com>; Fri,  7 Oct 2011 23:30:24 -0700 (PDT)
Received: from nm7.bullet.mail.ac4.yahoo.com (nm7.bullet.mail.ac4.yahoo.com
	[98.139.52.204]) by cuda.sgi.com with SMTP id rcpi5IXw10IOpCok
	for <xfs@oss.sgi.com>; Fri, 07 Oct 2011 23:30:24 -0700 (PDT)
References: <4E8E079B.4040103@birkenwald.de> <20111007013711.GW3159@dastard>
	<1317995933.17433.YahooMailNeo@web122515.mail.ne1.yahoo.com>
	<20111007233119.GJ3159@dastard>
In-Reply-To: <20111007233119.GJ3159@dastard>
MIME-Version: 1.0
Subject: Re: Premature "No Space left on device" on XFS
From: Bryan J Smith <b.j.smith@ieee.org>
Date: Sat, 08 Oct 2011 02:30:04 -0400
Message-ID: <f7b04e83-0303-4fa2-9bc0-db42c99228c0@email.android.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2191253803453333370=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Bernhard Schmidt <berni@birkenwald.de>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============2191253803453333370==
Content-Type: multipart/alternative; boundary="----570JKCQR6CXFRGYHNXD3331CY894Y2"

------570JKCQR6CXFRGYHNXD3331CY894Y2
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit

I figured someone would fill in the gaps in my experience-assumptions. Excellent info, especially on those fs comparisons.
-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.

Dave Chinner <david@fromorbit.com> wrote:

On Fri, Oct 07, 2011 at 06:58:53AM -0700, Bryan J Smith wrote:
> [ Not really adding any technical meat, but just some past
> experience with XFS, plus Ext3 experience ]
> 
> I remember running into this a long time ago when I was first
> playing with XFS for /tmp and /var (I was still a Linux/XFS noob
> at the time, not that I'm an expert today).  I ran into the same
> case where both free block and inodes were still available
> (although similarly well utilized), and the median file size was
> around 1KiB.  It was also in the case of many small files being
> written out in a short period.
> 
> In my case, I didn't use the XFS debugger to get into the
> allocation of the extents (would have if I wasn't such a noob,
> good, discrete command to know, thanx!).
> 
> Extents are outstanding for data and similar directories, ordering
> and placing large and small files to mitigate fragmentation.  But
> in this case, and correct me if I'm wrong, it's really just a
> wasteful use for the extents approach, as the files typically fit
> in a single data block or two. 

And single blocks still an extent, so there's nothing "wasted" by
having a single block extent.

....

> I've used Ext3 with around 8 million files with a median size well
> under 4KiB (under 32GiB total).  It works "well enough."  I'm
> curious how Ext4 would do though.  I think Ric Wheeler's team (at
> Red Hat) has done some benchmarks on 7+ figure file counts on Ext3
> and Ext4.

And against XFS, too. In case you didn't realise, you're talking to
the person who ran a large number of those tests. ;)

The results were ext4 is good for create/delete workloads up to 2-4
threads and about 100k files per directory on a decent disk
subsystem (4000 iops). It's much better than ext3, and for those
workloads about 2x as fast as XFS at 1-2 threads. This pattern held
true as long as the disk subsystem could handle the number of iops
that ext4 threw at it. XFS performance came at a much, much lower
iops cost (think order of magnitude), so shoul dbe more consistent
on a wider range of storage hardware than ext4.

However, XFS was about 3x faster on cold cache lookups than ext4, so
if you're workload is dominated by lookups, XFS is definitely the
faster filesystem to use even if creates/unlinks on ext4 are
faster..

As soon as you have more parallelism than 2-4 threads or large
directories, XFS create/unlink speed surpasses ext4 by a large
amount - the best I got out of ext4 was ~80k creates a second, while
XFS topped 130k creates/s at 8 threads. And the lookup speed
differential increase in XFS's favour at larger thread counts as
well.

So it really depends on your workload as to which filesystem will
handle your small files best. Mail spools tend to have lots of
parallelism, which is why XFS works pretty well, even though it is
a small file workload.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


------570JKCQR6CXFRGYHNXD3331CY894Y2
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: 8bit

<html><head></head><body>I figured someone would fill in the gaps in my experience-assumptions. Excellent info, especially on those fs comparisons.<br>
-- <br>
Sent from my Android phone with K-9 Mail. Please excuse my brevity.<br><br><div class="gmail_quote">Dave Chinner &lt;david@fromorbit.com&gt; wrote:<blockquote class="gmail_quote" style="margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">
<pre style="white-space: pre-wrap; word-wrap:break-word; font-family: sans-serif">On Fri, Oct 07, 2011 at 06:58:53AM -0700, Bryan J Smith wrote:<br />&gt; [ Not really adding any technical meat, but just some past<br />&gt; experience with XFS, plus Ext3 experience ]<br />&gt; <br />&gt; I remember running into this a long time ago when I was first<br />&gt; playing with XFS for /tmp and /var (I was still a Linux/XFS noob<br />&gt; at the time, not that I'm an expert today).  I ran into the same<br />&gt; case where both free block and inodes were still available<br />&gt; (although similarly well utilized), and the median file size was<br />&gt; around 1KiB.  It was also in the case of many small files being<br />&gt; written out in a short period.<br />&gt; <br />&gt; In my case, I didn't use the XFS debugger to get into the<br />&gt; allocation of the extents (would have if I wasn't such a noob,<br />&gt; good, discrete command to know, thanx!).<br />&gt; <br />&gt; Exte
 nts are
outstanding for data and similar directories, ordering<br />&gt; and placing large and small files to mitigate fragmentation.  But<br />&gt; in this case, and correct me if I'm wrong, it's really just a<br />&gt; wasteful use for the extents approach, as the files typically fit<br />&gt; in a single data block or two. <br /><br />And single blocks still an extent, so there's nothing "wasted" by<br />having a single block extent.<br /><br />....<br /><br />&gt; I've used Ext3 with around 8 million files with a median size well<br />&gt; under 4KiB (under 32GiB total).  It works "well enough."  I'm<br />&gt; curious how Ext4 would do though.  I think Ric Wheeler's team (at<br />&gt; Red Hat) has done some benchmarks on 7+ figure file counts on Ext3<br />&gt; and Ext4.<br /><br />And against XFS, too. In case you didn't realise, you're talking to<br />the person who ran a large number of those tests. ;)<br /><br />The results were ext4 is good for create/delete workloads up
  to
2-4<br />threads and about 100k files per directory on a decent disk<br />subsystem (4000 iops). It's much better than ext3, and for those<br />workloads about 2x as fast as XFS at 1-2 threads. This pattern held<br />true as long as the disk subsystem could handle the number of iops<br />that ext4 threw at it. XFS performance came at a much, much lower<br />iops cost (think order of magnitude), so shoul dbe more consistent<br />on a wider range of storage hardware than ext4.<br /><br />However, XFS was about 3x faster on cold cache lookups than ext4, so<br />if you're workload is dominated by lookups, XFS is definitely the<br />faster filesystem to use even if creates/unlinks on ext4 are<br />faster..<br /><br />As soon as you have more parallelism than 2-4 threads or large<br />directories, XFS create/unlink speed surpasses ext4 by a large<br />amount - the best I got out of ext4 was ~80k creates a second, while<br />XFS topped 130k creates/s at 8 threads. And the lookup spe
 ed<br
/>differential increase in XFS's favour at larger thread counts as<br />well.<br /><br />So it really depends on your workload as to which filesystem will<br />handle your small files best. Mail spools tend to have lots of<br />parallelism, which is why XFS works pretty well, even though it is<br />a small file workload.<br /><br />Cheers,<br /><br />Dave.<br />-- <br />Dave Chinner<br />david@fromorbit.com<br /></pre></blockquote></div></body></html>
------570JKCQR6CXFRGYHNXD3331CY894Y2--


--===============2191253803453333370==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2191253803453333370==--
