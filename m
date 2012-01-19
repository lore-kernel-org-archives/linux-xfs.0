Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0JLGE0G046353 for <xfs@oss.sgi.com>; Thu, 19 Jan 2012 15:16:14 -0600
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	8slP5UUjmlMWEiDE for <xfs@oss.sgi.com>;
	Thu, 19 Jan 2012 13:16:13 -0800 (PST)
Received: by iagz35 with SMTP id z35so441965iag.26
	for <xfs@oss.sgi.com>; Thu, 19 Jan 2012 13:16:13 -0800 (PST)
Subject: Re: working on extent locks for i_mutex
From: Frank Mayhar <fmayhar@google.com>
In-Reply-To: <20120118120223.GA4322@gmail.com>
References: <4F0F9E97.1090403@linux.vnet.ibm.com>
	<20120113043411.GH2806@dastard> <4F10992C.3070303@linux.vnet.ibm.com>
	<20120115235747.GA6922@dastard> <4F146275.8090304@linux.vnet.ibm.com>
	<20120118120223.GA4322@gmail.com>
Date: Thu, 19 Jan 2012 13:16:10 -0800
Message-ID: <1327007770.5899.66.camel@peace.lax.corp.google.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: xfs@oss.sgi.com, Allison Henderson <achender@linux.vnet.ibm.com>, Lukas Czerner <lczerner@redhat.com>, Tao Ma <tm@tao.ma>, Ext4 Developers List <linux-ext4@vger.kernel.org>

On Wed, 2012-01-18 at 20:02 +0800, Zheng Liu wrote:
> For this project, do you have a schedule? Would you like to share to me? This
> lock contention heavily impacts the performance of direct IO in our production
> environment. So we hope to improve it ASAP.
> 
> I have done some direct IO benchmarks to compare ext4 with xfs using fio
> in Intel SSD. The result shows that, in direct IO, xfs outperforms ext4 and
> ext4 with dioread_nolock.
> 
> To understand the effect of lock contention, I define a new function called 
> ext4_file_aio_write() that calls __generic_file_aio_write() without acquiring 
> i_mutex lock. Meanwhile, I remove DIO_LOCKING flag when __blockdev_direct_IO() 
> is called and do the similar benchmarks. The result shows that the performance 
> in ext4 is almost the same to the xfs. Thus, it proves that the i_mutex heavily
> impacts the performance. Hopefully the result is useful for you. :-)

For the record, I have a patchset that, while not affecting i_mutex (or
locking in general), does allow AIO append writes to actually be done
asynchronously.  (Currently they're forced to be done synchronously.)
It makes a big difference in performance for that particular case, even
for spinning media.  Performance roughly doubled when testing with fio
against a regular two-terabyte drive; the performance improvement
against SSD would have to be much greater.

One day soon I'll accumulate enough spare time to port the patchset
forward to the latest kernel and submit it here.
-- 
Frank Mayhar
fmayhar@google.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
