Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0KESj5t013387 for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 08:28:45 -0600
Received: from mail-ew0-f222.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBB3617B237
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 06:29:44 -0800 (PST)
Received: from mail-ew0-f222.google.com (mail-ew0-f222.google.com
	[209.85.219.222]) by cuda.sgi.com with ESMTP id
	QXATW6OaMva0YY8p for <xfs@oss.sgi.com>;
	Wed, 20 Jan 2010 06:29:44 -0800 (PST)
Received: by ewy22 with SMTP id 22so6128786ewy.19
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 06:29:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1067945374.1918531263959691412.JavaMail.root@mail-au.aconex.com>
References: <4B5578E0.5000201@gmail.com>
	<1067945374.1918531263959691412.JavaMail.root@mail-au.aconex.com>
Date: Wed, 20 Jan 2010 09:29:43 -0500
Message-ID: <9cf823c61001200629x5be69ea3t6fca943a9b0844f3@mail.gmail.com>
Subject: Re: acl build failure on x86_64
From: Jon Grosshart <jgrosshart@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Nathan Scott <nscott@aconex.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 19, 2010 at 10:54 PM, Nathan Scott <nscott@aconex.com> wrote:
>
> ----- "Jon" <jgrosshart@gmail.com> wrote:
>
>> Brandon and anyone else who might be able to shed some light on this
>> issue... I'm stumped.
>>
>> > /usr/bin/make -C chacl
>> > make[2]: Entering directory `/tmp/acl-2.2.49/chacl'
>> > gcc -g -O2 -DDEBUG -funsigned-char -fno-strict-aliasing -Wall
>> > -DVERSION=3D\"2.2.49\" -DLOCALEDIR=3D\"/usr/share/locale\"
>> > -DPACKAGE=3D\"acl\" -I../include =A0 =A0 -c -o chacl.o chacl.c
>> > chacl.c: In function 'walk_dir':
>> > chacl.c:335: warning: implicit declaration of function 'readdir64'
>
> Your compile line is missing "-D_GNU_SOURCE -D_FILE_OFFSET_BITS=3D64"
> I think - see include/builddefs.in which shows how this is meant to
> be pulled into your cc line for a Linux build.
>
> cheers.
>
> --
> Nathan
>

Right you are. This line in configure was the culprit:

test -z "$PLATFORM" || pkg_platform=3D"$PLATFORM"

In my /etc/bashrc I set this variable for all my build script to use:

export PLATFORM=3D$(arch)

Apparently, $pkg_platform shouldn't be "x86_64" as far as acl is concerned.=
...

Thanks Nathan.

Jon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
