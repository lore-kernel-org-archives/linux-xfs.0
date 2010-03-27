Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2RERDxH096756 for <xfs@oss.sgi.com>; Sat, 27 Mar 2010 09:27:13 -0500
Received: from omr10.networksolutionsemail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C1FA27BEC8
	for <xfs@oss.sgi.com>; Sat, 27 Mar 2010 07:28:36 -0700 (PDT)
Received: from omr10.networksolutionsemail.com
	(omr10.networksolutionsemail.com [205.178.146.60]) by
	cuda.sgi.com with ESMTP id Z1gCWHJ1nVMtDXJ2 for
	<xfs@oss.sgi.com>; Sat, 27 Mar 2010 07:28:36 -0700 (PDT)
Received: from cm-omr2 (mail.networksolutionsemail.com [205.178.146.50])
	by omr10.networksolutionsemail.com (8.13.6/8.13.6) with ESMTP id
	o2RESY0s020893 for <xfs@oss.sgi.com>; Sat, 27 Mar 2010 10:28:34 -0400
Message-ID: <4BAE15FC.2080901@chaven.com>
Date: Sat, 27 Mar 2010 09:28:12 -0500
From: Steve Costaras <stevecs@chaven.com>
MIME-Version: 1.0
Subject: Re: 128TB filesystem limit?
References: <alpine.DEB.2.00.1003251609160.12435@asgard.lang.hm>
	<20100327100618.71e24a0a@galadriel.home>
In-Reply-To: <20100327100618.71e24a0a@galadriel.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3897388845320106070=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============3897388845320106070==
Content-Type: multipart/alternative;
 boundary="------------040306060109070806090807"

This is a multi-part message in MIME format.
--------------040306060109070806090807
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit


 From my previous experience it's pure speculation until someone 
actually HAS a file system of X size to make a determination such as 
that.   Having run into limits that 'should not have been there' at 1TB, 
2TB, 8TB, 16TB, and 32TB when I've crossed each one (different file 
systems but all at the time of crossing them have been 'supposedly' 
capable of handling it, don't.  Most recent is the 32TiB limit in JFS, 
granted it looks to be all the jfs tools but that doesn't matter when 
you still loose all your data.  ;)

I know that XFS can handle >64TiB as I have that running (though made 
sure I had backups before I expanded to that).    I have not seen a 
deployment of 128TiB to see if that works, not saying it can't or wont 
just that I haven't seen it.

However from the thread here it appears that <128TiB (just shy it seems) 
works and what the OP seems to be running into is a units discrepancy.   
Using base 10 on the drives and then having the system use base 2 for 
display.   This is more dramatic the larger the drive/array and the lack 
of education/updates to properly display the units (?iB for base 2 (e.g. 
TiB) and ?B for base 10 (e.g. TB)).   So easily confused.



On 03/27/2010 04:06, Emmanuel Florac wrote:
> Le Thu, 25 Mar 2010 16:15:42 -0700 (PDT) vous écriviez:
>
>    
>> is this just rounding error combined with the 1000=1k vs 1024=1k
>> marketing stuff, or is there some limit I am bumping into here.
>>      
> This isn't an xfs limit, I've set up several hundred big xfs FS for
> more than 5 years (13 to 76 TB) and never saw that. It must be a bug in
> df or elsewhere. What distribution is this? and architecture?
>
>    

--------------040306060109070806090807
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
<font face="Courier New"><br>
>From my previous experience it's pure speculation until someone
actually HAS a file system of X size to make a determination such as
that.&nbsp;&nbsp; Having run into limits that 'should not have been there' at
1TB, 2TB, 8TB, 16TB, and 32TB when I've crossed each one (different
file systems but all at the time of crossing them have been
'supposedly' capable of handling it, don't.&nbsp; Most recent is the 32TiB
limit in JFS, granted it looks to be all the jfs tools but that doesn't
matter when you still loose all your data.&nbsp; ;) <br>
<br>
I know that XFS can handle &gt;64TiB as I have that running (though
made sure I had backups before I expanded to that).&nbsp;&nbsp;&nbsp; I have not seen
a deployment of 128TiB to see if that works, not saying it can't or
wont just that I haven't seen it.<br>
<br>
However from the thread here it appears that &lt;128TiB (just shy it
seems) works and what the OP seems to be running into is a units
discrepancy.&nbsp;&nbsp; Using base 10 on the drives and then having the system
use base 2 for display.&nbsp;&nbsp; This is more dramatic the larger the
drive/array and the lack of education/updates to properly display the
units (?iB for base 2 (e.g. TiB) and ?B for base 10 (e.g. TB)).&nbsp;&nbsp; So
easily confused.<br>
<br>
<br>
</font><br>
On 03/27/2010 04:06, Emmanuel Florac wrote:
<blockquote cite="mid:20100327100618.71e24a0a@galadriel.home"
 type="cite">
  <pre wrap="">Le Thu, 25 Mar 2010 16:15:42 -0700 (PDT) vous &eacute;criviez:

  </pre>
  <blockquote type="cite">
    <pre wrap="">is this just rounding error combined with the 1000=1k vs 1024=1k
marketing stuff, or is there some limit I am bumping into here.
    </pre>
  </blockquote>
  <pre wrap="">
This isn't an xfs limit, I've set up several hundred big xfs FS for
more than 5 years (13 to 76 TB) and never saw that. It must be a bug in
df or elsewhere. What distribution is this? and architecture?

  </pre>
</blockquote>
</body>
</html>

--------------040306060109070806090807--


--===============3897388845320106070==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3897388845320106070==--
