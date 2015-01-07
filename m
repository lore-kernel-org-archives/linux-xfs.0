Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 30A077F5E
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 23:36:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0CD34304043
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 21:36:21 -0800 (PST)
Received: from mail-qg0-f41.google.com (mail-qg0-f41.google.com
	[209.85.192.41]) by cuda.sgi.com with ESMTP id pabNDd9WSfHAiv5q
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Jan 2015 21:36:21 -0800 (PST)
Received: by mail-qg0-f41.google.com with SMTP id e89so474821qgf.14
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 21:36:20 -0800 (PST)
From: Hillel Lubman <shtetldik@gmail.com>
Subject: Re: What is a recommended XFS sector size for hybrid (512e) advanced
	format hard drives?
Date: Wed, 07 Jan 2015 00:36:19 -0500
Message-ID: <1564490.3HJmP8WlOV@shtub-cm>
In-Reply-To: <54ACC472.4010104@sandeen.net>
References: <1806495.BCZcrVVEOf@shtub-cm> <2511571.nTXGg0tW6M@shtub-cm>
	<54ACC472.4010104@sandeen.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6877865085562556749=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.

--===============6877865085562556749==
Content-Type: multipart/alternative; boundary="nextPart1702992.cZmYT4SFY6"
Content-Transfer-Encoding: 7Bit

This is a multi-part message in MIME format.

--nextPart1702992.cZmYT4SFY6
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday, January 06, 2015 23:30:26 Eric Sandeen wrote:
> On 1/6/15 11:17 PM, Hillel Lubman wrote:
> 
> > I see. Indeed, on the drive where I get sectsz as 512 by default, blockdev --getss --getpbsz reports:
> > 
> > 512
> > 512
> 
> what kind of drive is this; is it usb, SATA, or ?
> 
> c) not sure why there are 2 different answers.  Knowing what kind of drive
> it is would be good; mkfs.xfs just uses whatever blkid says.
> 

One is a recent portable WD USB3 drive (elements) and another is a regular 3.5" internal AF WD black in an enclosure (also attached through USB3). I didn't recently test the case of a drive attached through regular SATA.

Regards,
Hillel.

--nextPart1702992.cZmYT4SFY6
Content-Transfer-Encoding: 7Bit
Content-Type: text/html; charset="us-ascii"

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">
<html><head><meta name="qrichtext" content="1" /><style type="text/css">
p, li { white-space: pre-wrap; }
</style></head><body style=" font-family:'Arial'; font-size:10pt; font-weight:400; font-style:normal;">
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">On Tuesday, January 06, 2015 23:30:26 Eric Sandeen wrote:</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; On 1/6/15 11:17 PM, Hillel Lubman wrote:</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; &gt; I see. Indeed, on the drive where I get sectsz as 512 by default, blockdev --getss --getpbsz reports:</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; &gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; &gt; 512</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; &gt; 512</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; what kind of drive is this; is it usb, SATA, or ?</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; c) not sure why there are 2 different answers.  Knowing what kind of drive</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; it is would be good; mkfs.xfs just uses whatever blkid says.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">One is a recent portable WD USB3 drive (elements) and another is a regular 3.5&quot; internal AF WD black in an enclosure (also attached through USB3). I didn't recently test the case of a drive attached through regular SATA.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Regards,</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Hillel.</p></body></html>
--nextPart1702992.cZmYT4SFY6--


--===============6877865085562556749==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6877865085562556749==--
