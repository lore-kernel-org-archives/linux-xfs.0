Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3QCbq23053957 for <xfs@oss.sgi.com>; Thu, 26 Apr 2012 07:37:52 -0500
Received: from mail-vx0-f181.google.com (mail-vx0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	zKhy1LBKAjHmhXWR (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Apr 2012 05:37:50 -0700 (PDT)
Received: by vcge1 with SMTP id e1so2136328vcg.26
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2012 05:37:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120425223845.GX9541@dastard>
References: <CADLDEKsP4DsXf_G07ub+a-ODbrJbsiprRJUX1fJdaQ41TB7+Xg@mail.gmail.com>
	<20120423143843.GN9541@dastard>
	<CADLDEKvFF3FvEHVtmwdWhbM58_jrCRX+Uk9vLBg1hA8sizh5BQ@mail.gmail.com>
	<20120423235840.GQ9541@dastard>
	<CADLDEKsfckBw2oVYFfaaTbpe8Ri+rYJr2e5SB7-pM0BU9nRUeA@mail.gmail.com>
	<20120424120731.GT9541@dastard>
	<CADLDEKs01GnxgYh2UTt1waVDUXHbB_RcBcUTBr5REFg5aD5jHA@mail.gmail.com>
	<20120425223845.GX9541@dastard>
Date: Thu, 26 Apr 2012 14:37:50 +0200
Message-ID: <CADLDEKvYkpUnMrqdMyqCmsYrZcUtiJ6ZRhrRu_ERTjn=r7M3Pg@mail.gmail.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
From: Juerg Haefliger <juergh@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 26, 2012 at 12:38 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Apr 24, 2012 at 08:26:04PM +0200, Juerg Haefliger wrote:
>> On Tue, Apr 24, 2012 at 2:07 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Tue, Apr 24, 2012 at 10:55:22AM +0200, Juerg Haefliger wrote:
>> >> > Alright, then I need all the usual information. I suspect an event
>> >> > trace is the only way I'm going to see what is happening. I just
>> >> > updated the FAQ entry, so all the necessary info for gathering a
>> >> > trace should be there now.
>> >> >
>> >> > http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>> >>
>> >> Very good. Will do. What kernel do you want me to run? I would prefer
>> >> our current production kernel (2.6.38-8-server) but I understand if
>> >> you want something newer.
>> >
>> > If you can reproduce it on a current kernel - 3.4-rc4 if possible, if
>> > not a 3.3.x stable kernel would be best. 2.6.38 is simply too old to
>> > be useful for debugging these sorts of problems...
>>
>> OK, I reproduced a hang running 3.4-rc4. The data is here but it's a
>> whopping 2GB (yes it's compressed):
>> https://region-a.geo-1.objects.hpcloudsvc.com:443/v1.0/AUTH_9630ead2-6194-40df-afd3-7395448d4536/xfs-hang/report-2012-04-24.tar
>
> That's a bit big to be useful, and far bigger than I'm willing to
> download given that I'm on the end of a wet piece of string, not a
> big fat intarwebby pipe.

Fair enough.


> I'm assuming it is the event trace
> that is causing it to blow out? If so, just the 30-60s either side of
> the hang first showing up is probaby necessary, and that should cut
> the size down greatly....

Can I shorten the existing trace.dat? I stopped the trace
automatically 10 secs after the the xlog_... trace showed up in syslog
so effectively some 130+ secs after the hang occured.

...Juerg


> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
