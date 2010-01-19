Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J4HRl9154692 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 22:17:27 -0600
Received: from mail-qy0-f188.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A5121C5D54F
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 20:18:26 -0800 (PST)
Received: from mail-qy0-f188.google.com (mail-qy0-f188.google.com
	[209.85.221.188]) by cuda.sgi.com with ESMTP id
	MoVksV0aEwx4be1O for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 20:18:26 -0800 (PST)
Received: by qyk26 with SMTP id 26so950574qyk.5
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 20:18:25 -0800 (PST)
Message-ID: <4B5578E0.5000201@gmail.com>
Date: Tue, 19 Jan 2010 04:18:24 -0500
From: Jon <jgrosshart@gmail.com>
MIME-Version: 1.0
Subject: acl build failure on x86_64
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Brandon and anyone else who might be able to shed some light on this 
issue... I'm stumped.

> /usr/bin/make -C chacl
> make[2]: Entering directory `/tmp/acl-2.2.49/chacl'
> gcc -g -O2 -DDEBUG -funsigned-char -fno-strict-aliasing -Wall 
> -DVERSION=\"2.2.49\" -DLOCALEDIR=\"/usr/share/locale\" 
> -DPACKAGE=\"acl\" -I../include     -c -o chacl.o chacl.c
> chacl.c: In function 'walk_dir':
> chacl.c:335: warning: implicit declaration of function 'readdir64'
> chacl.c:335: warning: assignment makes pointer from integer without a cast
> chacl.c:337: error: dereferencing pointer to incomplete type
> chacl.c:337: error: TONS MORE OF THESE ERRORS
> make[2]: *** [chacl.o] Error 1
> make[2]: Leaving directory `/tmp/acl-2.2.49/chacl'
> make[1]: *** [chacl] Error 2
> make[1]: Leaving directory `/tmp/acl-2.2.49'
> make: *** [default] Error 2

This is a pure 64 bit bootstrap using gcc-4.4.2/glibc-2.11/binutils-2.20 
following Greg Shaffers DIY Linux reference build. I've got almost 300 
packages compiled and am at the tail end of my build so know this has to 
be isolated with ACL.... besides the occasional -fPIC issue with certain 
progs, this is the first stumbling block I've hit.

Thanks for any and all help.

Jon


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
