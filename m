Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K3rx0S236209 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 21:53:59 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 455AB1C5CC15
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:54:57 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id KH7PQCbfc9SpG7eb for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:54:57 -0800 (PST)
Date: Wed, 20 Jan 2010 14:54:51 +1100 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <1067945374.1918531263959691412.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <4B5578E0.5000201@gmail.com>
Subject: Re: acl build failure on x86_64
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
To: Jon <jgrosshart@gmail.com>
Cc: xfs@oss.sgi.com


----- "Jon" <jgrosshart@gmail.com> wrote:

> Brandon and anyone else who might be able to shed some light on this 
> issue... I'm stumped.
> 
> > /usr/bin/make -C chacl
> > make[2]: Entering directory `/tmp/acl-2.2.49/chacl'
> > gcc -g -O2 -DDEBUG -funsigned-char -fno-strict-aliasing -Wall 
> > -DVERSION=\"2.2.49\" -DLOCALEDIR=\"/usr/share/locale\" 
> > -DPACKAGE=\"acl\" -I../include     -c -o chacl.o chacl.c
> > chacl.c: In function 'walk_dir':
> > chacl.c:335: warning: implicit declaration of function 'readdir64'

Your compile line is missing "-D_GNU_SOURCE -D_FILE_OFFSET_BITS=64"
I think - see include/builddefs.in which shows how this is meant to
be pulled into your cc line for a Linux build.

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
