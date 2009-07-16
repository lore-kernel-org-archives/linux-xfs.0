Return-Path: <xfs-bounces@oss.sgi.com>
Received: from fransum.emea.sgi.com (fransum.emea.sgi.com [144.253.208.10])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6GB0sOb009673 for <xfs@oss.sgi.com>; Thu, 16 Jul 2009 06:00:55 -0500
Subject: Re: Chacl command not found
References: <FBC5D53CDA80FE43A05535FF85DA349B0494FAAF@ttpnemsg02.ttglobal.tatatechnologies.com>
From: Olaf Weber <olaf@sgi.com>
Date: Thu, 16 Jul 2009 13:01:33 +0200
In-Reply-To: <FBC5D53CDA80FE43A05535FF85DA349B0494FAAF@ttpnemsg02.ttglobal.tatatechnologies.com>
	(anil rathod's message of "Thu, 16 Jul 2009 13:43:25 +0530")
Message-ID: <bzy7hy8hoxe.fsf@fransum.emea.sgi.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: anil.rathod@tatatechnologies.com
Cc: xfs@oss.sgi.com

anil rathod writes:

> Hi,
> We are using IRIX OS on our SGI tezro Server.

> I am facing a problem regarding to the ACL.

> chacl  this commad was not  supporting.

On IRIX the chacl command is part of eoe.sw.acl, make sure it has been
installed.  It is not installed by default.  eoe.sw.acl also contains
kernel components, so you will need to reboot as well.

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
