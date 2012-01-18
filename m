Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0IBwdSC207873 for <xfs@oss.sgi.com>; Wed, 18 Jan 2012 05:58:39 -0600
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	eE6ltoh7IonoF13H for <xfs@oss.sgi.com>;
	Wed, 18 Jan 2012 03:58:38 -0800 (PST)
Received: by iagz35 with SMTP id z35so12073880iag.26
	for <xfs@oss.sgi.com>; Wed, 18 Jan 2012 03:58:37 -0800 (PST)
Date: Wed, 18 Jan 2012 20:02:23 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: working on extent locks for i_mutex
Message-ID: <20120118120223.GA4322@gmail.com>
References: <4F0F9E97.1090403@linux.vnet.ibm.com>
	<20120113043411.GH2806@dastard>
	<4F10992C.3070303@linux.vnet.ibm.com>
	<20120115235747.GA6922@dastard>
	<4F146275.8090304@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F146275.8090304@linux.vnet.ibm.com>
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
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: Lukas Czerner <lczerner@redhat.com>, Tao Ma <tm@tao.ma>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Jan 16, 2012 at 10:46:29AM -0700, Allison Henderson wrote:
> On 01/15/2012 04:57 PM, Dave Chinner wrote:
> >On Fri, Jan 13, 2012 at 01:50:52PM -0700, Allison Henderson wrote:
> >>On 01/12/2012 09:34 PM, Dave Chinner wrote:
> >>>On Thu, Jan 12, 2012 at 08:01:43PM -0700, Allison Henderson wrote:
> >>>>Hi All,
> >>>>
> >>>>I know this is an old topic, but I am poking it again because I've
> >>>>had some work items wrap up, and Im planning on picking up on this
> >>>>one again.  I am thinking about implementing extent locks to replace
> >>>>i_mutex.  So I just wanted to touch base with folks and see what
> >>>>people are working on because I know there were some folks out there
> >>>>that were thing about doing similar solutions.
> >>>
> >>>What locking API are you looking at? If you are looking at an
> >>>something like:
> >>>
> >>>read_range_{try}lock(lock, off, len)
> >>>read_range_unlock(lock, off, len)
> >>>write_range_{try}lock(lock, off, len)
> >>>write_range_unlock(lock, off, len)
> >>>
> >>>and implementing with an rbtree or a btree for tracking, then I
> >>>definitely have a use for it in XFS - replacing the current rwsem
> >>>that is used for the iolock. Range locks like this are the only
> >>>thing we need to allow concurrent buffered writes to the same file
> >>>to maintain the per-write exclusion that posix requires.
> >>
> >>Yes that is generally the idea I was thinking about doing, but at
> >>the time, I was not thinking outside the scope of ext4.  You are
> >>thinking maybe it should be in vfs layer so that it's something that
> >>all the filesystems will use?  That seems to be the impression I'm
> >>getting from folks.  Thx!
> >
> >Yes, that's what I'm suggesting. Not so much a vfs layer function,
> >but a library (range locks could be useful outside filesystems) so
> >locating it in lib/ was what I was thinking....
> >
> >Cheers,
> >
> >Dave.
> 
> Alrighty, that sounds good to me.  I will aim to keep it as general
> purpose as I can.  I am going to start some proto typing and will
> post back when I get something working.  Thx for the feedback all!
> :)

Hi Allison,

For this project, do you have a schedule? Would you like to share to me? This
lock contention heavily impacts the performance of direct IO in our production
environment. So we hope to improve it ASAP.

I have done some direct IO benchmarks to compare ext4 with xfs using fio
in Intel SSD. The result shows that, in direct IO, xfs outperforms ext4 and
ext4 with dioread_nolock.

To understand the effect of lock contention, I define a new function called 
ext4_file_aio_write() that calls __generic_file_aio_write() without acquiring 
i_mutex lock. Meanwhile, I remove DIO_LOCKING flag when __blockdev_direct_IO() 
is called and do the similar benchmarks. The result shows that the performance 
in ext4 is almost the same to the xfs. Thus, it proves that the i_mutex heavily
impacts the performance. Hopefully the result is useful for you. :-)

I post the result in here.

config file:
[global]
filesize=64G
size=64G
bs=16k
ioengine=psync
direct=1
filename=/mnt/ext4/benchmark
runtime=600
group_reporting
thread

[randrw]
numjobs=32
rw=randrw
rwmixread=90

result:

iops			1 (r/w)		2		3
ext4			5584/622	5726/636	5719/636
ext4+dioread_nolock	7105/789	7117/793	7129/795
ext4+dio_nolock		8920/992	8956/995	8976/997
xfs			8726/971	8962/994	8975/998

bandwidth		1 (r/w)		2		3		KB/s
ext4			89359/9955.3	91621/10186	91519/10185
ext4+dioread_nolock	113691/12635	113882/12692	114066/12728
ext4+dio_nolock		142731/15888	143301/15930	143617/15959
xfs			139627/15537	143400/15914	143603/15980

latency			1 (r/w)		2		3		usec
ext4			5163.28/5048.31	5037.81/4914.82	5041.49/4932.81
ext4+dioread_nolock	1220.04/29510.5 1213.67/29418.9 1208.77/29361.49
ext4+dio_nolock		3226.61/3194.35	3214.59/3178.09	3207.34/3173.78
xfs			3299.87/3266.32	3213.73/3182.20	3208.16/3178.10

Regards,
Zheng

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
