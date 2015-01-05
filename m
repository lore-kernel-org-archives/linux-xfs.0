Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 32F577F51
	for <xfs@oss.sgi.com>; Sun,  4 Jan 2015 18:56:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 12F768F8033
	for <xfs@oss.sgi.com>; Sun,  4 Jan 2015 16:56:09 -0800 (PST)
Received: from mail-qa0-f45.google.com (mail-qa0-f45.google.com
	[209.85.216.45]) by cuda.sgi.com with ESMTP id gGzvBLmxLUHxuZAv
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 04 Jan 2015 16:56:04 -0800 (PST)
Received: by mail-qa0-f45.google.com with SMTP id f12so13045622qad.18
	for <xfs@oss.sgi.com>; Sun, 04 Jan 2015 16:56:03 -0800 (PST)
Received: from shtub-cm.localnet (ool-182d7911.dyn.optonline.net.
	[24.45.121.17]) by mx.google.com with ESMTPSA id
	g20sm33409515qar.17.2015.01.04.16.56.02 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Sun, 04 Jan 2015 16:56:03 -0800 (PST)
From: Hillel Lubman <shtetldik@gmail.com>
Subject: What is a recommended XFS sector size for hybrid (512e) advanced
	format hard drives?
Date: Sun, 04 Jan 2015 19:56:01 -0500
Message-ID: <1806495.BCZcrVVEOf@shtub-cm>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1301980108027816736=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.

--===============1301980108027816736==
Content-Type: multipart/alternative; boundary="nextPart1440770.HVOdQ0Q7sz"
Content-Transfer-Encoding: 7Bit

This is a multi-part message in MIME format.

--nextPart1440770.HVOdQ0Q7sz
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi.

Looking around I saw some references that it's preferable to use sector size (sectsz) of 4 KB when creating XFS partitions on hybrid (512e) advanced format hard drives and also some mentions of making that a default in mkfs.xfs. However I noticed that my current mkfs.xfs (3.2.1) used with current Debian testing (Linux 3.16.0) still uses 512 B sectors by default.

Can you please clarify what after all is the recommended sector size for such drives and why isn't it a default in mkfs.xfs (since supposedly defaults are generally recommended optimal settings unless you have some special use case).

Can you please also add this topic to the XFS FAQ (http://www.xfs.org/index.php/XFS_FAQ[1]), since I couldn't find any information about it there.

Thanks!

Hillel Lubman.

--------
[1] http://www.xfs.org/index.php/XFS_FAQ

--nextPart1440770.HVOdQ0Q7sz
Content-Transfer-Encoding: 7Bit
Content-Type: text/html; charset="us-ascii"

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">
<html><head><meta name="qrichtext" content="1" /><style type="text/css">
p, li { white-space: pre-wrap; }
</style></head><body style=" font-family:'Arial'; font-size:10pt; font-weight:400; font-style:normal;">
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Hi.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Looking around I saw some references that it's preferable to use sector size (sectsz) of 4 KB when creating XFS partitions on hybrid (512e) advanced format hard drives and also some mentions of making that a default in mkfs.xfs. However I noticed that my current mkfs.xfs (3.2.1) used with current Debian testing (Linux 3.16.0) still uses 512 B sectors by default.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Can you please clarify what after all is the recommended sector size for such drives and why isn't it a default in mkfs.xfs (since supposedly defaults are generally recommended optimal settings unless you have some special use case).</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Can you please also add this topic to the XFS FAQ (<a href="http://www.xfs.org/index.php/XFS_FAQ"><span style=" text-decoration: underline; color:#d8d8d8;">http://www.xfs.org/index.php/XFS_FAQ</span></a>), since I couldn't find any information about it there.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Thanks!</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Hillel Lubman.</p></body></html>
--nextPart1440770.HVOdQ0Q7sz--


--===============1301980108027816736==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1301980108027816736==--
