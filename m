Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 266697F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 09:40:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D4A5E304043
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 07:40:10 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[194.177.153.153]) by cuda.sgi.com with ESMTP id
	NcNnNF2ogeVlTQhS (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jan 2014 07:40:08 -0800 (PST)
Received: from noclinksys.net4you.net ([194.177.153.180] helo=[127.0.0.1])
	by firestarter.dermichi.com with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.82) (envelope-from <mw@dermichi.com>) id 1W2jcU-0006Eg-IT
	for xfs@oss.sgi.com; Mon, 13 Jan 2014 16:40:06 +0100
Message-ID: <52D408EC.5000205@dermichi.com>
Date: Mon, 13 Jan 2014 16:40:28 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
References: <A40DF90D-5F6B-4595-AA30-B91D8F7972D0@kotlarek.com>
In-Reply-To: <A40DF90D-5F6B-4595-AA30-B91D8F7972D0@kotlarek.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi Zach!
> I now have 23 directories (matching the 23 =93rebuilding" messages) where=
 a file or directory with non-ASCII characters in the name exists in the di=
rectory list but cannot be read or deleted:
>
> ls -la
> ls: cannot access 07 - Se=F1or Macho Solo.m4v: No such file or directory
> -rw-rw----+  1 profplump media 332M Sep 11  2010 06 - Christmas Special.m=
4v
> ???????????  ? ?         ?        ?            ? 07 - Se??or Macho Solo.m=
4v
> -rw-rw----+  1 profplump media 304M Sep 11  2010 08 - Flu Shot.m4v
>
Might be a long shot, but have you tried mounting the file system with =

"-o inode64"?

cheers,
Michael

---
This email is free from viruses and malware because avast! Antivirus protec=
tion is active.
http://www.avast.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
