Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 08 Jul 2007 12:11:30 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l68JBPtL002898
	for <linux-xfs@oss.sgi.com>; Sun, 8 Jul 2007 12:11:27 -0700
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1I7bRO-0007OL-P4
	for linux-xfs@oss.sgi.com; Sun, 08 Jul 2007 20:25:02 +0200
Received: from cm169-230.liwest.at ([81.10.169.230])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Sun, 08 Jul 2007 20:25:02 +0200
Received: from jp by cm169-230.liwest.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Sun, 08 Jul 2007 20:25:02 +0200
From: Jakob Praher <jp@hapra.at>
Subject: usage pattern: xfsrestore to mirror disks
Date: Sun, 08 Jul 2007 20:18:18 +0200
Message-ID: <f6r9pb$qv0$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

hi all,

first of all: I am a very happy user of xfs for a long time now.
I use xfs in tandem with lvm2 and I have to say I am very pleased.

Now a question:

There are two modes of using xfs(dump,restore): non-cumulative and 
cumulative. Is this cumulative mode also good to work with full dumps 
(level0). E.g. the data I have to mirror is not large, and I don't want 
to rely on inventory data. So I want for instance if between two full 
dumps a file F was deleted, it should get deleted when I do xfsrestore 
for the second time.

I don't keep the xfsdump output files but i just apply them via ssh. So 
something like that would be great!

Maybe someone can shed some light on that.

thanks

--Jakob
