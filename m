Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 06 Jun 2008 11:32:31 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m56IWQWF025675
	for <xfs@oss.sgi.com>; Fri, 6 Jun 2008 11:32:26 -0700
Received: from defout.telus.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 378D417921B4
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2008 11:33:19 -0700 (PDT)
Received: from defout.telus.net (defout.telus.net [199.185.220.240]) by cuda.sgi.com with ESMTP id KuLPhha9m071OQmF for <xfs@oss.sgi.com>; Fri, 06 Jun 2008 11:33:19 -0700 (PDT)
Received: from priv-edtnaa04.telusplanet.net ([216.232.71.140])
          by priv-edtnes25.telusplanet.net
          (InterMail vM.7.08.02.02 201-2186-121-104-20070414) with ESMTP
          id <20080606183258.QPM16573.priv-edtnes25.telusplanet.net@priv-edtnaa04.telusplanet.net>
          for <xfs@oss.sgi.com>; Fri, 6 Jun 2008 12:32:58 -0600
Received: from mail.zymeworks.com (s216-232-71-140.bc.hsia.telus.net [216.232.71.140])
	by priv-edtnaa04.telusplanet.net (BorderWare MXtreme Infinity Mail Firewall) with ESMTP id D3G198CHK8
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2008 12:33:18 -0600 (MDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.zymeworks.com (Postfix) with ESMTP id 4FD60756D2D
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2008 11:33:18 -0700 (PDT)
Received: from mail.zymeworks.com ([127.0.0.1])
	by localhost (barista.lan.zymeworks.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id elqEHuWEccG6 for <xfs@oss.sgi.com>;
	Fri,  6 Jun 2008 11:33:17 -0700 (PDT)
Received: from zubrowka.lan.zymeworks.com (zubrowka.lan.zymeworks.com [10.3.3.16])
	by mail.zymeworks.com (Postfix) with ESMTP id DC29D756D22
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2008 11:33:17 -0700 (PDT)
Message-Id: <FCF761C7-435E-4AA5-9055-9DA0033B7ACC@zymeworks.com>
From: Kamil Kisiel <kamil@zymeworks.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: XFS and block-level snapshots
Date: Fri, 6 Jun 2008 11:33:17 -0700
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

I had a question about XFS integrity and performing block-level  
snapshots.

We currently have a 2TB (but growing soon..) volume mounted by a Linux  
host with kernel 2.6.23 over iSCSI from our SAN. Our SAN unit has the  
capability to perform block-level snapshots, which is done at regular  
intervals.

I know that it is recommended to perform an xfs_freeze before  
performing a snapshot. However, the control of the snapshots is  
independent from the OS, which currently has no knowledge of their  
occurrence. I'm curious as to the repercussions of this. I understand  
that in all likelyhood, the integrity of files which are currently  
being written will not be preserved. However, even with an xfs_freeze  
this is not guaranteed, as an application may require additional disk  
transactions to maintain the file in a valid state (it is not  
necessarily atomic, depending on the application).

As far as metadata transactions are concerned, the journal should make  
these atomic, so there should not be any problem there?

Basically, I'd like to know what is the worst that could happen, and  
why an xfs_freeze is necessary in this scenario.

____________
Kamil Kisiel
HPC Systems Engineer, Zymeworks Inc.
201-1401 West Broadway,
Vancouver, BC, V6H 1H6, Canada
Tel: (604) 678-1388 ext. 135
Fax: (604) 737-7077
www.zymeworks.com
