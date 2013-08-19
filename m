Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8F6757F59
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 22:55:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A23A304032
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 20:55:24 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	hzWYTtZwnHPYqOI2 for <xfs@oss.sgi.com>;
	Sun, 18 Aug 2013 20:55:22 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 3FAA21F003F5
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 23:55:22 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id zoWmBprgEIRl for <xfs@oss.sgi.com>;
	Sun, 18 Aug 2013 23:55:20 -0400 (EDT)
Received: from 145-169-1-30.pools.spcsdns.net (66-87-123-145.pools.spcsdns.net
	[66.87.123.145])
	by benjamin.baylink.com (Postfix) with ESMTPSA id 5FE2E1F003E7
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 23:55:20 -0400 (EDT)
References: <11558272.4016.1376861936621.JavaMail.root@benjamin.baylink.com>
	<5211455B.3000409@hardwarefreak.com>
In-Reply-To: <5211455B.3000409@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS recovery resumes...
From: Jay Ashworth <jra@baylink.com>
Date: Sun, 18 Aug 2013 23:55:18 -0400
Message-ID: <6f8bb504-c786-4bc0-9327-ee58a40d99e2@email.android.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9015677013621210074=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============9015677013621210074==
Content-Type: multipart/alternative; boundary="----G8X6HRAC0KEWMQ1WIFD7AIY4DDY0U2"

------G8X6HRAC0KEWMQ1WIFD7AIY4DDY0U2
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit

Still the same outage from 2 weeks ago, Stan; my script had nothing to do with breaking the FSs. Was a zorched power supply, almost certainly. 

And in fact, after 32 years adminning *nix boxes for a living, yes, I do expect that if any userland program can /corrupt/ FS internals without twiddling with /dev/sdX, either the FS is broken or the hardware is.

In this case I'm quite certain it /was/ the hardware, and 85-90% confident it's fixed now.

Cheers,
-jra
-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.

Stan Hoeppner <stan@hardwarefreak.com> wrote:

On 8/18/2013 4:38 PM, Jay Ashworth wrote:
> I'm trying to dedupe the two large XFS filesystems on which I have DVR 
> recordings, so that I can walk around amongst the available HDDs and create
> new filesystems under everything.
> 
> Every time I rm a file, the filesystem blows up, and the driver shuts it
> down. 
> 
> Some background:
> 
> At the moment, I have 2 devices, /dev/sdd1 mounted on /appl/media4, and
> /dev/sda1 mounted on /appl/media5, and a large script, created by hand-
> hacking the output of a perl dupe finder script.
> 
> The large script was mangled so that it would remove anything that was a 
> dupe from media4, unless the file was an unlabeled lost+found on media5,
> and had a name on media4. In that case, I removed the file on media5, and
> then moved it from media4 to media5.
> 
> After the hand-hacking on the script, I sorted it to do all the rm's first,
> and then all the mv's, to make sure free space when up before it went down.
> 
> And, of course, when I ran the script, it caused the XFS driver to cough and
> die, leading to error 5s and gnashing of teeth.

If this script is the catalyst of your XFS problems, it seems logical
that you would include said script in your trouble report, yet you did
not. It's a bit foolish to assume you can't break a Linux subsystem
with a poorly written program and/or in combination with a platform that
isn't up to the task being asked of it. As Joe mentioned having too
little RAM could be part of this problem.

-- 
Stan



------G8X6HRAC0KEWMQ1WIFD7AIY4DDY0U2
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: 8bit

<html><head></head><body>Still the same outage from 2 weeks ago, Stan; my script had nothing to do with breaking the FSs.  Was a zorched power supply, almost certainly. <br>
<br>
And in fact, after 32 years adminning *nix boxes for a living, yes, I do expect that if any userland program can /corrupt/ FS internals without twiddling with /dev/sdX, either the FS is broken or the hardware is.<br>
<br>
In this case I&#39;m quite certain it /was/ the hardware, and 85-90% confident it&#39;s fixed now.<br>
<br>
Cheers,<br>
-jra<br>
-- <br>
Sent from my Android phone with K-9 Mail. Please excuse my brevity.<br><br><div class="gmail_quote">Stan Hoeppner &lt;stan@hardwarefreak.com&gt; wrote:<blockquote class="gmail_quote" style="margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">
<pre style="white-space: pre-wrap; word-wrap:break-word; font-family: monospace">On 8/18/2013 4:38 PM, Jay Ashworth wrote:<br />&gt; I'm trying to dedupe the two large XFS filesystems on which I have DVR <br />&gt; recordings, so that I can walk around amongst the available HDDs and create<br />&gt; new filesystems under everything.<br />&gt; <br />&gt; Every time I rm a file, the filesystem blows up, and the driver shuts it<br />&gt; down.  <br />&gt; <br />&gt; Some background:<br />&gt; <br />&gt; At the moment, I have 2 devices, /dev/sdd1 mounted on /appl/media4, and<br />&gt; /dev/sda1 mounted on /appl/media5, and a large script, created by hand-<br />&gt; hacking the output of a perl dupe finder script.<br />&gt; <br />&gt; The large script was mangled so that it would remove anything that was a <br />&gt; dupe from media4, unless the file was an unlabeled lost+found on media5,<br />&gt; and had a name on media4.  In that case, I removed the file on media5, and<br />&gt
 
 ; then
moved it from media4 to media5.<br />&gt; <br />&gt; After the hand-hacking on the script, I sorted it to do all the rm's first,<br />&gt; and then all the mv's, to make sure free space when up before it went down.<br />&gt; <br />&gt; And, of course, when I ran the script, it caused the XFS driver to cough and<br />&gt; die, leading to error 5s and gnashing of teeth.<br /><br />If this script is the catalyst of your XFS problems, it seems logical<br />that you would include said script in your trouble report, yet you did<br />not.  It's a bit foolish to assume you can't break a Linux subsystem<br />with a poorly written program and/or in combination with a platform that<br />isn't up to the task being asked of it.  As Joe mentioned having too<br />little RAM could be part of this problem.<br /><br />-- <br />Stan<br /><br /><br /></pre></blockquote></div></body></html>
------G8X6HRAC0KEWMQ1WIFD7AIY4DDY0U2--


--===============9015677013621210074==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9015677013621210074==--
