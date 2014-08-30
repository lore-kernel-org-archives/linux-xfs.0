Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B9B6D7FBA
	for <xfs@oss.sgi.com>; Sat, 30 Aug 2014 14:33:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9CE8E8F8037
	for <xfs@oss.sgi.com>; Sat, 30 Aug 2014 12:33:54 -0700 (PDT)
Received: from smtpi.inserm.fr (smtpi.inserm.fr [195.98.252.11]) by
	cuda.sgi.com with ESMTP id MWdYGKXfOMAF9cfR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 30 Aug 2014 12:33:49 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtpi.inserm.fr (SrvInserm) with ESMTP id 13C6016835C
	for <xfs@oss.sgi.com>; Sat, 30 Aug 2014 21:33:48 +0200 (CEST)
Received: from smtpi.inserm.fr ([195.98.252.11])
	by localhost (potentille.inserm.fr [127.0.0.1]) (amavisd-new,
	port 10033) with ESMTP id 7Ot9V8p9BLwa for <xfs@oss.sgi.com>;
	Sat, 30 Aug 2014 21:33:48 +0200 (CEST)
Received: from lavande.inserm.fr (lavande.inserm.fr [192.168.20.4])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtpi.inserm.fr (SrvInserm) with ESMTP id 00462168267
	for <xfs@oss.sgi.com>; Sat, 30 Aug 2014 21:33:47 +0200 (CEST)
Received: from zamia1.inserm.fr (zamia1.inserm.fr [192.168.19.93])
	by lavande.inserm.fr (Postfix) with ESMTP id EC0518F74D
	for <xfs@oss.sgi.com>; Sat, 30 Aug 2014 21:33:47 +0200 (CEST)
Received: from webmail.inserm.fr (localhost.localdomain [127.0.0.1])
	by zamia1.inserm.fr (Postfix) with ESMTP id DFAAB27D850
	for <xfs@oss.sgi.com>; Sat, 30 Aug 2014 21:33:46 +0200 (CEST)
MIME-Version: 1.0
Date: Sat, 30 Aug 2014 21:33:46 +0200
From: Samuel GRANJEAUD IR/INSERM <samuel.granjeaud@inserm.fr>
Subject: Re: Run out of =?UTF-8?Q?inodes=3F?=
In-Reply-To: <54009603.9050404@sandeen.net>
References: <54005108.1020203@inserm.fr>
	<20140829114806.GA17610@bfoster.bfoster> <5400802C.5050005@inserm.fr>
	<54009603.9050404@sandeen.net>
Message-ID: <8d5fff2548d35737c6cebcb1f6382e80@inserm.fr>
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
To: xfs@oss.sgi.com

Enabling the inode64 option has solved the problem.

Final question: could some issues appear with SAMBA?

# smbstatus  -V
Version 3.4.5

# xfs_info -V /dev/vg1_backup/backup
xfs_info version 2.6.25

# uname -a
Linux 2.6.26.8-1.0.11.smp.gcc3.4.x86_64 #1 SMP Sun Jan 11 02:42:55 GMT 
2009 x86_64 x86_64 x86_64 GNU/Linux

Thanks for your expert help.

Best regards,
Samuel

On 29-08-2014 17:02, Eric Sandeen wrote:
> 
> You'll want to be using the inode64 mount option for this filesystem;
> I'm surprised the openfiler folks didn't do this by default.
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_inode64_mount_option_for.3F
> 
> add it to fstab for this filesystem, reboot the box (or unmount/mount
> the filesystem) and all should be well.
> 
> -Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
