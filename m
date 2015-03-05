Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0042E7F3F
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 11:06:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E083130406A
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 09:05:59 -0800 (PST)
Received: from darcachon.resolversystems.com (darcachon.resolversystems.com
	[80.68.93.186]) by cuda.sgi.com with ESMTP id cTX4aVCt8tebcXuu
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 Mar 2015 09:05:56 -0800 (PST)
Message-ID: <54F88CEC.4030009@pythonanywhere.com>
Date: Thu, 05 Mar 2015 17:05:48 +0000
From: Harry <harry@pythonanywhere.com>
MIME-Version: 1.0
References: <54EC958E.2000001@pythonanywhere.com>	<20150224215907.GA18360@dastard>	<54EF1A8F.7030505@pythonanywhere.com>
	<54F856E7.10006@pythonanywhere.com> <54F87BF3.3000405@sandeen.net>
In-Reply-To: <54F87BF3.3000405@sandeen.net>
Subject: Re: trying to avoid a lengthy quotacheck by deleting all quota data
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4455896170897902546=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: "developers@pythonanywhere.com" <developers@pythonanywhere.com>

This is a multi-part message in MIME format.
--===============4455896170897902546==
Content-Type: multipart/alternative;
 boundary="------------070106080608030908060004"

This is a multi-part message in MIME format.
--------------070106080608030908060004
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Thanks for the reply Eric.

One of our problems is that we're limited in terms of what manipulations 
we can apply to the live system, and so instead we've been running our 
experiments against the backup system, and you're quite right that DRBD 
may be introducing some weirdness of its own, so those experiments may 
not be safe to draw conclusions from.

Here's what we know about the live system
-> it had an outage, equivalent to having its power cable yanked, or 
doing an 'echo b > /proc/sysrq-trigger'
-> when it came back, it decided to mount the drive without quotas.
-> we saw a message in syslog saying " Failed to initialize disk quotas"
-> last time we had to run a quotacheck (several months ago) it took 
about 2 hours.

We can repro the quotacheck issue on our test clusters, as follows:
-> kick off a job that writes to the disk
-> hard reboot with "echo b > /proc/sysrq-trigger"
-> on next boot, see "Failed to initialize disk quotas" message, xfs 
mounts without quotas
-> soft reboot with "reboot"
-> on next boot, see "Quotacheck needed: Please wait." message.
-> Quotacheck completes some time later.

So our best-case scenario is that, next time we reboot, we'll have an 
outage of about 2 hours.  And our paranoid worst-case scenario, induced 
by our experiments with our drbd backup drives, are that the disk will 
actually turn out not to be mountable at all.

is that "quotacheck always required after hard reboot" behaviour that 
we're observing something you expected?  you seemed to be saying that 
the fact that quota are journaled should mean it's not needed?

HP

On 05/03/15 15:53, Eric Sandeen wrote:
> On 3/5/15 7:15 AM, Harry wrote:
>> Update -- so far, we've not managed to gain any confidence that we'll
>> ever be able to re-mount that disk. The general consensus seems to be
>> to fish all the data off the disk using rsync, and then move off XFS
>> to ext4.
>>
>> Not a very helpful message for y'all to hear, I know. But if it's any
>> help in prioritising your future work, i think the dealbreaker for us
>> was the inescapable quotacheck on mount, which means that any time a
>> fileserver goes down unexpectedly, we have an unavoidable,
>> indeterminate-but-long period of downtime...
>>
>> hp
> What you decide to use is up to you of course, and causes us no
> heartbreak.  :)  But I think you fundamentally misunderstand the situation;
> an unexpected fileserver failure should not result in a lengthy quotacheck
> on xfs, because xfs quota is journaled, and will simply be replayed along with
> the rest of the log.
>
> I honestly don't know what has led you to the conclusion that remounting
> the filesystem will lead to any quotacheck at all, let alone a lengthy one.
>
>> * We're even a bit worried the disk might be in a broken state, such
>> that the quotacheck won't actually complete successfully at all.
> If your disk is broken, that's not a filesystem issue.  It seems possible
> that whatever drbd manipulation you're doing is causing an issue, but because
> you haven't really explained it in detail, I don't know.
>
>> We take DRBD offline, so it's no longer writing, then we take
>> snapshots of the drives, then remount those elsewhere so we can
>> experiment without disturbing the live system.
> Did you quiesce the filesystem first with i.e. xfs_freeze?
>
> So far this thread has been long on prose and speculation, and short
> on actual analysis, log messages, etc.  Feel free to use ext4 or whatever
> suits you, but given that nothing in this thread has implicated misbehavior
> by xfs, I don't think that switching filesystems will solve the perceived
> problem.
>
> -Eric

Rgds,
Harry + the PythonAnywhere team.

-- 
Harry Percival
Developer
harry@pythonanywhere.com

PythonAnywhere - a fully browser-based Python development and hosting environment
<http://www.pythonanywhere.com/>

PythonAnywhere LLP
17a Clerkenwell Road, London EC1M 5RD, UK
VAT No.: GB 893 5643 79
Registered in England and Wales as company number OC378414.
Registered address: 28 Ely Place, 3rd Floor, London EC1N 6TD, UK


