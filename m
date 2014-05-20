Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DDDB17F4E
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 10:33:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BFEF98F8049
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 08:33:23 -0700 (PDT)
Received: from mail.zbfmail.de (mail.zbfmail.de [176.9.84.12]) by cuda.sgi.com
	with ESMTP id Ga5BtTPHHB88ex47 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 May 2014 08:33:21 -0700 (PDT)
Received: from mail.zbfmail.de (localhost [127.0.0.1])
	by mail.zbfmail.de (Postfix) with ESMTP id A33A172EE9
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 17:33:15 +0200 (CEST)
MIME-Version: 1.0
Date: Tue, 20 May 2014 17:33:15 +0200
From: Marko Weber|8000 <weber@zbfmail.de>
Subject: a maybe silly question about xfsdump
Message-ID: <33dfdd6d469a5be58f79cbf0f0222c51@zbfmail.de>
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


hello, again me ;-)

i use at runtime this command to backup root partition of a server:

xfsdump -f /var/backup/root2.dump -l 0 -p 5 -L rootdump -M rootdump /


i googled around alot, cause a question wont get out of my mind:
is this backup consistent?
And what about consistency when i backup a mysql partition at runtime?

but my most wondering is abot this:

bunka ~ # df -h
Filesystem                     Size  Used Avail Use% Mounted on
/dev/root                      135G   11G  125G   8% /


but the saved dump shows:


bunka ~ # ls -lh /var/backup/

-rw-r--r-- 1 root root 8.4G May 20 17:29 root2.dump


why is there such a great difference between df -h and the stored dump?

can you give me some enlightment?

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
