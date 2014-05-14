Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 440CA7F3F
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 07:47:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CCAB9AC00A
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 05:47:19 -0700 (PDT)
Received: from mail.zbfmail.de (mail.zbfmail.de [176.9.84.12]) by cuda.sgi.com
	with ESMTP id FXFSPWL4XsKFMmc5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 May 2014 05:47:17 -0700 (PDT)
Received: from mail.zbfmail.de (localhost [127.0.0.1])
	by mail.zbfmail.de (Postfix) with ESMTP id 184CD30502
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 14:47:16 +0200 (CEST)
MIME-Version: 1.0
Date: Wed, 14 May 2014 14:47:16 +0200
From: Marko Weber|8000 <weber@zbfmail.de>
Subject: =?UTF-8?Q?xfs=5Fdb=20dont=20work=20on=20blocksize=20=34=30=39=36?=
	=?UTF-8?Q?=3F?=
Message-ID: <e6b0d925a9409122a92d4e14922a26fd@zbfmail.de>
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


hello,
does xfs_db not work on blocksize 4096 ?

i get this:

bunka distfiles # xfs_db -r /dev/sda4
xfs_db: error - read only 0 of 512 bytes
cache_node_purge: refcount was 1, not zero (node=0x686530)
xfs_db: cannot read root inode (117)
cache_node_purge: refcount was 1, not zero (node=0x688810)
xfs_db: cannot read realtime bitmap inode (117)
xfs_db: error - read only 0 of 512 bytes
xfs_db> quit

any hints, ideas tipps?

thank you

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