--------------070106080608030908060004
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta content="text/html; charset=windows-1252"
      http-equiv="Content-Type">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    Thanks for the reply Eric.<br>
    <br>
    One of our problems is that we're limited in terms of what
    manipulations we can apply to the live system, and so instead we've
    been running our experiments against the backup system, and you're
    quite right that DRBD may be introducing some weirdness of its own,
    so those experiments may not be safe to draw conclusions from.<br>
    <br>
    Here's what we know about the live system<br>
    -&gt; it had an outage, equivalent to having its power cable yanked,
    or doing an 'echo b &gt; /proc/sysrq-trigger'<br>
    -&gt; when it came back, it decided to mount the drive without
    quotas.<br>
    -&gt; we saw a message in syslog saying "
    <meta http-equiv="content-type" content="text/html;
      charset=windows-1252">
    Failed to initialize disk quotas"<br>
    -&gt; last time we had to run a quotacheck (several months ago) it
    took about 2 hours.<br>
    <br>
    We can repro the quotacheck issue on our test clusters, as follows:<br>
    -&gt; kick off a job that writes to the disk<br>
    -&gt; hard reboot with "echo b &gt; /proc/sysrq-trigger"<br>
    -&gt; on next boot, see "Failed to initialize disk quotas" message,
    xfs mounts without quotas<br>
    -&gt; soft reboot with "reboot"<br>
    -&gt; on next boot, see "Quotacheck needed: Please wait." message.<br>
    -&gt; Quotacheck completes some time later.<br>
    <br>
    So our best-case scenario is that, next time we reboot, we'll have
    an outage of about 2 hours.  And our paranoid worst-case scenario,
    induced by our experiments with our drbd backup drives, are that the
    disk will actually turn out not to be mountable at all.<br>
    <br>
    is that "quotacheck always required after hard reboot" behaviour
    that we're observing something you expected?  you seemed to be
    saying that the fact that quota are journaled should mean it's not
    needed?<br>
    <br>
    HP<br>
    <br>
    <div class="moz-cite-prefix">On 05/03/15 15:53, Eric Sandeen wrote:<br>
    </div>
    <blockquote cite="mid:54F87BF3.3000405@sandeen.net" type="cite">
      <pre wrap="">On 3/5/15 7:15 AM, Harry wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">Update -- so far, we've not managed to gain any confidence that we'll
ever be able to re-mount that disk. The general consensus seems to be
to fish all the data off the disk using rsync, and then move off XFS
to ext4.

Not a very helpful message for y'all to hear, I know. But if it's any
help in prioritising your future work, i think the dealbreaker for us
was the inescapable quotacheck on mount, which means that any time a
fileserver goes down unexpectedly, we have an unavoidable,
indeterminate-but-long period of downtime...

hp
</pre>
      </blockquote>
      <pre wrap="">
What you decide to use is up to you of course, and causes us no
heartbreak.  :)  But I think you fundamentally misunderstand the situation;
an unexpected fileserver failure should not result in a lengthy quotacheck
on xfs, because xfs quota is journaled, and will simply be replayed along with
the rest of the log.

I honestly don't know what has led you to the conclusion that remounting
the filesystem will lead to any quotacheck at all, let alone a lengthy one.

</pre>
      <blockquote type="cite">
        <pre wrap="">* We're even a bit worried the disk might be in a broken state, such
that the quotacheck won't actually complete successfully at all.
</pre>
      </blockquote>
      <pre wrap="">
If your disk is broken, that's not a filesystem issue.  It seems possible
that whatever drbd manipulation you're doing is causing an issue, but because
you haven't really explained it in detail, I don't know.

</pre>
      <blockquote type="cite">
        <pre wrap="">We take DRBD offline, so it's no longer writing, then we take
snapshots of the drives, then remount those elsewhere so we can
experiment without disturbing the live system.
</pre>
      </blockquote>
      <pre wrap="">
Did you quiesce the filesystem first with i.e. xfs_freeze?

So far this thread has been long on prose and speculation, and short
on actual analysis, log messages, etc.  Feel free to use ext4 or whatever
suits you, but given that nothing in this thread has implicated misbehavior
by xfs, I don't think that switching filesystems will solve the perceived
problem.

-Eric
</pre>
    </blockquote>
    <br>
    <pre class="moz-signature" cols="72">Rgds,
Harry + the PythonAnywhere team.

-- 
Harry Percival
Developer
<a class="moz-txt-link-abbreviated" href="mailto:harry@pythonanywhere.com">harry@pythonanywhere.com</a>

PythonAnywhere - a fully browser-based Python development and hosting environment
<a class="moz-txt-link-rfc2396E" href="http://www.pythonanywhere.com/">&lt;http://www.pythonanywhere.com/&gt;</a>

PythonAnywhere LLP
17a Clerkenwell Road, London EC1M 5RD, UK
VAT No.: GB 893 5643 79
Registered in England and Wales as company number OC378414.
Registered address: 28 Ely Place, 3rd Floor, London EC1N 6TD, UK
</pre>
  </body>
</html>

--------------070106080608030908060004--


--===============4455896170897902546==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4455896170897902546==--
