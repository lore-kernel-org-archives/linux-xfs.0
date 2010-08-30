Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o81DWpaQ140865 for <xfs@oss.sgi.com>; Wed, 1 Sep 2010 08:32:52 -0500
Received: from smtpo10.poczta.onet.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D466A1E5AB12
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 06:33:27 -0700 (PDT)
Received: from smtpo10.poczta.onet.pl (smtpo10.poczta.onet.pl
	[213.180.142.141]) by cuda.sgi.com with ESMTP id
	pPdwEqgv6DQyTqu6 for <xfs@oss.sgi.com>;
	Wed, 01 Sep 2010 06:33:27 -0700 (PDT)
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:24152 "EHLO
	orion.wszechswiat.org" rhost-flags-OK-OK-OK-FAIL) by ps3.m5r2.onet
	with ESMTPSA id S134219135Ab0H3QfWKmmHM (ORCPT
	<rfc822;xfs@oss.sgi.com>); Mon, 30 Aug 2010 18:35:22 +0200
Message-ID: <4C7BDDB1.6030209@op.pl>
Date: Mon, 30 Aug 2010 18:34:57 +0200
From: Bogdan <bogdandr@op.pl>
MIME-Version: 1.0
Subject: Re: xfsprogs: minimum version with these commands
References: <4C7A2654.3080106@op.pl> <4C7B0EF6.5030505@sandeen.net>
In-Reply-To: <4C7B0EF6.5030505@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 30.08.2010 03:52, Eric Sandeen wrote:
> Bogdan wrote:
>>  Hello.
>>
>>  I couldn't find this information in the xfsprogs ChangeLog, so I'm
>> asking here: what is the minimum version of xfsprogs to:
>>
>> 1) contain these utilities: xfs_db, xfs_freeze, xfs_check, and
>> 2) xfs_db accepts the following command-line parameters: -i, -c, and
>> 3) xfs_freeze accepts the following command-line parameters: -f, -u, and
>> 4) xfs_db accepts the following interactive mode commands: "freesp
>> -d", "quit", "blockget -n", "ncheck", "sb 0", "print".
> 
> I am not surprised that changelogs do not mention when "quit" was
> added to xfs_db ...!

 It could have been "exit" one day in the past, right?

> 
>>  Or is there a ChangeLog that covers all xfsprogs versions in such
>> deatil that I would be able to find this myself? If so, where can I
>> find it?
>>
> 
> You could look at git and/or cvs history/blame to see when commands & 
> options were added.

 Is everything really there? How do I get these?

> Most of the things you ask about are SO OLD it will take some digging
> through renames and moves.

 I thought so. I'm surprised such things as added commands aren't in
the ChangeLog, unless they were present from the first version.

> Do you really need to know if "xfs_check" was added in 1994, or 1995, for
> example? :)

 No. I need to know what was the first version of the xfsprogs package
that contained this program. The version number, not the year.

> This strikes me as a bit of an odd question; what is your motivation here?

 I'm writing a program that executes xfs_db and other processes,
passes commands to them and reads replies. Now I want to know what the
minimum required version is to be sure that these commands are
accepted. I know this might seem strange, but I'd like to know this in
more detail, so I can say "requires xfsprogs version X.Y.Z or newer"
instead of "requires xfsprogs" (which would imply that all versions
work, and this might not be the case). If it would be "1.0.0", great.
But I wanted to be sure.

-- 
Pozdrawiam/Regards - Bogdan                     (GNU/Linux & FreeDOS)
Kurs asemblera x86 (DOS, GNU/Linux):http://rudy.mif.pg.gda.pl/~bogdro
Grupy dyskusyjne o asm:  pl.comp.lang.asm alt.pl.asm alt.pl.asm.win32
www.Xiph.org   www.TorProject.org   Soft (EN): miniurl.pl/bogdro-soft

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
