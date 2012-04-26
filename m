Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3QN0Bns105315 for <xfs@oss.sgi.com>; Thu, 26 Apr 2012 18:00:11 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id y7vikK0GfDPMx5ie
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 Apr 2012 16:00:10 -0700 (PDT)
Received: by pbbrr4 with SMTP id rr4so288956pbb.26
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2012 16:00:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120426224412.GA9541@dastard>
References: <CADLDEKsP4DsXf_G07ub+a-ODbrJbsiprRJUX1fJdaQ41TB7+Xg@mail.gmail.com>
	<20120423143843.GN9541@dastard>
	<CADLDEKvFF3FvEHVtmwdWhbM58_jrCRX+Uk9vLBg1hA8sizh5BQ@mail.gmail.com>
	<20120423235840.GQ9541@dastard>
	<CADLDEKsfckBw2oVYFfaaTbpe8Ri+rYJr2e5SB7-pM0BU9nRUeA@mail.gmail.com>
	<20120424120731.GT9541@dastard>
	<CADLDEKs01GnxgYh2UTt1waVDUXHbB_RcBcUTBr5REFg5aD5jHA@mail.gmail.com>
	<20120425223845.GX9541@dastard>
	<CADLDEKvYkpUnMrqdMyqCmsYrZcUtiJ6ZRhrRu_ERTjn=r7M3Pg@mail.gmail.com>
	<20120426224412.GA9541@dastard>
Date: Fri, 27 Apr 2012 01:00:08 +0200
Message-ID: <CADLDEKs6oMDA-6OhmcFxyRoBVpduKtSput=53TQGn9NCAOXC1Q@mail.gmail.com>
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 27, 2012 at 12:44 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Apr 26, 2012 at 02:37:50PM +0200, Juerg Haefliger wrote:
>> On Thu, Apr 26, 2012 at 12:38 AM, Dave Chinner <david@fromorbit.com> wro=
te:
>> > On Tue, Apr 24, 2012 at 08:26:04PM +0200, Juerg Haefliger wrote:
>> >> On Tue, Apr 24, 2012 at 2:07 PM, Dave Chinner <david@fromorbit.com> w=
rote:
>> >> > On Tue, Apr 24, 2012 at 10:55:22AM +0200, Juerg Haefliger wrote:
>> >> >> > Alright, then I need all the usual information. I suspect an eve=
nt
>> >> >> > trace is the only way I'm going to see what is happening. I just
>> >> >> > updated the FAQ entry, so all the necessary info for gathering a
>> >> >> > trace should be there now.
>> >> >> >
>> >> >> > http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_in=
clude_when_reporting_a_problem.3F
>> >> >>
>> >> >> Very good. Will do. What kernel do you want me to run? I would pre=
fer
>> >> >> our current production kernel (2.6.38-8-server) but I understand if
>> >> >> you want something newer.
>> >> >
>> >> > If you can reproduce it on a current kernel - 3.4-rc4 if possible, =
if
>> >> > not a 3.3.x stable kernel would be best. 2.6.38 is simply too old to
>> >> > be useful for debugging these sorts of problems...
>> >>
>> >> OK, I reproduced a hang running 3.4-rc4. The data is here but it's a
>> >> whopping 2GB (yes it's compressed):
>> >> https://region-a.geo-1.objects.hpcloudsvc.com:443/v1.0/AUTH_9630ead2-=
6194-40df-afd3-7395448d4536/xfs-hang/report-2012-04-24.tar
>> >
>> > That's a bit big to be useful, and far bigger than I'm willing to
>> > download given that I'm on the end of a wet piece of string, not a
>> > big fat intarwebby pipe.
>>
>> Fair enough.
>>
>>
>> > I'm assuming it is the event trace
>> > that is causing it to blow out? If so, just the 30-60s either side of
>> > the hang first showing up is probaby necessary, and that should cut
>> > the size down greatly....
>>
>> Can I shorten the existing trace.dat?
>
> No idea, but that's likely the problem - I don't want the binary
> trace.dat file. I want the text output of the report command
> generated from the binary trace.dat file...

Well yes. I did RTFM :-) trace.dat is 15GB.


>> I stopped the trace
>> automatically 10 secs after the the xlog_... trace showed up in syslog
>> so effectively some 130+ secs after the hang occured.
>
> Extract the text report from it, and compress that. For example, a
> trace i've just done:
>
> $ ~/trace-cmd/trace-cmd report > trace.out
> $ ls -ltr |tail -4
> -rw-r--r-- 1 root root =A021430272 Apr 27 08:36 trace.dat
> -rw-r--r-- 1 root root =A010039296 Apr 27 08:36 trace.dat.cpu1
> -rw-r--r-- 1 root root =A010035200 Apr 27 08:36 trace.dat.cpu0
> -rw-r--r-- 1 dave dave =A048255670 Apr 27 08:37 trace.out
> $ gzip trace.out
> $ ls -ltr |tail -4
> -rw-r--r-- 1 root root =A021430272 Apr 27 08:36 trace.dat
> -rw-r--r-- 1 root root =A010039296 Apr 27 08:36 trace.dat.cpu1
> -rw-r--r-- 1 root root =A010035200 Apr 27 08:36 trace.dat.cpu0
> -rw-r--r-- 1 dave dave =A0 2500733 Apr 27 08:37 trace.out.gz
>
> Has 200MB of binary trace data, which generates a 470MB text output
> file, which compresses really well - down to 2.5MB in this case.

Compressed trace_report.txt is 2GB.
Sorry, haven't had the time today to look into this. I'll cut the size
down somehow.

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
