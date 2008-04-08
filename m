Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 21:50:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m384nweo005819
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 21:50:00 -0700
Received: from ext.agami.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFB3A963791
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2008 21:50:34 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177]) by cuda.sgi.com with ESMTP id K37pTpQKesyyIFCh for <xfs@oss.sgi.com>; Mon, 07 Apr 2008 21:50:34 -0700 (PDT)
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id m381rwwB015475
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 18:53:58 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id m381rw8N027773
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 18:53:58 -0700
Message-ID: <47FAD04D.5080308@agami.com>
Date: Mon, 07 Apr 2008 18:54:21 -0700
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: inconsistent xfs log record
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: XFS Mailing List <xfs@oss.sgi.com>

I've just finished analyzing an xfs filesystem which won't recover.
An inconsistent log record has 332 log operations but the num_logop field
in the record header says 333 log operations.  The result is that xfs recovery
complains with "bad clientid" because recovery eventually attempts to decode
garbage.

The log record really has 332 log ops (I counted!).

Looking through xlog_write(), I don't see any way that record_cnt can be bumped
without also writing out a log operation.

Does this issue ring a bell with anyone?

    Michael
