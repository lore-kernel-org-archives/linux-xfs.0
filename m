Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4J7Swug083287 for <xfs@oss.sgi.com>; Sat, 19 May 2012 02:28:58 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id 6yFX7g2NfacusFJG
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 May 2012 00:28:56 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so5759249pbb.26
	for <xfs@oss.sgi.com>; Sat, 19 May 2012 00:28:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120518171959.GQ16099@sgi.com>
References: <CADLDEKvYkpUnMrqdMyqCmsYrZcUtiJ6ZRhrRu_ERTjn=r7M3Pg@mail.gmail.com>
	<20120426224412.GA9541@dastard>
	<CADLDEKs6oMDA-6OhmcFxyRoBVpduKtSput=53TQGn9NCAOXC1Q@mail.gmail.com>
	<20120426230738.GB9541@dastard>
	<CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507171908.GA16881@sgi.com>
	<CADLDEKvgT_FcGhJKoPaQv0mh_Jqdaqu8SYatc9xxU7vOY217YQ@mail.gmail.com>
	<20120518171959.GQ16099@sgi.com>
Date: Sat, 19 May 2012 09:28:55 +0200
Message-ID: <CADLDEKssiOCVRknW3hYtxDxYHSyGr6qfepfai+UymsD6zMGopw@mail.gmail.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

Hi Ben,

> Hey Juerg,
>
> On Wed, May 09, 2012 at 09:54:08AM +0200, Juerg Haefliger wrote:
>> > On Sat, May 05, 2012 at 09:44:35AM +0200, Juerg Haefliger wrote:
>> >> Did anybody have a chance to look at the data?
>> >
>> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/979498
>> >
>> > Here you indicate that you have created a reproducer. =A0Can you post =
it to the list?
>>
>> Canonical attached them to the bug report that they filed yesterday:
>> http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D922
>
> I'm interested in understanding to what extent the hang you see in produc=
tion
> on 2.6.38 is similar to the hang of the reproducer. =A0Mark is seeing a s=
ituation
> where there is nothing on the AIL and is clogged up in the CIL, others are
> seeing items on the AIL that don't seem to be making progress. =A0Could y=
ou
> provide a dump or traces from a hang on a filesystem with a normal sized =
log?
> Can the reproducer hit the hang eventually without resorting to the tiny =
log?

I'm not certain that the reproducer hang is identical to the
production hang. One difference that I've noticed is that a reproducer
hang can be cleared with an emergency sync while a production hang
can't. I'm working on trying to get a trace from a production machine.
Any ideas how to do the tracing without filling up the filesystem with
trace data? I need to run it for at least a week to catch a hang. I
was thinking of tracing in 15 min batches and just keeping 30 mins
worth of trace data but that will leave some gaps when I stop/restart
the tracing. I'm not familiar with ftrace, maybe it provides the
functionality to do some sort of ring buffer dumping to only keep the
last x mins of data?

Thanks
...Juerg


> Regards,
> =A0 =A0 =A0 =A0Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
