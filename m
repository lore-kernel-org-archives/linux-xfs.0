Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 23EC77F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 02:11:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 93F56AC30F
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 00:11:15 -0800 (PST)
Received: from mail.zbfmail.de (mail.zbfmail.de [176.9.84.12]) by cuda.sgi.com
	with ESMTP id PTTXahVrpIWU4Y25 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 00:10:39 -0800 (PST)
Received: from [10.28.238.236] (tmo-100-212.customers.d1-online.com
	[80.187.100.212])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: weber@zbfmail.de)
	by mail.zbfmail.de (Postfix) with ESMTPSA id 83F7010C147
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 09:10:37 +0100 (CET)
In-Reply-To: <530A71E3.9060107@hardwarefreak.com>
References: <9963a76fbd006355c9ffd79f341c9971@zbfmail.de>
	<530A71E3.9060107@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: gentoo linux, kernel 3.10.31 mount options bug?
From: Marko Weber|8000 <weber@zbfmail.de>
Date: Tue, 25 Feb 2014 09:10:35 +0100
Message-ID: <a9ad8075-ec2b-476e-bb51-40a93e879b1d@email.android.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3440864160526654730=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Xfs <xfs@oss.sgi.com>

--===============3440864160526654730==
Content-Type: multipart/alternative; boundary="----ZAN00CQ4Q8W1GTNO7HICO0VWUPOA80"
Content-Transfer-Encoding: 8bit

------ZAN00CQ4Q8W1GTNO7HICO0VWUPOA80
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8

Thanks for the short and clear answer stan.

Marko

On 23. Februar 2014 23:10:43 MEZ, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>On 2/23/2014 3:37 AM, Marko Weber|8000 wrote:
>...
>> linux /bzImage-3.10.31 root=/dev/md2 elevator=cfq clocksource=hpet
>                                       ^^^^^^^^^^^^
>
>cfq tends to defeat much of the parallelism in XFS, decreasing
>throughput substantially.  This is documented in the XFS FAQ and has
>been discussed here many times in the past.  It has been recommended
>for
>a few years now that XFS not be used with the cfq elevator.  Use
>deadline with md arrays on plain HBAs and noop on SSDs or any device
>with [F|B]BWC, i.e. RAID HBA or SAN controller.
>
>If you're using cfq to allow shaping of per process IO with control
>groups, simply using cfq alone may slow down XFS throughput to the
>point
>that you don't need to bother with control group optimizations.
>
>-- 
>Stan

-- 
Diese Nachricht wurde von meinem Android-Mobiltelefon mit K-9 Mail gesendet.
------ZAN00CQ4Q8W1GTNO7HICO0VWUPOA80
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: 8bit

<html><head></head><body>Thanks for the short and clear answer stan.<br>
<br>
Marko<br><br><div class="gmail_quote">On 23. Februar 2014 23:10:43 MEZ, Stan Hoeppner &lt;stan@hardwarefreak.com&gt; wrote:<blockquote class="gmail_quote" style="margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">
<pre class="k9mail">On 2/23/2014 3:37 AM, Marko Weber|8000 wrote:<br />...<br /><blockquote class="gmail_quote" style="margin: 0pt 0pt 1ex 0.8ex; border-left: 1px solid #729fcf; padding-left: 1ex;"> linux /bzImage-3.10.31 root=/dev/md2 elevator=cfq clocksource=hpet<br /></blockquote>                                       ^^^^^^^^^^^^<br /><br />cfq tends to defeat much of the parallelism in XFS, decreasing<br />throughput substantially.  This is documented in the XFS FAQ and has<br />been discussed here many times in the past.  It has been recommended for<br />a few years now that XFS not be used with the cfq elevator.  Use<br />deadline with md arrays on plain HBAs and noop on SSDs or any device<br />with [F|B]BWC, i.e. RAID HBA or SAN controller.<br /><br />If you're using cfq to allow shaping of per process IO with control<br />groups, simply using cfq alone may slow down XFS throughput to the point<br />that you don't need to bother with control group optimizations.<br
/></pre></blockquote></div><br>
-- <br>
Diese Nachricht wurde von meinem Android-Mobiltelefon mit K-9 Mail gesendet.</body></html>
------ZAN00CQ4Q8W1GTNO7HICO0VWUPOA80--


--===============3440864160526654730==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3440864160526654730==--
