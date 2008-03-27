Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Mar 2008 09:31:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2RGViZ4022864
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2008 09:31:46 -0700
Received: from ext.agami.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CF74104824F
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2008 09:32:18 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177]) by cuda.sgi.com with ESMTP id cUtfWOIddgVbMZEK for <xfs@oss.sgi.com>; Thu, 27 Mar 2008 09:32:18 -0700 (PDT)
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id m2RGUn3M022386
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2008 09:31:53 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id m2R0u4jc026339
	for <xfs@oss.sgi.com>; Wed, 26 Mar 2008 17:56:04 -0700
Message-ID: <47EAF0BA.4040909@agami.com>
Date: Wed, 26 Mar 2008 17:56:26 -0700
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: accounting disk quotas in space reservation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: XFS Mailing List <xfs@oss.sgi.com>

Hi,

When allocating a space reservation at xfs_trans_reserve time,
it doesn't look like xfs takes into account new disk blocks which
might get allocated in the quota DBs.  There is code to handle the
log reservation for disk quotas, but I don't see anything for
the space reservation.

Am I missing something?

thanks,

    Michael
