Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q457ibkD157404 for <xfs@oss.sgi.com>; Sat, 5 May 2012 02:44:37 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id tKY71pIE5crhFbad
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 05 May 2012 00:44:36 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so5343650pbb.26
	for <xfs@oss.sgi.com>; Sat, 05 May 2012 00:44:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
References: <20120423235840.GQ9541@dastard>
	<CADLDEKsfckBw2oVYFfaaTbpe8Ri+rYJr2e5SB7-pM0BU9nRUeA@mail.gmail.com>
	<20120424120731.GT9541@dastard>
	<CADLDEKs01GnxgYh2UTt1waVDUXHbB_RcBcUTBr5REFg5aD5jHA@mail.gmail.com>
	<20120425223845.GX9541@dastard>
	<CADLDEKvYkpUnMrqdMyqCmsYrZcUtiJ6ZRhrRu_ERTjn=r7M3Pg@mail.gmail.com>
	<20120426224412.GA9541@dastard>
	<CADLDEKs6oMDA-6OhmcFxyRoBVpduKtSput=53TQGn9NCAOXC1Q@mail.gmail.com>
	<20120426230738.GB9541@dastard>
	<CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
Date: Sat, 5 May 2012 09:44:35 +0200
Message-ID: <CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
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

>>> >> >> > I'm assuming it is the event trace
>>> >> >> > that is causing it to blow out? If so, just the 30-60s either s=
ide of
>>> >> >> > the hang first showing up is probaby necessary, and that should=
 cut
>>> >> >> > the size down greatly....
>>> >> >>
>>> >> >> Can I shorten the existing trace.dat?
>>
>> Looks like you can - the "trace-cmd split" option.
>>
>>> >> >
>>> >> > No idea, but that's likely the problem - I don't want the binary
>>> >> > trace.dat file. I want the text output of the report command
>>> >> > generated from the binary trace.dat file...
>>> >>
>>> >> Well yes. I did RTFM :-) trace.dat is 15GB.
>>> >
>>> > OK, that's a lot larger than I expected for a hung filesystem....
>>> >
>>> >> >> I stopped the trace
>>> >> >> automatically 10 secs after the the xlog_... trace showed up in s=
yslog
>>> >> >> so effectively some 130+ secs after the hang occured.
>>> >
>>> > Can you look at the last timestamp in the report file, and trim off
>>> > anything from the start that is older than, say, 180s before that?
>>>
>>> Cut the trace down to 180 secs which brought the filesize down to
>>> 93MB: https://region-a.geo-1.objects.hpcloudsvc.com:443/v1.0/AUTH_9630e=
ad2-6194-40df-afd3-7395448d4536/xfs-hang/report-2012-04-24-180secs.tgz
>>
>> I see the problem - the trace.dat file is hosted on an XFS
>> filesystem, so all the writes to the trace.dat file are causing
>> events to be logged, which causes writes to the trace.dat file....
>>
>> taking out al the trace-cmd events:
>>
>> $ grep -v trace-cmd trace_report_180secs.txt > t.t
>> $ ls -l trace_report_180secs.txt t.t
>> -rw-r--r-- 1 dave dave 2136941443 Apr 27 18:52 trace_report_180secs.txt
>> -rw-r--r-- 1 dave dave =A0 =A03280629 Apr 27 20:12 t.t
>>
>> Brings the event trace for that 180s down ifrom 2.1GB to 3.2MB,
>> which is much more like I'd expect from a hung filesystem....
>>
>> Ok, so it looks like there's lots of noise from other XFS
>> filesystems to, and from the info.log, the xfs-hang filesystem is on
>> device 252:2 (/dev/vg00/tmp):
>>
>> $ grep "dev 252:2" t.t
>> $
>>
>> And there are no events from that filesystem in the log at all. Ok,
>> so what you need to do is find out if there are *any* events from
>> that device in the larger log file you have.....
>>
>> If not, then it is time for advanced trace-cmd mojo. We can tell it
>> to filter events only from the PID of the test script and all it's
>> children using:
>>
>> # trace-cmd record -e xfs\* -P <parent-pid> -c
>>
>> But better would be to use the device number of the relevant
>> filesystem to filter the events. The device is 252:2, which means in
>> kernel terms is it:
>>
>> =A0 =A0 =A0 =A0dev =3D (major << 20) | minor
>> =A0 =A0 =A0 =A0 =A0 =A0=3D 0xfc00002
>>
>> So you should be able to get just the xfs-hang events via:
>>
>> # trace-cmd record -e xfs\* -d 'dev =3D=3D 0xfc00002'
>>
>> and as long as you don't host log files on /xfs-hang, it'll only
>> record the workload running on the xfs-hang filesystem.
>
> Third try: https://region-a.geo-1.objects.hpcloudsvc.com:443/v1.0/AUTH_96=
30ead2-6194-40df-afd3-7395448d4536/xfs-hang/report-2012-04-27-180secs.tgz
> Filtered by device, trace events go to a different filesystem.

Did anybody have a chance to look at the data?

Thanks
...Juerg


>
>> BTW, how often do you see this sort of thing:
>>
>> [ =A0220.571551] ------------[ cut here ]------------
>> [ =A0220.571562] WARNING: at fs/inode.c:280 drop_nlink+0x49/0x50()
>> [ =A0220.571564] Hardware name: SE2170s
>> [ =A0220.571565] Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler=
 ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_=
ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_ma=
ngle xt_tcpudp iptable_filter ip_tables x_tables bridge 8021q garp stp core=
temp ghash_clmulni_intel aesni_intel cryptd usbhid i7core_edac lp edac_core=
 hid aes_x86_64 parport serio_raw microcode xfs igb hpsa dca
>> [ =A0220.571594] Pid: 4637, comm: copy-files Not tainted 3.4.0-rc4 #2
>> [ =A0220.571595] Call Trace:
>> [ =A0220.571603] =A0[<ffffffff810508cf>] warn_slowpath_common+0x7f/0xc0
>> [ =A0220.571605] =A0[<ffffffff8105092a>] warn_slowpath_null+0x1a/0x20
>> [ =A0220.571607] =A0[<ffffffff81193319>] drop_nlink+0x49/0x50
>> [ =A0220.571628] =A0[<ffffffffa00701ef>] xfs_droplink+0x2f/0x60 [xfs]
>> [ =A0220.571640] =A0[<ffffffffa0072d58>] xfs_remove+0x2e8/0x3c0 [xfs]
>> [ =A0220.571645] =A0[<ffffffff8163aeee>] ? _raw_spin_lock+0xe/0x20
>> [ =A0220.571656] =A0[<ffffffffa0068248>] xfs_vn_unlink+0x48/0x90 [xfs]
>> [ =A0220.571659] =A0[<ffffffff8118684f>] vfs_unlink+0x9f/0x100
>> [ =A0220.571662] =A0[<ffffffff811893ef>] do_unlinkat+0x1af/0x1e0
>> [ =A0220.571668] =A0[<ffffffff810a8eab>] ? sys_futex+0x7b/0x180
>> [ =A0220.571670] =A0[<ffffffff8118a9a6>] sys_unlink+0x16/0x20
>> [ =A0220.571675] =A0[<ffffffff816431a9>] system_call_fastpath+0x16/0x1b
>>
>> You might want to run xfs-repair over your filesystems to find out
>> how many inodes have bad link counts....
>
> First time I saw it was when I started using 3.4-rc4. I repaired the
> fs before I rerun the test that produced the above data.
>
> ...Juerg
>
>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
