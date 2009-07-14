Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6E27p4o082542 for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 21:07:51 -0500
Received: from snt0-omc3-s8.snt0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD95C136538C
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 19:08:29 -0700 (PDT)
Received: from snt0-omc3-s8.snt0.hotmail.com (snt0-omc3-s8.snt0.hotmail.com
	[65.55.90.147]) by cuda.sgi.com with ESMTP id DuuTDG7M4YKVDUJn
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 19:08:29 -0700 (PDT)
Message-ID: <SNT109-W281A335998D4B1CD86B0A9EC230@phx.gbl>
From: crow al <al-john@hotmail.com>
Subject: RE: How to simulate journal corruption
Date: Tue, 14 Jul 2009 10:08:28 +0800
In-Reply-To: <4A5B4833.9070300@sandeen.net>
References: <SNT109-W2390816D3EF297CE0D07DEEC220@phx.gbl>
	<4A5B4833.9070300@sandeen.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3076445187961817750=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: sandeen@sandeen.net, olaf@sgi.com
Cc: xfs@oss.sgi.com

--===============3076445187961817750==
Content-Type: multipart/alternative;
	boundary="_2f5fceb3-8c3c-48a5-9614-0a3c9821fadd_"

--_2f5fceb3-8c3c-48a5-9614-0a3c9821fadd_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8bit


Hi, Olaf & Eric

Thanks for your kindly reply. I will try your suggestions & if there is any interesting findings, I will let your know

Thanks & Regards.
Lv Wentao.





> Date: Mon, 13 Jul 2009 09:44:03 -0500
> From: sandeen@sandeen.net
> To: al-john@hotmail.com
> CC: xfs@oss.sgi.com
> Subject: Re: How to simulate journal corruption
> 
> crow al wrote:
> > Hi, there
> > 
> > I'm a QA engineer from Cisco. I'm working on a test case concerning XFS
> > journal playback failure, which needs to manually inject error to XFS.
> > 
> > I did some google work but get no luck. Then I think maybe XFA-QA could
> > give me some advice. That why I come to here.
> > 
> > Is there anyone could tell me how to inject error into XFS or is there
> > any tool could be used?
> > 
> > Wish for your response.
> > 
> > Thanks & Regards.
> > Lv Wentao.
> 
> test 044 in xfstests runs something called "loggen" which will generate
> log traffic to be replayed on mount, if I'm reading it right.  Of course
> that's an uncorrupted log ...
> 
> There is another tool called "fsfuzzer" which writes random junk over a
> filesystem.  You could probably combine the two tools to create valid
> logs to replay, and then write varying degrees of junk on top with
> fsfuzzer, and try to replay the result.
> 
> You could probably even use fsfuzzer "stock" and just restrict the
> fuzzing to the log portion of the filesystem.
> 
> I'm not sure what kinds of errors you are trying to catch - oopses,
> hangs, improperly replaying a corrupted log, etc - but it sounds well
> worth doing.  FWIW when I used fsfuzzer, it often ran into problems in
> the log, so I imagine you'll uncover some interesting things; if you do,
> please share.  :)
> 
> -Eric

_________________________________________________________________
With Windows Live, you can organize, edit, and share your photos.
http://www.microsoft.com/middleeast/windows/windowslive/products/photo-gallery-edit.aspx
--_2f5fceb3-8c3c-48a5-9614-0a3c9821fadd_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: 8bit

<html>
<head>
<style>
.hmmessage P
{
margin:0px;
padding:0px
}
body.hmmessage
{
font-size: 10pt;
font-family:Verdana
}
</style>
</head>
<body class='hmmessage'>
Hi, Olaf &amp; Eric<br><br>Thanks for your kindly reply. I will try your suggestions &amp; if there is any interesting findings, I will let your know<br><br>Thanks &amp; Regards.<br>Lv Wentao.<meta http-equiv="Content-Type" content="text/html; charset=unicode">
<meta name="Generator" content="Microsoft SafeHTML">
<style>
.hmmessage P
{margin:0px;padding:0px;}
body.hmmessage
{font-size:10pt;font-family:Verdana;}
</style>

<br><br>&gt; Date: Mon, 13 Jul 2009 09:44:03 -0500<br>&gt; From: sandeen@sandeen.net<br>&gt; To: al-john@hotmail.com<br>&gt; CC: xfs@oss.sgi.com<br>&gt; Subject: Re: How to simulate journal corruption<br>&gt; <br>&gt; crow al wrote:<br>&gt; &gt; Hi, there<br>&gt; &gt; <br>&gt; &gt; I'm a QA engineer from Cisco. I'm working on a test case concerning XFS<br>&gt; &gt; journal playback failure, which needs to manually inject error to XFS.<br>&gt; &gt; <br>&gt; &gt; I did some google work but get no luck. Then I think maybe XFA-QA could<br>&gt; &gt; give me some advice. That why I come to here.<br>&gt; &gt; <br>&gt; &gt; Is there anyone could tell me how to inject error into XFS or is there<br>&gt; &gt; any tool could be used?<br>&gt; &gt; <br>&gt; &gt; Wish for your response.<br>&gt; &gt; <br>&gt; &gt; Thanks &amp; Regards.<br>&gt; &gt; Lv Wentao.<br>&gt; <br>&gt; test 044 in xfstests runs something called "loggen" which will generate<br>&gt; log traffic to be replayed on mount, 
 if I'm reading it right.  Of course<br>&gt; that's an uncorrupted log ...<br>&gt; <br>&gt; There is another tool called "fsfuzzer" which writes random junk over a<br>&gt; filesystem.  You could probably combine the two tools to create valid<br>&gt; logs to replay, and then write varying degrees of junk on top with<br>&gt; fsfuzzer, and try to replay the result.<br>&gt; <br>&gt; You could probably even use fsfuzzer "stock" and just restrict the<br>&gt; fuzzing to the log portion of the filesystem.<br>&gt; <br>&gt; I'm not sure what kinds of errors you are trying to catch - oopses,<br>&gt; hangs, improperly replaying a corrupted log, etc - but it sounds well<br>&gt; worth doing.  FWIW when I used fsfuzzer, it often ran into problems in<br>&gt; the log, so I imagine you'll uncover some interesting things; if you do,<br>&gt; please share.  :)<br>&gt; <br>&gt; -Eric<br><br /><hr />With Windows Live, you can organize, edit, and  <a href='http://www.microsoft.com/middleeast/windows
 /
 windowslive/products/photo-gallery-edit.aspx' target='_new'>share your photos.</a></body>
</html>
--_2f5fceb3-8c3c-48a5-9614-0a3c9821fadd_--


--===============3076445187961817750==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3076445187961817750==--
