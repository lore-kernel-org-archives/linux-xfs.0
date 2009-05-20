Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4KGp4i3113030 for <xfs@oss.sgi.com>; Wed, 20 May 2009 11:51:04 -0500
Received: from kcout02.prserv.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37F1C1BC3EA4
	for <xfs@oss.sgi.com>; Wed, 20 May 2009 09:51:12 -0700 (PDT)
Received: from kcout02.prserv.net (kcout02.prserv.net [12.154.55.32]) by
	cuda.sgi.com with ESMTP id 2FCuYiuPtq8TAH88 for
	<xfs@oss.sgi.com>; Wed, 20 May 2009 09:51:12 -0700 (PDT)
Message-ID: <4A1434FA.8010006@attglobal.net>
Date: Wed, 20 May 2009 09:51:06 -0700
From: Eddie Atherton <stunnel@attglobal.net>
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_trans_cancel at line 1164 of
	file	fs/xfs/xfs_trans.c
References: <4A13AA1B.7080801@attglobal.net> <4A141F72.3020607@sandeen.net>
In-Reply-To: <4A141F72.3020607@sandeen.net>
Reply-To: stunnel@attglobal.net
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2791239185976584621=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============2791239185976584621==
Content-Type: multipart/alternative;
 boundary="------------010605040202030201050206"

This is a multi-part message in MIME format.
--------------010605040202030201050206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Eric Sandeen wrote:
> Eddie Atherton wrote:
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
>> Apologies for posting the stack trace as a couple of jpg's, but it's the 
>> only way I could capture them, as I don't have any VMs set up, yet, that 
>> have conectivity to upload any files.  The stack trace can be found at:
>>
>> http://www.bogolinux.net/xfs_crash_a.JPG
>> http://www.bogolinux.net/xfs_crash_b.JPG
>>
>> I'm guessing that it's something to do with this running under a VM, but 
>> is there any way to stop it happening.
>>
>> Cheers,
>> Eddie
>>     
>
> Not sure what that is offhand, seems odd.  xfs_mkdir() is getting some
> error and cancelling a dirty transaction.  Perhaps someone on the list
> remembers better than me, a few causes of this were fixed but I don't
> remember details.  Any chance you can try, say, .28 or .29? :)
>   
I'm not sure I can, because it's not a running system, where I can just 
recompile the kernel myself.  It's the Slack installer, that comes as a 
bootable initrd.img.

Cheers,
Eddie

> -Eric
>
>
>   

--------------010605040202030201050206
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Eric Sandeen wrote:
<blockquote cite="mid:4A141F72.3020607@sandeen.net" type="cite">
  <pre wrap="">Eddie Atherton wrote:
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

Apologies for posting the stack trace as a couple of jpg's, but it's the 
only way I could capture them, as I don't have any VMs set up, yet, that 
have conectivity to upload any files.  The stack trace can be found at:

<a class="moz-txt-link-freetext" href="http://www.bogolinux.net/xfs_crash_a.JPG">http://www.bogolinux.net/xfs_crash_a.JPG</a>
<a class="moz-txt-link-freetext" href="http://www.bogolinux.net/xfs_crash_b.JPG">http://www.bogolinux.net/xfs_crash_b.JPG</a>

I'm guessing that it's something to do with this running under a VM, but 
is there any way to stop it happening.

Cheers,
Eddie
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Not sure what that is offhand, seems odd.  xfs_mkdir() is getting some
error and cancelling a dirty transaction.  Perhaps someone on the list
remembers better than me, a few causes of this were fixed but I don't
remember details.  Any chance you can try, say, .28 or .29? :)
  </pre>
</blockquote>
I'm not sure I can, because it's not a running system, where I can just
recompile the kernel myself.&nbsp; It's the Slack installer, that comes as a
bootable initrd.img.<br>
<br>
Cheers,<br>
Eddie<br>
<br>
<blockquote cite="mid:4A141F72.3020607@sandeen.net" type="cite">
  <pre wrap="">
-Eric


  </pre>
</blockquote>
</body>
</html>

--------------010605040202030201050206--


--===============2791239185976584621==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2791239185976584621==--
