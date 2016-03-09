Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 96A8D7CA0
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 04:35:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17311AC006
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 02:35:40 -0800 (PST)
Received: from mail.zbfmail.de (mail.zbfmail.de [176.9.84.12]) by cuda.sgi.com
	with ESMTP id I5B4UwcsxvWW69Yv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 Mar 2016 02:35:37 -0800 (PST)
Received: from mail.zbfmail.de (localhost [127.0.0.1])
	by mail.zbfmail.de (Postfix) with ESMTP id 338A610C0BB
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 11:35:36 +0100 (CET)
MIME-Version: 1.0
Date: Wed, 09 Mar 2016 11:35:36 +0100
From: Marko Weber | 8000 <weber@zbfmail.de>
Subject: an mount option question and dunno if right here...
Message-ID: <08297acdf77244b468e15458f3d78327@zbfmail.de>
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



hello list,

my drives are all xfs formatted.
in fstab i set:

                  lazytime,logbsize=256k,logbufs=8


when i call "mount" on console i get:

                  
rw,relatime,lazytime,attr2,inode64,logbufs=8,logbsize=256k,sunit=1024,swidth=3072,noquota


Why is relatime listed? Or is lazytime override this setting?
Even when i set "norelatime" in /etc/fstab i get "relatime" listed on 
'mount'

Or am i wrong here with this question? is this not xfs related?
anyway, for any hints or suggestions i am thankful


best regards

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
