Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 644957F37
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 02:12:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3BC4230404E
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 00:12:27 -0700 (PDT)
Received: from mail.zbfmail.de (mail.zbfmail.de [176.9.84.12]) by cuda.sgi.com
	with ESMTP id IeM7j9ybLZT1jHbn (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 30 Mar 2014 00:12:22 -0700 (PDT)
Received: from mail.zbfmail.de (localhost [127.0.0.1])
	by mail.zbfmail.de (Postfix) with ESMTP id 3DB681E54DE
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 09:12:20 +0200 (CEST)
MIME-Version: 1.0
Date: Sun, 30 Mar 2014 09:12:20 +0200
From: Marko Weber|8000 <weber@zbfmail.de>
Subject: xfs help question
Message-ID: <6997ecc6ee5c7096ded12e8ad3d77d12@zbfmail.de>
Reply-To: weber@zbfmail.de
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Xfs <xfs@oss.sgi.com>


hello again me ;-),
i thought best place to ask this is here.
i read the faq alot last days but have still questions:

i got a server now with 4 Disks,
i plan to do an raid5 with linux soft raid.
On the server is planed to store 'larger' from 1GB up to 60GB.

what would be best settings when formatting with xfs?
is it better to use '-b size=4096' or the '512'?
should i manipulate the '-i size=' to 2048? or use the default?

i also dont get it with the write-disk cache at all,
its an linux softraid, is the best then to use 'nobarrier' and let the
'disk write cache on'?

or is best solution on linux softraid 'disk write cache' on with xfs 
barrier on?

also, should i tweak with sunit,swidth? and how do i calculate best 
setting?

thanks for any tipps n hints

marko

-- 
zbfmail - Mittendrin statt nur Datei!

OpenDKIM, SPF, DSPAM, Greylisting, POSTSCREEN, AMAVIS, Mailgateways
Mailfiltering, SMTP Service, Spam Abwehr, MX-Backup, Mailserver Backup
Redundante Mailgateways, HA Mailserver, Secure Mailserver

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
