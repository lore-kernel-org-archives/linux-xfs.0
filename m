Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 676947F55
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2015 20:23:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3771B304051
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2015 18:23:13 -0800 (PST)
Received: from mail-qc0-f172.google.com (mail-qc0-f172.google.com
	[209.85.216.172]) by cuda.sgi.com with ESMTP id
	8ROyNoonBbmGWjoG (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 05 Jan 2015 18:23:08 -0800 (PST)
Received: by mail-qc0-f172.google.com with SMTP id m20so16187987qcx.17
	for <xfs@oss.sgi.com>; Mon, 05 Jan 2015 18:23:07 -0800 (PST)
From: Hillel Lubman <shtetldik@gmail.com>
Subject: Re: What is a recommended XFS sector size for hybrid (512e) advanced
	format hard drives?
Date: Mon, 05 Jan 2015 21:23:06 -0500
Message-ID: <11099415.8G4MDk5SIC@shtub-cm>
In-Reply-To: <54AA0A93.2010204@hardwarefreak.com>
References: <1806495.BCZcrVVEOf@shtub-cm> <54AA0A93.2010204@hardwarefreak.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7313116034927538664=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.

--===============7313116034927538664==
Content-Type: multipart/alternative; boundary="nextPart1905843.IrjfAu9uhn"
Content-Transfer-Encoding: 7Bit

This is a multi-part message in MIME format.

--nextPart1905843.IrjfAu9uhn
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sunday, January 04, 2015 21:52:51 Stan Hoeppner wrote:
> On 01/04/2015 06:56 PM, Hillel Lubman wrote:
> ...
> > when creating XFS partitions on hybrid (512e)
> ...
> > Can you please clarify what after all is the recommended sector size for
> > such drives 
> ...
> 
> XFS sectsz is unimportant with these drives.  What matters is that any
> partitions you create start and end on 4KB boundaries. 

Thanks. So there shouldn't be any negative impact either if sectz is set to 4 KB? In one particular case I experience some perceived slowness on 2 TB WD drive (and I created XFS partition on that drive using sectz as 4 KB). I didn't test however how it compares to default settings on the same drive which would set it to 512 B.

Regards,
Hillel.

--nextPart1905843.IrjfAu9uhn
Content-Transfer-Encoding: 7Bit
Content-Type: text/html; charset="us-ascii"

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">
<html><head><meta name="qrichtext" content="1" /><style type="text/css">
p, li { white-space: pre-wrap; }
</style></head><body style=" font-family:'Arial'; font-size:10pt; font-weight:400; font-style:normal;">
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">On Sunday, January 04, 2015 21:52:51 Stan Hoeppner wrote:</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; On 01/04/2015 06:56 PM, Hillel Lubman wrote:</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; ...</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; &gt; when creating XFS partitions on hybrid (512e)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; ...</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; &gt; Can you please clarify what after all is the recommended sector size for</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; &gt; such drives </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; ...</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; XFS sectsz is unimportant with these drives.  What matters is that any</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; partitions you create start and end on 4KB boundaries. </p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Thanks. So there shouldn't be any negative impact either if sectz is set to 4 KB? In one particular case I experience some perceived slowness on 2 TB WD drive (and I created XFS partition on that drive using sectz as 4 KB). I didn't test however how it compares to default settings on the same drive which would set it to 512 B.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Regards,</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Hillel.</p></body></html>
--nextPart1905843.IrjfAu9uhn--


--===============7313116034927538664==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7313116034927538664==--
