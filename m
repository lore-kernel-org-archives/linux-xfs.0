Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6F08E7F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 15:31:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6054C8F8050
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 13:31:34 -0800 (PST)
Received: from mail-lf0-f47.google.com (mail-lf0-f47.google.com
	[209.85.215.47]) by cuda.sgi.com with ESMTP id nT83BlNhGpWdPHLy
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 13:31:32 -0800 (PST)
Received: by lfdl133 with SMTP id l133so26327363lfd.2
	for <xfs@oss.sgi.com>; Tue, 01 Dec 2015 13:31:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <565E0FFD.70507@scylladb.com>
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130141000.GC24765@bfoster.bfoster>
	<565C5D39.8080300@scylladb.com>
	<20151130161438.GD24765@bfoster.bfoster>
	<565D639F.8070403@scylladb.com>
	<20151201131114.GA26129@bfoster.bfoster>
	<565DA784.5080003@scylladb.com>
	<20151201145631.GD26129@bfoster.bfoster>
	<565DBB3E.2010308@scylladb.com> <20151201210417.GY19199@dastard>
	<565E0FFD.70507@scylladb.com>
Date: Tue, 1 Dec 2015 16:31:30 -0500
Message-ID: <CAD-J=zbCy1v9T4AyX7_g37z8ZepBrqcr_UG5Wjm0_=Sxk=2AgA@mail.gmail.com>
Subject: Re: sleeps and waits during io_submit
From: Glauber Costa <glauber@scylladb.com>
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
To: Avi Kivity <avi@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

>
>>> That is, the code called by io_submit()
>>> (file_operations::write_iter, it seems to be called today) can kick
>>> off this operation and have it continue from where it left off.
>>
>> This is a problem that people have tried to solve in the past (e.g.
>> syslets, etc) where the thread executes until it has to block, and
>> then it's handled off to a worker thread/syslet to block and the
>> main process returns with EIOCBQUEUED.
>
>
> Yes, I remember that.
>
>> Basically, you're asking for a real AIO infrastructure to
>> beintroduced into the kernel, and I think that's beyond what us XFS
>> guys can do...
>
>
> Sure you can, Dave.  In fact you feel an irresistible urge to do it.

What is that? Are you that anxious for the Star Wars premiere that you
are trying your very own jedi mind tricks??


> I do now. What's the unicode for a crying face?
>
>> Hence if you are seeing delays in transactions (e.g. timestamp updates)
>> it's entirely possible that things will get much better if you
>> remove the discard mount option. It's much better from a performance
>> perspective to use the fstrim command every so often - fstrim issues
>> discard operations in the context of the fstrim process - it does
>> not interact with the transaction subsystem at all.
>>
>>
>
> All right.  On the other hand we have to know when to issue it. That would
> be when nn% of the disk area have been rewritten.  Is there some counter I
> can poll every minute or so for this?  Not doing the fstrim in time would
> cause the disk performance to tank.

Note, as I said, that while this is a really good general
recommendation from down under, that was not likely to have had any
effect in the current trace - that disk does not support discard, and
I am assuming the mount option becomes a noop in this case.

>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
