Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4P46cYt072993 for <xfs@oss.sgi.com>; Sun, 24 May 2009 23:06:38 -0500
Received: from kcout02.prserv.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C5812A8C3F
	for <xfs@oss.sgi.com>; Sun, 24 May 2009 21:06:50 -0700 (PDT)
Received: from kcout02.prserv.net (kcout02.prserv.net [12.154.55.32]) by
	cuda.sgi.com with ESMTP id FgdMru8xMDE38ac7 for
	<xfs@oss.sgi.com>; Sun, 24 May 2009 21:06:50 -0700 (PDT)
Message-ID: <4A1A1953.6030009@attglobal.net>
Date: Sun, 24 May 2009 21:06:43 -0700
From: Eddie Atherton <stunnel@attglobal.net>
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_trans_cancel at line 1164 of
	file	fs/xfs/xfs_trans.c
References: <4A13AA1B.7080801@attglobal.net>
	<20090525005132.GR16929@discord.disaster>
In-Reply-To: <20090525005132.GR16929@discord.disaster>
Reply-To: stunnel@attglobal.net
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5066360839134742263=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============5066360839134742263==
Content-Type: multipart/alternative;
 boundary="------------000807050808040906010604"

This is a multi-part message in MIME format.
--------------000807050808040906010604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Dave Chinner wrote:
> On Tue, May 19, 2009 at 11:58:35PM -0700, Eddie Atherton wrote:
>   
>> I'm trying to install a clean Slackware 12.2 (2.6.27.7) under ESXi, and  
>> can almost guarantee getting this error immediately after formatting the  
>> root partition.  It's happened 4 out of the 5 times I've tried, so far.
>>
>> The sequence of commands, after digging through the install scripts,  
>> that lead to this failure are just:
>>
>> mkfs.xfs
>> mount
>> mkdir
>>     
>
> That's bizarre. Can you provide a xfs_metadump image of the fs after
> the shutdown has occurred?
>   
I can try, but it's kinda difficult, as this happens in a VM, where I 
don't have a filesystem to capture the data to, or any "communication" 
to the "outside world" to transfer it out.  But, hey, that's what 
challenges are all about.

Cheers,
Eddie
> Cheers,
>
> Dave.
>   

--------------000807050808040906010604
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
<br>
Dave Chinner wrote:
<blockquote cite="mid:20090525005132.GR16929@discord.disaster"
 type="cite">
  <pre wrap="">On Tue, May 19, 2009 at 11:58:35PM -0700, Eddie Atherton wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">I'm trying to install a clean Slackware 12.2 (2.6.27.7) under ESXi, and  
can almost guarantee getting this error immediately after formatting the  
root partition.  It's happened 4 out of the 5 times I've tried, so far.

The sequence of commands, after digging through the install scripts,  
that lead to this failure are just:

mkfs.xfs
mount
mkdir
    </pre>
  </blockquote>
  <pre wrap=""><!---->
That's bizarre. Can you provide a xfs_metadump image of the fs after
the shutdown has occurred?
  </pre>
</blockquote>
I can try, but it's kinda difficult, as this happens in a VM, where I
don't have a filesystem to capture the data to, or any "communication"
to the "outside world" to transfer it out.&nbsp; But, hey, that's what
challenges are all about.<br>
<br>
Cheers,<br>
Eddie<br>
<blockquote cite="mid:20090525005132.GR16929@discord.disaster"
 type="cite">
  <pre wrap="">
Cheers,

Dave.
  </pre>
</blockquote>
</body>
</html>

--------------000807050808040906010604--


--===============5066360839134742263==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5066360839134742263==--
