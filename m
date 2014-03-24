Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 079B57F4E
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2014 08:40:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E05BE8F8064
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2014 06:40:53 -0700 (PDT)
Received: from smtp2.ispfabriek.nl (smtp2.ispfabriek.nl [37.251.0.169]) by
	cuda.sgi.com with ESMTP id n3GHwovlomvgGpe6 for
	<xfs@oss.sgi.com>; Mon, 24 Mar 2014 06:40:48 -0700 (PDT)
Message-ID: <533035CF.6050807@1st-setup.nl>
Date: Mon, 24 Mar 2014 14:40:31 +0100
From: "Michel Verbraak(1st-Setup)" <info@1st-setup.nl>
MIME-Version: 1.0
Subject: Re: xfs blocks (blocked for more than 120 seconds)
References: <532FF9DD.5080700@1st-setup.nl> <533032C6.8090800@sgi.com>
In-Reply-To: <533032C6.8090800@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2098236494985366760=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============2098236494985366760==
Content-Type: multipart/alternative;
 boundary="------------020108000003080303060109"

This is a multi-part message in MIME format.
--------------020108000003080303060109
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

op 24-03-14 14:27, Mark Tinguely schreef:
> On 03/24/14 04:24, Michel Verbraak(1st-Setup) wrote:
>> Hi,
>>
>> We have a problem with one of our systems which is using XFS but we are
>> unable to find the problem. Recently we had two moments, Tuesday 4th of
>> March and Friday the 21st of March, where we had to reboot the system to
>> get it up and running again.
>>
>> What happens:
>> - The programs handling files on the XFS disc stop working when
>> creating, deleting or writing files. They do not error they are just
>> waiting on the command to complete.
>> - One of our programs, a java application, goes into very high cpu usage
>> (50%) which normally is at 1%. This could be something in our java
>> application but it happens at the moment handling files gets stuck.
>> - A nice restart of the programs does not succeed as wel a kill -9 does
>> not work.
>> - Trying to reboot the servers in a normal fashion does not work. As it
>> is a virtual machine we have to do a shutdown (unplug power) and start
>> it up again to get it up and running.
>>
>> Following details I have for you:
>>
>> System OS: Ubuntu 12.04 LTS
>> Kernel: 3.2.0-37-generic #58-Ubuntu SMP Thu Jan 24 15:28:10 UTC 2013
>> x86_64 x86_64 x86_64 GNU/Linux
>> Server: Virtual machine in a VMWare setup.
>> Disc: 300GB direct attached LUN
>>
>> We have an exact clone of this system for our acceptance environment. In
>> this environment we are unable to reproduce this problem/situation.
>>
>> Differences between the two days is that our services on 2014-03-21 were
>> quit busy with a lot of file changes on the xfs disc and on 2014-03-04
>> the system was very quiet on the moment the kernel traces appear and the
>> services get stuck.
>>
>> Any help is appreciated.
>>
>> Regards Michel Verbraak.
>
>
> Could you set up kdump and take a core dump next time it hangs?
> There is a couple suspicious items in the syslog entries
>
> --Mark.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
Mark,

We will setup the kdump. Can you elloborate on your suspicions?

Michel.

--------------020108000003080303060109
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
  </head>
  <body text="#666666" bgcolor="#FFFFFF">
    <div class="moz-cite-prefix">op 24-03-14 14:27, Mark Tinguely
      schreef:<br>
    </div>
    <blockquote cite="mid:533032C6.8090800@sgi.com" type="cite">On
      03/24/14 04:24, Michel Verbraak(1st-Setup) wrote:
      <br>
      <blockquote type="cite">Hi,
        <br>
        <br>
        We have a problem with one of our systems which is using XFS but
        we are
        <br>
        unable to find the problem. Recently we had two moments, Tuesday
        4th of
        <br>
        March and Friday the 21st of March, where we had to reboot the
        system to
        <br>
        get it up and running again.
        <br>
        <br>
        What happens:
        <br>
        - The programs handling files on the XFS disc stop working when
        <br>
        creating, deleting or writing files. They do not error they are
        just
        <br>
        waiting on the command to complete.
        <br>
        - One of our programs, a java application, goes into very high
        cpu usage
        <br>
        (50%) which normally is at 1%. This could be something in our
        java
        <br>
        application but it happens at the moment handling files gets
        stuck.
        <br>
        - A nice restart of the programs does not succeed as wel a kill
        -9 does
        <br>
        not work.
        <br>
        - Trying to reboot the servers in a normal fashion does not
        work. As it
        <br>
        is a virtual machine we have to do a shutdown (unplug power) and
        start
        <br>
        it up again to get it up and running.
        <br>
        <br>
        Following details I have for you:
        <br>
        <br>
        System OS: Ubuntu 12.04 LTS
        <br>
        Kernel: 3.2.0-37-generic #58-Ubuntu SMP Thu Jan 24 15:28:10 UTC
        2013
        <br>
        x86_64 x86_64 x86_64 GNU/Linux
        <br>
        Server: Virtual machine in a VMWare setup.
        <br>
        Disc: 300GB direct attached LUN
        <br>
        <br>
        We have an exact clone of this system for our acceptance
        environment. In
        <br>
        this environment we are unable to reproduce this
        problem/situation.
        <br>
        <br>
        Differences between the two days is that our services on
        2014-03-21 were
        <br>
        quit busy with a lot of file changes on the xfs disc and on
        2014-03-04
        <br>
        the system was very quiet on the moment the kernel traces appear
        and the
        <br>
        services get stuck.
        <br>
        <br>
        Any help is appreciated.
        <br>
        <br>
        Regards Michel Verbraak.
        <br>
      </blockquote>
      <br>
      <br>
      Could you set up kdump and take a core dump next time it hangs?
      <br>
      There is a couple suspicious items in the syslog entries
      <br>
      <br>
      --Mark.
      <br>
      <br>
      _______________________________________________
      <br>
      xfs mailing list
      <br>
      <a class="moz-txt-link-abbreviated" href="mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a>
      <br>
      <a class="moz-txt-link-freetext" href="http://oss.sgi.com/mailman/listinfo/xfs">http://oss.sgi.com/mailman/listinfo/xfs</a>
      <br>
    </blockquote>
    <font size="-1"><font face="DejaVu Sans">Mark,<br>
        <br>
        We will setup the kdump. Can you elloborate on your suspicions?<br>
        <br>
        Michel.<br>
      </font></font>
  </body>
</html>

--------------020108000003080303060109--


--===============2098236494985366760==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2098236494985366760==--
