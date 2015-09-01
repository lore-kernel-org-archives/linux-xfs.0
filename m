Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C0ED7F47
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 22:55:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2996DAC003
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 20:55:17 -0700 (PDT)
Received: from smtpproxy21.qq.com (smtpproxy21.qq.com [184.105.206.83]) by
	cuda.sgi.com with ESMTP id rpLyWmeDcouJ5IAZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 31 Aug 2015 20:55:15 -0700 (PDT)
Received: from Jevons-MacBook-Pro.local (unknown [182.48.117.114])
	by esmtp4.qq.com (ESMTP) with SMTP id 0
	for <xfs@oss.sgi.com>; Tue, 01 Sep 2015 11:55:05 +0800 (CST)
From: Jevon Qiao <qiaojianfeng@unitedstack.com>
Subject: Ask help on an issue 'XFS (sd*): discard failed for extent, error 5'
Message-ID: <55E52198.7070607@unitedstack.com>
Date: Tue, 1 Sep 2015 11:55:04 +0800
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2933151728394143026=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============2933151728394143026==
Content-Type: multipart/alternative;
 boundary="------------000208040907060202040503"

This is a multi-part message in MIME format.
--------------000208040907060202040503
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi All,

Currently, I notice that there are lot's of errors written in the 
/var/log/messages file.

    2015-08-29T23:58:54.477236+00:00 server-68 kernel: sd 0:0:4:0: [sdc]
    2015-08-29T23:58:54.477255+00:00 server-68 kernel: Result:
    hostbyte=DID_OK driverbyte=DRIVER_SENSE
    2015-08-29T23:58:54.477256+00:00 server-68 kernel: sd 0:0:4:0: [sdc]
    2015-08-29T23:58:54.477257+00:00 server-68 kernel: Sense Key :
    Illegal Request [current]
    2015-08-29T23:58:54.477258+00:00 server-68 kernel: sd 0:0:4:0: [sdc]
    2015-08-29T23:58:54.477259+00:00 server-68 kernel: Add. Sense:
    Invalid field in parameter list
    2015-08-29T23:58:54.477260+00:00 server-68 kernel: sd 0:0:4:0: [sdc]
    CDB:
    2015-08-29T23:58:54.477261+00:00 server-68 kernel: Unmap/Read
    sub-channel: 42 00 00 00 00 00 00 00 18 00
    2015-08-29T23:58:54.477263+00:00 server-68 kernel: end_request:
    critical target error, dev sdc, sector 325046824
    2015-08-29T23:58:54.477268+00:00 server-68 kernel: XFS (sdc2):
    discard failed for extent [0x64815,2021], error 5

Has anyone encountered the same issue before? How can you solve it?

Thanks,
Jevon

--------------000208040907060202040503
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=utf-8">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    Hi All,<br>
    <br>
    Currently, I notice that there are lot's of errors written in the
    /var/log/messages file.<br>
    <blockquote>2015-08-29T23:58:54.477236+00:00 server-68 kernel: sd
      0:0:4:0: [sdc]<br>
      2015-08-29T23:58:54.477255+00:00 server-68 kernel: Result:
      hostbyte=DID_OK driverbyte=DRIVER_SENSE<br>
      2015-08-29T23:58:54.477256+00:00 server-68 kernel: sd 0:0:4:0:
      [sdc]<br>
      2015-08-29T23:58:54.477257+00:00 server-68 kernel: Sense Key :
      Illegal Request [current]<br>
      2015-08-29T23:58:54.477258+00:00 server-68 kernel: sd 0:0:4:0:
      [sdc]<br>
      2015-08-29T23:58:54.477259+00:00 server-68 kernel: Add. Sense:
      Invalid field in parameter list<br>
      2015-08-29T23:58:54.477260+00:00 server-68 kernel: sd 0:0:4:0:
      [sdc] CDB:<br>
      2015-08-29T23:58:54.477261+00:00 server-68 kernel: Unmap/Read
      sub-channel: 42 00 00 00 00 00 00 00 18 00<br>
      2015-08-29T23:58:54.477263+00:00 server-68 kernel: end_request:
      critical target error, dev sdc, sector 325046824<br>
      2015-08-29T23:58:54.477268+00:00 server-68 kernel: XFS (sdc2):
      discard failed for extent [0x64815,2021], error 5<br>
    </blockquote>
    Has anyone encountered the same issue before? How can you solve it?<br>
    <br>
    Thanks,<br>
    Jevon<br>
  </body>
</html>

--------------000208040907060202040503--



--===============2933151728394143026==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2933151728394143026==--
