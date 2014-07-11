Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD0437F47
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 05:48:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ABE528F804C
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 03:48:10 -0700 (PDT)
Received: from mail-we0-f180.google.com (mail-we0-f180.google.com
	[74.125.82.180]) by cuda.sgi.com with ESMTP id LiSOSMDogYXqh1bd
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Jul 2014 03:48:07 -0700 (PDT)
Received: by mail-we0-f180.google.com with SMTP id x48so879595wes.39
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 03:48:04 -0700 (PDT)
Message-ID: <1405075678.28203.56.camel@jtulak>
Subject: Re: symlink loop for /lib64/libhandle.so
From: Jan =?UTF-8?Q?=C5=A4ul=C3=A1k?= <jan@tulak.me>
Date: Fri, 11 Jul 2014 12:47:58 +0200
In-Reply-To: <53BEC1E7.1070904@sandeen.net>
References: <1404898212.7231.12.camel@jtulak>
	<20140709132836.GA65226@bfoster.bfoster>
	<20140710134851.GA26652@infradead.org>
	<1405009872.31068.22.camel@jtulak> <53BEC1E7.1070904@sandeen.net>
Mime-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, XFS mail list <xfs@oss.sgi.com>

On Thu, 2014-07-10 at 11:40 -0500, Eric Sandeen wrote:
> Here's what the current RPM build does; I don't claim that it's elegant or
> beautiful:
> 
> %install
> rm -rf $RPM_BUILD_ROOT
> make V=1 DIST_ROOT=$RPM_BUILD_ROOT install install-dev install-qa \
>         PKG_ROOT_SBIN_DIR=%{_sbindir} PKG_ROOT_LIB_DIR=%{_libdir}
> 
> so that sounds like what you're doing, too.

I think I found it. In short: On Fedora, /lib64 is a symlink
into /usr/lib64, but "install/buildmacros" script thinks it as two
different directories and mess it. Proposed solution: better condition
on line 79 to avoid symlink changes.


Long version:

I looked for the variables and maybe found something more in files
"include/buildmacros" and "install-sh". In the buildmacros file on line
around 80 is command:

../$(INSTALL) -S $(PKG_ROOT_LIB_DIR)/$(LIBNAME).so
$(PKG_LIB_DIR)/$(LIBNAME).so; 

It is invoked just once and its arguments are  [/lib64/libhandle.so] and
[/usr/lib64/libhandle.so] (in this order). This is at the end translated
into this call in "install-sh" on line 172:

ln -s -f /lib64/libhandle.so //usr/lib64/libhandle.so 


It seems to be OK, , but when I put a "ls -li" before and after this
command on line 172, this is what I got (I just added few echos):

 ---------------- 
before:
1668 lrwxrwxrwx. 1 root root 14 Jul 11 10:36 /lib64/libhandle.so ->
libhandle.so.1
1668 lrwxrwxrwx. 1 root root 14 Jul 11 10:36 //usr/lib64/libhandle.so ->
libhandle.so.1
......
ln -s -f /lib64/libhandle.so //usr/lib64/libhandle.so 
......
after:
1668 lrwxrwxrwx. 1 root root 19 Jul 11 10:36 /lib64/libhandle.so
-> /lib64/libhandle.so
1668 lrwxrwxrwx. 1 root root 19 Jul 11 10:36 //usr/lib64/libhandle.so
-> /lib64/libhandle.so
 -----------

Then I have done "ls -l /" and found the reason:
lrwxrwxrwx.   1 root root     9 Dec 12  2013 lib64 -> usr/lib64

So the loop is because on Fedora, /lib64 and /usr/lib64 are the same
directory. The "buildmacros" script does some check before doing the
symlinking, but it just checks the paths as strings. I think that a
better condition on line 80 of "include/buildmacros" file should fix it.
I tried to make a new condition and it works, but I'm not sure about
portability of using the "$(shell ...)" extension of GNU Make. Is there
some more portable way how to do it and keep the condition short?

Proposed condition:

if test "x$(PKG_LIB_DIR)" != "x$(PKG_ROOT_LIB_DIR)"\
-a "x$(shell readlink -f $(PKG_ROOT_LIB_DIR))" != "x$(PKG_LIB_DIR)"\
-a "x$(shell readlink -f $(PKG_LIB_DIR))" != "x$(PKG_ROOT_LIB_DIR)";\ 
then \

Instead of:

if test "x$(PKG_LIB_DIR)" != "x$(PKG_ROOT_LIB_DIR)"; then \


And by the way: It seems to me that the command on line 83 in
"buildmacros" has swapped arguments. In two other symlinks around,
PKG_LIB_DIR and PKG_ROOT_LIB_DIR for .a and .la files are in other
order. Is this all right?


Jan Tulak



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
