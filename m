Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3OIQ6Xa096222 for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 13:26:07 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id Sx4GBLAxftI0s1T8
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 24 Apr 2012 11:26:04 -0700 (PDT)
Received: by pbcuo1 with SMTP id uo1so691435pbc.26
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 11:26:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120424120731.GT9541@dastard>
References: <CADLDEKsP4DsXf_G07ub+a-ODbrJbsiprRJUX1fJdaQ41TB7+Xg@mail.gmail.com>
	<20120423143843.GN9541@dastard>
	<CADLDEKvFF3FvEHVtmwdWhbM58_jrCRX+Uk9vLBg1hA8sizh5BQ@mail.gmail.com>
	<20120423235840.GQ9541@dastard>
	<CADLDEKsfckBw2oVYFfaaTbpe8Ri+rYJr2e5SB7-pM0BU9nRUeA@mail.gmail.com>
	<20120424120731.GT9541@dastard>
Date: Tue, 24 Apr 2012 20:26:04 +0200
Message-ID: <CADLDEKs01GnxgYh2UTt1waVDUXHbB_RcBcUTBr5REFg5aD5jHA@mail.gmail.com>
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

On Tue, Apr 24, 2012 at 2:07 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Apr 24, 2012 at 10:55:22AM +0200, Juerg Haefliger wrote:
>> On Tue, Apr 24, 2012 at 1:58 AM, Dave Chinner <david@fromorbit.com> wrot=
e:
>> > On Mon, Apr 23, 2012 at 05:33:40PM +0200, Juerg Haefliger wrote:
>> >> Hi Dave,
>> >>
>> >>
>> >> On Mon, Apr 23, 2012 at 4:38 PM, Dave Chinner <david@fromorbit.com> w=
rote:
>> >> > On Mon, Apr 23, 2012 at 02:09:53PM +0200, Juerg Haefliger wrote:
>> >> >> Hi,
>> >> >>
>> >> >> I have a test system that I'm using to try to force an XFS filesys=
tem
>> >> >> hang since we're encountering that problem sporadically in product=
ion
>> >> >> running a 2.6.38-8 Natty kernel. The original idea was to use this
>> >> >> system to find the patches that fix the issue but I've tried a who=
le
>> >> >> bunch of kernels and they all hang eventually (anywhere from 5 to =
45
>> >> >> mins) with the stack trace shown below.
>> >> >
>> >> > If you kill the workload, does the file system recover normally?
>> >>
>> >> The workload can't be killed.
>> >
>> > OK.
>> >
>> >> >> Only an emergency flush will
>> >> >> bring the filesystem back. I tried kernels 3.0.29, 3.1.10, 3.2.15,
>> >> >> 3.3.2. From reading through the mail archives, I get the impression
>> >> >> that this should be fixed in 3.1.
>> >> >
>> >> > What you see is not necessarily a hang. It may just be that you've
>> >> > caused your IO subsystem to have so much IO queued up it's complete=
ly
>> >> > overwhelmed. How much RAM do you have in the machine?
>> >>
>> >> When it hangs, there are zero IOs going to the disk. The machine has
>> >> 100GB of RAM.
>> >
>> > Can you get an event trace across the period where the hang occurs?
>> >
>> > ....
>> >
>> >> >> I can't seem to hit the problem without the above modifications.
>> >> >
>> >> > How on earth did you come up with this configuration?
>> >>
>> >> Just plain ol' luck. I was looking for a configuration that would
>> >> allow me to reproduce the hangs and I accidentally picked a machine
>> >> with a faulty controller battery which disabled the cache.
>> >
>> > Wonderful.
>> >
>> >> >> For the IO workload I pre-create 8000 files with random content and
>> >> >> sizes between 1k and 128k on the test partition. Then I run a tool
>> >> >> that spawns a bunch of threads which just copy these files to a
>> >> >> different directory on the same partition.
>> >> >
>> >> > So, your workload also has a significant amount parallelism and
>> >> > concurrency on a filesytsem with only 4 AGs?
>> >>
>> >> Yes. Excuse my ignorance but what are AGs?
>> >
>> > Allocation groups.
>> >
>> >> >> At the same time there are
>> >> >> other threads that rename, remove and overwrite random files in the
>> >> >> destination directory keeping the file count at around 500.
>> >> >
>> >> > And you've added as much concurrent metadata modification as
>> >> > possible, too, which makes me wonder.....
>> >> >
>> >> >> Let me know what other information I can provide to pin this down.
>> >> >
>> >> > .... exactly what are you trying to acheive with this test? =A0From=
 my
>> >> > point of view, you're doing something completely and utterly insane.
>> >> > You filesystem config and workload is so far outside normal
>> >> > configurations and workloads that I'm not surprised you're seeing
>> >> > some kind of problem.....
>> >>
>> >> No objection from my side. It's a silly configuration but it's the
>> >> only one I've found that lets me reproduce a hang at will.
>> >
>> > Ok, that's fair enough - it's handy to tell us that up front,
>> > though. =A0;)
>>
>> Ah sorry for not being clear enough. I thought my intentions could be
>> deduced from the information that I provided :-)
>>
>>
>> > Alright, then I need all the usual information. I suspect an event
>> > trace is the only way I'm going to see what is happening. I just
>> > updated the FAQ entry, so all the necessary info for gathering a
>> > trace should be there now.
>> >
>> > http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_=
when_reporting_a_problem.3F
>>
>> Very good. Will do. What kernel do you want me to run? I would prefer
>> our current production kernel (2.6.38-8-server) but I understand if
>> you want something newer.
>
> If you can reproduce it on a current kernel - 3.4-rc4 if possible, if
> not a 3.3.x stable kernel would be best. 2.6.38 is simply too old to
> be useful for debugging these sorts of problems...

OK, I reproduced a hang running 3.4-rc4. The data is here but it's a
whopping 2GB (yes it's compressed):
https://region-a.geo-1.objects.hpcloudsvc.com:443/v1.0/AUTH_9630ead2-6194-4=
0df-afd3-7395448d4536/xfs-hang/report-2012-04-24.tar

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
